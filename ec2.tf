resource "aws_instance" "main_instance" {
  # AMI
  ami = data.aws_ssm_parameter.instance_ami.value
  # instance type/size
  instance_type = "t3.micro"
  # key name
  key_name = "bvanek"
  # security group
  vpc_security_group_ids = [aws_default_security_group.main.id]
  # subnet
  subnet_id = aws_subnet.public[0].id
  # tags
  tags = {
    "Name" = "${var.default_tags.username}-EC2"
  }
  # userdata
  user_data = file("${path.module}/user.sh") # CHANGED
  # Instance profile role
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name # data.aws_iam_role.ec2_role
}

resource "aws_default_security_group" "main" {
  vpc_id = aws_vpc.main.id # ADDED
  # ingress SSH
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  # ingress HTTP
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  # egress ALL TRAFFIC
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "bvanek-demo"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_read_only" {
  role = "${aws_iam_role.ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "bvanek-demo"
    role = aws_iam_role.ec2_role.name
}