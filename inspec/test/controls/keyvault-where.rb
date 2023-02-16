# with resource providers only type
control 'azure_key_vault_where_all' do
    title "Check Azure Keyvault where tags"
  
    azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').name.each do |id|
      
        azure_key_vault.where(name: id, tag_name: 'owned-by', tag_name: 'cisaz').each do |keyvaults|

            describe keyvaults do
                its('properties.enabledForDiskEncryption') { should be_truthy }
            end
            
            describe keyvaults do
                its('properties.privateEndpointConnections') { should_not be_empty }
            end
        end
    end
end


control 'azure_key_vault_where_tags' do
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

control 'azure_key_vault_where_tags_name' do
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




control 'azure_key_vault_where_if' do
    title "Check Azure Keyvault where if tags"
  
    keyvaults = azure_generic_resources(resource_provider: 'Microsoft.KeyVault/vaults').name.each do |id|
      
        if keyvaults.tags['owned-by']

            describe keyvaults do
                its('properties.enabledForDiskEncryption') { should be_truthy }
            end
            
            describe keyvaults do
                its('properties.privateEndpointConnections') { should_not be_empty }
            end
        end
    end
end
end