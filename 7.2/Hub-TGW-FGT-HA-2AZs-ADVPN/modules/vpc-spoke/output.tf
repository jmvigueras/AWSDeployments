output "ni-spoke-vm_id" {
  value = {
    "ni-spoke-1_id" = aws_network_interface.ni-vm-spoke-1.id
    "ni-spoke-2_id" = aws_network_interface.ni-vm-spoke-2.id
  }
}

output "ni-spoke-vm_ip" {
  value = {
    "ni-spoke-1_ip" = aws_network_interface.ni-vm-spoke-1.private_ip
    "ni-spoke-2_ip" = aws_network_interface.ni-vm-spoke-2.private_ip
  }
}

output "subnet-spoke-vm" {
  value = {
    "n-spoke-1-vm_net"    = aws_subnet.subnet-vpc-spoke-1-vm.cidr_block
    "n-spoke-2-vm_net"    = aws_subnet.subnet-vpc-spoke-2-vm.cidr_block
    "n-spoke-1-vm_id"    = aws_subnet.subnet-vpc-spoke-1-vm.id
    "n-spoke-2-vm_id"    = aws_subnet.subnet-vpc-spoke-2-vm.id
  }
}

output "vpc-spokes_id" {
  value = {
    "vpc-spoke-1_id"    = aws_vpc.vpc-spoke-1.id
    "vpc-spoke-2_id"    = aws_vpc.vpc-spoke-2.id
  }
}

output "tgw-att-vpc-spoke-1_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-spoke-1.id
}

output "tgw-att-vpc-spoke-2_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-spoke-2.id
}