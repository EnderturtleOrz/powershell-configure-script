# Author: Tianci Hou (EnderturleOrz on GitHub)
# Description: PowerShell configuration script to install and configure modules and append content to $PROFILE.
# Usage: Run this script in PowerShell to install and configure modules and append content to $PROFILE.

# If you cannot run this script, you may need to change the execution policy.
# Run command in PowerShell as an administrator: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Function to check if the script is running with administrator privileges
function Test-Administrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

    if (-not (Test-Administrator)) {
    Write-Host "This script needs to be run as an administrator. Please restart PowerShell with administrator privileges and run the script again."
    exit
}

function Append-ContentToProfile {
    param (
        [string]$filePath
    )
    $comment = "# $(Split-Path -Leaf $filePath)"
    Add-Content -Path $PROFILE -Value $comment
    Get-Content -Path $filePath | Add-Content -Path $PROFILE
    Write-Host "Appended content from $filePath to `$PROFILE."
}

function Install-ModuleIfSelected {
    param (
        [string]$moduleName,
        [string]$installCommand
    )
    Invoke-Expression $installCommand
    Write-Host "$moduleName installed successfully."
}

function Check-PowerShellGet {
    $powerShellGetModule = Get-Module -Name PowerShellGet -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
    if ($null -eq $powerShellGetModule -or -not $powerShellGetModule.Version.ToString().StartsWith("2")) {
        Install-Module -Name PowerShellGet -Force
        Write-Host "PowerShellGet module installed. Please restart your terminal and run the script again."
        exit
    } else {
        Write-Host "PowerShellGet version $($powerShellGetModule.Version) is installed."
    }
}

function Select-Files {
    param (
        [array]$configFiles
    )
    $selectedFilesArray = @()
    try {
        $fileNames = $configFiles | ForEach-Object { $_.Name }
        $selectedFiles = $fileNames | fzf --multi --prompt "Select files to process: " --header "Use TAB to select multiple files"
        $selectedFilesArray = $selectedFiles -split "`n"
    } catch {
        Write-Host "fzf not found, falling back to manual selection"
        foreach ($file in $configFiles) {
            $fileName = $file.Name
            $install = Read-Host "Do you want to process $fileName? (Y/N)"
            if ($install.ToUpper() -eq "Y") {
                $selectedFilesArray += $fileName
            }
        }
    }
    return $selectedFilesArray
}

function Install-SelectedFiles {
    param (
        [array]$selectedFilesArray,
        [array]$configFiles,
        [bool]$appendToProfile
    )
    foreach ($fileName in $selectedFilesArray) {
        $file = $configFiles | Where-Object { $_.Name -eq $fileName }
        Write-Host "$fileName is installing..."
        $lines = Get-Content -Path $file.FullName
        foreach ($line in $lines) {
            if ($line -match "^# install: ") {
                $installCommand = $line -replace "^# install: \s*", ""
                Install-ModuleIfSelected -moduleName $fileName -installCommand $installCommand
            }
        }
        if ($appendToProfile) {
            Append-ContentToProfile -filePath $file.FullName
        }
    }
}

Write-Host "Welcome to the PowerShell configuration script!"
Write-Host "This script will install and configure modules and append content to your PowerShell profile."
Write-Host "You can always run this script again to update or customize your configuration."
Write-Host "To enable all features, please install Nerd Fonts https://www.nerdfonts.com/font-downloads."
Write-Host "If you want to change the startup configuration including themes, you can manually edit `$PROFILE."
Write-Host ""

$initialMode = Read-Host "Select initial mode: (Y)es for install and configure all, (C)ustomize, (R)est `$PROFILE, (N)o for exit"
$configFiles = Get-ChildItem -Path "./config" -Filter "*.ps1"

switch ($initialMode.ToUpper()) {
    "Y" {
        # Install all modules and append all content to $PROFILE
        Check-PowerShellGet
        $selectedFilesArray = $configFiles | ForEach-Object { $_.Name }
        Install-SelectedFiles -selectedFilesArray $selectedFilesArray -configFiles $configFiles -appendToProfile $true
    }
    "R" {
        # Reset $PROFILE
        $reset = Read-Host "Do you want to clean `$PROFILE? (Y/N)"
        if ($reset.ToUpper() -eq "Y") {
            Clear-Content -Path $PROFILE
            Write-Host "`$PROFILE is reset."
        }
    }
    "C" {
        # Custom settings
        Write-Host ""
        Check-PowerShellGet
        $customMode = Read-Host "Select custom mode: (S)elective install and configure, (U)pdate selected modules, (N)o for exit"

        switch ($customMode.ToUpper()) {
            "S" {
                # Selective install and configure
                $selectedFilesArray = Select-Files -configFiles $configFiles
                Install-SelectedFiles -selectedFilesArray $selectedFilesArray -configFiles $configFiles -appendToProfile $true
            }
            "U" {
                # Update selected modules
                $selectedFilesArray = Select-Files -configFiles $configFiles
                Install-SelectedFiles -selectedFilesArray $selectedFilesArray -configFiles $configFiles -appendToProfile $false
            }
            "N" {
                Write-Host "Exiting custom mode."
            }
            default {
                Write-Host "Invalid selection. Please run the script again and select a valid mode."
            }
        }
    }
    "N" {
        Write-Host "Exiting."
    }
    default {
        Write-Host "Invalid selection. Please run the script again and select a valid mode."
    }
}