# with resource providers only type
control 'azure_key_vault_where' do
    title "Check Azure Keyvault where tags"
  
    azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').name.each do |id|
      
        azure_key_vault.where(name: id tag_name: 'owned-by', tag_name: 'cisaz').each do |keyvaults|

            describe keyvaults do
                its('properties.enabledForDiskEncryption') { should be_truthy }
            end
            
            describe keyvaults do
                its('properties.privateEndpointConnections') { should_not be_empty }
            end
        end
    end
end


# with resource providers only type
control 'azure_key_vault_where' do
    title "Check Azure Keyvault where tags"
  
    azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').name.each do |id|
      
        azure_key_vault.where(tag_name: 'owned-by', tag_name: 'cisaz').each do |keyvaults|

            describe keyvaults do
                its('properties.enabledForDiskEncryption') { should be_truthy }
            end
            
            describe keyvaults do
                its('properties.privateEndpointConnections') { should_not be_empty }
            end
        end
    end
end


# with resource providers only type
control 'azure_key_vault_where' do
    title "Check Azure Keyvault where tags"
  
    azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').name.each do |id|
      
        azure_key_vault.where(tag_name: 'owned-by').each do |keyvaults|

            describe keyvaults do
                its('properties.enabledForDiskEncryption') { should be_truthy }
            end
            
            describe keyvaults do
                its('properties.privateEndpointConnections') { should_not be_empty }
            end
        end
    end
end