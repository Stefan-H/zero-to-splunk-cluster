# zero-to-splunk-cluster

A quick-and-dirty splunk cluster deployment. A mash-up of some bash scripts and terraform to deploy a pretty consistent basic splunk cluster on AWS. Tunable for search factor/replication factor/number of indexers.

I'll update this in the next couple days to have more customization to the ebs volumes on the indexers.

This is really just a playground, but the principles in this might be useful to someone.

You'll need to configure two aws_secrets in the region specified in your input vars:
splunk_password
pass4symmkey

splunk_password will be the default admin password.
pass4symmkey will be the key used for cluster communications.

Upload a copy of the Splunk_TA_nix tgz to S3 in a bucket that has a private access policy and put the S3 uri in the tfvars file
Upload your splunk license to S3 in a bucket that has a private access policy and put the S3 uri in the tfvars file
Put your SSH key that you want to be able to SSH to the hosts with in the tfvars file.
I left mine in there as an example.

After the instances have been deployed, there will be outputs with the public IP address, you can connect to a splunk instance over ssh with 

ssh root@<splunk_instance_ip> -L 8000:localhost:8000

and then navigate to localhost:8000 in your browser.
