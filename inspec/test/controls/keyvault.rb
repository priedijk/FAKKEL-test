# describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
#     it { should exist }  
#   end     

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


describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections[].provisioningState') { should eq 'Succeeded' }
  end   

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections[].privateLinkServiceConnectionState.status') { should eq 'Approved' }
  end            
describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections[*].provisioningState') { should eq 'Succeeded' }
  end   

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections[*].privateLinkServiceConnectionState.status') { should eq 'Approved' }
  end            