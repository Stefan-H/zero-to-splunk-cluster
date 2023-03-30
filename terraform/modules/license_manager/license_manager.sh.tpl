

aws s3 cp ${license_s3_uri} /opt/splunk/Splunk.license
/opt/splunk/bin/splunk add licenses /opt/splunk/Splunk.license -auth admin:$${password}
/opt/splunk/bin/splunk set deploy-poll ${deployment_server_fqdn}:8089 -auth admin:$${password}

/opt/splunk/bin/splunk restart 

