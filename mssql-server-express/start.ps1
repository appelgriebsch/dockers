# The script sets the sa password and start the SQL Service 
# Also it attaches additional database from the disk
# The format for attach_dbs

param(
  [Parameter(Mandatory = $false)]
  [string]$sa_password,

  [Parameter(Mandatory = $false)]
  [string]$ACCEPT_EULA,

  [Parameter(Mandatory = $false)]
  [string]$attach_dbs
)


if ($ACCEPT_EULA -ne "Y" -And $ACCEPT_EULA -ne "y") {
  Write-Verbose "ERROR: You must accept the End User License Agreement before this container can start."
  Write-Verbose "Set the environment variable ACCEPT_EULA to 'Y' if you accept the agreement."

  exit 1 
}

# start the service
Write-Verbose "Starting SQL Server"
start-service MSSQL`$SQLEXPRESS

if ($sa_password -eq "_") {
  if (Test-Path $env:sa_password_path) {
    $sa_password = Get-Content -Raw $secretPath
  }
  else {
    Write-Verbose "WARN: Using default SA password, secret file not found at: $secretPath"
  }
}

if ($sa_password -ne "_") {
  Write-Verbose "Changing SA login credentials"
  $sqlcmd = "ALTER LOGIN sa with password=" + "'" + $sa_password + "'" + ";ALTER LOGIN sa ENABLE;"
  & sqlcmd -Q $sqlcmd
}

$scripts = Get-Item -Path "/MSSQL" -Filter "*.sql" | Sort-Object -CaseSensitive -Unique
foreach ($script in $scripts) {
  Write-Verbose "Executing script $($script)..."
  & sqlcmd -i $script
}

Write-Verbose "Started SQL Server."
$lastCheck = (Get-Date).AddSeconds(-2) 
while ($true) { 
  Get-EventLog -LogName Application -Source "MSSQL*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message	 
  $lastCheck = Get-Date 
  Start-Sleep -Seconds 2 
}
