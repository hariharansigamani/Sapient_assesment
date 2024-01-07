# EC2 Key Pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "web_server_kp" {
  key_name   = format("%s-%s", var.common_name_prefix, "kp")
  public_key = trimspace(tls_private_key.ssh_key.public_key_openssh)
}

# Create SG for EC2 Instance
resource "aws_security_group" "web_server_sg" {
  name        = format("%s-%s", var.common_name_prefix, "sg")
  description = "Security group for ec2"
  vpc_id      =  var.vpc_id
  
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.common_tags_map, {
    Name = format("%s-%s", var.common_name_prefix, "sg")
  })
}

# Create IAM Role and EC2 Instance Profile

resource "aws_iam_instance_profile" "web_server_profile" {
  name = format("%s-%s-%s", var.common_name_prefix, "instance", "profile")

  role = aws_iam_role.web_server_role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "web_server_role" {
  name = format("%s-%s", var.common_name_prefix, "role")
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Create Launch Template
resource "aws_launch_template" "web_server_lt" {
  name_prefix            = format("%s-%s", var.common_name_prefix, "lt")
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.web_server_kp.key_name
  iam_instance_profile {
    name                 = aws_iam_instance_profile.web_server_profile.name
  }
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  ebs_optimized          = true
  placement {
    tenancy              = var.tenancy
  }
  user_data = base64encode(templatefile(format("%s/user-data.sh", path.module), {
    aws_region           = var.aws_region
  }))
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = var.root_volume_type
      volume_size           = var.root_volume_size
      delete_on_termination = var.root_volume_delete_on_termination
      encrypted             = true
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdb"

    ebs {
      volume_type           = var.data_volume_type
      volume_size           = var.data_volume_size
      delete_on_termination = var.data_volume_delete_on_termination
      encrypted             = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags_map, {
      Name = format("%s-%s", var.common_name_prefix, "ec2")
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.common_tags_map, {
      Name = format("%s-%s", var.common_name_prefix, "volume")
    })
  }
}


# Create ASG
resource "aws_autoscaling_group" "web_asg" {
  name_prefix         = format("%s-%s", var.common_name_prefix, "asg")
  launch_template {
    id                      = aws_launch_template.web_server_lt.id
    version                 = aws_launch_template.web_server_lt.latest_version
  }
  vpc_zone_identifier       = var.subnet_ids
  min_size                  = var.cluster_size_min
  max_size                  = var.cluster_size_max
  desired_capacity          = var.cluster_size_desired
  termination_policies      = [var.termination_policies]
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  enabled_metrics           = var.enabled_metrics
  target_group_arns         = [aws_lb_target_group.web_server_alb_tg.arn]
  tag {
      key                 = "Name"
      value               = format("%s-%s", var.common_name_prefix, "asg")
      propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [load_balancers]
  }

}

# Create ALB
resource "aws_lb" "web_server_alb" {
  name                        = format("%s-%s", "ctd-dev-aps2-webserver", "alb")

  internal                         = var.internal
  load_balancer_type               = "application"
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = var.cross_zone_load_balancing
  idle_timeout                     = var.idle_timeout
  enable_http2                     = true
  security_groups                  = [aws_security_group.web_server_sg.id]
  subnets                          = var.subnet_ids

  tags = merge(var.common_tags_map, {
    Name = format("%s-%s", "ctd-dev-aps2-webserver", "alb")
  })
}

resource "aws_lb_target_group" "web_server_alb_tg" {
  name       = format("%s-%s", "ctd-dev-aps2-webserver", "tg")
  port       = var.webserver_port
  protocol   = "HTTP"
  vpc_id     = var.vpc_id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 8080
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "web_server_alb_listner" {
  load_balancer_arn  = aws_lb.web_server_alb.arn
  port               = "80"
  protocol           = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_alb_tg.arn
  }
}