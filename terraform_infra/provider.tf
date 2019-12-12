resource "aws_kms_key" "s3_encryption_key" {
  description             = "This key is used for encrypt s3 bucket"
  deletion_window_in_days = 10
}

data "terraform_remote_state" "bv_wp" {
  backend = "s3"

  config = {
    bucket     = "bv-tfstate"
    key        = "bv-test_infra.tfstate"
    region     = "eu-west-2"
    kms_key_id = aws_kms_key.s3_encryption_key
  }
}

