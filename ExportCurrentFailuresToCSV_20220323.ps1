# By: Keith Lammers
# Last Updated: 2022-03-23

# Note: If you want to export to Excel instead of CSV, install the ImportExcel module (Install-Module ImportExcel -Scope CurrentUser) and then change $exportToExcel to true below.

###################
# Script Settings #
###################

# Set this to true if you want to export to Excel instead of CSV (requires that you have the ImportExcel PowerShell module installed)
$exportToExcel = $true

# Set the path to the folder where you want the file to be exported to
$destinationFolder = "C:\temp\export_check_Central"

# Set the file name (without the extension) here
$destinationFileNoExtension = ""

# Set your API Token here
$apiToken = '579f078e7fb94fccb6b348a6dacb64f5'


################################
# Don't modify below this line #
################################

# Get the list of checks
Write-Output "Getting the list of checks..."
$allChecks = Invoke-WebRequest -Uri "https://api.checkcentral.cc/getChecks/?apiToken=$apiToken" -UseBasicParsing | ConvertFrom-Json

# Loop through the latest activity for each check and if it's a failure, add it to the list
Write-Output "Checking the latest activity for each check..."
[System.Collections.ArrayList]$failures = @()

foreach ($check in $allChecks.checks)
{
    $activity = Invoke-WebRequest -Uri "https://api.checkcentral.cc/getActivities/?apiToken=$apiToken&checkId=$($check.id)&matched=matched&activityCount=1" -UseBasicParsing | ConvertFrom-Json

    if ($activity.activities.status -eq "Failure")
    {
        $failures += [PSCustomObject]@{
            Check = $check.name
            Message = $activity.activities.title
            Date = $activity.activities.updated
            Assignee = ""
            Followup = ""
        }
    }
}

# Output to CSV or XLSX
if (!$destinationFolder.EndsWith("\"))
{
    $destinationFolder+= "\"
}

if ($exportToExcel)
{
    Write-Output "Exporting to Excel..."
    $destinationFile = $destinationFolder + $destinationFileNoExtension + ".xlsx"
    $failures | Export-Excel -Path $destinationFile -AutoSize -TableName Failures -WorksheetName Failures
}
else
{
    Write-Output "Exporting to CSV..."
    $destinationFile = $destinationFolder + $destinationFileNoExtension + ".csv"
    $failures | Export-Csv -Path $destinationFile -NoTypeInformation
}