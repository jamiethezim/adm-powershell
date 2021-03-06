Param(
   [string]$RGname,
   [string]$SAname,
   [string]$ContainerName,
   [string]$SubFolderName,
   [string]$RollOutMetadata_Name,
   [string]$RollOutMetadata_BuildSource_Parameters_VersionFile,
   [string]$RollOutMetadata_Notification_Email_To,
   [string]$OrchestratedSteps_RolloutCheck_Group1_Name,
   [string]$OrchestratedSteps_RolloutCheck_Group1_TargetName,
   [string]$OrchestratedSteps_RolloutCheck_Group2_Name,
   [string]$OrchestratedSteps_RolloutCheck_Group2_TargetName,
   [string]$OrchestratedSteps_RolloutCheck_Group3_Name,
   [string]$OrchestratedSteps_RolloutCheck_Group3_TargetName,
   [string]$ServiceMetadata_ServiceGroup,
   [string]$ServiceMetadata_Environment,
   [string]$ServiceResourceGroupDefinitions_Name,
   [string]$ServiceResourceGroupDefinitions_ServiceResourceDefinitions_Name,
   [string]$ServiceResourceGroupDefinitions_ServiceResourceDefinitions_ArmTemplatePath,
   [string]$ServiceResourceGroups_Group1_AzureResourceGroupName,
   [string]$ServiceResourceGroups_Group1_Location,
   [string]$ServiceResourceGroups_Group1_InstanceOf,
   [string]$ServiceResourceGroups_Group1_AzureSubscriptionId,
   [string]$ServiceResourceGroups_Group1_ServiceResources_Name,
   [string]$ServiceResourceGroups_Group1_ServiceResources_InstanceOf,
   [string]$ServiceResourceGroups_Group1_ServiceResources_ArmParametersPath,
   [string]$ServiceResourceGroups_Group1_ServiceResources_RolloutParametersPath,
   [string]$ServiceResourceGroups_Group2_AzureResourceGroupName,
   [string]$ServiceResourceGroups_Group2_Location,
   [string]$ServiceResourceGroups_Group2_InstanceOf,
   [string]$ServiceResourceGroups_Group2_AzureSubscriptionId,
   [string]$ServiceResourceGroups_Group2_ServiceResources_Name,
   [string]$ServiceResourceGroups_Group2_ServiceResources_InstanceOf,
   [string]$ServiceResourceGroups_Group2_ServiceResources_ArmParametersPath,
   [string]$ServiceResourceGroups_Group2_ServiceResources_RolloutParametersPath,
   [string]$ServiceResourceGroups_Group3_AzureResourceGroupName,
   [string]$ServiceResourceGroups_Group3_Location,
   [string]$ServiceResourceGroups_Group3_InstanceOf,
   [string]$ServiceResourceGroups_Group3_AzureSubscriptionId,
   [string]$ServiceResourceGroups_Group3_ServiceResources_Name,
   [string]$ServiceResourceGroups_Group3_ServiceResources_InstanceOf,
   [string]$ServiceResourceGroups_Group3_ServiceResources_ArmParametersPath,
   [string]$ServiceResourceGroups_Group3_ServiceResources_RolloutParametersPath,
   [string]$ServiceResourceGroups_Group4_AzureResourceGroupName,
   [string]$ServiceResourceGroups_Group4_Location,
   [string]$ServiceResourceGroups_Group4_InstanceOf,
   [string]$ServiceResourceGroups_Group4_AzureSubscriptionId,
   [string]$ServiceResourceGroups_Group4_ServiceResources_Name,
   [string]$ServiceResourceGroups_Group4_ServiceResources_InstanceOf,
   [string]$ServiceResourceGroups_Group4_ServiceResources_ArmParametersPath,
   [string]$ServiceResourceGroups_Group4_ServiceResources_RolloutParametersPath,
   [string]$Extensions_Name,
   [string]$Extensions_Type,
   [string]$Extensions_Version,
   [string]$Extensions_ConnectionProperties_Authentication_Reference_Parameters_SecretId
)
$pwd = "$(pwd)";
Write-Host "Executing pwd -- $(pwd)";
Write-Host "Executing whoami -- $(whoami)";

Write-Host "resource group is $RGname";
Write-Host "storage account is $SAname";
$SAKey = Get-AzureRmStorageAccountKey -ResourceGroupName "$RGname" -AccountName "$SAname";
$Context = New-AzureStorageContext -StorageAccountName $SAname -StorageAccountKey $SAKey.Value[0];

