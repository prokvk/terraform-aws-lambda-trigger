variable "aws_region" {
	description = "AWS region"
	default = "eu-west-1"
}
variable "s3_bucket" {
	description = "Lambda code will be stored here"
	default = "lambda-trigger-test"
}
variable "lambda_code_path" {
	description = "Local path with lambda function code"
	default = "./lambda/func.zip"
}
