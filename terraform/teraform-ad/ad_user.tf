
#variable container      { default = "CN=TerraformTest,DC=test,DC=local" }

#resource "ad_user" "tr2" {
#  principal_name    = "tr2"
#  sam_account_name  = "tr2"
#  display_name      = "Terraform Test User2"
#  initial_password  = "Welcome-123"
#  #container         =  var.container
#  custom_attributes = jsonencode({
#    "carLicense": ["This is", "a multi-value", "attribute"],
#    "comment": "and this is a single value attribute"
#    })
#  }


#  all user attributes
 variable principal_name2 { default = "tr3" }
 variable samaccountname2 { default = "tr3" }
 variable containeruser   { default = "CN=Users,DC=test,DC=local" }
#
  resource "ad_user" "tr3" {
  principal_name            = var.principal_name2
  sam_account_name          = var.samaccountname2
  display_name              = "Terraform Test User"
  container                 = var.containeruser
  initial_password          = "Welcome-123"
  city                      = "City"
  company                   = "Company"
  country                   = "us"
  department                = "Department"
  description               = "Description"
  division                  = "Division"
  email_address             = "some@email.com"
  employee_id               = "id"
  employee_number           = "number"
  fax                       = "Fax"
  given_name                = "GivenName"
  home_directory            = "HomeDirectory"
  home_drive                = "HomeDrive"
  home_phone                = "HomePhone"
  home_page                 = "HomePage"
  initials                  = "Initia"
  mobile_phone              = "MobilePhone"
  office                    = "Office"
  office_phone              = "OfficePhone"
  organization              = "Organization"
  other_name                = "OtherName"
  po_box                    = "POBox"
  postal_code               = "PostalCode"
  state                     = "State"
  street_address            = "StreetAddress"
  surname                   = "Surname"
  title                     = "Title"
  smart_card_logon_required = false
  trusted_for_delegation    = true
}
