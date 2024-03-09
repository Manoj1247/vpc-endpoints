module "database" {
  source = "./modules/storage"
}

module "network" {
  source = "./modules/network"
}