variable "initial_foundation_deployment" {
  description = "should be true during the initial deployment of both hubs (weu & frc). A second deployment is needed after the initial deployment has been done for each hub"
  type        = bool
  default     = false
}
