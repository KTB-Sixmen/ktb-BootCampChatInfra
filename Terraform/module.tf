locals {
  make = true
}

module "ami" {
  source = "./module/AMI"
}

// ============================================================================================================

module "load_test_network" {
  source = "./module/network"

  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
  subnet_names = var.subnet_names
  any_ip       = var.any_ip
}

// ============================================================================================================

module "load_test_master" {
  source = "./module/node/master"
  count  = local.make == true ? 3 : 0

  ami_id             = module.ami.amazon_linux_id
  subnet_ids         = module.load_test_network.subnet_ids
  security_group_ids = module.load_test_network.security_group_ids

  instance_index = var.instance_indexes["master"] + count.index
}

// ============================================================================================================

module "load_test_ingress" {
  source = "./module/node/worker"
  count  = local.make == true ? 2 : 0

  ami_id             = module.ami.amazon_linux_id
  subnet_ids         = module.load_test_network.subnet_ids
  security_group_ids = module.load_test_network.security_group_ids

  instance_index = var.instance_indexes["worker"] + count.index
  instance_type  = "ingress"
}

// ============================================================================================================

module "load_test_back" {
  source = "./module/node/worker"
  count  = local.make == true ? 2 : 0

  ami_id             = module.ami.amazon_linux_id
  subnet_ids         = module.load_test_network.subnet_ids
  security_group_ids = module.load_test_network.security_group_ids

  instance_index = var.instance_indexes["worker"] + count.index + 2
  instance_type  = "back"
}

// ============================================================================================================

module "load_test_nlb" {
  source = "./module/LB"

  vpc_id      = module.load_test_network.vpc_id
  subnet_ids  = module.load_test_network.lb_subnet_ids
  ingress_ids = module.load_test_ingress[*].instance_id
}

// ============================================================================================================

module "load_test_route53" {
  source = "./module/Route53"

  nlb_dns_name = module.load_test_nlb.nlb_dns_name
  nlb_zone_id  = module.load_test_nlb.nlb_zone_id
}
