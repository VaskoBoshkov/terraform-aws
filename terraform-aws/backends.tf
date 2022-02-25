terraform {
  cloud {
    organization = "vasko-terraform"

    workspaces {
      name = "vasko-dev"
    }
  }
}