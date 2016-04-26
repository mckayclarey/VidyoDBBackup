$portalURL = 'portal.vidyo.com'
$user = 'super'
$pass = '********'

$pair = "$($user):$($pass)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCreds"

$Headers = @{
    Authorization = $basicAuthValue
}
[xml]$soaprequest = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sup="http://portal.vidyo.com/superapi/">
   <soapenv:Header/>
   <soapenv:Body>
      <sup:backupDbRequest>
         <sup:password>somepassword</sup:password>
      </sup:backupDbRequest>
   </soapenv:Body>
</soapenv:Envelope>'

$response = Invoke-WebRequest https://$portalURL/services/VidyoPortalSuperService -Headers $Headers -Method Post -ContentType "text/xml" -Body $soaprequest

[xml]$xml = $response.Content

$url = $xml.Envelope.Body.backupDbResponse.databaseBackup.backupURL
$filename = $url.Replace("https://$portalURL/super/backups/","")
$dbfile = Invoke-WebRequest $url -Headers $Headers -Method Get -OutFile $filename
