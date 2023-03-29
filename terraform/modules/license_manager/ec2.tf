resource "aws_instance" "splunk_lm" {
  ami           = var.ami_id
  instance_type = var.instance_size
  subnet_id     = var.subnet_id
  user_data = format(
    "%s%s",
    templatefile("./modules/base_splunk/base.sh.tpl", {
      ssh_key          = var.ssh_key
      rpm_download_url = var.rpm_download_url
    }),
    templatefile("./modules/license_manager/license_manager.sh.tpl", {
      license_s3_uri = var.license_s3_uri
  }))
  key_name               = var.key_name
  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = var.security_groups
  tags = {
    Name = "Splunk License Manager"
  }
  root_block_device {
    volume_size = 50
  }
}

output "public_ip" {
  value = aws_instance.splunk_lm.public_ip
}

output "private_ip" {
  value = aws_instance.splunk_lm.private_ip
}
