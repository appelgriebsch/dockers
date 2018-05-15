# load initial Windows Server Core Image in version 1709
FROM microsoft/windowsservercore:1803

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

