# ansible-bootstrap

Make servers Ansible-ready

## First 5 Minutes on a Server (with Ansible)

Before you can use Ansible (or any other automated config management tool) on a new server you'll need to perform some
basic configuration.

To get some idea of what I'm talking about, search for [First 5 Minutes on a Server with Ansible](https://www.google.com/webhp?source=search_app#q=First+5+Minutes+on+a+Server+(with+Ansible)&safe=active) for some background.

## Goals

* Your configuration management is performed centrally by an Ansible control server.
* Set up a new remote server so that an Ansible control server can easily manage it.
* Make the bootstrap process [Vagrant](http://www.vagrantup.com)-friendly.

## Set up

It should be no surprise that Ansible is used here.  Ansible playbooks perform the lion's share
of the bootstrap process. How you plan on using Ansible AFTER the bootstrap will determine which
bootstrap playbooks you'll need to configure.

### remote.yml

You should always need to configure this playbook.  At a minimum you'll want to change the deployment
user's password.  Most of the other [user](https://github.com/pinterb/ansible-bootstrap/tree/master/roles/user) configuration options 
are related to how you plan on using ssh keys. 

If you're not using a control server to perform centralized management, you'll probably need to install
Ansible on your remote servers.  This means you'll need to include the Ansible [role](https://github.com/pinterb/ansible-bootstrap/tree/master/roles/ansible)
in this playbook.

### control.yml

This playbook is only required if you're using a control server for centralized management. If you are using
a control server then this playbook is the yang to remote.yml's ying.

### ssh.yml

This playbook is only required if you're using a control server and you want totally hands-free automation.
The use case that comes to mind is when you're using Vagrant in a continuous integration environment.

This playbook simply logs onto each remote server.  And if you're going to use this playbook you'll need
to update it with the address information for every remote server from your inventory file(s).

### bootstrap.sh

Once you have your Ansible playbooks configured, this is the script you'll excecute to make things happen.

Currently there are four options that can be set with this script:

    --ansible-repo=https://github.com/ansible/ansible.git
    --server-type=control OR remote
    --verbose
    --vagrant-env
