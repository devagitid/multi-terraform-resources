variable "environment" {

default = "dev"

}

module "sqldbresource" {
source = "../sqldbmodule/"
}
