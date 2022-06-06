variable "aws_region" {
  description = "AWS region for all resources."
  type    = string
  default = "us-east-1"
}

variable "lambda_name" {
  description = "Lamda function name"
  type    = string
  default = "greet_lambda"
}

variable "lambda_output_path" {
  description = "archives path"
  type    = string
  default = "output.zip"
}