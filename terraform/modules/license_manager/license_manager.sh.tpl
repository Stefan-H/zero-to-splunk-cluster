

aws s3 cp s3://my-build-repository-shutchison/Splunk.License /opt/splunk/Splunk.license
/opt/splunk/bin/splunk add licenses /opt/splunk/Splunk.license -auth admin:$${password}

/opt/splunk/bin/splunk start 
/opt/splunk/bin/splunk set deploy-poll ds.lab.splunk:8089 -auth admin:$${password}

