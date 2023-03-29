resource "aws_instance" "splunk_im" {
  ami           = var.ami_id
  instance_type = var.instance_size
  subnet_id     = var.subnet_id
  user_data = format(
    "%s%s",
    templatefile("./modules/base_splunk/base.sh.tpl", {
      ssh_key          = var.ssh_key
      rpm_download_url = var.rpm_download_url
    }),
    templatefile("./modules/indexer_manager/indexer_manager.sh.tpl", {
      search_factor              = var.search_factor
      replication_factor         = var.replication_factor
      splunk_ta_nix_download_url = var.splunk_ta_nix_download_url
  }))
  key_name               = var.key_name
  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = var.security_groups
  tags = {
    Name = "Splunk Indexer Manager"
  }
  root_block_device {
    volume_size = 50
  }
}

output "public_ip" {
  value = aws_instance.splunk_im.public_ip
}

output "private_ip" {
  value = aws_instance.splunk_im.private_ip
}
