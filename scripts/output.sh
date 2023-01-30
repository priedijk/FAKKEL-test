# export the values as environment variables
export TERRAFORM_DIR=$TERRAFORM_DIRECTORY

# echo "terra init env $TERRAFORM_DIRECTORY"
# echo "after init env"
# echo "terra after env $TERRAFORM_DIR"

# terraform -chdir=$TERRAFORM_DIR output -raw kv_name
# echo "only direct env 1"
# export KEYVAULT=$(terraform -chdir=$TERRAFORM_DIRECTORY output -raw kv_name)
# echo $KEYVAULT
# echo "only direct env 2"
# export KEYVAULT=$(terraform -chdir=${TERRAFORM_DIRECTORY} output -raw kv_name)
# echo $KEYVAULT
# echo "only direct env 3"
# export KEYVAULT=$(terraform -chdir=$TERRAFORM_DIRECTORY output -raw kv_name)
# echo $KEYVAULT




# echo "after command 1"
# export KEYVAULT=$(terraform -chdir=$TERRAFORM_DIR output -raw kv_name)
# echo $KEYVAULT
# echo "after command 2"
# export KEYVAULT=$(terraform -chdir=${TERRAFORM_DIR} output -raw kv_name)
# echo $KEYVAULT
# echo "after command 3"
# export KEYVAULT=$(terraform -chdir=$TERRAFORM_DIR output -raw kv_name)

echo "KEYVAULT=$(terraform -chdir=$TERRAFORM_DIR output -raw kv_name)" >> $GITHUB_ENV
echo "RG=$(terraform -chdir=$TERRAFORM_DIR output -raw rg_name)" >> $GITHUB_ENV


exit 0
