variable "alb_name" {}
variable "grafana_port" {}
variable "grafana_protocol" {}
variable "grafana_tg_name" {}
variable "grafana_tg_port" {}
variable "grafana_tg_protocol" {}
variable "ecs_cluster_name" {}
variable "grafana_service_name" {}
variable "grafana_container_name" {}
variable "grafana_container_port" {}
variable "grafana_desired_count" {}
variable "grafana_efs" {}
variable "ecs_sg_name" {}
variable "ecs_sg_description" {}
variable "alb_sg_name" {}
variable "alb_sg_description" {}


variable "prom_tg_port" {}
variable "prom_tg_protocol" {}
variable "prom_tg_name" {}
variable "prom_tg_target_port" {}
variable "prom_tg_target_protocol" {}
variable "prom_svc_name" {}
variable "prom_container_name" {}
variable "prom_container_port" {}
variable "prom_container_protocol" {}
variable "prom_efs_name" {}
