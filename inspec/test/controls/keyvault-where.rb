# # with resource providers only type
# control 'azure_key_vault_where_check_name' do
#     title "Check Azure Keyvault where check name"
  
#     azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').name.each do |id|
      
#         azure_key_vault(name: id, tag_name: 'owned-by', tag_value: 'cisaz').each do |keyvaults|

#             describe keyvaults do
#                 its('properties.enabledForDiskEncryption') { should be_truthy }
#             end
            
#             describe keyvaults do
#                 its('properties.privateEndpointConnections') { should_not be_empty }
#             end
#         end
#     end
# end

# # with resource providers only type
# control 'azure_key_vault_where_all' do
#     title "Check Azure Keyvault where tags"
  
#     azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').name.each do |id|
      
#         azure_key_vault.where(name: id, tag_name: 'owned-by', tag_value: 'cisaz').each do |keyvaults|

#             describe keyvaults do
#                 its('properties.enabledForDiskEncryption') { should be_truthy }
#             end
            
#             describe keyvaults do
#                 its('properties.privateEndpointConnections') { should_not be_empty }
#             end
#         end
#     end
# end


# control 'azure_key_vault_where_tags' do
#     title "Check Azure Keyvault where tags"
  
#     azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').name.each do |id|
      
#         azure_key_vault.where(tag_name: 'owned-by', tag_value: 'cisaz').each do |keyvaults|

#             describe keyvaults do
#                 its('properties.enabledForDiskEncryption') { should be_truthy }
#             end
            
#             describe keyvaults do
#                 its('properties.privateEndpointConnections') { should_not be_empty }
#             end
#         end
#     end
# end

# control 'azure_key_vault_where_tags_name' do
#     title "Check Azure Keyvault where tags"
  
#     azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').name.each do |id|
      
#         azure_key_vault.where(tag_name: 'owned-by').each do |keyvaults|

#             describe keyvaults do
#                 its('properties.enabledForDiskEncryption') { should be_truthy }
#             end
            
#             describe keyvaults do
#                 its('properties.privateEndpointConnections') { should_not be_empty }
#             end
#         end
#     end
# end




# control 'azure_key_vault_where_if' do
#     title "Check Azure Keyvault where if tags"
  
#     keyvaults = azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').each do |id|
      
#         if azure_key_vault(resource_id: id).tags['owned-by']

#             describe keyvaults do
#                 its('properties.enabledForDiskEncryption') { should be_truthy }
#             end
            
#             describe keyvaults do
#                 its('properties.privateEndpointConnections') { should_not be_empty }
#             end
#         end
#     end
# end





# this works
# describe azure_key_vault(resource_id: id) do
#     its('tags.owned-by') { should eq 'cisaz' }
# end



# check tags of resrouce_provider
# with resource providers only type
# control 'keyvault_check_tags_after_id' do
#   title "Check Azure Keyvault - tags after ID"

#   azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|
    
#     # keyvault_tags = azure_key_vault(resource_id: id).tags 
#     keyvault_tags2 = azure_key_vault(resource_id: id).tags.owner

#     # p keyvault_tags
#     p keyvault_tags2

#     # puts keyvault_tags
#     puts keyvault_tags2
#     # if keyvault_tags == 'cisaz'





    #     describe azure_key_vault(resource_id: id) do
    #         its('tags.owned-by') { should eq 'cisaz' }
    #     end

    #     describe azure_key_vault(resource_id: id) do
    #         if its('tags.owned-by') { should eq 'cisaz' }

    #             describe azure_key_vault(resource_id: id) do
    #                 its('properties.privateEndpointConnections') { should_not be_empty }
    #             end
    #         end
    #     end
        
    #     describe azure_key_vault(resource_id: id) do
    #         its('properties.privateEndpointConnections') { should_not be_empty }
    #     end
    # end






    # keyvault_tags = azure_key_vault(resource_id: id).tags.owned-by 
    
    # if keyvault_tags == 'cisaz'

    #     describe azure_key_vault(resource_id: id) do
    #         its('tags.owned-by') { should eq 'cisaz' }
    #     end

        
    #     describe azure_key_vault(resource_id: id) do
    #         its('properties.privateEndpointConnections') { should_not be_empty }
    #     end
    # end




    # if azure_key_vault(resource_id: id).tags == 'cisaz'

    #     describe azure_key_vault(resource_id: id) do
    #         its('tags.owned-by') { should eq 'cisaz' }
    #     end


    #     describe azure_key_vault(resource_id: id) do
    #         its('properties.privateEndpointConnections') { should_not be_empty }
    #     end
    # end

    
# end