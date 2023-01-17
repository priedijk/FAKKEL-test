# export the values as environment variables
export AZURE_SUBSCRIPTION_ID=$INPUT_SUBSCRIPTIONID
export AZURE_CLIENT_ID=$INPUT_CLIENTID
export AZURE_TENANT_ID=$INPUT_TENANTID
export AZURE_CLIENT_SECRET=$INPUT_CLIENTSECRET

# install the Chef Inspec
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec 

# execute the compliance tests from the profile, if available. 
# Otherwise, execute the sample available as part of the action

ls


if [ ! -z "$INPUT_COMPLIANCE_TEST_PROFILE_URL" ]
then    
    inspec exec $INPUT_COMPLIANCE_TEST_PROFILE_URL -t azure:// --chef-license accept-silent
else
    inspec exec inspec/test/ -t azure:// --chef-license accept-silent 
fi