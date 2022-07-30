terraform {
backend "azure" {}
}

variable "resource_env" {
default = "dev"
}

module "sqldbresource" {
source = "../sqldbmodule/"
}
