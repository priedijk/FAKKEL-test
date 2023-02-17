# export the values as environment variables
# export AZURE_SUBSCRIPTION_ID=$INPUT_SUBSCRIPTIONID
# export AZURE_CLIENT_ID=$INPUT_CLIENTID
# export AZURE_TENANT_ID=$INPUT_TENANTID
# export AZURE_CLIENT_SECRET=$INPUT_CLIENTSECRET
export KEYVAULT_NAME=$KEYVAULT
# export KEYVAULT=$KEYVAULT
echo "test output of environment variables"
echo "---------------------------------"
echo "Keyvault name is $KEYVAULT_NAME"
echo "Keyvault name is $KEYVAULT"
echo "---------------------------------"
# exit 0

# # install the Chef Inspec
# curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec 

# test install specific version
wget -q https://packages.chef.io/files/stable/inspec/5.21.29/ubuntu/20.04/inspec_5.21.29-1_amd64.deb
echo 35ed1da6c885edd1618c19eb0305eaf2836cfae33b21ebd327d31512f15140d7 inspec_5.21.29-1_amd64.deb|sha256sum -c  
sudo dpkg -i inspec_5.21.29-1_amd64.deb
echo "---------------------------------"

# execute Azure tests
# inspec exec inspec/test/ --input=URL="kv-test-weu-50e2b310.vault.azure.net" KEYVAULT=$KEYVAULT -t azure:// --chef-license accept-silent --reporter cli html:azure_test.html 


cat inspec/test/inputs.yaml
envsubst < inspec/test/inputs.yaml
(cat inspec/test/inputs.yaml | envsubst) >> inspec/test/inputs-sub.yaml

TEST_VAR="test"
TEST_DIRECTORY="inspec/${TEST_VAR}"

inspec exec ${TEST_DIRECTORY} --input-file ${TEST_DIRECTORY}/inputs-sub.yaml -t azure:// --chef-license accept-silent --reporter cli html:azure_test.html --enhanced-outcomes

# execute keyvault test
# inspec exec inspec/access/ --input=URL="kv-test-weu-50e2b310.vault.azure.net" KEYVAULT=$KEYVAULT --chef-license accept-silent --reporter cli html:keyvault_test.html 