

/opt/splunk/bin/splunk edit licenser-localpeer -manager_uri 'https://${license_manager_fqdn}:8089' -auth admin:$${password}

/opt/splunk/bin/splunk restart

sleep 60

/opt/splunk/bin/splunk edit cluster-config -mode searchhead -manager_uri https://${indexer_manager_fqdn}:8089 -secret $${pass4symmkey} -auth admin:$${password}
/opt/splunk/bin/splunk set deploy-poll ${deployment_server_fqdn}:8089 -auth admin:$${password}


/opt/splunk/bin/splunk restart