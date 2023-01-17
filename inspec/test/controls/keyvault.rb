# describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
#     it { should exist }  
#   end     

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.enabledForDiskEncryption') { should be_true }  
  end     

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections.properties.privateEndpointConnections') { should eq 'Succeeded' }
  end            