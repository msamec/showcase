variable "project_name" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "environment" {
  type    = string
  description = "The environment to deploy to"
  default = "dev"
}

variable "region" {
  type    = string
  description = "The AWS region to deploy to"
  default = "us-east-1"
}

variable "ecs_desired_count" {
  type = number
  description = "The number of tasks to run"
  default = 1
}

variable "domain_name" {
  type = string
  description = "The domain name to use for the application"
}

variable "hosted_zone_id" {
  description = "The ID of the Route53 hosted zone to use for the application"
  type = string
}

