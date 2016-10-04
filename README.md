#openwrt-collectd-plc
This is a statistics-plugin for powerlan devices (also called "Power line communication" (plc),powerlan, dLan, HomePlug).  
It is written for the collectd-deamon used by the luci-statistics-application in openwrt.  

It uses the amprate-tool from the open-plc-utils from Qualcom Atheros for the atheros-chipset (used by TP-Link,devolo, and more)  
More Informatione about the open-plc-tools https://github.com/qca/open-plc-utils and compatible chipset.  
The following steps edit some dangerous files. Please backup your configuration.  


##Step1.1
Install packages if not allready installed with Openwrt WebUI:
```
sudo
luci-app-statistics
collectd-mod-exec

```

##Step1.2
Due to an dependency failure in the package you have to install the following package
by commandline.  
login with ssh and install it with the following command
```
opkg install --force-depends open-plc-utils-amprate

```

##Step2.1
The collectd-service that is used by luci-statistics, did not allow plugins with root-access.  
but amprate only work with root-access.  
As a workaround we create a unprivileged user with a seperate group  
Add the following line in the file /etc/group  
If the id 300 is allready defined, please change it  
```
plc:x:300:

```

##Step2.2
Add the following line in the file /etc/shadow  
The id 300 should be the same than the group-id  
```
plc:x:300:0:root:/root:/bin/ash

```

##Step2.3
Create a user   
Add the following line in the file /etc/shadow  
```
plc:x:0:0:99999:7:::

```

##Step2.4
Grant root access for the amprate-tool  
Be careful to add the following line to the file /etc/sudoer. Copy/Paste is OK.  
if you make it wrong, yo cannot log in anymore  
Alternative you can use the visudo-editor (you have to install it seperately)  
```
plc ALL=(root) NOPASSWD: /usr/bin/amprate

```

##Step3
Add the following collectd-datatypes to the file /usr/share/collectd/types.db  
```
plc_RX			value:GAUGE:0:4294967295
plc_TX			value:GAUGE:0:4294967295

```

##Step4
Copy the diagram-definition-file   
"exec.lua" to /usr/lib/lua/luci/statistics/rrdtool/definitions/  

##Step5
Copy the pugin-file to collect the data   
"plc_exec.sh" to /usr/lib/collectd/

##Step6
Make the plugin-file executable  
```
chmod +x /usr/lib/collectd/plc_exec.sh

```

##Step7
In Router WebUI goto   
Statistics / Collectd / System plugins / Exec  
and add click on the Add-button in the "Add command for reading values"-section.  
Fill in the following data:  

Script with network-interface "br-lan" as parameter.  
if your plc-devices is reachable over a different interface (like eth0 or eth1) please change   
```
/usr/lib/collectd/plc_exec.sh br-lan
```

User:
```
plc
```

Group:
```
plc
```

After that click "Add & Apply" at the bottom of the page  
![Exec-Settings](https://raw.githubusercontent.com/oweitman/openwrt-collectd-plc/master/pic/openwrt-collectd-plc-settings.png)

<a href="https://raw.githubusercontent.com/oweitman/openwrt-collectd-plc/master/pic/openwrt-collectd-plc-settings.png" target="_blank">
<img src="https://raw.githubusercontent.com/oweitman/openwrt-collectd-plc/master/pic/openwrt-collectd-plc-settings.png" alt="Exec-Settings" style="max-width:100%;"width="50%" height=%50%">
</a>
