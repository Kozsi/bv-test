data "terraform_remote_state" "infra_remote_state" {
  backend = "s3"

  config = {
    bucket = "bv-tfstate"
    key    = "bv-test_infra.tfstate"
    region = "eu-west-2"
  }
}

