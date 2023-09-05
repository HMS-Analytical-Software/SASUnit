

param(
    [Parameter(Mandatory=$true)][string]$src,
    [Parameter(Mandatory=$true)][string]$tgt_dir
)

if (-Not(Test-Path env:RUN_NUMBER)) {
    echo "RUN_NUMBER must be set in env"
    exit 2
}

$p_drive = "//analytical-software.eu/projekte/hms_interne_projekte/00773_kompetenzfelder/00773-006_SAS/SASUnit/github"
$timestamp = Get-Date -Format 'yyyy_MM_dd'
$path = "$p_drive/$timestamp/$env:RUN_NUMBER/$tgt_dir"

New-Item -Type Directory -Force $path
Copy-Item -Recurse -Path $src -Destination -Force $path
