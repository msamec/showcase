terraform {
  source = "../../terraform/"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  domain_name = "subdomain.example.com"
  ecs_desired_count = 1
}
