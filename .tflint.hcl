config {
  module = true
  force = false
  disabled_by_default = false
}

plugin "aws" {
  enabled = true
  deep_check = true
  region     = "eu-west-1"
  profile    = "terraform"
  shared_credentials_file = "~/.aws/credentials"
}
