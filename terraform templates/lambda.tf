data "archive_file" "technical_zip" {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "technical_test" {
  filename         = "lambda_function.zip"
  function_name    = "technical_test"
  role             = aws_iam_role.iam_for_lambda_tf.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.technical_zip.output_base64sha256
  runtime          = "nodejs12.x"
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
