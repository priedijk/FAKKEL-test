# describe 'my_cookbook::default' do
#     context 'when a certain condition is true' do
#       it 'does something' do
#         # test code here
#       end
  
#       it 'does something else' do
#         # test code here
#       end
#     end
  
#     context 'when the condition is false' do
#       it 'skips subsequent tests' do
#         skip('Skipping because the condition is false')
#       end
  
#       it 'should not run this test' do
#         # This test will be skipped
#       end
#     end
#   end







  control 'azure_key_vault_context_control' do
    title "Check Azure Keyvault - context control"
  
    azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|
      

        keyvault = azure_key_vault(resource_id: id)

        # control keyvault exits
        describe keyvault do
          it { should exist }
        end 

        # control keyvault exits with owner tag
        # this only checks if the resource has tags
      #   if keyvault.tags['owner']

      #     describe azure_key_vault(resource_id: id) do
      #       it { should exist } 
      #     end
      # end
  end
end


# control 'azure_key_vault_context_test1' do
#   title "Check Azure Keyvault - context test1"

#   azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

#       keyvault = azure_key_vault(resource_id: id)
#       keyvault_tags = azure_key_vault(resource_id: id).tags['owner']

#       # control keyvault exits
#       if keyvault.tags.include? 'cisaz'
#         describe keyvault do
#           it { should exist }
#         end 
#       end

      # if keyvault.tags.include? 'owner'
      #   describe keyvault do
      #     it { should exist }
      #   end 
      # end

#       # if keyvault_tags.include? 'cisaz'
#       #   describe keyvault do
#       #     it { should exist }
#       #   end 
#       # end

#       # if keyvault_tags.include? 'owner'
#       #   describe keyvault do
#       #     it { should exist }
#       #   end 
#       # end
# end
# end

control 'azure_key_vault_context_test2' do
  title "Check Azure Keyvault - context test2"

  azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

      keyvault = azure_key_vault(resource_id: id)

      if keyvault.tags.include? 'owner'
        describe keyvault do
          it { should exist }
        end 
      end
  end
end


# control 'azure_key_vault_context_test2v1' do
#   title "Check Azure Keyvault - context test2v1"

#   azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

#       keyvault = azure_key_vault(resource_id: id)

#       if keyvault.tags.include? 'owner'
#         describe keyvault do
#           it { should exist }
#         end 
#         describe keyvault do
#           its('properties.enabledForDiskEncryption') { should be_truthy }
#         end
  
#         describe azure_key_vault(resource_id: id) do
#           its('properties.privateEndpointConnections') { should_not be_empty }
#         end

#         privateEndpointConnections = keyvault.properties.privateEndpointConnections.each do |endpoints|
      
#           describe endpoints do
#             its('properties.provisioningState') { should eq 'Succeeded' }
#           end
      
#           describe endpoints do
#             its('properties.privateLinkServiceConnectionState.status') { should eq 'Approved' }
#           end
#         end
#       end
#   end
# end

# control 'azure_key_vault_context_test2v2' do
#   title "Check Azure Keyvault - context test2v2"

#   azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

#       keyvault = azure_key_vault(resource_id: id)


#       if keyvault.tags.include?('owner')
#         describe keyvault do
#           it { should exist }
#         end 
#       end
#   end
# end

control 'azure_key_vault_context_test2v3' do
  title "Check Azure Keyvault - context test2v3"

  azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

      keyvault = azure_key_vault(resource_id: id)

      if (keyvault.tags.any?)

        if (keyvault.tags.owner == 'cisaz')
          describe keyvault do
            it { should exist }
          end
        end 
      end
  end
end

control 'azure_key_vault_context_test2v4' do
  title "Check Azure Keyvault - context test2v4"

  azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

      keyvault = azure_key_vault(resource_id: id)


      if (keyvault.tags.any?)

        if (keyvault.tags.owner == 'team')
          describe keyvault do
            it { should exist }
          end
        end 
      end
  end
end

# check keyvault, filter on tag and location
control 'azure_key_vault_context_test2v5' do
  title "Check Azure Keyvault - context test2v5"

  azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

      keyvault = azure_key_vault(resource_id: id)

      if (keyvault.tags.any?)

        if (keyvault.tags.owner == 'cisaz')

          if (keyvault.location == 'northeurope')

            describe keyvault do
              it { should exist }
            end
          end
        end 
      end
  end
end

# control 'azure_key_vault_context_test3' do
#   title "Check Azure Keyvault - context test3"

#   azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

#       keyvault = azure_key_vault(resource_id: id)
#       keyvault_tags = azure_key_vault(resource_id: id).tags['owner']

#       # control keyvault exits
#       # if keyvault.tags.include? 'cisaz'
#       #   describe keyvault do
#       #     it { should exist }
#       #   end 
#       # end

#       # if keyvault.tags.include? 'owner'
#       #   describe keyvault do
#       #     it { should exist }
#       #   end 
#       # end

#       if keyvault_tags.include? 'cisaz'
#         describe keyvault do
#           it { should exist }
#         end 
#       end

#       if keyvault_tags.include? 'owner'
#         describe keyvault do
#           it { should exist }
#         end 
#       end
# end
# end

# control 'azure_key_vault_context_test4' do
#   title "Check Azure Keyvault - context test4"

#   azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

#       keyvault = azure_key_vault(resource_id: id)
#       keyvault_tags = azure_key_vault(resource_id: id).tags['owner']

#       # control keyvault exits
#       # if keyvault.tags.include? 'cisaz'
#       #   describe keyvault do
#       #     it { should exist }
#       #   end 
#       # end

#       # if keyvault.tags.include? 'owner'
#       #   describe keyvault do
#       #     it { should exist }
#       #   end 
#       # end

#       # if keyvault_tags.include? 'cisaz'
#       #   describe keyvault do
#       #     it { should exist }
#       #   end 
#       # end

#       if keyvault_tags.include? 'owner'
#         describe keyvault do
#           it { should exist }
#         end 
#       end
# end
# end


# control 'azure_key_vault_context_test5' do
#   title "Check Azure Keyvault - context test5"

#   azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

#       keyvault = azure_key_vault(resource_id: id)

#       if (keyvault.tags.any? { |h| h[:owner] == 'cisaz' })
#         describe keyvault do
#           it { should exist }
#         end 
#       end
# end
# end


# control 'azure_key_vault_context_test6' do
#   title "Check Azure Keyvault - context test6"

#   azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|

#       keyvault = azure_key_vault(resource_id: id)

#       if (keyvault.tags.find { |h| h[:owner] == 'cisaz' })
#         describe keyvault do
#           it { should exist }
#         end 
#       end
# end
# end

