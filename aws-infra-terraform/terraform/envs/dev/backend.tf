terraform {
  backend "s3" {
    bucket         = "tf-state-iamprasadd-aws-2tier"
    key            = "aws-2tier/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-locks-aws-2tier"
    encrypt        = true
  }
}