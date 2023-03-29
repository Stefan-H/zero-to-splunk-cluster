
provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "amzLinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


module "search_head" {
  source = "./modules/search_head/"

  ami_id           = data.aws_ami.amzLinux.id
  subnet_id        = aws_subnet.public.id
  key_name         = var.aws_key_name
  instance_profile = aws_iam_instance_profile.secrets_manager_profile.id
  security_groups  = [aws_security_group.Splunk_All.id]
  instance_size    = var.splunk_instance_size
  ssh_key          = var.ssh_key
  rpm_download_url = var.rpm_download_url
  depends_on = [
    aws_route53_record.lm
  ]
}


module "license_manager" {
  source = "./modules/license_manager/"

  ami_id           = data.aws_ami.amzLinux.id
  subnet_id        = aws_subnet.public.id
  key_name         = var.aws_key_name
  instance_profile = aws_iam_instance_profile.secrets_manager_profile.id
  security_groups  = [aws_security_group.Splunk_All.id]
  instance_size    = var.splunk_instance_size
  ssh_key          = var.ssh_key
  rpm_download_url = var.rpm_download_url
  license_s3_uri   = var.license_s3_uri
}



module "indexer_manager" {
  source = "./modules/indexer_manager/"

  ami_id                     = data.aws_ami.amzLinux.id
  subnet_id                  = aws_subnet.public.id
  key_name                   = var.aws_key_name
  instance_profile           = aws_iam_instance_profile.secrets_manager_profile.id
  security_groups            = [aws_security_group.Splunk_All.id]
  instance_size              = var.splunk_instance_size
  ssh_key                    = var.ssh_key
  rpm_download_url           = var.rpm_download_url
  splunk_ta_nix_download_url = var.splunk_ta_nix_download_url
  search_factor              = var.search_factor
  replication_factor         = var.replication_factor
  depends_on = [
    aws_route53_record.lm
  ]
}



module "deployment_server" {
  source = "./modules/deployment_server/"

  ami_id                     = data.aws_ami.amzLinux.id
  subnet_id                  = aws_subnet.public.id
  key_name                   = var.aws_key_name
  instance_profile           = aws_iam_instance_profile.secrets_manager_profile.id
  security_groups            = [aws_security_group.Splunk_All.id]
  instance_size              = var.splunk_instance_size
  ssh_key                    = var.ssh_key
  rpm_download_url           = var.rpm_download_url
  splunk_ta_nix_download_url = var.splunk_ta_nix_download_url
  depends_on = [
    aws_route53_record.lm
  ]
}

module "indexers" {
  source = "./modules/indexer/"

  ami_id           = data.aws_ami.amzLinux.id
  subnet_ids       = [aws_subnet.public.id]
  key_name         = var.aws_key_name
  instance_profile = aws_iam_instance_profile.secrets_manager_profile.id
  security_groups  = [aws_security_group.Splunk_All.id]
  indexer_count    = var.indexer_count
  instance_size    = var.splunk_instance_size
  ssh_key          = var.ssh_key
  rpm_download_url = var.rpm_download_url
  depends_on = [
    aws_route53_record.im
  ]
}


output "SH_ip" {
  value = module.search_head.public_ip
}
output "LM_ip" {
  value = module.license_manager.public_ip
}
output "IM_ip" {
  value = module.indexer_manager.public_ip
}
output "indexer_ips" {
  value = module.indexers.indexer_ips
}
output "DS_ip" {
  value = module.deployment_server.public_ip
}
