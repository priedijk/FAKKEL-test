control 'azure_key_vault' do
  title "Check Azure Keyvault"

describe azure_key_vault(resource_group: +input('RG'), name: +input('KEYVAULT')) do
    its('properties.enabledForDiskEncryption') { should be_truthy }
  end

  privateEndpointConnections = azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')).properties.privateEndpointConnections

   
  privateEndpointConnections.each do |endpoints|
    describe endpoints do
      its('properties.provisioningState') { should exist }
    end
  end

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


  privateEndpointConnectionsControl = azure_key_vault(resource_group: 'fileshare-resources', name: "rteasrdjkhvbjln").properties.privateEndpointConnections

   
  privateEndpointConnectionsControl.each do |endpoints|
    describe endpoints do
      its('properties.provisioningState') { should exist }
    end
  end
  
  privateEndpointConnectionsControl.each do |endpoints|
    describe endpoints do
      its('properties.provisioningState') { should eq 'Succeeded' }
    end
  end

  privateEndpointConnectionsControl.each do |privateLink|
    describe privateLink do
      its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
    end
  end








  # testing

  # keyvaults = azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids

  # keyvaults.each do |id|

  #   describe azure_key_vault(resource_id: id) do
  #     its('properties.enabledForDiskEncryption') { should be_truthy }
  #   end
  # end

keyvaults = azure_generic_resources(resource_group: 'fakkel-kv', name: +input('KEYVAULT'), resource_provider: 'Microsoft.KeyVault/vaults').ids

  keyvaults.each do |id|

    describe azure_key_vault(resource_id: id) do
      its('properties.enabledForDiskEncryption') { should be_truthy }
    end
  end






  # azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|
  #   describe azure_generic_resource(resource_id: id) do

      
  #       # disk encryption
  #       describe azure_key_vault(resource_group: +input('RG'), name: +input('KEYVAULT')) do
  #         its('properties.enabledForDiskEncryption') { should be_truthy }
  #       end

  #       # private endpoints
  #       privateEndpointConnections = azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')).properties.privateEndpointConnections

  #       privateEndpointConnections.each do |endpoints|
  #         describe endpoints do
  #           its('properties.provisioningState') { should eq 'Succeeded' }
  #         end
  #       end

  #       privateEndpointConnections.each do |privateLink|
  #         describe privateLink do
  #           its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
  #         end
  #       end
  #   end
  # end
end
