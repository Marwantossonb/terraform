resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-state-to-use"
  /*  lifecycle {
        prevent_destroy = true
    }*/
}


resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration{
        status = "Enabled"
    }
}


resource "aws_dynamodb_table" "terraform-locksIDs" {
    name = "terraform-locks-to-use"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}