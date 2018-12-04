## Multipath in Linux 
   1. Firstly install multipath tools
   ``sudo apt-get install multipath tools
   2. find partions available from command 
    `` fdiskk -l
   3. add wwwid number's to /etc/multipath/wwwid
   4. create multipath.conf file in /etc/multipath.comf
   `` touch /etc/multipath.conf
   5.add below lines to /etc/multipath.conf
    defaults {
    user_friendly_names yes
    path_grouping_policy multibus
    }
    6.Restart multipath service
    ``systemctl restart multipath-tools.service
    7.Now binding files should be created in /etc/multipath/bindings
    8.To check the status of multipath 
     ''ls -l /dev/mapper
     ``multipath -ll
     