#Join as a license peer to the license manager
/opt/splunk/bin/splunk edit licenser-localpeer -manager_uri 'https://lm.lab.splunk:8089' -auth admin:$${password}

#Copy down Splunk_TA_nix for use on the indexers
aws s3 cp ${splunk_ta_nix_download_url} /opt/splunk/etc/manager-apps/
cd /opt/splunk/etc/manager-apps/
tar -xvzf splunk-add-on-for-unix-and-linux_880.tgz
rm -f splunk-add-on-for-unix-and-linux_880.tgz
mkdir /opt/splunk/etc/manager-apps/Splunk_TA_nix/local

#Enable all the scripts in Splunk_TA_nix
cat <<EOT >> /opt/splunk/etc/manager-apps/Splunk_TA_nix/local/inputs.conf
[script://./bin/bandwidth.sh]
disabled = 0

[script://./bin/df.sh]
disabled = 0

[script://./bin/cpu_metric.sh]
disabled = 0

[script://./bin/cpu.sh]
disabled = 0

[script://./bin/df_metric.sh]
disabled = 0

[script://./bin/hardware.sh]
disabled = 0

[script://./bin/interfaces.sh]
disabled = 0

[script://./bin/interfaces_metric.sh]
disabled = 0

[script://./bin/iostat.sh]
disabled = 0

[script://./bin/iostat_metric.sh]
disabled = 0

[script://./bin/lastlog.sh]
disabled = 0

[script://./bin/lsof.sh]
disabled = 0

[script://./bin/netstat.sh]
disabled = 0

[script://./bin/nfsiostat.sh]
disabled = 0

[script://./bin/openPorts.sh]
disabled = 0

[script://./bin/openPortsEnhanced.sh]
disabled = 0

[script://./bin/package.sh]
disabled = 0

[script://./bin/passwd.sh]
disabled = 0

[script://./bin/protocol.sh]
disabled = 0

[script://./bin/ps_metric.sh]
disabled = 0

[script://./bin/ps.sh]
disabled = 0

[script://./bin/rlog.sh]
disabled = 0

[script://./bin/selinuxChecker.sh]
disabled = 0

[script://./bin/service.sh]
disabled = 0

[script://./bin/sshdChecker.sh]
disabled = 0

[script://./bin/time.sh]
disabled = 0

[script://./bin/top.sh]
disabled = 0

[script://./bin/update.sh]
disabled = 0

[script://./bin/uptime.sh]
disabled = 0

[script://./bin/usersWithLoginPrivs.sh]
disabled = 0

[script://./bin/version.sh]
disabled = 0

[script://./bin/vmstat.sh]
disabled = 0

[script://./bin/vmstat_metric.sh]
disabled = 0

[script://./bin/vsftpdChecker.sh]
disabled = 0

[script://./bin/who.sh]
disabled = 0
EOT


#Create a test index on the indexers, really just to plumb out the option.
mkdir /opt/splunk/etc/manager-apps/indexes
mkdir /opt/splunk/etc/manager-apps/indexes/local
cat <<EOT >> /opt/splunk/etc/manager-apps/indexes/local/indexes.conf
[test]

homePath   = $SPLUNK_DB/test/db
coldPath   = $SPLUNK_DB/test/colddb
thawedPath = $SPLUNK_DB/test/thaweddb
maxDataSize = 10000
maxHotBuckets = 10
EOT

/opt/splunk/bin/splunk restart
sleep 20

#Configure Indexer cluster settings
/opt/splunk/bin/splunk edit cluster-config -mode manager -replication_factor ${replication_factor} -search_factor ${search_factor} -secret $${pass4symmkey} -cluster_label cluster1 -auth admin:$${password}

#Turn on indexer discovery
cat <<EOT >> /opt/splunk/etc/system/local/server.conf

[indexer_discovery]
pass4SymmKey = $${pass4symmkey}
polling_rate = 10
indexerWeightByDiskCapacity = true
EOT

#join to the deployment server - this is likely a bad idea, but will play around with this.
/opt/splunk/bin/splunk set deploy-poll ds.lab.splunk:8089 -auth admin:$${password}


/opt/splunk/bin/splunk restart