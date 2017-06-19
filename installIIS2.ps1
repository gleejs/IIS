#Set-ExecutionPolicy -Scope CurrentUser
#Set-ExecutionPolicy Bypass
$srvName="ServerName"
Import-Module \\$srvName\Deploymentshare$\Applications\LIB\getOSVer.psm1

$osVer=getOSVer
Write-Host $osVer

Switch -Regex ($osVer)
{
    "Windows10"
    {
    Write-Host "Installing IIS on Windows 10"
     $state=Get-WindowsOptionalFeature -Online -FeatureName "Netfx3" 
     if($state.state -eq "Enabled")
       {}
     else
       {
         Enable-WindowsOptionalFeature -Online -FeatureName "NetFX3" -NoRestart
    
       }
     $state=Get-WindowsOptionalFeature -Online -FeatureName "NetFx4-AdvSrvs"
     if($state.state -eq "Disabled")
        {
              Enable-WindowsOptionalFeature -Online -FeatureName "NetFx4-AdvSrvs" -NoRestart
        }

      
      dism /online /enable-feature /featurename:WCF-HTTP-Activation /all /NoRestart
      dism /online /enable-feature /featurename:WCF-NonHTTP-Activation /all /NoRestart

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


      import-module webadministration
      get-childitem IIS:\Sites | Select -expand Name | % { set-WebconfigurationProperty -PSPath MACHINE/WEBROOT/APPHOST -Location $_ -Filter system.webserver/asp -Name enableParentPaths -Value $true}




    }
     
    "Windows7"
    {
       dism /online /enable-feature /featureName:NetFx3 /norestart
       dism /online /enable-feature /featurename:WAS-WindowsActivationService /norestart
       dism /online /enable-feature /featurename:WAS-NetFxEnvironment /norestart
       dism /online /enable-feature /featurename:WAS-ConfigurationAPI /norestart
       
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
        dism /online /enable-feature /featurename:IIS-WebServerRole /featurename:IIS-WebServer /NoRestart
        dism /online /enable-feature /featurename:IIS-WebServerManagementTools /Featurename:IIS-IIS6ManagementCompatibility /featurename:IIS-WMICompatibility /featurename:IIS-Metabase /NoRestart
        dism /online /enable-feature /featurename:IIS-LegacyScripts /featurename:IIS-LegacySnapIn /NoRestart
      

        dism /online /enable-feature /featurename:IIS-ISAPIExtensions /FeatureName:IIS-ASP /NoRestart
        dism /online /enable-feature /featurename:IIS-ISAPIFilter /featurename:IIS-NetFxExtensibility /featurename:IIS-ASPNET /NoRestart

        dism /online /enable-feature /featurename:IIS-ManagementScriptingTools /featurename:IIS-ManagementService /NoRestart
        dism /online /enable-feature /featurename:IIS-CGI /featurename:IIS-ServerSideIncludes /NoRestart
     
        dism /online /enable-feature /featurename:WCF-HTTP-Activation /norestart
        dism /online /enable-feature /featurename:WCF-NonHTTP-Activation /norestart
        dism /online /enable-feature /featurename:IIS-WindowsAuthentication /NoRestart
        #set-itemproperty "IIS:\AppPools\DefaultAppPool" -Name managedRuntimeVersion -Value v4.0
        c:\Windows\System32\inetsrv\appcmd set apppool /apppool.name:DefaultAppPool /managedRuntimeversion:v4.0
        c:\Windows\System32\inetsrv\appcmd unlock config /section:asp
        c:\Windows\System32\inetsrv\appcmd set config "Default Web Site" -section:system.webserver/asp /enableParentPaths:"TRUE" /commit:apphost

    }



DEFAULT {" OSVersion Not Supported"}
}

if((get-wmiobject -Class Win32_Processor).addresswidth -eq "64")
   {
    Write-Host "64Bit"
    import-module webadministration
    Set-ItemProperty "IIS:\appPools\DefaultAppPool" -name enable32BitAppOnWin64 -Value "TRUE"
   }


Write-Host "Completed IIS Installation"
