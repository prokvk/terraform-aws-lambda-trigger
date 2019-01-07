provider "aws" {
  region = "${var.aws_region}"
}

# S3 bucket for lambda code
resource "aws_s3_bucket" "b" {
	bucket = "${var.s3_bucket}"
	acl = "private"
	server_side_encryption_configuration = {
		rule {
			apply_server_side_encryption_by_default {
				sse_algorithm = "AES256"
			}
		}
	}
}

# put lambda code to S3
resource "aws_s3_bucket_object" "bo" {
	bucket = "${aws_s3_bucket.b.bucket}"
	key = "func.zip"
	source = "${var.lambda_code_path}"
}


# IAM permissions
resource "aws_iam_policy" "p" {
	policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Action": ["logs:*"],
			"Resource": "arn:aws:logs:*:*:*",
			"Effect": "Allow"
		}
	]
}
EOF
}

resource "aws_iam_role" "r" {
	name = "lambda_trigger_test"
	assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Action": ["sts:AssumeRole"],
			"Principal": {
				"Service": "lambda.amazonaws.com"
			},
			"Effect": "Allow"
		}
	]
}
EOF
}

resource "aws_iam_role_policy_attachment" "a" {
	role = "${aws_iam_role.r.name}"
	policy_arn = "${aws_iam_policy.p.arn}"
}

# sample lambda func
resource "aws_lambda_function" "f" {
	s3_bucket = "${var.s3_bucket}"
	s3_key = "func.zip"
	function_name = "lambda-trigger-test"
	role = "${aws_iam_role.r.arn}"
	handler = "index.handler"
	runtime = "nodejs8.10"
	timeout = 25
	memory_size = "128"

	depends_on = ["aws_s3_bucket_object.bo"]
}

# create lambda-trigger (scheduled warmup event)
module "warmup" {
	source = "../../"

	schedule = "rate(2 minutes)"
	function_name = "${aws_lambda_function.f.function_name}"
}
