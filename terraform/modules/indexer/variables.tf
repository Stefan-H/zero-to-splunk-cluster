variable "ami_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
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

variable "indexer_count" {
  type = number
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

variable "indexer_ebs_config" {
  type = list(object({
    name        = string
    volume_type = string
    volume_size = number
    iops        = number
    throughput  = number
  }))
}

