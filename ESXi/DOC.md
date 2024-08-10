# ILO REQUIREMENTS/CONFIGURATION/DOCUMENTATION
This file focus on documentation and all the useful information about the automatic deploy of ESXi hosts directly from ILO by PowerShell scripts mixed with other technologies.


### Requirements
* A web server where to store the ISO of ESXi.
* Windows ADK for Windows 10
* ESXi vSphere ISO
* HP Proliant Server G8 or higher
* The latest HP Service Pack for Proliant
* HP iLO PowerShell cmdlets

### Setup
* Once you installed the web server (I'll consider that on a Windows Server machine), you will need to create a virtual directory and we can do that thanks to the following PowerShell commands. The folder will be called Deployment and we will put our ISO inside it.


```ruby
mkdir c:\inetpub\deployment
```

* Now we create the virtual directory.

```ruby
New-WebVirtualDirectory -Site "Default Web Site" -Name Deployment -PhysicalPath c:\inetpub\deployment
```
![](https://www.altaro.com/vmware/wp-content/uploads/2018/05/BMAuto-2.png)

* Now we need to enable the browsing function on the directory just created with the following syntax:
```ruby
Set-WebConfigurationProperty -filter /system.webServer/directoryBrowse -name enabled -PSPath 'IIS:\Sites\Default Web Site\deployment' -Value True
```
![](https://www.altaro.com/vmware/wp-content/uploads/2018/05/BMAuto-3.png)

* At this moment we ensure that our ISO and the .cfg file are correctly downloadable from the web server with the following commands:
```ruby
& "c:\windows\system32\inetsrv\appcmd.exe" set config /section:staticContent /+"[fileExtension='.iso',mimeType='application/octet-stream']"
& "c:\windows\system32\inetsrv\appcmd.exe" set config /section:staticContent /+"[fileExtension='.cfg',mimeType='application/octet-stream']"
```
And we can test the functionality by doing this:<br>
![](https://www.altaro.com/vmware/wp-content/uploads/2018/05/BMAuto-4.png)

* It's necessary to have the latest version of HP Service Pack for Proliant. Once downloaded the version, we can save inside <code> C:\inetpub\deployment directory sul web server.</code>

* We need to install the cmdlets Ilo too.<br>
![](https://www.altaro.com/vmware/wp-content/uploads/2018/05/BMAuto-8-1.png)

### Use of KS file with ESXi iso
First of all, if we wanna use the KS file during the ESXi installation, it's necessary to include it in the ESXi ISO or specify the file path as launch argument. It's possible to do this also by modifying directly the ISO or by using a TFTP server to give the KS file.
You will find how to recreate the ISO on Windows and later how to do the same on Linux.

### Mod of ESXi ISO
* Mount the ESXi ISO on your computer.
* Copy the file ks.cfg on ISO root folder.
* Modify the launch file(boot.cfg or isolinux.cfg for example) to add the path to ks.cfg. Just add the following line:
```ruby
kernelopt=ks=cdrom:/ks.cfg
```
* Now re-create the ISO with the KS file included.

### Ricreare la ISO su Windows(script powershell disponibile in questo path)
* Download and install ascdimg: it's possible to download it from Windows ADK (Assessment and Deployment Kit).

* Mount ESXi ISO: mount the image so you can access to the content. If you're on Windows 10/11, you can simply do this by right clicking on the ISO and select "Mount"

* Copy files from mounted ISO: copy all the content to a local folder.

* Add the kickstart file(ks.cfg): copy your file ks.cfg in the root of your local folder which you copied the ISO in.

* Modify the configuration launch file: modify the boot.cfg file in the local folder to include the KS file. Open boot.cfg and add the following line with a text editor:
```ruby
kernelopt=ks=cdrom:/ks.cfg
```
* Create a new ISO: use ascdimg to create a new ISO image. Open a command prompt with administrator privilege and execute:
```ruby
oscdimg -n -m -b[Path_to_bootsector] [Path_to_ISO_files] [Output_ISO_Path]
#esempio
oscdimg -n -m -bC:\ESXi\boot\efi\boot\bootx64.efi C:\ESXi C:\ESXi-custom.iso
```

### Re-create the ISO on Linux
```ruby
mkdir /mnt/esxi
mount -o loop /path/to/esxi.iso /mnt/esxi

mkdir -p /tmp/esxi-iso
cp -r /mnt/esxi/* /tmp/esxi-iso/
umount /mnt/esxi

cp /path/to/ks.cfg /tmp/esxi-iso/
# Modify the configuration launch file: modify the boot.cfg file inside the folder /tmp/esxi-iso to include the KS file. Open boot.cfg with a text editor and add the following line:
kernelopt=ks=cdrom:/ks.cfg

mkisofs -o /path/to/esxi-custom.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -R -V "ESXi Custom" /tmp/esxi-iso
```

<b>How to do with Server TFTP</b><br>
If you have a TFTP server, you can put the KS file there and just launch installation with a specific URL:
```ruby
kernelopt=ks=http://yourserver/path/to/ks.cfg
```
### Order of execution of scripts.
* mod-iso.ps1 (using ks.cfg as argument)
* esxi-iso-deploy.ps1 to launch the deploy process.

