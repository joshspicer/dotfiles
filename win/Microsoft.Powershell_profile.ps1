
Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'

Start-SshAgent
# Add-SshKey (Resolve-Path ~\.ssh\...)

# change the prompt foreground color
$GitPromptSettings.DefaultForegroundColor = "DarkCyan"
# make the prompt span two lines and change the prompt character to `$`
$GitPromptSettings.DefaultPromptSuffix = '`n$(''$'' * ($nestedPromptLevel + 1)) '
# prefix the prompt with "username@hostname"
$GitPromptSettings.DefaultPromptPrefix = '$(hostname) - '
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
