# IIS
Windows IIS
https://www.iis.net/learn/install/installing-iis-85/installing-iis-85-on-windows-server-2012-r2

Windows 7

https://www.sepago.com/blog/2012/05/19/install-internet-information-services-iis-on-windows-7

dism /online /get-features /format:table

Internet Information Services

Web Manamgent Tools

dism /online /enable-feature /featurename:IIS-WebServerRole /featurename:IIS-WebServer

dism /online /enable-feature /featurename:IIS-IIS6ManagentCompatibility /featurename:IIS-WMICompatibility /featurename:IIS-Metabase

