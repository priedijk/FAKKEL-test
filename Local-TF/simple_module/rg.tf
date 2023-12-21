module "rg_module" {
  source = "./module"

  resource_group_name     = "module-rg-test"
  resource_group_location = "westeurope"

  resource_tags = {
    "service" = "rg"
  }
  sysops_tags = {
    "app1" = "high"
  }
  tags = [{ "app1" : "high", "app2" : "low" }]
}

output "tags" {
  value = module.rg_module.tags
}

output "app" {
  value = module.rg_module.application_services
}
output "app_tags" {
  value = module.rg_module.application_services_tags
}
output "busi_criticalities" {
  value = module.rg_module.business_criticalities
}
output "busi_criticality_tags" {
  value = module.rg_module.business_criticality_tags
}
