# Files for Creating a 'deployment' User 

## SSH Public/Private Keys

If you're going centralize configuration managment you'll need to bootstrap a
control server and some remote servers.  Once all these servers are indeed
bootstrap'd, remote configuration will be performed over good ol' ssh.

Like pretty much any other automated, remote Linux operation, this task is 
best accomplished with a pair of public/private ssh keys.

### Keypair Generation

On your local Linux machine, generate a RSA key pair. The default key directory
is "~/.ssh". But for purposes of this exercise, you can create your key pair
from inside this directory. 

The following command creates a standard 1024-bit RSA keypair:

    # ssh-keygen -t rsa -f private_key/id_rsa

### Key Location

Assuming you created your key pair in the private_key sub-directory, your work is
mostly done.  All you need to do is move the public key to the public_keys directory. 

    # cp private_key/id_rsa.pub public_keys/deploy.pub

It doesn't really matter what you name your public key as long as if follows the
*.pub naming convention.  All *.pub files in the public_keys directory get copied
to the server's authorized keys file.

If you did not create your key pair in the private_key sub-directory, be sure to
move the private key there as well.

### Note

This repo is set up to ignore any id_rsa or id_dsa files.  If you use a 
different naming convention, be sure to update the .gitignore file.  We don't
want ssh keys in this repository.
