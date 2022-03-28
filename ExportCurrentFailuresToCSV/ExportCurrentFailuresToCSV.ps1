# By: Keith Lammers
# Last Updated: 2022-03-15


###################
# Script Settings #
###################

# Set the path to the .csv file where you want the results to be exported to
$destinationFile = "C:\temp\CheckCentral.csv"

# Set your API Token here
$apiToken = '579f078e7fb94fccb6b348a6dacb64f5'


################################
# Don't modify below this line #
################################

# Get the list of checks
$allChecks = Invoke-WebRequest -Uri "https://api.checkcentral.cc/getChecks/?apiToken=$apiToken" -UseBasicParsing | ConvertFrom-Json

Write-Host $allChecks.checks.Count #DEBUG

# Loop through the latest activity for each check and if it's a failure, add it to the list
[System.Collections.ArrayList]$failures = @()
$i = 0 #DEBUG
foreach ($check in $allChecks.checks)
{
    $activity = Invoke-WebRequest -Uri "https://api.checkcentral.cc/getActivities/?apiToken=$apiToken&checkId=$($check.id)&matched=all&activityCount=1" -UseBasicParsing | ConvertFrom-Json

    if ($activity.activities.status -eq "Failure")
    {
        $failures += [PSCustomObject]@{
            Check = $check.id
            Message = $activity.activities.title
            Assignee = ""
            Followup = ""
        }
        
        Write-Host $failures[$i].Check","$failures[$i].Message #DEBUG
        $i++ #DEBUG
    }
}

# Output to CSV
$failures | Export-Csv -Path $destinationFile -NoTypeInformation
