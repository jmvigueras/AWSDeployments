##############################################################################################################
# VM LINUX for testing
##############################################################################################################
# Security Groups
## Need to create 4 of them as our Security Groups are linked to a VPC

resource "aws_security_group" "nsg-vpc-spoke-1-vm" {
  name        = "${var.prefix}-nsg-vpc-spoke-1-vm"
  description = "Allow SSH and ICMP traffic"
  vpc_id      = module.vpc-spokes.vpc-spokes_id["vpc-spoke-1_id"]

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.prefix}-nsg-vpc-spoke-1-vm"
  }
}


resource "aws_security_group" "nsg-vpc-spoke-2-vm" {
  name        = "${var.prefix}-nsg-vpc-spoke-2-vm"
  description = "Allow SSH, HTTP and ICMP traffic"
  vpc_id      = module.vpc-spokes.vpc-spokes_id["vpc-spoke-2_id"]

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.prefix}-nsg-vpc-spoke-2-vm"
  }
}


## Retrieve AMI info
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# test device in spoke1
resource "aws_instance" "instance-spoke-1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc-spokes.subnet-spoke-vm["n-spoke-1-vm_id"]
  vpc_security_group_ids = [aws_security_group.nsg-vpc-spoke-1-vm.id]
  key_name               = var.keypair

  tags = {
    Name     = "${var.prefix}-vm-spoke1"
  }
}

# test device in spoke2
resource "aws_instance" "instance-spoke-2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc-spokes.subnet-spoke-vm["n-spoke-2-vm_id"]
  vpc_security_group_ids = [aws_security_group.nsg-vpc-spoke-2-vm.id]
  key_name               = var.keypair

  tags = {
    Name     = "${var.prefix}-vm-spoke2"
  }
}


