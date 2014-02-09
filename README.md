# ansible-bootstrap

Make servers Ansible-ready

## First 5 Minutes on a Server (with Ansible)

Before you can use Ansible (or any other automated config management tool) on a new server you'll need to perform some
basic configuration.

To get some idea of what I'm talking about, search for _[First 5 Minutes on a Server (with Ansible)](https://www.google.com/webhp?source=search_app#q=First+5+Minutes+on+a+Server+(with+Ansible)&safe=active)_ for some background.

## Goals

* Your configuration management is performed centrally by an Ansible control server.
* Set up a new remote server so that an Ansible control server can easily manage it.
* Make the bootstrap process [Vagrant](http://www.vagrantup.com)-friendly.
