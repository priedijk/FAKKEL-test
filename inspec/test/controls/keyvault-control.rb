control 'azure_key_vault_control' do
    title "Check Azure Keyvault - control"
  
  describe azure_key_vault(resource_group: +input('RG'), name: +input('KEYVAULT')) do
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
end