
mkdir /mount
mkdir /mount/dev
for drive in /dev/xvd*
do
	if [[ ! $drive =~ .*xvda.* ]]; then
		mkfs.ext4 $drive
		mkdir /mount$drive
		mount $drive /mount$drive
	fi
done


/opt/splunk/bin/splunk edit licenser-localpeer -manager_uri 'https://${license_manager_fqdn}:8089' -auth admin:$${password}

/opt/splunk/bin/splunk restart

sleep 60

/opt/splunk/bin/splunk edit cluster-config -mode peer -manager_uri https://${indexer_manager_fqdn}:8089 -replication_port 9887 -secret $${pass4symmkey} -auth admin:$${password}
/opt/splunk/bin/splunk enable listen 9997 -auth admin:$${password}

/opt/splunk/bin/splunk restart