variable "project" {
  type        = string
  default     = "master-the-legacy"
  description = "The name of the project"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Cloud Environment"
}

locals {
  tags = merge(
    {
      project = var.project,
      environment = var.environment,
      owners = "minders"
    }
  )
}