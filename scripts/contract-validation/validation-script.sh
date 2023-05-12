TEAM=$1
ENVIRONMENT=$2
LOCATION=$3
SUBSCRIPTION_NUMBER=$4
B_CLUSTER_ENABLED=$5

echo "-----------------------------------------------------------------------------------"
echo "outputting variables"
echo "-----------------------------------------------------------------------------------"
echo "team = $TEAM"
echo "environment = $ENVIRONMENT"
echo "location = $LOCATION"
echo "subscription number = $SUBSCRIPTION_NUMBER"
echo "B cluster enabled = $B_CLUSTER_ENABLED"
echo "-----------------------------------------------------------------------------------"

VERSION="v4.2.0"
BINARY="yq_linux_amd64"

wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - |\
  tar xz && mv ${BINARY} /usr/bin/yq

# WORKSPACES=(
#     # ACR
#     "ngdc-sc-azure-${TEAM}-acr01-${ENVIRONMENT}-${LOCATION}-${SUBSCRIPTION_NUMBER}"
#     # A cluster
#     "ngdc-sc-azure-${TEAM}-aks01-${ENVIRONMENT}-${LOCATION}-${SUBSCRIPTION_NUMBER}"
# )

# ACR_WORKSPACE=$(yq -r '.acr_workspace_name' contract.yaml)
# echo $ACR_WORKSPACE

# if [ $ACR_WORKSPACE == "ngdc-sc-azure-${TEAM}-acr01-${ENVIRONMENT}-${LOCATION}-${SUBSCRIPTION_NUMBER}" ]; then
#     echo "ACR name is the same"
# else
#     echo -e "ACR name is \n\"${ACR_WORKSPACE}\" \nbut should be \n\"ngdc-sc-azure-${TEAM}-acr01-${ENVIRONMENT}-${LOCATION}-${SUBSCRIPTION_NUMBER}\""
# fi

# naming conventions
ACR_WORKSPACE_NAME="ngdc-sc-azure-${TEAM}-acr01-${ENVIRONMENT}-${LOCATION}-${SUBSCRIPTION_NUMBER}"
# AKS_A_WORKSPACE_NAME
# AKS_B_WORKSPACE_NAME
white_line () {
    echo "------------------------------------------------------------------------"
}

contract_validation () {
   echo "Parameter #1 is $1"
   echo "Parameter #2 is $2"
   echo "Parameter #3 is $3"
   echo "Parameter #3 is $4"
   white_line
   
   # retrieve key value from yaml file
   VALUE=$(yq -r $2 $1)

    # check if value is expected
    if [ $VALUE == $3 ]; then
        echo "$4 is the same"
        white_line
    else
        echo -e "$4 is \n\"${VALUE}\" \nbut should be \n\"$3\""
        white_line
    fi
}

# function should be used like contract_validation "fileName" "key location in yaml file" "naming convention" "name for value for readability"
contract_validation "contract.yaml" ".acr_workspace_name" ${ACR_WORKSPACE_NAME} "ACR Workspace"