# dynatrace-activegate

Contains terraform code to create scalesets and associated infrastructure for [dynatrace-activegate](https://docs.dynatrace.com/docs/setup-and-configuration/dynatrace-activegate)

A DNS record has been configured to point to the IP of the active instance - only one instance in the scaleset is considered the active instance.

If the active instance becomes unavailable for any reason, update the [DNS records](https://github.com/hmcts/azure-private-dns/commit/0a57c906b1dd96fadc53c5e964d79f6c270bb237) to point to the IP address of another instance.

Dynatrace is configured to point to the DNS record so everything should update automatically when you update the DNS record.

## Connect to activegates via SSH

If you need to connect directly to the VMs in the scaleset, connect to one of the bastions and then connect to the instance either via its DNS name or its IP address, which can be found in the Azure portal.

SSH requires a private key for authentication, which can be found in [this keyvault](https://github.com/hmcts/dynatrace-activegate/blob/8db16ee4baac8fcdfd7995417be494ad838c4e98/components/activegate/vm.tf#L27).