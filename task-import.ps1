# Make sure to run as administrator 

# Not a typo, the C:\\ is needed for the script to properly parse the input path 
# You should match the base export path specified in the export-tasks.ps1 script 

$basePath = 'C:\\tasks\\toImport'


# Create a hash table of usernames and password pairs that are found inside of the XML Files
# This is needed so that the tasks can be re-imported with the password specified
$credentials = @{"domain\username1" = "P@ssword"}
$credentials += @{"domain\username2" = "Passw0rd"}
$credentials += @{"domain\otherusername" = "Password"}


# Enumerate the folder structure and parse results into scheduled tasks
$vContents = (Get-ChildItem -path $basePath  -Recurse -Force -filter *.xml | Select-Object -Property FullName )
foreach ($item in $vContents) 
    {
        # Clean up the variables to extract the data we need 
        $taskpath = $item.Fullname 
        $taskname = $item.Fullname -replace "${basepath}", ""
        $taskname = $taskname -replace ".xml","" 
# For Debugging -- uncomment the below to see what $taskname evaluates to 
#        Write-Host "Task Name: ${taskname}" 

        # Import the XML into a variable
        [xml]$username = get-content $taskpath

        #Extract the uid token from the XML File
        $uid = $username.DocumentElement.Principals.Principal.UserID
# Enable to debug 
#        Write-Host "User ID is: "${uid}" "
#        Write-Host "Password is: "  $credentials.$uid

        # Create the scheduled task with the extracted values
        schtasks /s localhost /Create /XML ${taskpath} /tn $taskname /RU "${uid}" /RP $credentials.$uid

    }
