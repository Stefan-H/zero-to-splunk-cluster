variable "vpc_cidr" {
  type = string
}

variable "aws_key_name" {
  type = string
}

variable "indexer_instance_size" {
  type = string
}

variable "splunk_instance_size" {
  type = string
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

variable "splunk_ta_nix_download_url" {
  type = string
}
