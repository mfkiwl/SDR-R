# Install VBox Additions
**NOTE** The following is specifically instructions for the Debian Linux distribution. 
If you're using Ubuntu or Mint, this will maybe still work since they're based on 
Debian, but I can't promise
```bash
# Switch to root user
su
# Update APT database
apt-get update
# Then install security updates
apt-get upgrade
# Then install the following required packages for Virtualbox Guest Additions
apt-get install build-essential module-assistant
# Now configure system for building kernel modules
m-a prepare
# Do the Virtualbox thing to insert the guest additions CD
# then either cd as root into /media/cdrom1 or just navigate
# with the file explorer and open a root terminal in the directory
# Once there, run the following command
sh VBoxLinuxGuestAdditions.run
```
Pay close attention to the output, if there are any errors, try installing any/all 
of the packages in the following section (some/most should have been installed in 
the previous steps like gcc/g++/make/perl/etc.

After a reboot, you should now have a much better experience with your VM

## Want to SSH in?
If you are using Debian and wish to SSH into your guest VM from your host computer:
1. Google how to add a 2nd "host-only" adapter 
2. Do what they say here, or you may not have access to outside internet
 (https://unix.stackexchange.com/questions/37122/virtualbox-two-network-interfaces-nat-and-host-only-ones-in-a-debian-guest-on)

## God, the default terminal colors hurt my eyeballs
1. Edit -> Profile Preferences
2. In General tab, give your profile a name
3. In Colors tab, uncheck 'Use colors from system theme'
4. Under the same tab, select 'Solarized' from Built-in schemes drop down menu
5. Click ok
6. Edit -> Preferences
7. Click profiles tab, set your sexy profile as default by either deleting any other unnamed profiles, or using the drop down menu. I'm sure you can read.
8. Profit.

# Recommended Packages for Fresh Linux VM
* git
* gcc
* g++
* make
  - makefiles and whatnot
* libelf-dev
  - Required for OS class
* libqt4-dev
  - Needed for standard gui libraries
* libncurses5-dev
  - idk, cs421 prof had us install it
* libssl-dev
  - idk, cs421 prof had us install it
* perl
  - Needed for some build/compilation scripts
* pkg-config
  - idk, cs421 prof had us install it
* python and python-dev
  - 2.7 for GNU Radio, possibly 3 for other things
* pip
  - python package installer. Has loads of gnuradio libraries and is required.
  - May install via apt or [via these instructions](https://pip.pypa.io/en/stable/installing/)
* curl
  - Will be a dependency later on
* libcanberra-gtk-module
  - To suppress an error from GNU Radio

# Installing GNU Radio

Review GNU radio by reading their Wiki. I'm building it from source, but it may
suffice for you to simply install the binaries and libraries via apt. 

```bash
sudo apt-get install gnuradio
```

If you have issues with gnuradio after this form of installation... apt-get remove it, and [install it via its source](https://wiki.gnuradio.org/index.php/InstallingGRFromSource)
like I did.

## Installing GNU Radio from Source

__SIDENOTE1__

GNU Radio currently is still mostly built on old Python 2.7 and is in the process of migrating to Python 3.
Unfortunately, we're not there yet so make sure you have python and pip installed.

__SIDENOTE2__
I wrote up the following steps as I completed them, and every went perfect the first time around. Note that I am using Debian 9.5
as my base operating system. As you should be utilizing a VM... be smart about it all and take advantage of the **snapshots** 
capability that VirtualBox provides. I highly suggest creating one before starting the actual installation process at all.

1. Again, make sure you've installed python and pip. I linked to some instructions earlier, but if you're lazy 
[here they are again](https://pip.pypa.io/en/stable/installing/). Note that running get-pip.py will require root
priveleges or by specifying installing specifically to userspace with the proper '--user' flag.

2. Make sure pip is up to date before proceeding with the install
```bash
# If you previously installed pip with the --user flag,
#  You will have to do that every time you install or upgrade
#  a package you're managing via pip. For me, I would have to
#  prepend all these commands with sudo rather than using the
#  --user flag
[sudo] pip install -U pip
```

3. Using pip, we're going to install PyBOMBS. What is PyBOMBS? 
[Click here to find out more](https://www.gnuradio.org/blog/pybombs-the-what-the-how-and-the-why). 
I did a quick read through [of this](https://github.com/gnuradio/pybombs/blob/master/README.md) 
prior to installing, and there's some good stuff. All you really need to know at the moment
is that PyBOMBS is going to do all the heavy lifting for installing GNU Radio but you'll have
more time in a minute to read through it.
```bash
[sudo] pip install PyBOMBS
```

4. Once you have PyBOMBS successfully installed:
```bash
# NOTE: The installation process may go more smoothly if you allocate more than
#        two cores to your VM. If this isn't possible, then no worries.

# Apply a configuration (idk the particulars of what this really means)
pybombs auto-config
# Add the default recipes
pybombs recipes add-defaults
# Install gnuradio into your home directory ~/gr-prefix
pybombs prefix init ~/gr-prefix -a myprefix -R gnuradio-default
# Wait for last command to complete... go to the bathroom or something
# Or read the following which explains wth a prefix is
# Then if it's still working after you're done reading... leave your
#  laptop in the capstone lab or something and go to starbucks
# Seriously, it takes forever. If you see 'volk' being downloaded or built,
#  then you're on your last leg of the install
```
  - So what the heck is a prefix? Welp, it's the directory into which packages are installed.
  It may be `~/gr-prefix` like we specified in that last command, but it can be anything really.
  It should reside in your home directory so that it's easy to find and doesn't require admin
  rights to modify. Other developers out there may have multiple prefixes for their projects or w/e
  but we should be able to get by with just one. 
  - Prefixes require a configuration directory to function properly.
  Typically, it is called `.pybombs/` and is a subdirectory of the prefix.
  So, if your prefix is `~/gr-prefix`, there will be a directory called
  `~/gr-prefix/.pybombs/` containing special files. The two most important
  files are the inventory file (inventory.yml) and the prefix-local
  configuration file (config.yml), but it can also contain recipe files
  that are specific to this prefix.
  - Note that I'm not pulling all this info out of my ass, but putting it here for the lazy people
  who didn't click on [the previous link that I'm so kindly linking again](https://github.com/gnuradio/pybombs/blob/master/README.md)

5. Now you can run gnuradio-companion in one of two ways:
  - First set up the environment dictated by the packages installed into your prefix directory, and then run gnuradio-companion
  ```bash
  source ~/gr-prefix/setup_env.sh
  gnuradio-companion
  ```
  - Or use pybombs which I assume defaults to the default prefix which we specified earlier. I don't personally do it this way
  ```bash
  pybombs run gnuradio-companion
  ```
6. You have now installed the base gnuradio package from source!

