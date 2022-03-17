output "access_point" { value = module.grafana_dashboard_efs.access_point[*] }
#output "new" { value = [for u in module.grafana_dashboard_efs.access_point : u.id if u.tags["Name"] == "grafana"][0] }
