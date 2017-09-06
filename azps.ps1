Param(
   [string]$RGname,
   [string]$SAname,
   [string]$Container
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
Write-Host $Context;