# Create a VPC
resource "aws_vpc" "etcd" {
  cidr_block = "10.0.0.0/16"

  tags = {
      Name = "etcd"
  }
}