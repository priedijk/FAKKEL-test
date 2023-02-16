# control 'azure_key_vault_disk_encryption' do
#   title "Check Azure Keyvault"

# describe azure_key_vault(resource_group: +input('RG'), name: +input('KEYVAULT')) do
#     its('properties.enabledForDiskEncryption') { should be_truthy }
#   end
# end



# # test of keyvault without a private endpoint

# control 'azure_key_vault_disk_privateEndpointConnections' do
#     title "Check Azure Keyvault"

#   properties = azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT'))

#   describe properties.properties do
#     its('privateEndpointConnections') { should_not be_empty }
#   end

#   privateEndpointConnections = azure_key_vault(resource_group: 'fakkel-kv', name: +input('KEYVAULT')).properties.privateEndpointConnections

#   privateEndpointConnections.each do |endpoints|
#     describe endpoints do
#       its('properties.provisioningState') { should eq 'Succeeded' }
#     end
#   end

#   privateEndpointConnections.each do |privateLink|
#     describe privateLink do
#       its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
#     end
#   end
# end






# # control test of keyvault with a private endpoint
# control 'azure_key_vault_disk_privateEndpointConnections_control' do
#   title "Check Azure Keyvault"


#   privateEndpointConnectionsControlProperties = azure_key_vault(resource_group: 'fileshare-resources', name: "rteasrdjkhvbjln")

#   # how to check if this value is empty or not?
#   describe privateEndpointConnectionsControlProperties do
#     its('properties.privateEndpointConnections') { should_not be_empty }
#   end
  
#   privateEndpointConnectionsControlEndpoints = azure_key_vault(resource_group: 'fileshare-resources', name: "rteasrdjkhvbjln").properties.privateEndpointConnections.each do |endpoints|
  
#     describe endpoints do
#       its('properties.provisioningState') { should eq 'Succeeded' }
#     end

#     describe endpoints do
#       its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
#     end
#   end
# end




# # testing


# # with resource providers only type
# control 'azure_key_vault_disk_privateEndpointConnections_generic_resource_provider' do
#   title "Check Azure Keyvault"

#   azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|
    
#     describe azure_key_vault(resource_id: id) do
#       its('properties.enabledForDiskEncryption') { should be_truthy }
#     end
  
#     describe azure_key_vault(resource_id: id) do
#       its('properties.privateEndpointConnections') { should_not be_empty }
#     end

#     privateEndpointConnections = azure_key_vault(resource_id: id).properties.privateEndpointConnections.each do |endpoints|
  
#       describe endpoints do
#         its('properties.provisioningState') { should eq 'Succeeded' }
#       end
  
#       describe endpoints do
#         its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
#       end
#     end
#   end
# end



# check with tag
control 'azure_key_vault_with_tags' do
  title "Check Azure Keyvault - with tags"

  azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults', tag_name: 'owned-by', tag_value: 'cisaz').ids.each do |id|
    
    describe azure_key_vault(resource_id: id) do
      its('properties.enabledForDiskEncryption') { should be_truthy }
    end
  
    describe azure_key_vault(resource_id: id) do
      its('properties.privateEndpointConnections') { should_not be_empty }
    end

    privateEndpointConnections = azure_key_vault(resource_id: id).properties.privateEndpointConnections.each do |endpoints|
  
      describe endpoints do
        its('properties.provisioningState') { should eq 'Succeeded' }
      end
  
      describe endpoints do
        its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
      end
    end
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
# end








# check with tags only
control 'azure_key_vault_with_tags_only' do
  title "Check Azure Keyvault - with tags"

  azure_generic_resources(tag_name: 'owned-by', tag_value: 'cisaz').ids.each do |id|
    
    describe azure_key_vault(resource_id: id) do
      its('properties.enabledForDiskEncryption') { should be_truthy }
    end
  
    describe azure_key_vault(resource_id: id) do
      its('properties.privateEndpointConnections') { should_not be_empty }
    end

    privateEndpointConnections = azure_key_vault(resource_id: id).properties.privateEndpointConnections.each do |endpoints|
  
      describe endpoints do
        its('properties.provisioningState') { should eq 'Succeeded' }
      end
  
      describe endpoints do
        its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
      end
    end
  end
end

# check with tag_name
control 'azure_key_vault_with_tag_name' do
  title "Check Azure Keyvault - with tags"

  azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults', tag_name: 'owned-by').ids.each do |id|
    
    describe azure_key_vault(resource_id: id) do
      its('properties.enabledForDiskEncryption') { should be_truthy }
    end
  
    describe azure_key_vault(resource_id: id) do
      its('properties.privateEndpointConnections') { should_not be_empty }
    end

    privateEndpointConnections = azure_key_vault(resource_id: id).properties.privateEndpointConnections.each do |endpoints|
  
      describe endpoints do
        its('properties.provisioningState') { should eq 'Succeeded' }
      end
  
      describe endpoints do
        its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
      end
    end
  end
end


# check with tag_value
control 'azure_key_vault_with_tag_value' do
  title "Check Azure Keyvault - with tags"

  azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults', tag_value: 'cisaz').ids.each do |id|
    
    describe azure_key_vault(resource_id: id) do
      its('properties.enabledForDiskEncryption') { should be_truthy }
    end
  
    describe azure_key_vault(resource_id: id) do
      its('properties.privateEndpointConnections') { should_not be_empty }
    end

    privateEndpointConnections = azure_key_vault(resource_id: id).properties.privateEndpointConnections.each do |endpoints|
  
      describe endpoints do
        its('properties.provisioningState') { should eq 'Succeeded' }
      end
  
      describe endpoints do
        its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
      end
    end
  end
end
