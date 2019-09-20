provider "aws" {
    region = "eu-central-1"
}

data "aws_ami" "red-ami"{
    most_recent = true
    filter {
        name   = "name"
        values = ["red-team-jenkins*"]
    }
 
    tags = {
        Name  = "Red Team AMI"
        owner = var.owner
    }
 
    owners = ["426714351745"]
}


resource "aws_instance" "web" {
    for_each = toset(keys(var.servers))
    ami           = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"

    tags = {
      Name = var.servers[each.key]
    }