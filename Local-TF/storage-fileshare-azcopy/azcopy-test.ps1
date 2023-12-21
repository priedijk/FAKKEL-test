RG="fileshareazcopy"
FILESHARE="fileshareazcopy66e4bd71"
SHARE="dev"
SASTOKEN="?sv=2022-11-02&ss=f&srt=co&sp=rwdlc&se=2023-10-03T21:32:49Z&st=2023-10-03T13:32:49Z&spr=https&sig=aYp0frUqtQBI6lXY%2BOtZlsajzGsUOb0kIERJEHqeUio%3D"
SASTOKEN="?se=2023-10-10T13%3A41Z&sp=rwdlacup&spr=https&sv=2022-11-02&ss=f&srt=sco&sig=APVPxnixvjikX2ZQaj3EKsQKOifRsHArzKxbHnoytTA%3D"

FSENDPOINT="https://${FILESHARE}.file.core.windows.net/"

az account set -s "SUBSCRIPTION_ID"

# copy directory and contents to "dev" fileshare
azcopy copy "folder_to_upload" "${FSENDPOINT}${SHARE}${SASTOKEN}" --recursive --preserve-smb-permissions=true --preserve-smb-info=true
azcopy copy "file3.txt" "${FSENDPOINT}${SHARE}/folder_to_upload${SASTOKEN}" --recursive --preserve-smb-permissions=true --preserve-smb-info=true






##### test on CADRA
az account set -s "a9bf129f-2a7b-4fb1-979a-844a84cfae5d"

$RG="rg-cisaz-app-automationtesting-weu-001"
$STORAGEACCOUNT="stautosatestdevqk46xddt"
$FILESHARE="dev"
$SASTOKEN="?sv=2022-11-02&ss=f&srt=co&sp=rwdlc&se=2023-10-05T17:20:44Z&st=2023-10-05T09:20:44Z&spr=https&sig=1IRgcvFQZaHgVembBWEoO5K%2B545RUW4DjOBCbaEA3Sw%3D"
$FSENDPOINT="https://${STORAGEACCOUNT}.file.core.windows.net/"

azcopy copy "folder_to_upload" "${FSENDPOINT}${FILESHARE}${SASTOKEN}" --recursive --preserve-smb-permissions=true --preserve-smb-info=true
azcopy copy "file3.txt" "${FSENDPOINT}${FILESHARE}/folder_to_upload${SASTOKEN}" --recursive --preserve-smb-permissions=true --preserve-smb-info=true


# private link
$FILESHARE="stautosatestdevqk46xddt.privatelink.file.core.windows.net"





# CRMpush test
$STORAGEACCOUNT="stcrmpushcae00046651"
$FILESHARE="crmpush-smb-share"
$SASTOKEN=""
$FSENDPOINT="https://${STORAGEACCOUNT}.file.core.windows.net/"


azcopy copy "folder_to_upload" "${FSENDPOINT}${FILESHARE}${SASTOKEN}" --recursive --preserve-smb-permissions=true --preserve-smb-info=true
azcopy copy "file3.txt" "${FSENDPOINT}${FILESHARE}/folder_to_upload_to${SASTOKEN}" --preserve-smb-permissions=true --preserve-smb-info=true

$SASTOKEN="?sv=2021-10-04&ss=f&srt=sco&st=2023-10-11T11%3A34%3A56Z&se=2023-10-20T18%3A34%3A00Z&sp=rwdlc&sig=tsrHGvwWTn1sme6v33%2F1V0pQE2qLLb3jqAUKST7a%2BHI%3D"


FILE_SHARE_NAME="crmpush-smb-share"
STORAGE_ACCOUNT_NAME="stcrmpushcae00046651"
RESOURCE_GROUP_NAME="rg-crmpush-platform-nonprod-frc-001"

HTTP_ENDPOINT=$(az storage account show \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $STORAGE_ACCOUNT_NAME \
    --query "primaryEndpoints.file" --output tsv | tr -d '"')
SMB_PATH=$(echo $HTTP_ENDPOINT | cut -c7-${#HTTP_ENDPOINT})$FILE_SHARE_NAME

STORAGE_ACCOUNT_KEY=$(az storage account keys list \
    --resource-group $RESOURCE_GROUP_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --query "[0].value" --output tsv | tr -d '"')