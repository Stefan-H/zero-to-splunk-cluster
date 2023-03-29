

resource "aws_instance" "splunk_idx" {
  count         = var.indexer_count
  ami           = var.ami_id
  instance_type = var.instance_size
  subnet_id     = var.subnet_ids[(count.index % length(var.subnet_ids))]
  user_data = format(
    "%s%s",
    templatefile("./modules/base_splunk/base.sh.tpl", {
      ssh_key          = var.ssh_key
      rpm_download_url = var.rpm_download_url
    }),
  templatefile("./modules/indexer/indexer.sh.tpl", {}))
  key_name               = var.key_name
  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = var.security_groups
  tags = {
    Name = "Splunk Indexer ${count.index + 1}"
  }
  root_block_device {
    volume_size = 50
  }
}

output "indexer_ips" {
  value = ["${aws_instance.splunk_idx.*.public_ip}"]
}
