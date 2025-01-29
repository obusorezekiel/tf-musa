resource "aws_security_group" "ec2" {
  name        = "${var.environment}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ec2-sg"
  }
}

resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = "ec2-key"

  vpc_security_group_ids = [aws_security_group.ec2.id]
  
  # Enable public IP for instances in public subnet
  associate_public_ip_address = true

  # IAM role for EC2 if needed
  # iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    docker_image = var.docker_image
    docker_port  = var.docker_port
    environment  = var.environment
  }))

  root_block_device {
    volume_size = 20  # 20GB root volume
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.environment}-app-server"
  }
}
