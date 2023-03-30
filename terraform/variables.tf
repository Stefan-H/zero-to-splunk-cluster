variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "aws_key_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "indexer_instance_size" {
  type = string
}

variable "splunk_instance_size" {
  type = string
}

variable "indexer_root_ebs_config" {
  type = object({
    volume_type = string
    volume_size = number
    iops        = number
    throughput  = number
  })
}

variable "splunk_root_ebs_config" {
  type = object({
    volume_type = string
    volume_size = number
    iops        = number
    throughput  = number
  })
}

variable "ssh_key" {
  type = string
}

variable "license_s3_uri" {
  type = string
}

variable "search_factor" {
  type = number
}

variable "replication_factor" {
  type = number
}

variable "indexer_count" {
  type = number
}

variable "subnet_cidr" {
  type = string
}


variable "rpm_download_url" {
  type = string
}

variable "splunk_ta_nix_s3_uri" {
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

