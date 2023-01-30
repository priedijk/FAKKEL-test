# describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
#     it { should exist }  
#   end  

control 'azure_key_vault' do 
  title "Check Azure Keyvault" 

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.enabledForDiskEncryption') { should be_truthy }  
  end   

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('keyvault')) do
    its('properties.enabledForDiskEncryption') { should be_truthy }  
  end   
describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('keyvault_name')) do
    its('properties.enabledForDiskEncryption') { should be_truthy }  
  end   



  privateEndpointConnections = azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')).properties.privateEndpointConnections
  
  privateEndpointConnections.each do |endpoints|
    describe endpoints do
      its('properties.provisioningState') { should eq 'Succeeded' }
    end 
  end

  privateEndpointConnections.each do |privateLink|
    describe privateLink do
      its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
    end
  end




describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections.provisioningState') { should eq 'Succeeded' }
  end   

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections.privateLinkServiceConnectionState.status') { should eq 'Approved' }
  end            
end