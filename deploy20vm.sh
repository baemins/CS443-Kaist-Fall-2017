#! /bin/bash

echo "Deploy 20 vms"

resource_group_name="CS443"
vnet_name="CS443-Vnet"
subnet_name="defalut"
public_ip_name="VMPublicIP"
nsg_name="CS443-NSG"
nic_name="CS443-NIC"
vm_name_prefix="VM"
location="koreacentral"
ssh_id="put your admin"    #id length check
ssh_pwd="put your password"    #pwd length and complexity check

# Create a resource group.
az group create --name $resource_group_name --location $location

# Create a virtual network.
az network vnet create --resource-group $resource_group_name --name $vnet_name --subnet-name $subnet_name

# deploy 2 vm - change here to target number    
# check maximum vm number limtation and size https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/
# default vm size is "Default: Standard_DS1_v2"
for i in {1..2}
do
   echo "vm $i deploying"

    # Create a public IP address.
    az network public-ip create --resource-group $resource_group_name --name $public_ip_name$i
    
    # Create a network security group.
    az network nsg create --resource-group $resource_group_name --name $nsg_name$i

    # Create a virtual network card and associate with public IP address and NSG.
    az network nic create --resource-group $resource_group_name --name $nic_name$i --vnet-name $vnet_name --subnet $subnet_name --network-security-group $nsg_name$i --public-ip-address $public_ip_name$i
    
    # Create a new virtual machine, this creates SSH keys if not present.
    az vm create --resource-group $resource_group_name --name $vm_name_prefix$i --nics $nic_name$i --image UbuntuLTS --admin-password $ssh_pwd --admin-username $ssh_id 
    
    # Open port 22 to allow SSh traffic to host.
    az vm open-port --port 22 --resource-group $resource_group_name --name $vm_name_prefix$i
done

echo "done!"