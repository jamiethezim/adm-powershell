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
# ex:
# $rollout.RolloutMetadata.Name = RolloutMetadataName; #where variable RolloutMetadataName is an argument passed into the script
# and processed in the PARAM section
#
# rolloutspec_multi-region.json
#(Get-Content $pathToRollout).replace("{{RollOutMetadata.Name}}", $RollOutMetadata_Name) | Set-Content $pathToRollout 
#(Get-Content $pathToRollout).replace("{{RollOutMetadata.BuildSource.Parameters.VersionFile}}", $RollOutMetadata_BuildSource_Parameters_VersionFile) | Set-Content $pathToRollout 
#(Get-Content $pathToRollout).replace("{{RollOutMetadata.Notification.Email.To}}", $RollOutMetadata_Notification_Email_To) | Set-Content $pathToRollout 
#(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group1.Name}}", $OrchestratedSteps_RolloutCheck_Group1_Name) | Set-Content $pathToRollout 
#(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group1.TargetName}}", $OrchestratedSteps_RolloutCheck_Group1_TargetName) | Set-Content $pathToRollout 
#(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group2.Name}}", $OrchestratedSteps_RolloutCheck_Group2_Name) | Set-Content $pathToRollout 
#(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group2.TargetName}}", $OrchestratedSteps_RolloutCheck_Group2_TargetName) | Set-Content $pathToRollout 
#(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group3.Name}}", $OrchestratedSteps_RolloutCheck_Group3_Name) | Set-Content $pathToRollout 
#(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group3.TargetName}}", $OrchestratedSteps_RolloutCheck_Group3_TargetName) | Set-Content $pathToRollout 

#servicemodel.json
#(Get-Content $servicemodel).replace("{{ServiceMetadata.ServiceGroup}}", $ServiceMetadata_ServiceGroup) | Set-Content $pathToRollout 
#(Get-Content $servicemodel).replace("{{RollOutMetadata.Name}}", $RollOutMetadata_Name) | Set-Content $servicemodel 
#(Get-Content $servicemodel).replace("{{RollOutMetadata.Name}}", $RollOutMetadata_Name) | Set-Content $servicemodel 
#(Get-Content $servicemodel).replace("{{RollOutMetadata.Name}}", $RollOutMetadata_Name) | Set-Content $servicemodel 
#(Get-Content $servicemodel).replace("{{RollOutMetadata.Name}}", $RollOutMetadata_Name) | Set-Content $servicemodel 
#(Get-Content $servicemodel).replace("{{RollOutMetadata.Name}}", $RollOutMetadata_Name) | Set-Content $servicemodel 
#(Get-Content $servicemodel).replace("{{RollOutMetadata.Name}}", $RollOutMetadata_Name) | Set-Content $servicemodel 
#(Get-Content $servicemodel).replace("{{RollOutMetadata.Name}}", $RollOutMetadata_Name) | Set-Content $servicemodel 



$rollout | ConvertTo-Json | set-content $pathToRollout;
$servicemodel | ConvertTo-Json | set-content $pathtoServiceModel;

##################################################################################################
#Now we upload the edited files back to storage account
