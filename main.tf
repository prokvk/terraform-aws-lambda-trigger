data "aws_lambda_function" "f" {
	function_name = "${var.function_name}"
	qualifier = ""
}

resource "aws_cloudwatch_event_rule" "r" {
	schedule_expression = "${var.schedule}"
}

resource "aws_cloudwatch_event_target" "t" {
	rule = "${aws_cloudwatch_event_rule.r.name}"
	arn = "${data.aws_lambda_function.f.arn}"
	input = "${var.function_input}"
}

resource "aws_lambda_permission" "p" {
	action = "lambda:InvokeFunction"
	function_name = "${data.aws_lambda_function.f.function_name}"
	principal = "events.amazonaws.com"
	source_arn = "${aws_cloudwatch_event_rule.r.arn}"
}
