terraform{
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
    required_version = ">= 1.15.0"
}

resource "aws_s3_bucket" "manu_bucket" {
    bucket = "manu-bucket-terraform-2026-1234-120820266"
    tags = {
        Name = "manu-bucket-terraform-2026-1234-120820266"
        environment = "Dev"
    }
}
