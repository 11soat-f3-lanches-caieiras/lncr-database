data "aws_vpc" "main" {
  filter {
    name   = "cidr"
    values = ["10.1.0.0/16"]
  }
}