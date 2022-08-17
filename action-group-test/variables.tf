
variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "location_code" {
  description = "Location code identifier"
  type        = string
  default     = "weu"
}

variable "role-id-owner" {
  type    = string
  default = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
}

variable "single_email" {
  type = map(object({
    name          = string
    email_address = string
  }))
  default = {
    mail1 = {
      name          = "single",
      email_address = "single@test.nl"
    }
  }
}

variable "multiple_emails" {
  type = map(object({
    name          = string
    email_address = string
  }))
  default = {
    mail1 = {
      name          = "test1",
      email_address = "123@test.nl"
    }
    mail2 = {
      name          = "test2",
      email_address = "456@test.nl"
    }
  }
}