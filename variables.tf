variable "schedule" {
	description = "See `schedule_expression` argument in Terraform docs for valid values - https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_rule.html"
}
variable "function_name" {
	description = "Lambda function name"
}
variable "function_input" {
	description = "JSON input that will be sent to Lambda function"
	default = <<EOF
{
	"action": "warmup"
}
EOF
}
