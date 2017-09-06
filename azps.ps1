Param(
   [string]$RGname,
   [string]$SAname,
   [string]$ContainerName,
   [string]$DestinationFolder
)
Write-Host "Executing pwd";
$pwd = pwd;
Write-Host $pwd;
Write-Host "Executing whoami";
$who = whoami;
Write-Host $who;

Write-Host "resource group is $RGname";
Write-Host "storage account is $SAname";
$SAKey = Get-AzureRmStorageAccountKey -ResourceGroupName "$RGname" -AccountName "$SAname";
$Context = New-AzureStorageContext -StorageAccountName $SAname -StorageAccountKey $SAKey.Value[0];

#List all blobs in a container.
$blobs = Get-AzureStorageBlob -Container $ContainerName -Context $Context;
#Download blobs from a container.
New-Item -Path $DestinationFolder -ItemType Directory -Force;
$blobs | Get-AzureStorageBlobContent -Destination $DestinationFolder -Context $Context;


##################################################################################################
#Now we edit the files locally
$pathToRollout = $DestinationFolder + "rolloutspec_multi-region.json";
$pathtoServiceModel = $DestinationFolder + "servicemodel.json";

$rollout = Get-Content $pathToRollout | ConvertFrom-Json;
$servicemodel = Get-Content $pathtoServiceModel | ConvertFrom-Json;

#TODO: make tag changes here based on user inputs!!!!
#
#
#
#

$rollout | ConvertTo-Json | set-content $pathToRollout;
$servicemodel | ConvertTo-Json | set-content $pathtoServiceModel;

##################################################################################################
#Now we upload the edited files back to storage account
