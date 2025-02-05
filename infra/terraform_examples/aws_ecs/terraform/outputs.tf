output "ecr_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_sg_id" {
  value = module.alb.security_group_id
}

output "alb_target_group_arn" {
  value = module.alb.target_groups.http-group.arn
}

output "ecs_sg_name" {
  value = local.ecs_sg
}

output "log_group_name" {
  value = local.log_group
}
