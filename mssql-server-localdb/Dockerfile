# load initial Windows Server Core Image in version 1709
FROM microsoft/windowsservercore:1709 as builder

# Download Links:
ENV     sql_installer_download_url "https://download.microsoft.com/download/E/F/2/EF23C21D-7860-4F05-88CE-39AA114B014B/SqlLocalDB.msi"
ENV     sql_installer_sha256       "1F8ECC7DCB4691C72D9F0FA29B05AC14C472944409C97C1BA428B67EC4FCCFF9"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN New-Item -Name MSSQL -Path / -ItemType Directory; \
        Set-Location C:\MSSQL; \
        Invoke-WebRequest -Proxy $env:HTTPS_PROXY -Uri $env:sql_installer_download_url -OutFile .\SqlLocalDB.msi ; \
        if ((Get-FileHash .\SqlLocalDB.msi -Algorithm sha256).Hash -ne $env:sql_installer_sha256) { \
        Write-Host 'Download FAILED!';  \
        exit 1;  \
        } \
        Start-Process msiexec.exe -ArgumentList '/i', 'C:\MSSQL\SqlLocalDB.msi', '/quiet', '/norestart', 'IACCEPTSQLLOCALDBLICENSETERMS=YES' -NoNewWindow -Wait ; \
        Remove-Item -Recurse -Force C:\MSSQL\SqlLocalDB.msi;

SHELL ["cmd", "/C"]

WORKDIR "/MSSQL"

RUN reg export "HKLM\Software\Wow6432Node\Microsoft\Microsoft SQL Server Local DB" HKLM_SW_SQLLOCALDB_32.reg
RUN reg export "HKLM\Software\Microsoft\Microsoft SQL Server Local DB" HKLM_SW_SQLLOCALDB.reg
RUN reg export "HKLM\Software\Microsoft\Microsoft SQL Server" HKLM_SW_SQLSERVER.reg
RUN reg export "HKLM\System\CurrentControlSet\services\EventLog\Application\SQLLocalDB 14.0" HKLM_EVT_SQLLOCALDB.reg
RUN reg export "HKLM\System\CurrentControlSet\services\EventLog\Application\SQLVDI" HKLM_EVT_SQLVDI.reg
RUN reg export "HKLM\System\CurrentControlSet\services\EventLog\Application\SQLWriter" HKLM_EVT_SQLWRITER.reg
RUN reg export "HKLM\System\CurrentControlSet\services\SQLWriter" HKLM_SVC_SQLWRITER.reg

FROM microsoft/nanoserver:1709
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="mssql-localdb"
LABEL VERSION="2017"

USER ContainerAdministrator

RUN mkdir C:\MSSQL && \
        mkdir "C:\Program Files" && \
        mkdir "C:\Program Files\common" && \
        mkdir "C:\Program Files (x86)" && \
        setx /m PATH %PATH%;"C:\Program Files\Microsoft SQL Server\140\Tools\Binn"

# make install files accessible
COPY --from=builder ["/Program Files/Microsoft SQL Server", "/Program Files/Microsoft SQL Server"]
COPY --from=builder ["/Program Files/common files/Microsoft Shared/SQL Debugging", "/Program Files/common files/Microsoft Shared/SQL Debugging"]
COPY --from=builder ["/Program Files (x86)/Microsoft SQL Server", "/Program Files (x86)/Microsoft SQL Server"]
COPY --from=builder ["/MSSQL", "/MSSQL"]

RUN FOR %r in (C:\MSSQL\*.reg) DO reg import %r
RUN regsvr32 "C:\Program Files\Microsoft SQL Server\80\COM\sqlvdi.dll"

WORKDIR "/MSSQL"

USER ContainerUser