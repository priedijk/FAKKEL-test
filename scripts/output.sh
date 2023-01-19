# export the values as environment variables
export TERRAFORM_DIR=$TERRAFORM_DIRECTORY
export KEYVAULT_NAME=$KEYVAULT
export KEYVAULT_NAME2=$KEYVAULT2
export KEYVAULT_NAME3=$KEYVAULT3

echo "Keyvault name is $KEYVAULT"
echo "Keyvault name is $KEYVAULT2"
echo "Keyvault name is $KEYVAULT3"
echo "terra init env $TERRAFORM_DIRECTORY"
echo "after init env"

terraform -chdir=$TERRAFORM_DIR output -raw kv_name
echo "after command 1"
export KEYVAULT=$(terraform -chdir=$TERRAFORM_DIR output -raw kv_name)
echo $KEYVAULT
echo "after command 2"
export KEYVAULT=$(terraform -chdir=${TERRAFORM_DIR} output -raw kv_name)
echo $KEYVAULT
echo "after command 3"
export KEYVAULT=$(terraform -chdir=$TERRAFORM_DIR output -raw kv_name)

echo "KEYVAULT=$(echo $KEYVAULT)" >> $GITHUB_ENV
echo "KEYVAULT2=$(terraform -chdir=$TERRAFORM_DIR output -raw kv_name)" >> $GITHUB_ENV
echo "KEYVAULT3=${KEYVAULT}" >> $GITHUB_ENV
echo "Keyvault name is $KEYVAULT_NAME"
echo "Keyvault name is $KEYVAULT_NAME2"
echo "Keyvault name is $KEYVAULT_NAME3"
exit 0
