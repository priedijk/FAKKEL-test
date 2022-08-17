
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
  default = {
    mail = {
      name          = "single",
      email_address = "single@test.nl"
    }
  }
  type = map(map(string))
}

variable "multiple_emails" {
  description = "Allowed Ec2 ports"
  type        = list
  default     = {
    "test1"  = "123@test.nl"
    "test2"  = "456@test.nl"
  }
}

/*
variable "multiple_emails" {
  default = {
    mail = {
      name          = "test1",
      email_address = "123@test.nl"
    }
    mail = {
      name          = "test2",
      email_address = "456@test.nl"
    }
  }
  type = map(map(string))
}
*/