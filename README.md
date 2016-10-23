# IIS
Windows IIS
https://www.iis.net/learn/install/installing-iis-85/installing-iis-85-on-windows-server-2012-r2

Windows 7

https://www.sepago.com/blog/2012/05/19/install-internet-information-services-iis-on-windows-7

dism /online /get-features /format:table

Internet Information Services

Web Manamgent Tools

dism /online /enable-feature /featurename:IIS-WebServerRole /featurename:IIS-WebServer

dism /online /enable-feature /featurename:IIS-WebServerManagementTools /featurename:IIS-IIS6ManagementCompatibility /featurename:IIS-WMICompatibility /featurename:IIS-Metabase

dism /online /enable-feature /featurename:IIS-LegacyScripts /featurename:IIS-LegacySnapIn

dism /online /enable-feature /featurename:IIS-ManagementScriptingTools /featurename:IIS-ManagementService

dism /online /enable-feature /featurename:IIS-ISAPIExtensions /featurename:IIS-ASP

dism /online /enable-feature /featurename:IIS-NetFxExtensibility /featurename:IIS-ISAPIFilter /featurename:IIS-ASPNET

dism /online /enable-feature /featurename:IIS-CGI /featurename:IIS-ServerSideIncludes

dism /online /enable-feature /featurename:IIS-WindowsAuthentication

*Enable 32 Bit Application on Default Application Pool

Set-ItemProperty IIS:\AppPools\DefaultAppPool enable32BitAppOnWin64 true
