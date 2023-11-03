######
###  Global IP-Address
######
output "global_ip_address_vm_1" {
  value = module.vm_instance_1.external_ip_address_vm
}
output "global_ip_address_vm_2" {
  value = module.vm_instance_2.external_ip_address_vm
}

######
### Local IP-Address
######
output "local_ip_address_vm_1" {
  value = module.vm_instance_1.internal_ip_address_vm
}
output "local_ip_address_vm_2" {
  value = module.vm_instance_2.internal_ip_address_vm
}

