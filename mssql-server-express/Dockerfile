# load initial Windows Server Core Image in version 1709
FROM microsoft/windowsservercore:1709

MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="mssql-server-express"
LABEL VERSION="2017"

# Download Links:
ENV     sql_installer_download_url "https://download.microsoft.com/download/E/F/2/EF23C21D-7860-4F05-88CE-39AA114B014B/SQLEXPRADV_x64_ENU.exe"
ENV     sql_installer_sha256       "8065F09C792D69110011BD1F144DA70E2E6A851680D1C31E0C71AF746F61ABF5"
ENV     sa_password "_"
ENV     sa_password_path "C:\ProgramData\Docker\secrets\sa-password"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# make install files accessible
COPY start.ps1 /MSSQL/

WORKDIR "/MSSQL"

RUN Invoke-WebRequest -Proxy $env:HTTPS_PROXY -Uri $env:sql_installer_download_url -OutFile .\sqlexpress.exe ; \
        if ((Get-FileHash .\sqlexpress.exe -Algorithm sha256).Hash -ne $env:sql_installer_sha256) { \
        Write-Host 'FAILED!';  \
        exit 1;  \
        } \
        Start-Process -Wait -FilePath .\sqlexpress.exe -ArgumentList /qs, /x:setup ; \
        .\setup\setup.exe /q /ACTION=Install /INSTANCENAME=SQLEXPRESS /FEATURES=SQLEngine,Replication,FullText /UPDATEENABLED=0 /SQLSVCACCOUNT='NT AUTHORITY\System' /SQLSYSADMINACCOUNTS='BUILTIN\ADMINISTRATORS' /TCPENABLED=1 /NPENABLED=0 /IACCEPTSQLSERVERLICENSETERMS ; \
        Remove-Item -Recurse -Force sqlexpress.exe, setup

RUN stop-service MSSQL`$SQLEXPRESS ; \
        set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql14.SQLEXPRESS\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpdynamicports -value '' ; \
        set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql14.SQLEXPRESS\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpport -value 1433 ; \
        set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql14.SQLEXPRESS\mssqlserver\' -name LoginMode -value 2 ;

EXPOSE 1433

VOLUME "C:\MSSQL"

ENTRYPOINT /MSSQL/start 

CMD -sa_password $env:sa_password -ACCEPT_EULA "Y" -Verbose
