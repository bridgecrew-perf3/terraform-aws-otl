locals {
  vpc_id                = var.vpc_id
  subnet_ids            = var.subnet_ids
  image                 = var.image
  cluster_id            = var.cluster_id
  proxy_url             = var.proxy_url
  high_availability     = length(local.subnet_ids) > 2
  image_pull_secret_arn = var.image_pull_secret_arn
  cpu                   = var.cpu
  memory                = var.memory
  task_execute_role_arn = var.task_execute_role_arn
  # network
  security_groups_ids       = var.security_group_ids
  network_mode              = "awsvpc"
  support_provider          = ["FARGATE"]
  otl_server_listening_port = var.otl_server_listening_port
  otl_server_tunneling_port = var.otl_server_tunneling_port
  log_driver                = "awslogs"
  application_name          = "otl"
  log_group_name            = var.log_group_name
}

data "aws_vpc" "this" {
  id = local.vpc_id
}
# get current region
data "aws_region" "current" {}
# get cluster_default_logging_group
data "aws_cloudwatch_log_group" "this" {
  name = local.log_group_name
}

resource "aws_ecs_task_definition" "this" {
  cpu                      = local.cpu
  memory                   = local.memory
  execution_role_arn       = local.task_execute_role_arn
  network_mode             = local.network_mode
  requires_compatibilities = local.support_provider
  task_role_arn            = local.task_execute_role_arn

  container_definitions = jsonencode(
    [
      {
        name  = local.application_name
        image = local.image
        repositoryCredentials = {
          credentialsParameter = local.image_pull_secret_arn
        }
        environment = [
          { name = "OTL_SERVER_HOST", value = local.proxy_url },
          { name = "OTL_NETWORK_CIDRS", value = data.aws_vpc.this.cidr_block },
          { name = "OTL_NETWORK_IDS", value = trimsuffix(data.aws_vpc.this.id, "vpc-") },
          { name = "OTL_SERVER_PORT1", value = tostring(local.otl_server_listening_port) },
          { name = "OTL_SERVER_PORT2", value = tostring(local.otl_server_tunneling_port) },
        ]
        logConfiguration = {
          logDriver = local.log_driver
          options = {
            awslogs-group         = data.aws_cloudwatch_log_group.this.name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = local.application_name
          }
        }
      }
    ]
  )
  family = local.application_name
}

resource "aws_ecs_service" "this" {
  for_each = toset(local.subnet_ids)

  name            = format("%s-%s", local.application_name, trimprefix(each.key, "subnet-"))
  cluster         = local.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [each.key]
    security_groups = local.security_groups_ids
  }

  lifecycle {
    create_before_destroy = true
  }
}