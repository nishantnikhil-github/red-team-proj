provider "aws" {
    region = "eu-central-1"
}


#basic example of creating s3 bucket
resource "aws_s3_bucket" "nishant-terraform" {
    bucket = var.bucket_name
    region = "eu-central-1"
    tags = {
        Name = var.name_tag
        Owner = var.owner_tag
    }

}