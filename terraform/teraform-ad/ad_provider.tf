terraform {
  required_providers {
    ad = {
      source = "hashicorp/ad"
      version = "0.4.2"
    }
  }
}

provider "ad" {
  # Configuration options
  winrm_hostname = "ad1"
  winrm_username = "administrator"
  winrm_password = "Welcome-123"
  #domain         = "test.local"
  #user           = "admin"
  #password       = "Welcome-123"
  #ip             = "192.168.0.150"
}
