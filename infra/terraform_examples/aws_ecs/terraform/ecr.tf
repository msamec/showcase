locals {
  repo_name      = "${var.project_name}-${var.environment}"
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"
  version = "2.2.1"

  repository_name                 = local.repo_name
  create_lifecycle_policy         = false
  repository_force_delete         = true
  repository_image_tag_mutability = "MUTABLE"

  tags = var.tags
}
