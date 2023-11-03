########### Images Instans ###########
variable "instance_family_image" {
  description = "Instance image"
  type        = string
  default     = "lamp"
}


########## Subnet Instans ############
variable "vpc_subnet_id" {
  description = "VPC subnet network id"
  type        = string
}

########## Zone Instans ###########
variable "instans_zone_id" {
  description = "VPC subnet network id"
  type        = string
}
