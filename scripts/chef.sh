# export the values as environment variables
export AZURE_SUBSCRIPTION_ID=$INPUT_SUBSCRIPTIONID
export AZURE_CLIENT_ID=$INPUT_CLIENTID
export AZURE_TENANT_ID=$INPUT_TENANTID
export AZURE_CLIENT_SECRET=$INPUT_CLIENTSECRET

# install the Chef Inspec
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec 


# execute basic test
inspec exec inspec/test/ -t azure:// --chef-license accept-silent 

# execute keyvault test
inspec exec inspec/access/ --input=URL="kv-test-weu-50e2b310.vault.azure.net" --chef-license accept-silent --reporter cli html:test.html 