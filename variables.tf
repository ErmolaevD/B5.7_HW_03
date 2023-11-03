######
### Variables for YandexClooud
######


variable "service_account_key_file" {
  default     = "*"
  description = "Connect key"
}


variable "cloud_id" {
  default     = "*"
  description = "Main Account"
}

variable "folder_id" {
  default     = "*"
  description = "Main Folder"
}
