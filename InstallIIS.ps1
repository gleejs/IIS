#set-executionpolicy remotesigned


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
$srvName="Win2012R2Dep2"
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

      dism /online /enable-feature /Quiet /norestart /featurename:IIS-WebServerRole /featurename:IIS-WebServer
      dism /online /enable-feature /Quiet /norestart /featurename:IIS-WebServerManagementTools /Featurename:IIS-IIS6ManagementCompatibility /featurename:IIS-WMICompatibility /featurename:IIS-Metabase
      dism /online /enable-feature /Quiet /norestart /featurename:IIS-LegacyScripts /featurename:IIS-LegacySnapIn
      
      dism /online /enable-feature /Quiet /norestart /featurename:IIS-ISAPIExtensions /FeatureName:IIS-ASP
      dism /online /enable-feature /Quiet /norestart /featurename:IIS-ISAPIFilter /featurename:IIS-NetFxExtensibility /featurename:NetFx4Extended-ASPNET45 /featurename:IIS-ASPNET 
      dism /online /enable-feature /Quiet /norestart /featurename:IIS-NetFxExtensibility45 /featurename:IIS-ASPNET45 
      dism /online /enable-feature /Quiet /norestart /featurename:IIS-ManagementScriptingTools /featurename:IIS-ManagementService
      dism /online /enable-feature /Quiet /norestart /featurename:IIS-CGI /featurename:IIS-ServerSideIncludes
      dism /online /enable-feature /Quiet /norestart /featurename:IIS-WebSockets /featurename:IIS-ApplicationInit
      dism /online /enable-feature /Quiet /norestart /featurename:IIS-WindowsAuthentication
     
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
    $RegKey='HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    Set-ItemProperty -Path $RegKey -Name DisableCachingOfSSLPages -Value 0
  


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

    $RegKey='HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    Set-ItemProperty -Path $RegKey -Name DisableCachingOfSSLPages -Value 0

}

"Windows81"
{
    Write-Host "Install IIS for Windows 8.1"
    dism /online /enable-feature /Quiet /norestart /featurename:IIS-WebServerRole /featurename:IIS-WebServer
    dism /online /enable-feature /Quiet /norestart /featurename:IIS-WebServerManagementTools /Featurename:IIS-IIS6ManagementCompatibility /featurename:IIS-WMICompatibility /featurename:IIS-Metabase
    dism /online /enable-feature /Quiet /norestart /featurename:IIS-LegacyScripts /featurename:IIS-LegacySnapIn
      

    dism /online /enable-feature /Quiet /norestart /featurename:IIS-ISAPIExtensions /FeatureName:IIS-ASP
    dism /online /enable-feature /Quiet /norestart /featurename:IIS-ApplicationInit  
    dism /online /enable-feature /Quiet /norestart /featurename:NetFX4Extended-ASPNET45 /featurename:IIS-NetFxExtensibility /Featurename:IIS-NetFxExtensibility45

    dism /online /enable-feature /Quiet /norestart /featurename:IIS-ISAPIFilter   
    dism /online /enable-feature /Quiet /norestart /featurename:IIS-ASPNET /FeatureName:IIS-ASPNET45

    dism /online /enable-feature /Quiet /norestart /featurename:IIS-ManagementScriptingTools /featurename:IIS-ManagementService
    dism /online /enable-feature /Quiet /norestart /featurename:IIS-CGI /featurename:IIS-ServerSideIncludes
     
    dism /online /enable-feature /Quiet /norestart /featurename:IIS-WindowsAuthentication
    #restart-computer
    #cscript.exe "\\Win2012R2Dep2\Deploymentshare$\Scripts\LTISuspend.wsf"
    new-item c:\InstallESE.txt -type file
}

"Windows7"
{
$osVer
#Windows 7.1
        dism /online /enable-feature /featurename:IIS-WebServerRole /featurename:IIS-WebServer
        dism /online /enable-feature /featurename:IIS-WebServerManagementTools /Featurename:IIS-IIS6ManagementCompatibility /featurename:IIS-WMICompatibility /featurename:IIS-Metabase
        dism /online /enable-feature /featurename:IIS-LegacyScripts /featurename:IIS-LegacySnapIn
      

        dism /online /enable-feature /featurename:IIS-ISAPIExtensions /FeatureName:IIS-ASP
        dism /online /enable-feature /featurename:IIS-ISAPIFilter /featurename:IIS-NetFxExtensibility /featurename:IIS-ASPNET 

        dism /online /enable-feature /featurename:IIS-ManagementScriptingTools /featurename:IIS-ManagementService
        dism /online /enable-feature /featurename:IIS-CGI /featurename:IIS-ServerSideIncludes
     
      dism /online /enable-feature /featurename:IIS-WindowsAuthentication
      new-item c:\InstallESE.txt -type file

                  $dnfDir='hklm:\SOFTWARE\Microsoft\NET Framework Setup\NDP'
                  $v4Dir="$dnfDir\v4\Full"
                  if (Get-ItemProperty -Path $v4Dir -ErrorAction Silentlycontinue)
                  {
                       $version=(Get-ItemProperty -Path $v4Dir -ErrorAction Silentlycontinue).release
                       $version
                       if ($version -lt '379893')
                       {
                            Write-Host "DotNETFramework 4.5 Not Installed"
                            $dotProg = "\\$srvName\deploymentshare$\Applications\DOTNETFRAMEWORK\NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
                            $dotArgs = " /q /norestart"
                            start-process $dotProg  "$dotArgs" -Wait
                       }
                  }
                  else{Write-Host "DOT NET 4 Not Installed"
                            <#
                            $dotProg = "\\$srvName\deploymentshare$\Applications\DOTNETFRAMEWORK\dotNetFx40_Full_x86_x64.exe"
                            $dotArgs = " /q /norestart"
                            start-process $dotProg "$dotArgs" -Wait
                            #>
                            #Write-Host "DotNETFramework 4.5 Not Installed"
                            $dotProg = "\\$srvName\deploymentshare$\Applications\DOTNETFRAMEWORK\NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
                            $dotArgs = " /q /norestart"
                            start-process $dotProg  "$dotArgs" -Wait


                  }
                 set-itemproperty "IIS:\AppPools\DefaultAppPool" managedRuntimeVersion v4.0
        
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

