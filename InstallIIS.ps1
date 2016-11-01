set-executionpolicy remotesigned


Function checkOSVersion {
$os=get-wmiobject -class Win32_OperatingSystem
$os.version
Switch -Regex ($os.version)
{
"10.0"
     {
         if($os.producttype -eq 1)
           {Write-Host "Windows 10"
           $osVer="Windows10"
           }
         elseIf($os.ProductType -eq 3)
           {Write-Host "Windows Server 2016"
            $osVer="Server2016"
            }
         else
           {Write-Host "Unknown"}

         
     }
"6.3"
{
$os.ProductType

         if($os.producttype -eq 1)
           {Write-Host "Windows 8.1"
           $osVer="Windows81"
           }
         elseIf($os.ProductType -eq 3)
           {Write-Host "Windows Server 2012 R2"
            $osVer="Server2012"
            }
         else
           {Write-Host "Unknown"}

         
    
}

"6.1"
{
$os.ProductType

        if($os.producttype -eq 1)
           {Write-Host "Windows 7 SP1"
           $osVer="Windows7"
           }

}


DEFAULT {"Version not listed"}
}

return $osVer
}

$osVer=""
$osVer=checkOSVersion
$osVer
Switch ($osVer)
{

"Windows10"
   {
     Write-Host "Installing IIS on Windows 10"
     $state=Get-WindowsOptionalFeature -Online -FeatureName "Netfx3"
     if($state.state -eq "Enabled")
       {}
     else
       {
         Enable-WindowsOptionalFeature -Online -FeatureName "NetFX3"
    
       }
     $state=Get-WindowsOptionalFeature -Online -FeatureName "NetFx4-AdvSrvs"
     if($state.state -eq "Disabled")
        {
              Enable-WindowsOptionalFeature -Online -FeatureName "NetFx4-AdvSrvs"
        }

      dism /online /enable-feature /featurename:IIS-WebServerRole /featurename:IIS-WebServer
      dism /online /enable-feature /featurename:IIS-WebServerManagementTools /Featurename:IIS-IIS6ManagementCompatibility /featurename:IIS-WMICompatibility /featurename:IIS-Metabase
      dism /online /enable-feature /featurename:IIS-LegacyScripts /featurename:IIS-LegacySnapIn
      
      dism /online /enable-feature /featurename:IIS-ISAPIExtensions /FeatureName:IIS-ASP
      dism /online /enable-feature /featurename:IIS-ISAPIFilter /featurename:IIS-NetFxExtensibility /featurename:NetFx4Extended-ASPNET45 /featurename:IIS-ASPNET 
      dism /online /enable-feature /featurename:IIS-NetFxExtensibility45 /featurename:IIS-ASPNET45 
      dism /online /enable-feature /featurename:IIS-ManagementScriptingTools /featurename:IIS-ManagementService
      dism /online /enable-feature /featurename:IIS-CGI /featurename:IIS-ServerSideIncludes
      dism /online /enable-feature /featurename:IIS-WebSockets /featurename:IIS-ApplicationInit
      dism /online /enable-feature /featurename:IIS-WindowsAuthentication
     
   }

"Server2016"
{
   $osVer
    Write-Host "Installing IIS on Windows Server 2016"
    Install-WindowsFeature Web-Server
    Install-Windowsfeature Web-App-Dev
    Install-WindowsFeature Web-Net-Ext
    Install-WindowsFeature Web-Net-Ext45
    Install-WindowsFeature Web-ASP
    Install-WindowsFeature Web-Asp-Net45
    
    Install-WindowsFeature Web-Includes
    Install-Windowsfeature Web-Scripting-Tools
    Install-Windowsfeature Web-Mgmt-Service

    Install-WindowsFeature Web-Windows-Auth
  


}

"Server2012"
{
$osVer
    Write-Host "Installing IIS on Windows Server 2012"
    Install-WindowsFeature Web-Server
    Install-Windowsfeature Web-App-Dev
    Install-WindowsFeature Web-Net-Ext
    Install-WindowsFeature Web-Net-Ext45
    Install-WindowsFeature Web-ASP
    Install-WindowsFeature Web-ASP-Net
    Install-WindowsFeature Web-Asp-Net45
    Install-WindowsFeature Web-AppInit
    Install-WindowsFeature Web-CGI
    
    Install-WindowsFeature Web-Mgmt-Console
    Install-WindowsFeature Web-Mgmt-Compat
    Install-WindowsFeature Web-Metabase
    Install-WindowsFeature Web-Lgcy-Mgmt-Console
    Install-WindowsFeature Web-Lgcy-Scripting
    Install-WindowsFeature Web-WMI
    Install-WindowsFeature Web-Includes
    Install-Windowsfeature Web-Scripting-Tools
    Install-Windowsfeature Web-Mgmt-Service

    Install-WindowsFeature Web-Windows-Auth

}

"Windows7"
{
$osVer
#Windows 7.1
                  $dnfDir='hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP'
                  $v4Dir="$dnfDir\v4\Full"
                  if (Get-ItemProperty -Path $v4Dir -ErrorAction Silentlycontinue)
                  {
                       $version=(Get-ItemProperty -Path $v4Dir -ErrorAction Silentlycontinue).release
                       $version
                       if ($version -lt '379893')
                       {
                            Write-Host "DotNETFramework 4.5 Not Installed"
                            $dotProg = "\\Win2012R2Dep2\deploymentshare$\Applications\DOTNETFRAMEWORK\NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
                            $dotArgs = " /q /norestart"
                            start-process $dotProg  "$dotArgs" -Wait
                       }
                  }
                  else{Write-Host "DOT NET 4 Not Installed"

                            #Write-Host "DotNETFramework 4.5 Not Installed"
                            $dotProg = "\\Win2012R2Dep2\deploymentshare$\Applications\DOTNETFRAMEWORK\NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
                            $dotArgs = " /q /norestart"
                            start-process $dotProg  "$dotArgs" -Wait


                  }
        dism /online /enable-feature /featurename:IIS-WebServerRole /featurename:IIS-WebServer
        dism /online /enable-feature /featurename:IIS-WebServerManagementTools /Featurename:IIS-IIS6ManagementCompatibility /featurename:IIS-WMICompatibility /featurename:IIS-Metabase
        dism /online /enable-feature /featurename:IIS-LegacyScripts /featurename:IIS-LegacySnapIn
      

        dism /online /enable-feature /featurename:IIS-ISAPIExtensions /FeatureName:IIS-ASP
        dism /online /enable-feature /featurename:IIS-ISAPIFilter /featurename:IIS-NetFxExtensibility /featurename:IIS-ASPNET 

        dism /online /enable-feature /featurename:IIS-ManagementScriptingTools /featurename:IIS-ManagementService
      dism /online /enable-feature /featurename:IIS-CGI /featurename:IIS-ServerSideIncludes
     
      dism /online /enable-feature /featurename:IIS-WindowsAuthentication
}

Default
{
  Write-Host "Not Covered"
}

}
if((get-wmiobject -Class Win32_Processor).addresswidth -eq "64")
   {
    Write-Host "64Bit"
    import-module webadministration
    Set-ItemProperty "IIS:\appPools\DefaultAppPool" -name enable32BitAppOnWin64 -Value "TRUE"
   }


import-module webadministration
get-childitem IIS:\Sites | Select -expand Name | % { set-WebconfigurationProperty -PSPath MACHINE/WEBROOT/APPHOST -Location $_ -Filter system.webserver/asp -Name enableParentPaths -Value $true}
#checking for 32 bit or 64 bit os
$GLBINSTDIR=(${env:ProgramFiles(x86)},${env:ProgramFiles} -ne $null)[0]
$GLBINSTDIR=$GLBINSTDIR+"\Company\Product\"
$GLBINSTDIR
$Program="\\CDSERVER\Share\Setup_AE.exe"
$arguments=' /S:2 /I:'+'"'+ $GLBINSTDIR+'"'
start-process "$Program" "$arguments" -Wait 
write-host 'Completed'
