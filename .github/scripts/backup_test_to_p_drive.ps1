
param(
    [Parameter(Mandatory=$true)][string]$run_number,
    [Parameter(Mandatory=$true)][string]$language,
    [string]$target_name = "win_$language"
)

$p_drive = "//analytical-software.eu/projekte/hms_interne_projekte/00773_kompetenzfelder/00773-006_SAS/SASUnit/github"
$timestamp = $(Get-Date -Format 'yyyy_MM_dd')

$path = "${p_drive}/$timestamp/tests/$run_number/$target_name"

New-Item -Type Directory -Force $path
New-Item -Type Directory -Force $path/example

Copy-Item -Recurse -Path $language/doc -Destination $path
Copy-Item -Recurse -Path $language/logs -Destination $path
Copy-Item -Recurse -Path example/$language/doc -Destination $path/example/doc
Copy-Item -Recurse -Path example/$language/logs -Destination $path/example/logs

