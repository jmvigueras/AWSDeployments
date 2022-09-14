// Create VPC-SEC
module "vpc-sec" {
    source = "./modules/vpc-sec"

    prefix          = var.prefix
    admin-cidr      = var.admin-cidr
    admin-sport     = var.admin-sport
    region          = var.region

    vpc-sec_net     = var.vpc-sec_net
    vpc-spoke-1_net = var.vpc-spoke-1_net
    vpc-spoke-2_net = var.vpc-spoke-2_net

    tgw_id          = aws_ec2_transit_gateway.tgw.id
}

// Create VPC-SPOKES
module "vpc-spokes" {
    source = "./modules/vpc-spoke"

    prefix          = var.prefix
    admin-cidr      = var.admin-cidr
    admin-sport     = var.admin-sport
    region          = var.region

    vpc-sec_net     = var.vpc-sec_net
    vpc-spoke-1_net = var.vpc-spoke-1_net
    vpc-spoke-2_net = var.vpc-spoke-2_net
    
    tgw_id         = aws_ec2_transit_gateway.tgw.id
}

// Create Active FGT
module "fgt-ha" {
    source = "./modules/fgt-ha"

    prefix          = var.prefix
    admin-cidr      = var.admin-cidr
    admin-sport     = var.admin-sport
    region          = var.region
    keypair         = var.keypair

    vpc-sec_net         = var.vpc-sec_net
    vpc-spoke-1_net     = var.vpc-spoke-1_net
    vpc-spoke-2_net     = var.vpc-spoke-2_net

    eni-active          = module.vpc-sec.eni-active
    eni-passive         = module.vpc-sec.eni-passive

    subnet-az1-vpc-sec  = module.vpc-sec.subnet-az1-vpc-sec
    subnet-az2-vpc-sec  = module.vpc-sec.subnet-az2-vpc-sec

    subnet-spoke-vm     = module.vpc-spokes.subnet-spoke-vm

    hub_id               = "HubAWS"
    advpn-public-hub-ip  = "10.10.10.253"
    hub-bgp-asn          = var.hub-bgp-asn
    sites-bgp-asn        = var.sites-bgp-asn

    advpn-ipsec-psk      = var.advpn-ipsec-psk
}

