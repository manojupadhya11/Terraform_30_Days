terraform{
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    required_version = ">= 1.5.0"
}

#configring the s3 bucket as backend for storing terraform state file
terraform{
    backend "s3"{
        bucket = "aws-terraform-state-bucket-2026-manojupadhya11"
        key = "dev.terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        #lock_table = "manojupadhya11-terraform-lock-table"
        use_lockfile = true
    }
}

#Create S3 bucket for storing terraform state file
resource "aws_s3_bucket" "terraform_state"{
    bucket = "aws-terraform-state-bucket-2026-manojupadhya11-23"

    tags = {
        name = "Terraform State Bucket"
        env = "Dev"
        key = "terraform" 
    }
}

