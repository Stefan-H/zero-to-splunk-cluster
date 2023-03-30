variable "region" {
  type = string
}

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

variable "ssh_key" {
  type = string
}

variable "rpm_download_url" {
  type = string
}


variable "splunk_ta_nix_download_url" {
  type = string
}

variable "splunk_root_ebs_config" {
  type = object({
    volume_type = string
    volume_size = number
    iops        = number
    throughput  = number
  })
}
