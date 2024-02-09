packer {
  required_plugins {
    amazon =  {
      version = >=1.2.8
      source = "github.com/hashicorp/amazon"
    }
  }
}

variable "AWS_ACCESS_KEY_ID" {
  type    = string
  default = ""
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type    = string
  default = ""
  sensitive = true
}

variable "AWS_DEFAULT_REGION" {
  type    = string
  default = "us-east-1"
}

# variable "AWS_ACCESS_KEY_ID" {
#   type    = string
#   default = "AKIAZI2LE2Z6CLDSGQZ7"
# }

# variable "AWS_SECRET_ACCESS_KEY" {
#   type    = string
#   default = "j4lfVWjpnLvWMLdJQ4YiQZ35EGMnoMxQE/XGW6dI"
# }

# variable "AWS_DEFAULT_REGION" {
#   type    = string
#   default = "us-east-1"
# }
