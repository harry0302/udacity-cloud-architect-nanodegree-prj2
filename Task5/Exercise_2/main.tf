provider "aws" {
  region = var.aws_region
}

data "archive_file" "greet_lambda" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = var.lambda_output_path
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "greet_lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 7
}

resource "aws_iam_policy" "lambda_logs_policy" {
  name        = "lambda_logs_policy"
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [ "logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
      Effect = "Allow"
      Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
}

resource "aws_lambda_function" "geeting_lambda" {
  function_name = var.lambda_name
  filename = data.archive_file.greet_lambda.output_path
  source_code_hash = data.archive_file.greet_lambda.output_base64sha256
  runtime = "python3.8"
  handler = "greet_lambda.lambda_handler"
  role = aws_iam_role.lambda_exec.arn

  environment{
      variables = {
          greeting = "Hello World!"
      }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_logs_policy, aws_cloudwatch_log_group.greet_lambda_log_group]
}