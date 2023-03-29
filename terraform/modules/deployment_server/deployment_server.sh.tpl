

/opt/splunk/bin/splunk edit licenser-localpeer -manager_uri 'https://lm.lab.splunk:8089' -auth admin:$${password}



/opt/splunk/bin/splunk restart

sleep 20

aws s3 cp ${splunk_ta_nix_download_url} /opt/splunk/etc/deployment-apps/
cd /opt/splunk/etc/deployment-apps/
tar -xvzf splunk-add-on-for-unix-and-linux_880.tgz
rm -f splunk-add-on-for-unix-and-linux_880.tgz
mkdir /opt/splunk/etc/deployment-apps/Splunk_TA_nix/local

cat <<EOT >> /opt/splunk/etc/deployment-apps/Splunk_TA_nix/local/inputs.conf
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

mkdir /opt/splunk/etc/deployment-apps/default_outputs
mkdir /opt/splunk/etc/deployment-apps/default_outputs/local

echo "# Default Outputs" > /opt/splunk/etc/deployment-apps/default_outputs/local/app.conf

cat <<EOT >> /opt/splunk/etc/deployment-apps/default_outputs/local/outputs.conf
[indexer_discovery:manager1]
pass4SymmKey = $${pass4symmkey}
manager_uri = https://im.lab.splunk:8089

[tcpout:default_indexers]
indexerDiscovery = manager1

[tcpout]
defaultGroup = default_indexers
EOT


/opt/splunk/bin/splunk restart

cat <<EOT >> /opt/splunk/etc/system/local/serverclass.conf
[serverClass:defaultClass]
whitelist.0 = *

[serverClass:defaultClass:app:Splunk_TA_nix]
restartSplunkWeb = 0
restartSplunkd = 1
stateOnClient = enabled

[serverClass:defaultClass:app:default_outputs]
restartSplunkWeb = 0
restartSplunkd = 1
stateOnClient = enabled
EOT

/opt/splunk/bin/splunk reload deploy-server -auth admin:$${password}