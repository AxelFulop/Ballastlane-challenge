resource "aws_api_gateway_rest_api" "TechnicalAPI" {
  name        = "TechnicalAPI"
  description = "Ballastlane  Test API"
}

resource "aws_api_gateway_resource" "TechnicalAResource" {
  rest_api_id = aws_api_gateway_rest_api.TechnicalAPI.id
  parent_id   = aws_api_gateway_rest_api.TechnicalAPI.root_resource_id
  path_part   = "healtcheck"
}

resource "aws_api_gateway_method" "TechnicalGetMethod" {
  rest_api_id   = aws_api_gateway_rest_api.TechnicalAPI.id
  resource_id   = aws_api_gateway_resource.TechnicalAResource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "TechnicalPostMethod" {
  rest_api_id   = aws_api_gateway_rest_api.TechnicalAPI.id
  resource_id   = aws_api_gateway_resource.TechnicalAResource.id
  http_method   = "POST"
  authorization = "NONE"
}
