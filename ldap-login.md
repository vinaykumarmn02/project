## Ansible playbook for LDAP based authentication in Ubuntu PC's

The below playbook gives ldap based authentication for ubuntu os login
It enables LDAP based authentication.

```bash
- hosts : bel
  tasks :  
 

   - name : remove libpam-cracklib
     apt : 
       pkg : libpam-cracklib
       state : absent 
      
    

   - name: Remove useless packages from the cache
     apt:
       autoclean: yes

   - name: Remove dependencies that are no longer required
     apt:
       autoremove: yes
    
   - name: sssd installation
     apt:
       name: sssd
       state: present
           

   - name : ssd.conf replace
     copy : 
       src : /home/escomm/sssd.conf
       dest : /etc/sssd/sssd.conf
       mode : 00600
   - name : replace common-session
     copy : 
       src : /home/escomm/common-session
       dest : /etc/pam.d/common-session

  
  
   - name : restart sssd
     command : service ssh restart
 ```
 
 **NOTE**:The above script is used in Ubuntu OS hardening,
 please fid sssd.conf file below.
 
 ```bash
 [sssd]
config_file_version = 2
debug_level = 4
reconnection_retries = 3
sbus_timeout = 30
services = nss, pam
domains = LDAP

[nss]

[pam]

[domain/LDAP]
enumerate = False
cache_credentials = True

id_provider = ldap
auth_provider = ldap
chpass_provider = ldap

ldap_uri = ldap://172.xx.xx.xx
ldap_user_search_base = dc=bel,dc=co,dc=in
ldap_tls_reqcert = never
ldap_user_gecos = sn

ldap_default_bind_dn = cn=ldapadmin,dc=bel,dc=co,dc=in
ldap_default_authtok = AAAQABRWBXXn1kQ9BadKdIgN8WwQ0l7KoltIx5p+28jyvYwe6jiCP52o6LhsY/ymOwfK0d1K2tk37m6yaOTSeSoezxYAAQIDAAA=
ldap_default_authtok_type = obfuscated_password
```

common session file is as below

```bash
#
# /etc/pam.d/common-session - session-related modules common to all services
#
# This file is included from other service-specific PAM config files,
# and should contain a list of modules that define tasks to be performed
# at the start and end of sessions of *any* kind (both interactive and
# non-interactive).
#
# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
# To take advantage of this, it is recommended that you configure any
# local modules either before or after the default block, and use
# pam-auth-update to manage selection of other modules.  See
# pam-auth-update(8) for details.

# here are the per-package modules (the "Primary" block)
session [default=1]                     pam_permit.so
# here's the fallback if no module succeeds
session requisite                       pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
session required                        pam_permit.so
# and here are more per-package modules (the "Additional" block)
session required        pam_unix.so
session optional                        pam_sss.so
session required        pam_mkhomedir.so        skel=/etc/skel/ umask=0022
session optional        pam_systemd.so
# end of pam-auth-update config
```

