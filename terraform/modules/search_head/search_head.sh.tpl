

/opt/splunk/bin/splunk edit licenser-localpeer -manager_uri 'https://lm.lab.splunk:8089' -auth admin:$${password}

/opt/splunk/bin/splunk restart

sleep 60

/opt/splunk/bin/splunk edit cluster-config -mode searchhead -manager_uri https://im.lab.splunk:8089 -secret $${pass4symmkey} -auth admin:$${password}
/opt/splunk/bin/splunk set deploy-poll ds.lab.splunk:8089 -auth admin:$${password}


/opt/splunk/bin/splunk restart