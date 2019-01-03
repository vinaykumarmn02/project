###Application to start at startup application

below shown example enables to startup application at ubuntu login

```bash

- hosts: bel
  tasks:
    - name: nevis installation
      file:
       path: /usr/share/applications/proxnevis
       state: directory
    - name: copy nevis file
      copy:
        src: /home/escomm/agent.sh
        dest: /usr/share/applications/proxnevis/agent.sh

    - name: copy agent.sh.desktop file
      copy:
        src: /home/escomm/agent.sh.desktop
        dest: /etc/xdg/autostart/agent.sh.desktop


    - name: copy illiagent file
      copy:
        src: /home/escomm/ilinagent
        dest: /usr/share/applications/proxnevis/ilinagent

    - name: set permission
      file:
        dest: /usr/share/applications/proxnevis/
        owner: root
        group: users
        recurse: yes
        mode: 01777
    - name: set permission
      file:
        dest:  /etc/xdg/autostart/agent.sh.desktop
        owner: root
        group: users

        mode: 01777

```

**NOTE**:Nevis is the application which starts at each indidual login.