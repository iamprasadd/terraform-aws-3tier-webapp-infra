# pick the latest amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

# ALB
resource "aws_lb" "app_alb" {
  name               = "${var.project}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Project = var.project

  }
}

# get vpc_id from first app subnet
data "aws_subnet" "first_app" {
  id = var.app_subnet_ids[0]
}

resource "aws_lb_target_group" "web_tg" {
  name     = "${var.project}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_subnet.first_app.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 15
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project}-tg"
  }
}

# listener
resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

#
# IAM: role + instance profile for EC2 to use SSM
#
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.project}-ec2-instance-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
  tags = {
    Project = var.project

  }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

#
# Minimal user_data: install amazon-ssm-agent and nginx, enable & start
#
locals {
  default_user_data = <<-EOF
    #!/bin/bash
    set -e

    # Install SSM Agent
    yum install -y amazon-ssm-agent || true
    systemctl enable amazon-ssm-agent || true
    systemctl start amazon-ssm-agent || true

    # Install nginx (amazon-linux-extras on AL2, fallback yum)
    amazon-linux-extras install -y nginx1 || yum install -y nginx || true
    systemctl enable nginx || true
    systemctl start nginx || true

    # Simple index
    echo "<h1>${var.project}: $(hostname)</h1>" > /usr/share/nginx/html/index.html

     # App config directory
    mkdir -p /etc/app
    chmod 700 /etc/app

    # Write DB configuration (DEMO ONLY: don't do this in prod)
    cat >/etc/app/db.conf <<DBCONF
DB_HOST="${var.db_endpoint}"
DB_PORT="${var.db_port}"
DB_NAME="${var.db_name}"
DB_USER="${var.db_username}"
DB_PASSWORD="${var.db_password}"
DBCONF

    chmod 600 /etc/app/db.conf

    # Simple nginx page
    cat >/usr/share/nginx/html/index.html <<HTML
<html>
  <head><title>${var.project}</title></head>
  <body>
    <h1>${var.project}: $(hostname)</h1>
    <h2>ALB → ASG → EC2 is working</h2>
    <h3>DB wiring (demo)</h3>
    <ul>
      <li>Host: ${var.db_endpoint}</li>
      <li>Port: ${var.db_port}</li>
      <li>Name: ${var.db_name}</li>
      <li>User: ${var.db_username}</li>
    </ul>
    <p>Password is in /etc/app/db.conf, not shown here.</p>
  </body>
</html>
HTML
  EOF

  user_data_final = var.user_data != "" ? var.user_data : local.default_user_data
}

# launch template
resource "aws_launch_template" "app_launch_template" {
  name_prefix   = "${var.project}-app-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  key_name = var.key_name

  user_data = base64encode(local.user_data_final)

  network_interfaces {
    security_groups             = [var.app_sg_id]
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Project = var.project

    }
  }
}

# autoscaling group
resource "aws_autoscaling_group" "app_asg" {
  name                = "${var.project}-app-asg"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_size
  vpc_zone_identifier = var.app_subnet_ids

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  target_group_arns         = [aws_lb_target_group.web_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  force_delete              = false

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
