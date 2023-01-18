control 'hub_to_hub_peering' do 
    title "Check peering status" 
  
  describe azure_virtual_network_peering(resource_group: 'rg-appserviceplanintegration', vnet: 'appsvc', name: 'testpeer') do
      its('properties.peeringSyncLevel') { should eq 'FullyInSync' }  
    end   

  describe azure_virtual_network_peering(resource_group: 'rg-appserviceplanintegration', vnet: 'appsvc', name: 'testpeer') do
      its('properties.provisioningState') { should eq 'Succeeded' }  
    end   

  describe azure_virtual_network_peering(resource_group: 'Ansible', vnet: 'Ansible-VMVNET', name: 'testpeer2') do
      its('properties.peeringSyncLevel') { should eq 'FullyInSync' }  
    end   

    describe azure_virtual_network_peering(resource_group: 'Ansible', vnet: 'Ansible-VMVNET', name: 'testpeer2') do
      its('properties.provisioningState') { should eq 'Succeeded' }  
    end   
