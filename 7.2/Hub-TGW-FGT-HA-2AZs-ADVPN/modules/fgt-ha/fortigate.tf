##############################################################################################################
# FORTIGATES VM
##############################################################################################################

# Create and attach the eip to the units
resource "aws_eip" "eip-cluster-public" {
  vpc               = true
  network_interface = var.eni-active["port2_id"]
  tags = {
    Name = "${var.prefix}-eip-cluster-public"
  }
}

resource "aws_eip" "eip-active-mgmt" {
  vpc               = true
  network_interface = var.eni-active["port1_id"]
  tags = {
    Name = "${var.prefix}-eip-active-mgmt"
  }
}

resource "aws_eip" "eip-passive-mgmt" {
  vpc               = true
  network_interface = var.eni-passive["port1_id"]
  tags = {
    Name = "${var.prefix}-eip-passive-mgmt"
  }
}


# Create the instance FGT AZ1 Active
resource "aws_instance" "active-fgt" {
  ami                  = var.license_type == "byol" ? var.fgtvmbyolami[var.region["region"]] : var.fgt-ond-amis[var.region["region"]]
  instance_type        = var.instance_type
  availability_zone    = var.region["region_az1"]
  key_name             = var.keypair
  iam_instance_profile = aws_iam_instance_profile.APICall_profile.name
  user_data            = data.template_file.active-fgt.rendered
  network_interface {
    device_index         = 0
    network_interface_id = var.eni-active["port1_id"]
  }
  network_interface {
    device_index         = 1
    network_interface_id = var.eni-active["port2_id"]
  }
  network_interface {
    device_index         = 2
    network_interface_id = var.eni-active["port3_id"]
  }
  /*
  network_interface {
    device_index         = 3
    network_interface_id = var.eni-active["port4_id"]
  }
  */
  tags = {
    Name = "${var.prefix}-active-fgt"
  }
}

# Create the instance FGT AZ2 Passive
resource "aws_instance" "passive-fgt" {
  ami                  = var.license_type == "byol" ? var.fgtvmbyolami[var.region["region"]] : var.fgt-ond-amis[var.region["region"]]
  instance_type        = var.instance_type
  availability_zone    = var.region["region_az2"]
  key_name             = var.keypair
  iam_instance_profile = aws_iam_instance_profile.APICall_profile.name
  user_data            = data.template_file.passive-fgt.rendered
  network_interface {
    device_index         = 0
    network_interface_id = var.eni-passive["port1_id"]
  }
  network_interface {
    device_index         = 1
    network_interface_id = var.eni-passive["port2_id"]
  }
  network_interface {
    device_index         = 2
    network_interface_id = var.eni-passive["port3_id"]
  }
  /*
  network_interface {
    device_index         = 3
    network_interface_id = var.eni-passive["port4_id"]
  }
  */
  tags = {
    Name = "${var.prefix}-passive-fgt"
  }
}


data "template_file" "active-fgt" {
  template = file("./templates/fgt.conf")

  vars = {
    fgt_id               = "${var.hub_id}-Active"
    fgt_priority         = "200"
    admin-sport          = var.admin-sport
    admin-cidr           = var.admin-cidr
    type                 = "${var.license_type}"
    license_file         = "${var.license}"

    port1_ip             = var.eni-active["port1_ip"]
    port1_mask           = cidrnetmask(var.subnet-az1-vpc-sec["mgmt-ha_net"])
    port1_gw             = cidrhost(var.subnet-az1-vpc-sec["mgmt-ha_net"], 1)
    port2_ip             = var.eni-active["port2_ip"]
    port2_mask           = cidrnetmask(var.subnet-az1-vpc-sec["public_net"])
    port2_gw             = cidrhost(var.subnet-az1-vpc-sec["public_net"], 1)
    port3_ip             = var.eni-active["port3_ip"]
    port3_mask           = cidrnetmask(var.subnet-az1-vpc-sec["private_net"])
    port3_gw             = cidrhost(var.subnet-az1-vpc-sec["private_net"], 1)
//    port4_ip             = var.eni-active["port4_ip"]
//    port4_mask           = cidrnetmask(var.subnet-az1-vpc-sec["mpls_net"])
//    port4_gw             = cidrhost(var.subnet-az1-vpc-sec["mpls_net"], 1)

    n-spoke-1-vm_net     = var.subnet-spoke-vm["n-spoke-1-vm_net"]
    n-spoke-2-vm_net     = var.subnet-spoke-vm["n-spoke-2-vm_net"]
    spokes-onprem-cidr   = var.spokes-onprem-cidr

    peerip               = var.eni-passive["port1_ip"]
    advpn-public-hub-ip  = var.advpn-public-hub-ip
    hub-bgp-asn          = var.hub-bgp-asn
    sites-bgp-asn        = var.sites-bgp-asn
    hub-bgp-router-id    = var.hub-bgp-router-id

    advpn-ipsec-psk      = var.advpn-ipsec-psk
  }
}

data "template_file" "passive-fgt" {
  template = file("./templates/fgt.conf")

  vars = {
    fgt_id               = "${var.hub_id}-Passive"
    fgt_priority         = "100"
    admin-sport          = var.admin-sport
    admin-cidr           = var.admin-cidr
    type                 = "${var.license_type}"
    license_file         = "${var.license}"

    port1_ip             = var.eni-passive["port1_ip"]
    port1_mask           = cidrnetmask(var.subnet-az2-vpc-sec["mgmt-ha_net"])
    port1_gw             = cidrhost(var.subnet-az2-vpc-sec["mgmt-ha_net"], 1)
    port2_ip             = var.eni-passive["port2_ip"]
    port2_mask           = cidrnetmask(var.subnet-az2-vpc-sec["public_net"])
    port2_gw             = cidrhost(var.subnet-az2-vpc-sec["public_net"], 1)
    port3_ip             = var.eni-passive["port3_ip"]
    port3_mask           = cidrnetmask(var.subnet-az2-vpc-sec["private_net"])
    port3_gw             = cidrhost(var.subnet-az2-vpc-sec["private_net"], 1)
//    port4_ip             = var.eni-passive["port4_ip"]
//    port4_mask           = cidrnetmask(var.subnet-az2-vpc-sec["mpls_net"])
//    port4_gw             = cidrhost(var.subnet-az2-vpc-sec["mpls_net"], 1)

    n-spoke-1-vm_net     = var.subnet-spoke-vm["n-spoke-1-vm_net"]
    n-spoke-2-vm_net     = var.subnet-spoke-vm["n-spoke-2-vm_net"]
    spokes-onprem-cidr   = var.spokes-onprem-cidr

    peerip               = var.eni-active["port1_ip"]
    advpn-public-hub-ip  = var.advpn-public-hub-ip
    hub-bgp-asn          = var.hub-bgp-asn
    sites-bgp-asn        = var.sites-bgp-asn
    hub-bgp-router-id    = var.hub-bgp-router-id

    advpn-ipsec-psk      = var.advpn-ipsec-psk
  }
}
