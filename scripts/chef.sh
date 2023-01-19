# export the values as environment variables
export AZURE_SUBSCRIPTION_ID=$INPUT_SUBSCRIPTIONID
export AZURE_CLIENT_ID=$INPUT_CLIENTID
export AZURE_TENANT_ID=$INPUT_TENANTID
export AZURE_CLIENT_SECRET=$INPUT_CLIENTSECRET
export KEYVAULT=$KEYVAULT
export KEYVAULT_NAME=$KEYVAULT2

echo "Keyvault name is $KEYVAULT_NAME"
exit 0

# install the Chef Inspec
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec 



# execute Azure tests
inspec exec inspec/test/ --input=URL="kv-test-weu-50e2b310.vault.azure.net" KEYVAULT=$KEYVAULT -t azure:// --chef-license accept-silent --reporter cli html:azure_test.html 

# execute keyvault test
# inspec exec inspec/access/ --input=URL="kv-test-weu-50e2b310.vault.azure.net" KEYVAULT=$KEYVAULT --chef-license accept-silent --reporter cli html:keyvault_test.html 