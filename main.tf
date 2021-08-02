locals {
  type                    = var.type
  vpc_id                  = var.vpc_id
  subnet_ids              = compact(var.subnet_ids)
  security_group_ids      = compact(var.security_group_ids)
  proxy_url                 = var.proxy_url
  cpu                     = var.cpu
  memory                  = var.memory
  cluster_id              = var.cluster_id
  task_execute_role_arn   = var.task_execute_role_arn
  image_pull_secret_arn   = var.image_pull_secret_arn
  image                   = var.image
  otl_server_listening_port = var.otl_server_listening_port
  otl_server_tunneling_port = var.otl_server_tunneling_port
}

module "ecs" {
  source             = "./modules/ecs"
  vpc_id             = local.vpc_id
  security_group_ids = local.security_group_ids
  subnet_ids         = local.subnet_ids
  count              = local.type == "ecs" ? 1 : 0

  proxy_url                 = local.proxy_url
  cluster_id              = local.cluster_id
  task_execute_role_arn   = local.task_execute_role_arn
  image_pull_secret_arn   = local.image_pull_secret_arn
  image                   = local.image
  otl_server_listening_port = local.otl_server_listening_port
  otl_server_tunneling_port = local.otl_server_tunneling_port
}

module "ec2" {
  source             = "./modules/ec2"
  vpc_id             = local.vpc_id
  security_group_ids = var.security_group_ids
  subnet_ids         = local.subnet_ids
  count              = local.type == "ec2" ? 1 : 0
}