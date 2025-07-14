output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "alb_security_group" {
  value = [aws_security_group.security_group["public"].id]
}

output "ecs_security_group" {
  value = [aws_security_group.security_group["ecs"].id]
}

output "public_subnets" {
  value = aws_subnet.public_subnet.*.id
}