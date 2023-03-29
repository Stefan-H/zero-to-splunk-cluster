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

variable "license_s3_uri" {
  type = string
}

variable "rpm_download_url" {
  type = string
}
