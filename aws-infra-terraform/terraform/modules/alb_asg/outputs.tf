output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
output "asg_name" {
  value = aws_autoscaling_group.app_asg.name
}
output "alb_arn" {
  value = "aws_lb.app_alb.arn"
}
output "target_group_arn" {
  value = aws_lb_target_group.web_tg.arn
}