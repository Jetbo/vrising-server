# resource "aws_route53_zone" "this" {
#   name = var.route53.zone_name
# }

# resource "aws_route53_record" "nlb" {
#   zone_id = aws_route53_zone.this.zone_id
#   name    = var.route53.network_lb_record_name
#   type    = "A"

#   alias {
#     name                   = "dualstack.${aws_lb.network.dns_name}"
#     zone_id                = aws_lb.network.zone_id
#     evaluate_target_health = false
#   }
# }
