#! /bin/bash

echo "stop 20 vms"

# set resource group name and vm name
resource_group_name="CS443"
vm_name_prefix="VM"

# stop 20 vm 
for i in {1..2}
do
    # change this loop number
    echo "vm $i stopping"

    # stop vm with resource group and vm name
    az vm stop --resource-group $resource_group_name --name $vm_name_prefix$i

done

echo "done!"
