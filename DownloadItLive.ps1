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
    Updated: 2021-11-11     Initial release. //EZS
    Release Date: 2021-11-11
   
  Author: Erik Zalitis, erik@zalitis.se, +4673-941 22 74

# Comment-based Help tags were introduced in PS 2.0
#requires -version 2
#>

#----------------[ Declarations ]------------------------------------------------------

$InitDir=""
$NewsURLs="http://www.fsnradionews.com/FSNNews/FSNBulletin.mp3", "http://www.fsnradionews.com/FSNNews/FSNBulletin.mp3"  # This is 
$Destination_dir=$InitDir + "\Destination"



#----------------[ Functions ]------------------------------------------------------



#----------------[ Script proper ]------------------------------------------------------