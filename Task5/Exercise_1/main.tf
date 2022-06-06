provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "udacity-t2" {
  ami = "ami-0fa49cc9dc8d62c84"
  instance_type = "t2.micro"
  subnet_id = "subnet-082242d713e40ed45"
  count = 4
  tags = {
    Name = "Udacity T2"
  }
}

resource "aws_instance" "udacity-m4" {
  ami = "ami-0fa49cc9dc8d62c84"
  instance_type = "m4.large"
  subnet_id = "subnet-082242d713e40ed45"
  count = 2
  tags = {
    Name = "Udacity M4"
  }
}