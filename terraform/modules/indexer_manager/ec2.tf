resource "aws_instance" "splunk_im" {
  ami           = var.ami_id
  instance_type = var.instance_size
  subnet_id     = var.subnet_id
  user_data = format(
    "%s%s",
    templatefile("./modules/base_splunk/base.sh.tpl", {
      ssh_key          = var.ssh_key
      rpm_download_url = var.rpm_download_url
      region           = var.region
    }),
    templatefile("./modules/indexer_manager/indexer_manager.sh.tpl", {
      search_factor              = var.search_factor
      replication_factor         = var.replication_factor
      splunk_ta_nix_download_url = var.splunk_ta_nix_download_url
      license_manager_fqdn       = "lm.${var.domain_name}"
      indexer_manager_fqdn       = "im.${var.domain_name}"
  }))
  key_name               = var.key_name
  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = var.security_groups
  tags = {
    Name = "Splunk Indexer Manager"
  }
  root_block_device {
    volume_size = var.splunk_root_ebs_config.volume_size
    volume_type = var.splunk_root_ebs_config.volume_type
    iops        = var.splunk_root_ebs_config.iops != null ? var.splunk_root_ebs_config.iops : null
    throughput  = var.splunk_root_ebs_config.throughput != null ? var.splunk_root_ebs_config.throughput : null
  }
}

output "public_ip" {
  value = aws_instance.splunk_im.public_ip
}

output "private_ip" {
  value = aws_instance.splunk_im.private_ip
}
