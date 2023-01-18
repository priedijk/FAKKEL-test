# describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
#     it { should exist }  
#   end  

control 'azure_key_vault' do 
  title "Check Azure Keyvault" 

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.enabledForDiskEncryption') { should be_truthy }  
  end   

  privateEndpointConnections = azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')).properties.privateEndpointConnections
  privateEndpointConnections.each do |endpoints|
    describe endpoints do
      its('provisioningState') { should eq 'Succeeded' }

  privateEndpointConnections.each do |privateLink|
    describe privateLink do
      its('privateLinkServiceConnectionState.status') { should eq 'Approved' }

  # nsg_securityRules = azurerm_network_security_group(resource_group: 'asdf', name: 'asdf').properties.securityRules
  # nsg_securityRules.each do |securityRules|
  #   describe securityRules do
  #     its('name') { should cmp 'BASTION' }
  #   end


describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections.provisioningState') { should eq 'Succeeded' }
  end   

describe azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')) do
    its('properties.privateEndpointConnections.privateLinkServiceConnectionState.status') { should eq 'Approved' }
  end            
end