#establish local space to edit files in - because this script runs on the agent, we get the directory of the machine running the agent
$DestinationFolder = "$pwd\workspace";
New-Item -Path $DestinationFolder -ItemType Directory -Force;
#Download only the file blobs we want
Get-AzureStorageBlobContent -Container $ContainerName -Destination $DestinationFolder -Context $Context -Blob "deploy-v1\rolloutspec_multi-region.json"
Get-AzureStorageBlobContent -Container $ContainerName -Destination $DestinationFolder -Context $Context -Blob "deploy-v1\servicemodel.json"
Get-AzureStorageBlobContent -Container $ContainerName -Destination $DestinationFolder -Context $Context -Blob "deploy-v1\parameters\sfg-app-rollout-parameters.json"
Get-ChildItem $DestinationFolder;


##################################################################################################
#Now we edit the files locally
$pathToRollout = $DestinationFolder + "\$SubFolderName\rolloutspec_multi-region.json";
$pathtoServiceModel = $DestinationFolder + "\$SubFolderName\servicemodel.json";
$pathToRolloutParams = $DestinationFolder + "\$SubFolderName\parameters\sfg-app-rollout-parameters.json";

#: make tag changes here based on user inputs!!!

######### rolloutspec_multi-region.json
Write-Host "editing the rollout file" + $pathToRollout
Write-Host "Rollout Metadata_name is $RollOutMetadata_Name"
(Get-Content $pathToRollout).replace("{{RollOutMetadata.Name}}", $RollOutMetadata_Name) | Set-Content $pathToRollout;
Write-Host "Build Source parms version file is " + $RollOutMetadata_BuildSource_Parameters_VersionFile;
(Get-Content $pathToRollout).replace("{{RollOutMetadata.BuildSource.Parameters.VersionFile}}", $RollOutMetadata_BuildSource_Parameters_VersionFile) | Set-Content $pathToRollout;
(Get-Content $pathToRollout).replace("{{RollOutMetadata.Notification.Email.To}}", $RollOutMetadata_Notification_Email_To) | Set-Content $pathToRollout;
(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group1.Name}}", $OrchestratedSteps_RolloutCheck_Group1_Name) | Set-Content $pathToRollout;
(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group1.TargetName}}", $OrchestratedSteps_RolloutCheck_Group1_TargetName) | Set-Content $pathToRollout;
(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group2.Name}}", $OrchestratedSteps_RolloutCheck_Group2_Name) | Set-Content $pathToRollout;
(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group2.TargetName}}", $OrchestratedSteps_RolloutCheck_Group2_TargetName) | Set-Content $pathToRollout;
(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group3.Name}}", $OrchestratedSteps_RolloutCheck_Group3_Name) | Set-Content $pathToRollout;
(Get-Content $pathToRollout).replace("{{OrchestratedSteps.RolloutCheck.Group3.TargetName}}", $OrchestratedSteps_RolloutCheck_Group3_TargetName) | Set-Content $pathToRollout;

######### servicemodel.json
(Get-Content $pathtoServiceModel).replace("{{ServiceMetadata.ServiceGroup}}", $ServiceMetadata_ServiceGroup) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceMetadata.Environment}}", $ServiceMetadata_Environment) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroupDefinitions.Name}}", $ServiceResourceGroupDefinitions_Name) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroupDefinitions.ServiceResourceDefinitions.Name}}", $ServiceResourceGroupDefinitions_ServiceResourceDefinitions_Name) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroupDefinitions.ServiceResourceDefinitions.ArmTemplatePath}}", $ServiceResourceGroupDefinitions_ServiceResourceDefinitions_ArmTemplatePath) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group1.AzureResourceGroupName}}", $ServiceResourceGroups_Group1_AzureResourceGroupName) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group1.Location}}", $ServiceResourceGroups_Group1_Location) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group1.InstanceOf}}", $ServiceResourceGroups_Group1_InstanceOf) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group1.AzureSubscriptionId}}", $ServiceResourceGroups_Group1_AzureSubscriptionId) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group1.ServiceResources.Name}}", $ServiceResourceGroups_Group1_ServiceResources_Name) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group1.ServiceResources.InstanceOf}}", $ServiceResourceGroups_Group1_ServiceResources_InstanceOf) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group1.ServiceResources.ArmParametersPath}}", $ServiceResourceGroups_Group1_ServiceResources_ArmParametersPath) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group1.ServiceResources.RolloutParametersPath}}", $ServiceResourceGroups_Group1_ServiceResources_RolloutParametersPath) | Set-Content $pathtoServiceModel;

