output "lb_arn" {
    value = aws_lb.lbv2.arn
}
output "lb_target_group_arn" {
    value = aws_lb_target_group.lb_target_group.arn
}
output "lb_dns_name" {
    value = aws_lb.lbv2.dns_name
}