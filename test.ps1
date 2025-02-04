
$source_file_remote = "https://github.com/torvalds/linux/archive/refs/heads/master.zip"
$source_file = "$PSScriptRoot/source.zip"
$source_folder = "source"

function main() {
  Get-Source  
  Test-Dockerfile
}

function Get-Source() {
  if (Test-Path -Path $source_folder -PathType Container) { return }
  mkdir -p $source_folder

  if (! (Test-Path -Path $source_file) ) {
    Invoke-WebRequest -Uri $source_file_remote -OutFile $source_file
    Expand-Archive -Path $source_file -DestinationPath $source_folder
  }
}

function Test-Dockerfile() {
  docker build -f "$PSScriptRoot/test.Dockerfile" $PSScriptRoot
}

main 