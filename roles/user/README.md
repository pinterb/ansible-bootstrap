# bootrap user 

This role creates a user that is used for Ansible configuration & deployment tasks.

## role variables

|name|description|default|
|----|-----------|-------|
|`bootstrap_user`|the deployment user name|deploy|
|`bootstrap_uid`|the uid of the deployment user|2000|
|`bootstrap_create_home`|should a home directory be created? yes or no|yes|
|`bootstrap_group`|the deployment user's group|deploy|
|`bootstrap_gid`|the gid of the deployment user's group|2000|
|`bootstrap_password`|the encryped password for the deployment user|$1$VKxa37iq$ON5pHixkhiic1S0M99.J.. (ie bit3m3)|
|`bootstrap_install_public_keys`|do you want any ssh public keys installed?|True|
|`bootstrap_install_private_key`|do you want a ssh private key installed?|False|
|`bootstrap_private_key`|the name of the private key to be installed|id_rsa|
|`bootstrap_allow_root_ssh`|should root user be allowed ssh access?|False|

## user password 

The Ansible user module requires an encypted password.  To generate a crypted password find your self a
Linux server and execute the following command:

    openssl passwd -salt VKxa37iq78 -1 bit3m3

Note: Obviously you should use your own salt and password values. Duh.

## role files

Very important!! If you want to use ssh key pairs for remote access, you'll need to create a ssh key pair.  
These keys should be located under this role's files sub-directory.  Please follow these [instructions](https://github.com/pinterb/ansible-bootstrap/blob/master/roles/user/files/README.md).

## role dependencies

N/A
