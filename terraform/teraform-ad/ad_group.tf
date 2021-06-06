
variable nameou { default = "TerraformTest" }
variable path { default = "dc=test,dc=local" }
variable description { default = "some description" }
variable protected { default = false }

variable namegp { default = "grouptr" }
variable sam_account_name { default = "TESTGROUP" }
variable scope { default = "global" }
variable category { default = "security" }

resource "ad_ou" "o" {
  name        = var.nameou
  path        = var.path
  description = var.description
  protected   = var.protected
}


resource "ad_group" "g" {
  name             = var.namegp
  sam_account_name = var.sam_account_name
  scope            = var.scope
  category         = var.category
  container        = ad_ou.o.dn
}
