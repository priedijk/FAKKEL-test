#!/bin/bash

# source env file and set values as environment variables
while read -r line
do
    echo "$line" >> $GITHUB_ENV
    export $line
done < ./conf/$1.env

# determine TF_VAR_location
case $2 in
    weu)
    echo "TF_VAR_location=westeurope" >> $GITHUB_ENV
    ;;
    frc)
    echo "TF_VAR_location=francecentral" >> $GITHUB_ENV
    ;;
esac

echo "TF_VAR_testput1=$VPN_SECRET" >> $GITHUB_ENV
echo "TF_VAR_testput2=${VPN_SECRET}" >> $GITHUB_ENV

echo $TF_CLI_ARGS_plan
echo $VPN_SECRET
echo "TF_CLI_ARGS_plan=$(echo $TF_CLI_ARGS_plan | envsubst)"

echo "TF_CLI_ARGS_plan=$(echo $TF_CLI_ARGS_plan | envsubst)" >> $GITHUB_ENV
echo "TF_CLI_ARGS_apply=$(echo $TF_CLI_ARGS_apply | envsubst)" >> $GITHUB_ENV
echo "TF_CLI_ARGS_destroy=$(echo $TF_CLI_ARGS_destroy | envsubst)" >> $GITHUB_ENV
