# Test 
output "vpc_id" {
  value = "${module.vpc-prod.vpc_id}"
}

output "private_subnet_ids" {
  value = "${module.vpc-prod.private_subnet_ids}"
}


output "public_subnet_ids" {
  value = "${module.vpc-prod.public_subnet_ids}"
}



output "public_route_table" {
  value = "${module.vpc-prod.public_route_table}"
}


output "private_route_table" {
  value = "${module.vpc-prod.private_route_table}"
}
