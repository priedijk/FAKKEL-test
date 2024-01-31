https://learn.microsoft.com/en-us/azure/developer/ansible/install-on-linux-vm?source=recommendations&tabs=azure-cli

RG="Ansible"
VMNAME="Ansible-VM"
MYIPS[0]=""
MYIPS[1]=""
MYIPS[2]=""
MYIPS[3]=""
MYIPS[4]=""


az account set -s "SUBSCRIPTION"

az group create --name $RG --location westeurope

# Create the Azure virtual machine for Ansible.
az vm create \
--resource-group $RG \
--name $VMNAME \
--image OpenLogic:CentOS:7.7:latest \
--size Standard_DS1_v2 \
--admin-username azureuser \
--admin-password "PASSWORD"

az vm auto-shutdown -g $RG -n $VMNAME --time 1830

# NSG rules
az network nsg rule create -n "OnlyMIPS" -g $RG --nsg-name "${VMNAME}NSG" \
--source-address-prefixes ${MYIPS[0]} ${MYIPS[1]} ${MYIPS[2]} ${MYIPS[3]} ${MYIPS[4]} --source-port-ranges '*' \
--destination-address-prefixes '*' --destination-port-range 22 \
--protocol Tcp --access "Allow" --priority 500

az network nsg rule delete -n "default-allow-ssh" -g $RG --nsg-name "${VMNAME}NSG"




az login
az account set -s "SUBSCRIPTION"

# Get the public Ip address of the Azure virtual machine.
VMIP=$(az vm show -d -g $RG -n $VMNAME --query publicIps -o tsv)

ssh azureuser@$VMIP
azureuser
PASSWORD

export AZURE_SUBSCRIPTION_ID="SUBSCRIPTION"
export AZURE_TENANT="TENANT"
export AZURE_CLIENT_ID="CLIENT ID"
export AZURE_SECRET="SECRET"


Ansible extra secret = "SECRET"



#### get VM status
az vm show -n $VMNAME -g $RG -d
