locals {
  alb_name          = "${var.project_name}-${var.environment}-alb"
  target_group_name = "${var.project_name}-${var.environment}"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.1.0"

  name = local.alb_name

  vpc_id  = module.vpc.vpc_id
  subnets = data.aws_subnets.public.ids

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      description = "Permit all outgoing requests to the internet"
      cidr_ipv4   = "0.0.0.0/0"
      cidr_ipv4   = data.aws_vpc.selected.cidr_block
    }
  }

  listeners = {
    http-https-redirect = {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = aws_acm_certificate.cert.arn
      forward = {
        target_group_key = "http-group"
      }
    }
  }

  target_groups = {
    http-group = {
      name             = local.target_group_name
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
      vpc_id           = module.vpc.vpc_id
      health_check = {
        enabled             = true
        interval            = 150
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 90
        protocol            = "HTTP"
        matcher             = "200,204"
      }
      create_attachment = false
    }
  }

  load_balancer_type = "application"

  depends_on = [
    aws_acm_certificate.cert
  ]

  tags = var.tags
}

data "aws_route53_zone" "primary" {
  zone_id = var.hosted_zone_id
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}


resource "aws_acm_certificate" "cert" {
  domain_name = var.domain_name
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_record : record.fqdn]
}
