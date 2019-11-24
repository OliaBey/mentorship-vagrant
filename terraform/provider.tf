# Specify the provider and access details
provider "aws" {
  region = "us-east-1"
  #access_key = "${var.aws_access_key}"  export AWS_ACCESS_KEY_ID="""
  #secret_key = "${var.aws_secret_key}"  export AWS_SECRET_ACCESS_KEY=""
}