(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group2.AzureResourceGroupName}}", $ServiceResourceGroups_Group2_AzureResourceGroupName) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group2.Location}}", $ServiceResourceGroups_Group2_Location) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group2.InstanceOf}}", $ServiceResourceGroups_Group2_InstanceOf) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group2.AzureSubscriptionId}}", $ServiceResourceGroups_Group2_AzureSubscriptionId) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group2.ServiceResources.Name}}", $ServiceResourceGroups_Group2_ServiceResources_Name) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group2.ServiceResources.InstanceOf}}", $ServiceResourceGroups_Group2_ServiceResources_InstanceOf) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group2.ServiceResources.ArmParametersPath}}", $ServiceResourceGroups_Group2_ServiceResources_ArmParametersPath) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group2.ServiceResources.RolloutParametersPath}}", $ServiceResourceGroups_Group2_ServiceResources_RolloutParametersPath) | Set-Content $pathtoServiceModel;

(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group3.AzureResourceGroupName}}", $ServiceResourceGroups_Group3_AzureResourceGroupName) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group3.Location}}", $ServiceResourceGroups_Group3_Location) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group3.InstanceOf}}", $ServiceResourceGroups_Group3_InstanceOf) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group3.AzureSubscriptionId}}", $ServiceResourceGroups_Group3_AzureSubscriptionId) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group3.ServiceResources.Name}}", $ServiceResourceGroups_Group3_ServiceResources_Name) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group3.ServiceResources.InstanceOf}}", $ServiceResourceGroups_Group3_ServiceResources_InstanceOf) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group3.ServiceResources.ArmParametersPath}}", $ServiceResourceGroups_Group3_ServiceResources_ArmParametersPath) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group3.ServiceResources.RolloutParametersPath}}", $ServiceResourceGroups_Group3_ServiceResources_RolloutParametersPath) | Set-Content $pathtoServiceModel;

(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group4.AzureResourceGroupName}}", $ServiceResourceGroups_Group4_AzureResourceGroupName) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group4.Location}}", $ServiceResourceGroups_Group4_Location) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group4.InstanceOf}}", $ServiceResourceGroups_Group4_InstanceOf) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group4.AzureSubscriptionId}}", $ServiceResourceGroups_Group4_AzureSubscriptionId) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group4.ServiceResources.Name}}", $ServiceResourceGroups_Group4_ServiceResources_Name) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group4.ServiceResources.InstanceOf}}", $ServiceResourceGroups_Group4_ServiceResources_InstanceOf) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group4.ServiceResources.ArmParametersPath}}", $ServiceResourceGroups_Group4_ServiceResources_ArmParametersPath) | Set-Content $pathtoServiceModel;
(Get-Content $pathtoServiceModel).replace("{{ServiceResourceGroups.Group4.ServiceResources.RolloutParametersPath}}", $ServiceResourceGroups_Group4_ServiceResources_RolloutParametersPath) | Set-Content $pathtoServiceModel;

########### rollout_parameters.json
(Get-Content $pathToRolloutParams).replace("{{Extensions.Name}}", $Extensions_Name) | Set-Content $pathToRolloutParams;
(Get-Content $pathToRolloutParams).replace("{{Extensions.Type}}", $Extensions_Type) | Set-Content $pathToRolloutParams;
(Get-Content $pathToRolloutParams).replace("{{Extensions.Version}}", $Extensions_Version) | Set-Content $pathToRolloutParams;
(Get-Content $pathToRolloutParams).replace("{{Extensions.ConnectionProperties.Authentication.Reference.Parameters.SecretId}}", $Extensions_ConnectionProperties_Authentication_Reference_Parameters_SecretId) | Set-Content $pathToRolloutParams;

##################################################################################################
#Now we upload the edited files back to storage account
Set-AzureStorageBlobContent -Container $ContainerName -File $pathToRollout -Context $Context -Blob "$SubFolderName\rolloutspec_multi-region.json" -Force
Set-AzureStorageBlobContent -Container $ContainerName -File $pathtoServiceModel -Context $Context  -Blob "$SubFolderName\servicemodel.json" -Force
Set-AzureStorageBlobContent -Container $ContainerName -File $pathToRolloutParams -Context $Context  -Blob "$SubFolderName\parameters\sfg-app-rollout-parameters.json" -Force