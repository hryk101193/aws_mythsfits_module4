output "vpc_id"{
	value = aws_vpc.vpc.id
}
output "public_subnet_one_id"{
	value = aws_subnet.public_subnet_one.id
}
output "public_subnet_two_id"{
	value = aws_subnet.public_subnet_two.id
}
output "security_group_id"{
	value = aws_security_group.ec2.id
}