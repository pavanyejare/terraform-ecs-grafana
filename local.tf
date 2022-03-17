locals {
  vpc = "vpc-dc1988b7"
  tags = {
    "env"            = "dev"
    "purpose"        = "wfapi"
    "application"    = "onlinebanking"
    "organization"   = "wafd"
    "shared-service" = "psl"
    "cost-center"    = "IT"
    "business-unit"  = "banking"
    "owner"          = "development"
    "app-tier"       = "middleware"
  }
  grafana_efs = [
    { name = "grafana"
      path = "/grafana"
    },
    {
      name = "grafana_config"
      path = "/grafana_config"
    },
    {
      name = "gtest"
      path = "/gtest"
    },
    {
      name = "grafana_datasource"
      path = "/grafana_datasource"
    }

  ]

  container_defination = [
    {
      image = "grafana/grafana:7.4.2" #"${data.aws_ecr_repository.ecr.repository_url}:latest"
      name  = "grafana"
      user  = "root"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/grafana"
          awslogs-region        = "us-east-2"
          awslogs-stream-prefix = "ecs"
        }
      }
      mountPoints = [
        {
          containerPath = "/var/lib/grafana/"
          sourceVolume  = "grafana_config"
          readOnly      = false
        },
        {
          containerPath = "/etc/grafana/provisionin/dashboards"
          sourceVolume  = "grafana_dashboard"
          readOnly      = false
        },
        {
          containerPath = "/etc/grafana/provisionin/datasource"
          sourceVolume  = "grafana_datasource"
          readOnly      = false
        }
      ]
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
      }]
      environment = [
        {
          name  = "GF_SECURITY_ADMIN_USER"
          value = "admin"
        },
        {
          name  = "GF_SECURITY_ADMIN_PASSWORD"
          value = "admin"
        },
        {
          name  = "GF_USER_ALLOW_SIGN_UP"
          value = "false"
        },
        {
          name  = "GF_SMTP_HOST"
          value = "mail"
        }

      ]
    }
  ]


}
