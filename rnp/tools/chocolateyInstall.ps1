$ErrorActionPreference = 'Stop';

$osBitness = Get-ProcessorBits
Write-Host "Detected osBitness=$osBitness"

# Include the Chocolatey compatibility scripts if available
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$compatScript = $toolsDir +  '.\ChocolateyCompat.ps1'
if (Test-Path $compatScript) {
    . ($compatScript)
}
# $packageDir      = Join-Path $toolsDir ".."

# MSYS2 zips contain a root dir named msys32 or msys64
# $msysName = '.' #shorten the path by exporting to the same folder
# $msysRoot = Join-Path $packageDir $msysName
$msysRoot = Get-ToolsLocation
$msysBase = Join-Path $msysRoot ("msys" + $osBitness)
$dllPath = Join-Path $msysBase ("mingw" + $osBitness + '\bin')

# Now we can use the $env:chocolateyPackageParameters inside the Chocolatey package
if ([string]::IsNullOrWhiteSpace($packageParameters))
{
    $packageParameters = $env:chocolateyPackageParameters
}

Set-Item Env:MSYSTEM ("MINGW" + $osBitness)
# $msysShell     = Join-Path (Join-Path $msysName ("msys" + $osBitness)) ('msys2_shell.cmd')
$msysBashShell = Join-Path $msysBase ('usr\bin\bash')

# Create some helper functions
function execute {
    param( [string] $message
         , [string] $command
         , [bool] $ignoreExitCode = $false
         )
    # Set the APPDATA path which does not get inherited during these invokes
    # and set MSYSTEM to make sure we're using the right system
    $envdata = "export APPDATA=""" + $Env:AppData + """ && export MSYSTEM=MINGW" + $osBitness + " && "

    # NOTE: For now, we have to redirect or silence stderr due to
    # https://github.com/chocolatey/choco/issues/445
    # Instead just check the exit code
    Write-Host "$message with '$command'..."
    if ($compat -eq 1)
    {
        $proc = Start-Process -NoNewWindow -UseNewEnvironment -Wait $msysBashShell -ArgumentList '--login', '-c', "'$envdata $command'" -PassThru
    } else {
        $proc = Start-Process -NoNewWindow -UseNewEnvironment -Wait $msysBashShell -ArgumentList '--login', '-c', "'$envdata $command'" -RedirectStandardError nul -PassThru
    }

    if ((-not $ignoreExitCode) -and ($proc.ExitCode -ne 0)) {
        # Retry the command, maybe something was up
        if ($compat -eq 1)
        {
            $proc = Start-Process -NoNewWindow -UseNewEnvironment -Wait $msysBashShell -ArgumentList '--login', '-c', "'$envdata $command'" -PassThru
        } else {
            $proc = Start-Process -NoNewWindow -UseNewEnvironment -Wait $msysBashShell -ArgumentList '--login', '-c', "'$envdata $command'" -RedirectStandardError nul -PassThru
        }

        if ((-not $ignoreExitCode) -and ($proc.ExitCode -ne 0)) {
            # Tried twice, just fail.
            throw ("Command `'$command`' did not complete successfully. ExitCode: " + $proc.ExitCode)
        }
    }
}

function rebase {
    if ($arch -eq 'x86') {
        $command = Join-Path $msysBase "autorebase.bat"
        Write-Host "Rebasing MSYS32 after update..."
        Start-Process -WindowStyle Hidden -Wait $command
    }
}

# Initialize and upgrade MSYS2 according to https://msys2.github.io
Write-Host "Initializing MSYS2..."

execute "Processing MSYS2 bash for first time use" `
        "exit"

execute "Appending profile with path information" `
        ('echo "export PATH=/mingw' + $osBitness + '/bin:\$PATH" >>~/.bash_profile')

execute "Setting default MSYSTEM" `
        ('echo "export MSYSTEM=' + ("MINGW" + $osBitness) + '" >>~/.bash_profile')

# Now perform commands to set up MSYS2
execute "Update pacman package DB" `
        "pacman -Syy"

execute "Updating system packages" `
        "pacman --noconfirm --needed -Sy bash pacman pacman-mirrors msys2-runtime"
rebase
execute "Upgrading full system" `
        "pacman --noconfirm -Su"

# It seems some parts of the system have to be update for others to be updateable. So just run this twice.
execute "Upgrading full system twice" `
        "pacman --noconfirm -Su"

rebase

$lines = Get-Content -Path "$toolsDir\$osBitness\packages.txt" | ForEach-Object {$_ -Replace ' ', '='}
$line = $lines -join " "
execute "Installing Dependencies" `
        "pacman --noconfirm -S --needed $line"

# Install-ChocolateyPath -PathToInstall $dllPath
Copy-Item "$dllPath\*.dll" $toolsDir -Force

# Copy RNP EXE files
Copy-Item "$toolsDir\$osBitness\*.exe" $toolsDir -Force

Remove-Item "$toolsDir\32" -Recurse

Remove-Item "$toolsDir\64" -Recurse

Write-Output "***********************************************************************************************"
Write-Output "*"
Write-Output "*  Please restart powershell "
Write-Output "*"
Write-Output "***********************************************************************************************"
Write-Output "Waiting for chocolatey to finish..."
