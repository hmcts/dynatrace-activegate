#cloud-config for private ActiveGate synthethic monitoring
package_upgrade: true

runcmd:
 # Pin self-identified hostname to platform.hmcts.net: this VNet has DNS auto-registration
 # enabled AND Azure's own internal.cloudapp.net naming, so reverse DNS lookups are
 # non-deterministic between the two. ActiveGate re-registers with a new collector ID
 # whenever it resolves a different hostname on restart - this keeps it stable.
 - ["bash", "-c", "IP=$(hostname -I | awk '{print $1}'); NAME=$(hostname -s); echo \"$IP $NAME.platform.hmcts.net $NAME\" >> /etc/hosts"]
 - apt-get update
 - 'wget -O /opt/Dynatrace-ActiveGate-Linux-x86-latest.sh "https://${dynatrace_instance_name}.live.dynatrace.com/api/v1/deployment/installer/gateway/unix/latest?arch=x86&flavor=default" --header="Authorization: Api-Token ${paas_token}"'
 - bash /opt/Dynatrace-ActiveGate-Linux-x86-latest.sh --set-network-zone=${network_zone} --enable-synthetic
 - sed -i 's/^UMASK.*/UMASK 027/' /etc/login.defs