<#
.SYNOPSIS
  Name: DownloadItLive
  Download files from Newsservices or other http(s)-services.

  .DESCRIPTION
  Download files from Newsservices or other http(s)-services.
  This script is meant to facilitate a safe downloading of scripts that will make sure
  you always broadcast the latest news available.

.PARAMETER InitialDirectory
  C:\Scripts\
  
.NOTES
    Updated: 2021-11-14     Initial release. //EZS
    Release Date: 2021-11-14
   
  Author: Erik Zalitis, erik@zalitis.se, +4673-941 22 74

# Comment-based Help tags were introduced in PS 2.0
#requires -version 2
#>

#----------------[ Declarations ]------------------------------------------------------

$InitDir = (Get-Location).path.tostring() # Change this is you run the script in another structure than the directories.

# Make sure you have the rights to broadcast the material you download. The FSN URLs below work, but you need to subscribe to them to put them on the air.
# Not doing so constitutes copyright infrigement. They're only included for test and can be replaced with any URLs you like.

# Please understand that each URL must lead to one downloadable file and may not lead to 302 redirects. The script will not parse files for links. They will be donwloaded as is.
$NewsURLs = "http://www.fsnradionews.com/FSNNews/FSNBulletin.mp3", "http://www.fsnradionews.com/FSNNews/FSNWorldNews.mp3", "http://www.fsnradionews.com/FSNNews/FSNHeadlines.mp3"  # This should be changed!
$Destination_dir = $InitDir + "\PublicFiles"
$LogDir = $InitDir + "\Logs\"
$Temp_dir = $InitDir + "\Temporary"
$MoveSeparateFiles = 1 # 1 = Move every file one-by-one. 0 = Move ALL downloaded files or none at all (1 failed download means NOTHING get moved into the destination)

#----------------[ Functions ]------------------------------------------------------

function Copy-Files($source, $destination) {
  $ErrorActionPreference = "stop"
  try {
    Copy-Item -Path "$source" -Destination "$destination" -Force
  }
  catch {
    Logwrite ("Copy-Files: Could not copy " + $source + " to " + $destination + " Given EC:" + $_ + ".")
  }
  
}

Function Logwrite ($message, $todisk = 1, $LD = $LogDir) {
  $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  write-host ("[" + $ts + "] " + $message)

  $file = $LD + "Log.txt"

  if ($todisk -eq 1) { ("[" + $ts + "] " + $message) | out-file $file -append }
}


#----------------[ Script proper ]------------------------------------------------------


# Create the folders if they do not exist.

if ((Test-path $Destination_dir) -eq $false) { New-Item -path $Destination_dir -ItemType "directory"}
if ((Test-path $Temp_dir) -eq $false) { New-Item -path $Temp_dir -ItemType "directory"}
if ((Test-path $LogDir) -eq $false) { New-Item -path $LogDir -ItemType "directory"}
if ((Test-path ($LogDir + "Log.txt")) -eq $false) { New-Item -path ($LogDir + "Log.txt") -ItemType "file"}



# Main execution

$SuccessFullFiles = New-Object System.Collections.ArrayList
$FailedFiles = New-Object System.Collections.ArrayList

Logwrite ("******************* *************************** Started.")
Logwrite ("DownloadItLive version 1.0, created by Erik Zalitis on ericade.radio. erik@zalitis.se.")


if ($MoveSeparateFiles -eq 0) { Logwrite ("Script is set only to copy new files if ALL can be downloaded.") }
elseif ($MoveSeparateFiles -eq 1) { Logwrite ("Script is set to copy and replace all files it can.") }
else { Logwrite ("MoveSeparateFiles is incorrectly setup. Please verify. Script will now terminate."); exit }


foreach ($NewsURL in $NewsURLs) {

  $rc = $NewsURL -match '([^\/]*)$'
  $URLFile = $rc
  $URLFile = $Matches[1]
  Logwrite ("Downloading " + $URLFile)

  $ErrorActionPreference = "stop"

  try {
  
    if (Test-path ($Temp_dir + "\" + $URLFile)) { Logwrite ("Old version of " + $URLFile + " found and was removed"); Remove-Item ($Temp_dir + "\" + $URLFile) }

    $Response = Invoke-WebRequest $NewsURL -OutFile ($Temp_dir + "\" + $URLFile) -PassThru 

    # All lines below in the Fry-block will only execute if the Invoke-WebRequest does not cast an error.
    $StatusCode = $Response.StatusCode

    if ($MoveSeparateFiles -eq 1 -and $StatusCode -eq "200") { 
      Logwrite ($URLFile + " was successfully download, now copying it.")
      Copy-Files ($Temp_dir + "\" + $URLFile) ($Destination_dir + "\" + $URLFile) 
    }
    elseif ($MoveSeparateFiles -eq 0 -and $StatusCode -eq "200") { $rc = $SuccessFullFiles.add($NewsURL) }
    else { $rc = FailedFiles.Add($URLFile) }


  }
  catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
    Logwrite ("Could not download " + $URLFile + ". Given error code: " + $StatusCode + ".")
    $rc = $FailedFiles.Add($URLFile)
  }

}

# If the $MoveSeparateFiles is set to 0, we will upload absolutely nothing unless ALL files where correctly uploaded

if ($FailedFiles.count -eq 0 -and $MoveSeparateFiles -eq 0) {

  Logwrite ("All files were downloaded. Now copying them to the correct location. Please standby.")

  Foreach ($SuccessFullFile in $SuccessFullFiles) {

    $rc = $SuccessFullFile -match '([^\/]*)$'
    $URLFile = ""
    $URLFile = $Matches[1]
    Logwrite ("Copying " + ($Temp_dir + "\" + $URLFile) + " to " + ($Destination_dir + "\") + " for " + $SuccessFullFile + "." )

    try {
      Copy-Files ($Temp_dir + "\" + $URLFile) ($Destination_dir + "\")
    }
    catch {
      Logwrite ("Could not copy " + ($Temp_dir + "\" + $URLFile) + " to " + ($Destination_dir + "\") + " Given EC:" + $_ + ".")
    }
    
  }

}
elseif ($FailedFiles.count -gt 0 -and $MoveSeparateFiles -eq 0) {
  Logwrite ("[ERROR] One or more files could not be downloaded. As a result, none will be updated. To change this behaviour, set MoveSeparateFiles=1.")
}
elseif ($FailedFiles.count -gt 0 -and $MoveSeparateFiles -eq 1) { 
  Logwrite ("[WARNING] One or more files could not be downloaded. Please check the log.") 
}
elseif ($FailedFiles.count -eq 0) {
  Logwrite ("All files have been downloaded and copied. All done") 
} 

Logwrite ("******************* *************************** Stop.")