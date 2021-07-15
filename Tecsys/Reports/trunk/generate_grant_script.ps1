
if (-not(Get-Module -Name SQLPS)) {
    if (Get-Module -ListAvailable -Name SQLPS) {
        Push-Location
        Import-Module -Name SQLPS -DisableNameChecking
        Pop-Location
    }
}

$query = "SELECT 'grant ' + pm.permission_name + ' on '+ obj.name + ' to ' + rp.name + ';' collate SQL_Latin1_General_CP1_CI_AS 
FROM   sys.database_principals rp 
       INNER JOIN sys.database_permissions pm 
               ON pm.grantee_principal_id = rp.principal_id 
       LEFT JOIN sys.schemas ss 
              ON pm.major_id = ss.schema_id 
       LEFT JOIN sys.objects obj 
              ON pm.[major_id] = obj.[object_id] 
WHERE  rp.type_desc = 'DATABASE_ROLE' 
       AND pm.class_desc <> 'DATABASE' 
          AND NOT rp.name = 'PUBLIC'"


function New-EsoEnv($n, $eso_name, $eso_inst, $eso_db) {
   $ReturnObject = New-Object PSObject @{
    EsoNum = $n
    EsoName = $eso_name
    EsoInstance = $eso_inst
    EsoDB = $eso_db
    }
    return $ReturnObject
}

$ESO = $null
$ESO = New-Object System.Collections.ArrayList

$NewEnv = New-EsoEnv 1 "Dev" "LDQ9DSQLESO\DESO" "ESO_DEV"
$ESO.Add($NewEnv) | Out-Null
$NewEnv = New-EsoEnv 2 "INT1" "esodb.int1.bcldb.com" "ldb_test"
$ESO.Add($NewEnv) | Out-Null
$NewEnv = New-EsoEnv 3 "INT3" "esodb.int3.bcldb.com" "ldb_int3"
$ESO.Add($NewEnv) | Out-Null
$NewEnv =  New-EsoEnv 4 "INT4" "esodb.int4.bcldb.com" "eso_int4"
$ESO.Add($NewEnv) | Out-Null
$NewEnv =  New-EsoEnv 5 "INT5" "esodb.int5.bcldb.com" "ldb_stage"
$ESO.Add($NewEnv) | Out-Null
$NewEnv =  New-EsoEnv 6 "SBX" "LDQ9SSQL01\SBXESO" "ldb_sbx"
$ESO.Add($NewEnv) | Out-Null
$NewEnv =  New-EsoEnv 7 "TRN" "LDQ9TRSQL01" "ldb_train"
$ESO.Add($NewEnv) | Out-Null
$NewEnv =  New-EsoEnv 8 "PROD" "esodb.bcldb.com" "eso_prod"
$ESO.Add($NewEnv) | Out-Null

Write-Host "### --------------------------------------------------------------------------------------###" 
foreach ( $esoenv in $ESO ) 
{
    
    #Invoke-Sqlcmd -Query $query -ServerInstance $esoenv.EsoInstance -Database $esoenv.EsoDB;
    Write-Host "$($esoenv.EsoNum). $($esoenv.EsoName)  Server Name: $($esoenv.EsoInstance), Database Name: $($esoenv.EsoDb)"
}
Write-Host "Enter environment number, enter 9, if you would like to exit "
Write-Host "### --------------------------------------------------------------------------------------###" 
$num = Read-Host -Prompt "Environmnet number (or 9 to exit)"

if (($num -lt 1) -or ($num -gt 8))
{
    Write-Host "You entered $num. This environment is not defined, exiting..."
    pause;
    exit;
}
else
{
    Write-Host "You entered $num. "
    $esoenv = $ESO[$num-1]
}

$file = [Environment]::GetFolderPath("Desktop") + "\grant_privs_$($esoenv.EsoName).sql"
#$file

$db1 = "ESO_CUSTOM_INTEGRATION"
$db2 = $esoenv.EsoDB
$db3 = $esoenv.ESODb + "_wh"

"use [$db1]" | Out-File $file
"go" | Out-File -Append $file
""  | Out-File -Append $file

(Invoke-Sqlcmd -query $query -ServerInstance $esoenv.EsoInstance -Database $db1 -ErrorAction Stop).ItemArray |Out-File -append $file;

"go" | Out-File -Append $file
""  | Out-File -Append $file

"use [$db2]" | Out-File -Append $file
"go" | Out-File -Append $file
""  | Out-File -Append $file

(Invoke-Sqlcmd -query $query -ServerInstance $esoenv.EsoInstance -Database $db2 -ErrorAction Stop).ItemArray |Out-File -append $file;

"go" | Out-File -Append $file
""  | Out-File -Append $file

"use [$db3]" | Out-File -Append  $file
"go" | Out-File -Append $file
""  | Out-File -Append $file

(Invoke-Sqlcmd -query $query -ServerInstance $esoenv.EsoInstance -Database $db3 -ErrorAction Stop).ItemArray |Out-File -append $file;

"go" | Out-File -Append $file
""  | Out-File -Append $file

Write-Host "Script generated: $file"
pause