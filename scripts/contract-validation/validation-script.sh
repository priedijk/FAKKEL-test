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


############################################################
################       Functions        ####################
############################################################
white_line () {
    echo "-----------------------------------------------------------------------------------"
}

contract_validation () {
#    echo "Parameter #1 is $1"
#    echo "Parameter #2 is $2"
#    echo "Parameter #3 is $3"
#    echo "Parameter #3 is $4"
#    white_line
   
   # retrieve key value from yaml file
   KEY_VALUE=$(yq -r $2 $1)
   LINE_NUMBER_VALUE=$(yq ''$2' | line' $1)

    # check if value is expected
    if [ $KEY_VALUE == $3 ]; then
        # echo -e "$4 is \n\"${KEY_VALUE}\" \nand is the same as \n\"$3\""
        COMPARISON_VALUES+=("true")
        # white_line
    else
        # echo -e "$4 is \n\"${KEY_VALUE}\" \nbut should be \n\"$3\""
        # echo -e "Line number ${LINE_NUMBER_VALUE}"
        COMPARISON_VALUES+=("false")
        # white_line
    fi

    # Arrays for table data
    KEY_NAMES+=("$4")
    KEY_VALUES+=("$KEY_VALUE")
    EXPECTED_VALUES+=("$3")
    LINE_NUMBER_VALUES+=("$LINE_NUMBER_VALUE")

}


############################################################
################       Set up yq        ####################
############################################################

# wget -q https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - |\
#   tar xz && mv ${BINARY} /usr/bin/yq
# echo -e 79ccca7829e22748ce7fc26efe36f408de23baa0fbb2f38250160afa966967ac yq_linux_amd64.tar.gz|sha256sum -c 
# white_line


############################################################
###########       Contract Validation        ###############
############################################################
# function should be used like contract_validation "fileName" "key location in yaml file" "naming convention" "name for value for readability"
contract_validation "${YAML_FOLDER}/contract.yaml" ".acr_workspace_name" ${ACR_WORKSPACE_NAME} "ACR Workspace"
contract_validation "${YAML_FOLDER}/contract.yaml" ".acr_workspace_name" ${ACR_WORKSPACE_NAME} "ACR Workspace"
contract_validation "${YAML_FOLDER}/contract.yaml" ".env" "dev" "Environment"

# Debug
white_line
echo "Debug"
white_line
echo "KEY NAMES = ${KEY_NAMES[*]}"
echo "KEY VALUES = ${KEY_VALUES[*]}"
echo "EXPECTED VALUES= ${EXPECTED_VALUES[*]}"
echo "LINE NUMBER VALUES = ${LINE_NUMBER_VALUES[*]}"
echo "COMPARISION VALUES = ${COMPARISON_VALUES[*]}"
white_line



############################################################
##########         Build table from data        ############
############################################################

# Define the delimiter
DELIMITER="|"

# Determine the width of each column
KEY_NAMES_WIDTH=20
KEY_VALUES_WIDTH=50
EXPECTED_VALUE_WIDTH=50
LINE_NUMBER_WIDTH=10
COMPARISON_VALUES_WIDTH=10

# Title of table
echo "=========================================================================================================================================================="
printf "%75s\n" "Contract validation"
echo "=========================================================================================================================================================="

# Format the table header
printf "%-${KEY_NAMES_WIDTH}s ${DELIMITER} %-${KEY_VALUES_WIDTH}s ${DELIMITER} %-${EXPECTED_VALUE_WIDTH}s ${DELIMITER} %-${LINE_NUMBER_WIDTH}s ${DELIMITER} %-${COMPARISON_VALUES_WIDTH}s ${DELIMITER}\n" "Name" "Current value" "Expected value" "Line" "Correct?"
echo "=========================================================================================================================================================="

# Format the table data
for (( i=0; i<${#KEY_NAMES[@]}; i++ ))
do
  printf "%-${KEY_NAMES_WIDTH}s ${DELIMITER} %-${KEY_VALUES_WIDTH}s ${DELIMITER} %-${EXPECTED_VALUE_WIDTH}s ${DELIMITER} %-${LINE_NUMBER_WIDTH}s ${DELIMITER} %-${COMPARISON_VALUES_WIDTH}s ${DELIMITER}\n" "${KEY_NAMES[$i]}" "${KEY_VALUES[$i]}" "${EXPECTED_VALUES[$i]}" "${LINE_NUMBER_VALUES[$i]}" "${COMPARISON_VALUES[$i]}"
  echo "----------------------------------------------------------------------------------------------------------------------------------------------------------"

done

# Footer of table
echo "=========================================================================================================================================================="