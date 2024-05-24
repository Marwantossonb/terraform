terraform {
    backend "s3" {
        bucket = "terraform-state-to-use"
        key = "dev/terraform.tfstate"
        region = "eu-north-1"

        dynamodb_table = "terraform-locks-to-use"
        encrypt = true
    }
}