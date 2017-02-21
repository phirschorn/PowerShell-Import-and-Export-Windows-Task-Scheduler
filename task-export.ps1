Param(
        [Parameter(Mandatory=$false)][string]$outfile_root 
       ) 
# Define the path to write all of the exported tasks to 
# The script must be run on the local machine as administrator 

# Uncomment and define the below if you don't want to be prompted for input with each run of the script 
# $outfile_root = "C:\export\path\root"
if (!$outfile_root) {$outfile_root1 = (Read-Host -prompt 'Please Enter The Path To Export Scheduled Tasks To') }


$service = New-Object -ComObject("Schedule.Service")
$service.connect() 
$folders = [System.collections.arraylist]@()
# Define the root path to traverse down 
$root = $service.getfolder("\")
$folders.Add($root) 
# Add the root level folders to the $Folders Array 
# $service.GetFolder($root.path).getfolders(0)  | foreach {$folders.add($_) }


$i = 0 
while ($i -ne $folders.count ) {
    
    $service.GetFolder($folders[$i].path).getfolders(0) | foreach {$folders.add($_)} 
    $i++
}


$i = 0 
while ($i -ne $folders.count) { 
    $service.GetFolder(${folders[$i]}).gettasks(0) | % {
      $xml = $_.xml 
      $task_name = $_.Name
      $outfile = $outfile_root + $folders[$i].path + "\" + $task_name + ".xml" 
      $xml  | New-Item -force $outfile  -type file 
      }
    $i++
    
    
}


