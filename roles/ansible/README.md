# bootrap ansible 

This role installs [Ansible](http://www.ansible.com/).  Depending on how you plan on using Ansible, you'll
use this role to install on a single control server (centralized management) or on each remote server.

## role variables

|name|description|default|
|----|-----------|-------|
|`z_ansible_repo:`|the location of the Ansible git repository|https://github.com/ansible/ansible.git|
|`z_ansible_update_from_remote`|if yes, repository will be updated using the supplied remote|yes|
|`z_ansible_version`|what version of the repository to check out|HEAD|
|`z_ansible_install_dir`|directory where ansible will be installed|/usr/local|
|`z_ansible_user`|the user owning the ansible installation|root|

## role dependencies

N/A
