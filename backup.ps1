$BackupServerUsername = ""
$BackupServerPassword = ""

$Date = Get-Date

$BackupDesPath = ""
$BackupSrcPath = "\*"

$BackupDesPathTest = Test-Path ""
$BackupSrcPathTest = Test-Path ""

if ($BackupSrcPathTest -eq $true -and $BackupDesPathTest -eq $true)
{
    $SecurePwd = ConvertTo-SecureString $BackupServerPassword -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PSCredential ($BackupServerUsername, $SecurePwd)

    $files = Get-ChildItem -Path "" -Recurse

    foreach ($file in $files)
    {
        $TimeBetween = New-TimeSpan -Start $file.LastWriteTime -End $Date

        $FilenameEdit = $file.FullName.Remove(0, 24)
        $BackupDesPathFinal = $BackupDesPath + $FilenameEdit

        if ($TimeBetween.Days -eq 0)
        {         
            if ($file.Mode -eq "d-----")
            {
                $folderexist = Test-Path $BackupDesPathFinal
                if ($folderexist -eq $false)
                {
                    Copy-Item -Path $file.FullName -Destination $BackupDesPathFinal
                }
            }
            else
            {
                Copy-Item -Path $file.FullName -Destination $BackupDesPathFinal -Force
            }
            
        }       
    }
}


