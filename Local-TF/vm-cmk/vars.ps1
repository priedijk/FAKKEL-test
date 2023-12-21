RG="disk-resources"
VMNAME="disk-vm"

az account set -s "SUBSCRIPTION_ID"

# Get the public Ip address of the Azure virtual machine.
VMIP=$(az vm show -d -g $RG -n $VMNAME --query publicIps -o tsv)


ssh testadmin@$VMIP