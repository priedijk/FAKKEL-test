# Convert Input
storageAccountName=$1
fileShareName=$2
containerName=$3
zipPassword=$4
tokenAccess=$5
tokenValidity=$6

# Output input
echo "-----------------------------------------------------------------------------------"
echo "outputting variables"
echo "-----------------------------------------------------------------------------------"
echo "team = ${storageAccountName}"
echo "Fileshare Name = ${fileShareName}"
echo "Blob container name  = ${containerName}"
echo "Zip password  = ${zipPassword}"
echo "Token access = ${tokenAccess}"
echo "Token validity = ${tokenValidity}"
echo "-----------------------------------------------------------------------------------"