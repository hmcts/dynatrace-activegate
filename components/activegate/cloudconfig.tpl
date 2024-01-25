#cloud-config
package_upgrade: true

runcmd:
 - 'wget -O /opt/Dynatrace-ActiveGate-Linux-x86-latest.sh "https://${dynatrace_instance_name}.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?arch=x86&flavor=default" --header="Authorization: Api-Token ${paas_token}"'
 - bash /opt/Dynatrace-ActiveGate-Linux-x86-latest.sh --set-network-zone=${network_zone}
 - apt-get update
 - apt-get install unzip
 - '[ ! -f /usr/local/bin/blobxfer-1.9.4 ] && wget -O /usr/local/bin/blobxfer-1.9.4  https://github.com/Azure/blobxfer/releases/download/1.9.4/blobxfer-1.9.4-linux-x86_64'
 - chmod 755 /usr/local/bin/blobxfer-1.9.4
 - blobxfer-1.9.4 download --storage-account ${plugin_storage_account} --storage-account-key ${plugin_storage_key}
 - sed -i 's/^UMASK.*/UMASK 027/' /etc/login.defs