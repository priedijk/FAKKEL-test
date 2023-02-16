control 'azure_key_vault_disk_encryption' do
  title "Check Azure Keyvault"

describe azure_key_vault(resource_group: +input('RG'), name: +input('KEYVAULT')) do
    its('properties.enabledForDiskEncryption') { should be_truthy }
  end
end






# test of keyvault without a private endpoint

control 'azure_key_vault_disk_privateEndpointConnections' do
    title "Check Azure Keyvault"

  privateEndpointConnections = azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')).properties.privateEndpointConnections

  privateEndpointConnections.each do |endpoints|
    describe endpoints do
      its('properties') { should exist }
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
end






# control test of keyvault with a private endpoint
control 'azure_key_vault_disk_privateEndpointConnections_control' do
  title "Check Azure Keyvault"


  privateEndpointConnectionsControlProperties = azure_key_vault(resource_group: 'fileshare-resources', name: "rteasrdjkhvbjln")


  # how to check if this value is empty or not?
  describe privateEndpointConnectionsControlProperties do
    its('properties.privateEndpointConnections') { should_not exist }
  end

  privateEndpointConnectionsControlProperties2 = azure_key_vault(resource_group: 'fileshare-resources', name: "rteasrdjkhvbjln").properties


  # how to check if this value is empty or not?
  describe privateEndpointConnectionsControlProperties2 do
    its('privateEndpointConnections') { should_not eq '' }
  end




  privateEndpointConnectionsControlEndpoints = azure_key_vault(resource_group: 'fileshare-resources', name: "rteasrdjkhvbjln").properties.privateEndpointConnections.each do |endpoints|
  
    describe endpoints do
      its('properties.provisioningState') { should eq 'Succeeded' }
    end

    describe endpoints do
      its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
    end
  end
end




# testing

# control 'azure_key_vault_disk_privateEndpointConnections_generic' do
#   title "Check Azure Keyvault"

# keyvaults = azure_generic_resources(resource_group: 'fakkel-kv', name: +input('KEYVAULT'), resource_provider: 'Microsoft.KeyVault/vaults').ids

#   keyvaults.each do |id|

#     describe azure_key_vault(resource_id: id) do
#       its('properties.enabledForDiskEncryption') { should be_truthy }
#     end
#   end
# end



# with resource providers only type
control 'azure_key_vault_disk_privateEndpointConnections_generic_resource_provider' do
  title "Check Azure Keyvault"

  azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|
    
    describe azure_key_vault(resource_id: id) do
      its('properties.enabledForDiskEncryption') { should be_truthy }
    end
  end


  # azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|
  #   describe azure_generic_resource(resource_id: id) do
  #     it { should exist } 
  #   end
  # end
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
# end





privateEndpointConnectionsControl = azure_key_vault(resource_group: 'fileshare-resources', name: "rteasrdjkhvbjln").properties.privateEndpointConnections
  
privateEndpointConnectionsControl.each do |endpoints|
  describe endpoints.properties do
    it { should exist }
  end
end