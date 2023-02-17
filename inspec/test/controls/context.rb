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
      
      # describe azure_key_vault(resource_id: id) do
      #   it { should exist } 
      # end

        keyvault = azure_key_vault(resource_id: id)

        # control keyvault exits
        describe keyvault do
          it { should exist }
        end 

        # control keyvault exits with owner tag
        if keyvault.tags['owner']

          describe azure_key_vault(resource_id: id) do
            it { should exist } 
          end
      end

      
      #   # test if tag has cetain value
      #   if keyvault.tags['owner'] == 'cisaz'

      #     describe azure_key_vault(resource_id: id) do
      #       it { should exist } 
      #     end
      # end

      #   # test if tag has cetain value
      #   if keyvault.tags['owner-by'] == 'cisaz'

      #     describe azure_key_vault(resource_id: id) do
      #       it { should exist } 
      #     end
      # end
  end
end


control 'azure_key_vault_context_test' do
  title "Check Azure Keyvault - context test"

  azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|
    
    # describe azure_key_vault(resource_id: id) do
    #   it { should exist } 
    # end

      keyvault = azure_key_vault(resource_id: id)
      keyvault_tags = azure_key_vault(resource_id: id).tags['owner']

      # control keyvault exits
      if keyvault.tags.include? 'cisaz'
        describe keyvault do
          it { should exist }
        end 
      end

      if keyvault.tags.include? 'owner'
        describe keyvault do
          it { should exist }
        end 
      end

      if keyvault_tags.include? 'cisaz'
        describe keyvault do
          it { should exist }
        end 
      end

      if keyvault_tags.include? 'owner'
        describe keyvault do
          it { should exist }
        end 
      end

    #   # control keyvault exits with owner tag
    #   if keyvault.tags['owner']

    #     describe azure_key_vault(resource_id: id) do
    #       it { should exist } 
    #     end
    # end


      # test if tag has cetain value
      if keyvault.tags['owner'] === 'cisaz'

        describe azure_key_vault(resource_id: id) do
          it { should exist } 
        end
    end

      # test if tag has cetain value
      if keyvault.tags['owner-by'] == 'cisaz'

        describe azure_key_vault(resource_id: id) do
          it { should exist } 
        end
    end


      # test if tag has cetain value
      if keyvault_tags === 'cisaz'

        describe azure_key_vault(resource_id: id) do
          it { should exist } 
        end
    end

      # test if tag has cetain value
      if keyvault_tags = 'cisaz'

        describe azure_key_vault(resource_id: id) do
          it { should exist } 
        end
    end
end
end