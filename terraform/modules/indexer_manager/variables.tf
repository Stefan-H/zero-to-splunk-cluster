variable "ami_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "instance_size" {
  type = string
}

variable "search_factor" {
  type = number
}

variable "replication_factor" {
  type = number
}

variable "ssh_key" {
  type = string
}

variable "rpm_download_url" {
  type = string
}

variable "splunk_ta_nix_download_url" {
  type = string
}
