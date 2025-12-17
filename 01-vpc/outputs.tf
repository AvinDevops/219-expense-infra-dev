# output "azs" {
#     value = module.vpc_test.az
# }

# output "mrt_id" {
#     value = module.vpc_test.main_rt_id
# }

output "vpc_id" {
    value = module.vpc_test.vpc_id
}

output "public_subnet_list" {
    value = module.vpc_test.public_subnet_ids
}

output "private_subnet_list" {
    value = module.vpc_test.private_subnet_ids
}

output "db_subnet_list" {
    value = module.vpc_test.db_subnet_ids
}

# output "db_subnet_group_name" {
#     value = module.vpc_test.db_subnet_group_name
# }