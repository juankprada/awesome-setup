# This is my Super Awesome Environment Setup

If you are copying this make sure to replace the content inside `.ssh` with your own `ansible-vault` encrypted keys.

## Warning

***These scripts have only been tested in Fedora Linux***
It should be very easy to make it work on other Linux distributions if you know how to define the right ansible tasks
to install packages with your distro's package manager.

## Disclaimer

I am not an ansible expert. In fact this is my first ansible script that does more than just install a few packages.
I assume no responsibility for how you may use this script.

# How to run

clone this repo and run:

`ansible-playbook awesome-setup.yml --ask-become-pass --ask-vault-pass`

You will be prompted for `sudo` password and for the right password to decrypt ssh keys (not provided for obvious reasons)
