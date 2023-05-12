#!/bin/bash

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

# variables
VERSION="v4.2.0"
BINARY="yq_linux_amd64"
YAML_FOLDER="scripts/contract-validation"
# naming conventions
ACR_WORKSPACE_NAME="ngdc-sc-azure-${TEAM}-acr01-${ENVIRONMENT}-${LOCATION}-${SUBSCRIPTION_NUMBER}"
# AKS_A_WORKSPACE_NAME
# AKS_B_WORKSPACE_NAME

# functions
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

# wget -q https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - |\
#   tar xz && mv ${BINARY} /usr/bin/yq
white_line

# function should be used like contract_validation "fileName" "key location in yaml file" "naming convention" "name for value for readability"
contract_validation "${YAML_FOLDER}/contract.yaml" ".acr_workspace_name" ${ACR_WORKSPACE_NAME} "ACR Workspace"