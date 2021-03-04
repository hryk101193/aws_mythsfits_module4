#elb
resource "aws_lb" "lbv2" {
  name = "mysfits-nlb"
  # internet facing
  load_balancer_type = "network"
  subnets = [var.public_subnet_one_id, var.public_subnet_two_id]
}

resource "aws_lb_target_group" "lb_target_group" {
  name = "MythicalMysfits-TargetGroup"
  port = 8080
  protocol = "TCP"
  target_type = "ip"
  vpc_id = var.vpc_id
  health_check {
    interval = 10
    path = "/"
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "lb_listener"{
  load_balancer_arn = aws_lb.lbv2.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
  port = "80"
  protocol = "TCP"
}