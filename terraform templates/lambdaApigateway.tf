data "archive_file" "technical_test_zip" {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "technical_test_submit_post" {
  filename         = "lambda_function.zip"
  function_name    = "technical-test-submit-post"
  role             = aws_iam_role.iam_for_lambda_tf.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.technical_test_zip.output_base64sha256
  runtime          = "nodejs12.x"
}

resource "aws_iam_role" "iam_for_lambda_gateway_tf" {
  name = "iiam_for_lambda_gateway_tf"

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

resource "aws_api_gateway_rest_api" "TechnicalAPITest" {
  name        = "TechnicalAPITest"
  description = "Ballastlane  Test API"
}


resource "aws_api_gateway_resource" "TechnicalResourceV2" {
  rest_api_id = aws_api_gateway_rest_api.TechnicalAPITest.id
  parent_id   = aws_api_gateway_rest_api.TechnicalAPITest.root_resource_id
  path_part   = "v2"
}

resource "aws_api_gateway_resource" "TechnicalResourceTests" {
  rest_api_id = aws_api_gateway_rest_api.TechnicalAPITest.id
  parent_id   = aws_api_gateway_resource.TechnicalResourceV2.id
  path_part   = "tests"
}

resource "aws_api_gateway_resource" "TechnicalResource" {
  rest_api_id = aws_api_gateway_rest_api.TechnicalAPITest.id
  parent_id   = aws_api_gateway_resource.TechnicalResourceTests.id
  path_part   = "technical"
}


resource "aws_api_gateway_method" "TechnicalPostMethodTest" {
  rest_api_id   = aws_api_gateway_rest_api.TechnicalAPITest.id
  resource_id   = aws_api_gateway_resource.TechnicalResource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.TechnicalAPITest.id
  resource_id = aws_api_gateway_method.TechnicalPostMethodTest.resource_id
  http_method = aws_api_gateway_method.TechnicalPostMethodTest.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.technical_test_submit_post.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.technical_test_submit_post.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.TechnicalAPITest.execution_arn}/*/POST/v2/tests/technical"
}