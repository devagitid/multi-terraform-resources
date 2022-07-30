terraform {
backend "azure" {}
}

module "sqldbresource" {
source = "../sqldbmodule/"
resource_env = "dev"
}
