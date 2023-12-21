output "tags" {
  value = var.tags
}

output "application_services" {
  value = local.application_services
}
output "application_services_tags" {
  value = local.application_service_tags
}
output "business_criticalities" {
  value = local.business_criticalities
}
output "business_criticality_tags" {
  value = local.business_criticality_tags
}
