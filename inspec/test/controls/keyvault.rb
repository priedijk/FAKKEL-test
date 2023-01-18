# describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
#     it { should exist }  
#   end  

keyvaultProperties = azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT'))
privateEndpointConnections = keyvaultProperties["privateEndpointConnections"]
privateEndpointConnectionsToo = keyvaultProperties["privateEndpointConnections[0]"]

control 'azure_key_vault' do 
  title "Check Azure Keyvault" 

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.enabledForDiskEncryption') { should be_truthy }  
  end     

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections.provisioningState') { should eq 'Succeeded' }
  end   

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections.privateLinkServiceConnectionState.status') { should eq 'Approved' }
  end       

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections[0].provisioningState') { should eq 'Succeeded' }
  end   

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections[0].privateLinkServiceConnectionState.status') { should eq 'Approved' }
  end  

describe privateEndpointConnections do
  its('provisioningState') { should eq 'Succeeded' }   
  end        

describe privateEndpointConnectionsToo do
  its('provisioningState') { should eq 'Succeeded' }   
  end        

describe privateEndpointConnections do
  its('privateLinkServiceConnectionState.status') { should eq 'Approved' }   
  end        

describe privateEndpointConnectionsToo do
  its('privateLinkServiceConnectionState.status') { should eq 'Approved' }   
  end        
end