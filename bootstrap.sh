#!/usr/bin/env bash

ANSIBLE_INSTALL_DIR=/tmp
ANSIBLE_HOME=$ANSIBLE_INSTALL_DIR/ansible
ANSIBLE_REPO=https://github.com/ansible/ansible.git

function usage()
{
    echo ""
    echo -e "Blue/Green Ansible bootstrap"
    echo ""
    echo -e "./bootstrap.sh"
    echo -e "\t-h --help"
    echo -e "\t--ansible-repo=$ANSIBLE_REPO"
    echo -e "\t--server-type=control OR remote"
    echo -e "\t--verbose"
    echo -e "\t--vagrant-env"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --ansible-repo)
            ANSIBLE_REPO=$VALUE
            ;;
        --server-type)
            SERVER_TYPE=$VALUE
            ;;
        --verbose)
            VERBOSE="--verbose"
            ;;
        --vagrant-env)
            VAGRANT="vagrant-env"
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

if [ -z "$SERVER_TYPE" ]; then
   usage
   exit 1
elif [ "$SERVER_TYPE" != "control" ] && [ "$SERVER_TYPE" != "remote" ]; then
   usage
   exit 1
fi

# Grab some Linux distro info
if [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
elif [ -f /etc/debian_version ]; then
    OS=Debian 
elif [ -f /etc/redhat-release ]; then
    OS=RedHat
else
    OS=$(uname -s)
fi

# Currently, only supporting RedHat/CentOS
if [ "$OS" != "RedHat" ]; then 
   echo "This script only supports RedHat distro's" 1>&2
   exit 1
fi

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!" 1>&2
   exit 1
fi

echo ""
echo "#######################################"
echo "# Install RedHat's Ansible dependencies"
echo "#######################################"
echo ""
yum -y install git python-devel python-setuptools libdevel
easy_install pip
pip install PyYAML paramiko jinja2 httplib2

# save current script directory
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
echo "SCRIPT DIR: $SCRIPTPATH"

echo ""
echo "#######################################"
echo "# Clone Ansible"
echo "#######################################"
echo ""
if [ ! -d "$ANSIBLE_INSTALL_DIR" ]; then
   mkdir -p $ANSIBLE_INSTALL_DIR
fi

git clone $ANSIBLE_REPO $ANSIBLE_HOME

if [ ! -d "$ANSIBLE_HOME" ]; then
   echo "Git clone of ansible seems to have failed!" 1>&2
   exit 1
fi

echo ""
echo "#######################################"
echo "# Install Ansible"
echo "#######################################"
echo ""
source $ANSIBLE_HOME/hacking/env-setup
ANSIBLE_CMD=`which ansible-playbook`

if [ -z "$ANSIBLE_CMD" ]; then
   echo "Ansible failed to install" 1>&2
   exit 1
fi

echo ""
echo "#######################################"
echo "# Finally, bootstrap this server"
echo "#######################################"
echo ""
cd $SCRIPTPATH
[ -z $VERBOSE ] && verbose="" || verbose=$VERBOSE

if [ "$SERVER_TYPE" == "control" ]; then
   $ANSIBLE_CMD -i control/hosts.ini control.yml --connection=local $verbose 

  # If we're running from Vagrant, we can do some more "auto-magic" things 
  if [ -n "$VAGRANT" ]; then
      # perform initial ssh login to remote servers 
      $ANSIBLE_CMD -i control/hosts.ini ssh.yml --connection=local $verbose

      # as vagrant user, provision all remote servers 
      su - vagrant -c "$ANSIBLE_CMD -i /vagrant/vagrant/hosts.ini /vagrant/site.yml $verbose"
  fi
else
   $ANSIBLE_CMD -i remote/hosts.ini remote.yml --connection=local $verbose
fi

echo ""
echo "#######################################"
echo "# Clean up"
echo "#######################################"
echo ""
rm -rf $ANSIBLE_HOME 
