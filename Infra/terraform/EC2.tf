
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners      = ["099720109477"]
}


resource "aws_instance" "web-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro" #Setting manually for now
  key_name                    = var.ssh_key_name # This assumes you have a exsisting key

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  
  //associate_public_ip_address = true

  user_data                   = file("../../scripts/user_data.sh")
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 10
    volume_type           = "gp3"
    tags = {
    Name = "web-instance-storage"
    }
  }
  tags = {
    Name = "web-instance"
  }
}


