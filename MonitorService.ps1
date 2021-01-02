#Function for write a Log
function CreateLog($Logmsg){
$DateTime=get-date
#Get date for creating file in specific Folder
$Date= get-date -Format "ddMMMyyyy"
$Year=get-date -Format "yyyy"
$Mon=get-date -Format "MMM"

$FolderPath ='D:\Log Folder\'+$Year+'\'+$Mon
$FilePath =$FolderPath+'\'+$Date+'.txt'
$CheckFolder=Test-Path $FolderPath
$CheckFile=Test-Path $FilePath
    #Check Folder already exist or not 
    If((Test-path $FolderPath) -eq $false)
    {
        New-Item -Path $FolderPath -ItemType Directory
        #Check File already exist or not
        if((Test-path $CheckFile) -eq $false)
        {
        
            New-Item -Path $FilePath -ItemType File
            Set-Content $FilePath [$DateTime]$Logmsg
           }
    }
   #Folder not exist then Create Folder
    Else
    {
        #Check File already exist or not
        if(-not (Test-path $FilePath))
        {
        
            New-Item -Path $FilePath -ItemType File
            Set-Content $FilePath [$DateTime]$Logmsg
        }
        #File not exist then create New File on System date wise
        else
        {
            
            Add-Content $FilePath [$DateTime]$Logmsg
        }
    }

}

Function SendMail()
{
$From = "piyush.thorat@weatherford.com"
$To = "piyush.horat@weatherford.com"#,"sachin.gomle@weatherford.com"
#$Attachment = "C:\MyRun.txt"
$Subject = "Error:-Bitfarm trail mail"
$Body = "Testing email services :-
Service status: Stop  Please refresh service "
$SMTPServer = "smtp.weatherford.com"
$SMTPPort = "587"
#$Cred= Get-Credential "piyush.thorat@weatherford.com" "Password%%123"

Send-MailMessage -From $From -to $To -Subject $Subject `
-Body $Body -SmtpServer $SMTPServer -port $SMTPPort

Write-Host "Mail send"
}

# start the following Windows services in the specified order:
[Array] $Services = 'MyService','MyService';
# loop through each service, if its not running, start it
foreach($ServiceName in $Services)
{
    $arrService = Get-Service -Name $ServiceName
    write-host $ServiceName    
    If ($arrService.Status -ne 'Running')
    {
    SendMail
        Start-Service $ServiceName
        #write-host $arrService.status
        CreateLog($ServiceName+'  '+$arrService.Status)
        #write-host 'Service starting'
        Start-Sleep -seconds 60
        $arrService.Refresh()
        #Stop-Service $ServiceName
        if ($arrService.Status -eq 'Running')
        {
        CreateLog($ServiceName+'  '+$arrService.Status)
          Write-Host 'Services is now Running'
        }
    }
    else
    {
    CreateLog($ServiceName+'  '+$arrService.Status)
    }
   
}