#! /bin/bash

#write the provided SSH key to root's authorized_keys for easy access.
echo "${ssh_key}" >> ~/.ssh/authorized_keys

#Make a temp install directory, pull down the rpm from splunk, install
mkdir /tmp/splunk_install
cd /tmp/splunk_install
wget -O splunk.rpm ${rpm_download_url}
rpm -i splunk.rpm

#set THP to never, then instal and init.d script to ensure its set on reboot
echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled
echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag 
cat <<'EOT' >> /etc/init.d/disable-transparent-hugepages
#!/bin/sh

### BEGIN INIT INFO
# Provides:          disable-transparent-hugepages
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description:       Disable Linux transparent huge pages, to improve
#                    database performance.
### END INIT INFO

case $1 in   start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo 'never' > $${thp_path}/enabled
    echo 'never' > $${thp_path}/defrag

    unset thp_path
    ;; 
esac 
EOT
sudo chmod 755 /etc/init.d/disable-transparent-hugepages
sudo chkconfig --add disable-transparent-hugepages

#Set ulimits to appropriate settings for splunk
cat <<EOT >> /etc/security/limits.d/splunk.conf
    *       soft  nofile  64000
    *       hard  nofile  64000
EOT

#First start and enable boot start
/opt/splunk/bin/splunk start --accept-license --no-prompt
/opt/splunk/bin/splunk enable boot-start 

#Stop for config file update (I can probably move the admin user creation to before the first start then I wouldn't need this)
/opt/splunk/bin/splunk stop

#Get secrets from secret manager (these are configured outside of terraform.)
password=`aws secretsmanager get-secret-value --region us-west-2 --secret-id splunk_password --query SecretString --output text`
pass4symmkey=`aws secretsmanager get-secret-value --region us-west-2 --secret-id pass4symmkey --query SecretString --output text`

#Write the admin seed user
cat <<EOT >> /opt/splunk/etc/system/local/user-seed.conf
[user_info]
USERNAME = admin
PASSWORD = $${password}
EOT

#Start back up and set license manager
/opt/splunk/bin/splunk start 