$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $dir
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Bajar($url, $out) {
  if (Test-Path $out) { Write-Host "Ya existe: $out"; return }
  Write-Host "Descargando $out ..."
  & curl.exe -L --fail --retry 3 -o $out $url
  if ($LASTEXITCODE -ne 0) { throw "Fallo la descarga de $url" }
}

# 1) Platform Tools (adb / fastboot)
Bajar "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" "platform-tools.zip"
if (-not (Test-Path "platform-tools\fastboot.exe")) { Expand-Archive "platform-tools.zip" -DestinationPath . -Force }

# 2) Driver USB de Google (para fastboot)
Bajar "https://dl.google.com/android/repository/usb_driver_r13-windows.zip" "usb_driver.zip"
if (-not (Test-Path "usb_driver")) { Expand-Archive "usb_driver.zip" -DestinationPath . -Force }

# 3) vbmeta vacio de Google
Bajar "https://dl.google.com/developers/android/qt/images/gsi/vbmeta.img" "vbmeta.img"

# 4) LineageOS 19.x GSI (Andy Yan) arm64_bvN = A/B, sin Google, sin root
if (-not (Test-Path "system.img")) {
  Write-Host "Buscando la ultima LineageOS 19.x arm64_bvN ..."
  $rss = (& curl.exe -sL "https://sourceforge.net/projects/andyyan-gsi/rss?path=/lineage-19.x") -join "`n"
  $names = [regex]::Matches($rss, "lineage-19[^/<""]*arm64_bvN\.img\.(xz|gz)") | ForEach-Object { $_.Value } | Sort-Object -Unique | Sort-Object -Descending
  if (-not $names) { throw "No encontre el archivo arm64_bvN en SourceForge" }
  $name = $names[0]
  Write-Host "Elegido: $name"
  Bajar "https://sourceforge.net/projects/andyyan-gsi/files/lineage-19.x/$name/download" $name

  Write-Host "Descomprimiendo (puede tardar varios minutos)..."
  if ($name.EndsWith(".gz")) {
    $in = [IO.File]::OpenRead("$dir\$name"); $gz = New-Object IO.Compression.GZipStream($in, [IO.Compression.CompressionMode]::Decompress)
    $o = [IO.File]::Create("$dir\system.img"); $gz.CopyTo($o); $o.Close(); $gz.Close(); $in.Close()
  } else {
    $7z = "C:\Program Files\7-Zip\7z.exe"
    if (Test-Path $7z) {
      & $7z e $name -y | Out-Null
    } else {
      Bajar "https://github.com/tukaani-project/xz/releases/download/v5.6.3/xz-5.6.3-windows.zip" "xz.zip"
      if (-not (Test-Path "xz")) { Expand-Archive "xz.zip" -DestinationPath "xz" -Force }
      $xz = Get-ChildItem -Recurse "xz" -Filter xz.exe | Where-Object { $_.FullName -match "bin_x86-64" } | Select-Object -First 1
      if (-not $xz) { $xz = Get-ChildItem -Recurse "xz" -Filter xz.exe | Select-Object -First 1 }
      & $xz.FullName -dk $name
    }
    $img = $name -replace "\.xz$",""
    Rename-Item $img "system.img"
  }
}
Write-Host ""
Write-Host "LISTO. Archivos:"
Get-ChildItem platform-tools\fastboot.exe, vbmeta.img, system.img | Format-Table Name, Length
