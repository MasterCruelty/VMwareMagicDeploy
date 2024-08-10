# VMwareMagicDeploy 
<br>

# What is it?

The project's purpose has the objective of create a tool to deploy automatically an entire VMware infrastructure.<br>
All of this is based on Ansible and PowerShell. I recommend a Linux machine for the vCenter deployment.<br>
The project is still under development, feel free to contribute in any way.<br>
Here you can find the vCenter instructions, for the ESXi you can find all the documentation in the other folder called <code>ESXi</code>.<br>

<b>DISCLAIMER</b><br>
This project is still under studying and development. Only the vCenter side is completely tested. So, take these information as what they are, think and read before execute anything. If you find errors or any way to improve the project, feel free to do it by sending an issue or a pull request.

## Requirements (vCenter deployment)
* Ansible
* ovftool

### Ansible installation

Just install it by python command using pip.

### ovftool installation

* Download ovftool from the Broadcom website(you need to login) [here](https://developer.broadcom.com/tools/open-virtualization-format-ovf-tool/latest)
* Execute the following commands from your terminal:
```ruby
chmod +x VMware-ovftool-4.6.2-22220919-lin.x86_64.bundle
sudo ./VMware-ovftool-4.6.2-22220919-lin.x86_64.bundle --extract ovftool && cd ovftool
ls -rtl #verify the extracted content
tree -L 2 #verify the subfolders and extracted content
sudo mv vmware-ovftool /usr/bin/
sudo chmod +x /usr/bin/vmware-ovftool/ovftool.bin
sudo chmod +x /usr/bin/vmware-ovftool/ovftool
alias ovftool=/usr/bin/vmware-ovftool/ovftool
sudo dnf install libnsl #dependence of ovftool
ovftool --version #verify you installed correctly
```


env used: CentOS 8 based machine<br>
How to launch Ansible to deploy vCenter:
```ruby
ansible-playbook -i hosts deploy_vcenter.yml -e ansible_python_interpreter=/usr/bin/python3
```
