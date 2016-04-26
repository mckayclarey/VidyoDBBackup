#set these variables for your specific VidyoPortal
$portalURL = 'portal.vidyo.com'
$user = 'super'
$pass = '********'

#prepping the username and password for sending the http requests to the Portal
$pair = "$($user):$($pass)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$Headers = @{
    Authorization = $basicAuthValue
}

#soap request body
[xml]$soaprequest = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sup="http://portal.vidyo.com/superapi/">
   <soapenv:Header/>
   <soapenv:Body>
      <sup:backupDbRequest>
         <sup:password>somepassword</sup:password>
      </sup:backupDbRequest>
   </soapenv:Body>
</soapenv:Envelope>'

#soap request to make the db backup file and return the file URL 
$response = Invoke-WebRequest https://$portalURL/services/VidyoPortalSuperService -Headers $Headers -Method Post -ContentType "text/xml" -Body $soaprequest

#capture just the xml content of the response and store as xml 
[xml]$xml = $response.Content

#grab the URL of the DB backup file 
$url = $xml.Envelope.Body.backupDbResponse.databaseBackup.backupURL
#store the filename portion of the URL for labelling the file
$filename = $url.Replace("https://$portalURL/super/backups/","")
#store the file as a variable for the heck of it and output it to the current working directory 
$dbfile = Invoke-WebRequest $url -Headers $Headers -Method Get -OutFile $filename
