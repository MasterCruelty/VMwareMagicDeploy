# Parameters
$isoPathOriginal = "C:\path\to\original\esxi.iso"
$isoPathModified = "C:\path\to\modified\esxi.iso"
$ksPath = "C:\path\to\ks.cfg"
$tempDir = "C:\path\to\temp\esxi"

# Mount the original ISO
Mount-DiskImage -ImagePath $isoPathOriginal
$mountedISO = Get-DiskImage -ImagePath $isoPathOriginal | Get-Volume

# Create the temporary directory and copy files
New-Item -ItemType Directory -Force -Path $tempDir
Copy-Item -Path "$($mountedISO.DriveLetter):\*" -Destination $tempDir -Recurse

# Unmount ISO
Dismount-DiskImage -ImagePath $isoPathOriginal

# Copy ks.cfg file in temporary local folder
Copy-Item -Path $ksPath -Destination $tempDir

# Modify boot.cfg
$bootCfgPath = "$tempDir\EFI\BOOT\boot.cfg"
$content = Get-Content $bootCfgPath
$content += "kernelopt=ks=cdrom:/ks.cfg"
Set-Content -Path $bootCfgPath -Value $content

# Create new ISO
oscdimg -n -m -b"$tempDir\EFI\BOOT\bootx64.efi" $tempDir $isoPathModified

# Clean temporary local folder
Remove-Item -Recurse -Force $tempDir
