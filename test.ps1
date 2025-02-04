
$source_file_remote = "https://github.com/torvalds/linux/archive/refs/heads/master.zip"
$source_file = "$PSScriptRoot/source.zip"
$source_folder = "$PSScriptRoot/source"
$tmp_folder = "$PSScriptRoot/tmp"

function main() {
  Get-Source  
  # Test-Dockerfile
  Test-CopyFiles
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
  docker build --no-cache -f "$PSScriptRoot/test.Dockerfile" $PSScriptRoot
}

function Test-CopyFiles() {
  $target_dir = "$tmp_folder/$( [guid]::NewGuid().ToString() )" 
  mkdir -p $target_dir 
  
  Write-Output "test copying files ..."
  Measure-Command { xcopy $source_folder $target_dir /s /e }
  Write-Output "$((ls -r $target_dir | Measure-Object -line).Lines) files copied."

}

main 
