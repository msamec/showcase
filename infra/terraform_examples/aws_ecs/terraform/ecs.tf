locals {
  cluster_name = "${var.project_name}-${var.environment}-cluster"
  log_group      = "${var.project_name}-${var.environment}-log-group"
  ecs_sg = "${var.project_name}-${var.environment}-ecs-sg"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = local.log_group

  tags = var.tags
}

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.6.0"

  cluster_name = local.cluster_name

  cluster_settings = {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = var.tags
}

resource "aws_security_group" "ecs_security_group" {
  name   = local.ecs_sg
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [module.alb.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
