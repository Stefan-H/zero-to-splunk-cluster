region = "us-west-2"
vpc_cidr = "10.0.0.0/16"
subnet_cidr = "10.0.1.0/24"
aws_key_name = "Stefan"
indexer_instance_size = "m5.xlarge"
splunk_instance_size = "m5.xlarge"
ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJns/T4gReQLLWpbpHMxeO6TdkE+Y2m5sXpq8vLC9xu stefanhutchison@Stefans-MacBook-Pro.local"
rpm_download_url = "https://download.splunk.com/products/splunk/releases/9.0.4.1/linux/splunk-9.0.4.1-419ad9369127-linux-2.6-x86_64.rpm"
license_s3_uri = "s3://my-build-repository-shutchison/Splunk.License"
search_factor =  2
replication_factor = 2
indexer_count = 3
splunk_ta_nix_s3_uri = "s3://my-build-repository-shutchison/splunk-add-on-for-unix-and-linux_880.tgz"
#optional list of additional volumes. must use xvdb,xvdc, etc to have the volumes auto-mount.
#these will get mounted as /mount/dev/xvdb, etc. 
indexer_ebs_config = [{
    name = "/dev/xvdb"
    volume_type = "io2"
    volume_size = 50
    iops        = 10000
    throughput  = null
    }]
#root volume settings for indexers
indexer_root_ebs_config = {
    volume_type = "io2"
    volume_size = 50
    iops        = 10000
    throughput  = null
    }
#root volume settings for anything other than an indexer
splunk_root_ebs_config = {
    volume_type = "io2"
    volume_size = 50
    iops        = 10000
    throughput  = null
    }