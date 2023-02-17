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







  control 'azure_key_vault_generic_resources' do
    title "Check Azure Keyvault"
  
    azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').ids.each do |id|
      
      describe azure_key_vault(resource_id: id) do
        it { should exist } 
      end

        keyvault = azure_key_vault(resource_id: id)

        describe keyvault do
          it { should exist }
        end 

        if keyvault.tags['owner']

          describe azure_key_vault(resource_id: id) do
            it { should exist } 
          end
      end
  end
end