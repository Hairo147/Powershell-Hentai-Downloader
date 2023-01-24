$hentai = @(
    "https://api.waifu.pics/nsfw/waifu",
    "https://api.waifu.pics/nsfw/neko",
    "https://api.waifu.pics/nsfw/blowjob"
)
if (Test-Path -Path "./hentai") {
    Write-Host "Scraping started"
} else {
    mkdir hentai
}
$downloader = New-Object System.Net.WebClient
function download {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]$url,
        [Parameter()]
        [String]$path
    )
    switch -Exact ($url) {
        {$url.EndsWith(".png")} {$end = "png"; break}
        {$url.EndsWith(".jpg")} {$end = "jpg"; break}
        {$url.EndsWith(".jpeg")} {$end = "jpeg"; break}
        {$url.EndsWith(".gif")} {$end = "gif"; break}
    }
    $downloader.DownloadFile($url, "$path.$end")
}
<#
    Get-RandomHexDigit
    URL: https://www.powershellgallery.com/packages/PoshFunctions/2.2.1.6/Content/Functions%5CGet-RandomHexDigit.ps1
#>
function Get-RandomHexDigit {
    [CmdletBinding(ConfirmImpact='None')]
    param (
        [Parameter(Position=0)]
        [ValidateRange(1,16)]
        [int] $Length = 1,
        [switch] $IncludePrefix,
        [switch] $UpperCase
    )
    $ReturnVal = ( 1..$Length | foreach-object {'{0:x}' -f (Get-Random -Maximum 16)}) -join ''
    if ($UpperCase) {
        $ReturnVal = $ReturnVal.ToUpper()
    }
    if ($IncludePrefix) {
        $ReturnVal = '0x' + $ReturnVal
    }
    return $ReturnVal
}
function Get-Hentai {
    foreach ($links in $hentai) {
        $jsonhentai = (Invoke-WebRequest -Uri $links | ConvertFrom-Json).url
        $name = Get-RandomHexDigit -Length 16
        download -url $jsonhentai -path "./hentai/$name"
    }
}
while ($true) {
    $i++
    Get-Hentai
    Write-Host "Downloaded $i hentai"
}


