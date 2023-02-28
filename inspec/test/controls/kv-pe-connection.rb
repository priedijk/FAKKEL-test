control 'azure_key_vault_separate' do 
   title "Check Azure Keyvault separate URL" 
 

describe http('https://'+input('URL'), ssl_verify: true) do
    its('status') { should cmp 403 }
 end

describe host(input('URL'), port: 443, protocol: 'tcp') do
    it { should be_reachable }
    it { should be_resolvable }
 end

describe command('dig '+input('URL')) do
    its('stdout') { should match 'IN A 20.61' }
 end

 describe command('dig '+input('URL')) do
    its('stdout') { should match 'kv-test-weu-50e2b310.privatelink.vaultcore.azure.net' }
 end

 describe command('dig '+input('URL')) do
    its('stdout') { should match 'IN CNAME kv-test-weu-50e2b310.privatelink.vaultcore.azure.net' }
 end

 describe command('dig '+input('URL')) do
    its('stdout') { should match 'IN CNAME .privatelink.vaultcore.azure.net' }
 end

 describe command('dig '+input('URL')) do
    its('stdout') { should match 'IN CNAME *privatelink.vaultcore.azure.net' }
 end

 describe command('dig '+input('URL')) do
    its('stdout') { should match '*privatelink.vaultcore.azure.net' }
 end

 describe command('dig '+input('URL')) do
    its('stdout') { should match *privatelink.vaultcore.azure.net }
 end

 describe command('dig '+input('URL')) do
    its('stdout') { should match 'privatelink.vaultcore.azure.net' }
 end

 describe command('dig '+input('URL')) do
    its('stdout') { should match +input('KEYVAULT') }
 end

 describe command('dig '+input('URL')) do
    its('stdout') { should match +input('KEYVAULT') }
 end
end



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