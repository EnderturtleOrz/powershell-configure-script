# install: Install-Module -Name PowerShellGet -Force
# install: Install-Module PSReadLine -AllowPrerelease -Force
Import-Module PSReadLine
Import-Module posh-git

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -PredictionSource History