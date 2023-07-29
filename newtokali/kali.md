# How to install a new OS in your computer?
Before we talk that, try to think this:  
How many steps does it take to put an elephant to refrigerator need?  
- First, you must makesure what OS do you want.
- Second, you need some hardware.
- Third, get the software in right place.
- Fourth, just install it!
## Why install kali?
Why I need kali? not ubuntu or centos, unix, even windows and so on...  
There are many reasons:  
  - Wsl don't have a good graphicalinterface!  
  - A dream for hacker!
  - Want to be powerful in computer field!
  - ~~For the fuck job~~
  - ...
## Hardware!
A 'U' disk! You need a USB flash disk.  
A Computer! You have it, right?  
## Software!
An Image of your OS!
And don't download it in anywhere expect Official web.([kali](https://www.kali.org/) is here!)  
Now here comes a problem, there are so many different image in web, which image is what I need to download? What should I do next? Who can help me! SOS!  
Calm down, please! Don't worry about it, each developers of OS want users to use their OS!  
So, they will teach you how to choose them!  
For example, in kali, you can click the button called "DOCUMENTATION" next to the DOWNLOAD, then you will come into a new world, you can get everything about kali! In this world, I advise you read "Introduction" firstly!  
Then you will find "Which Image Should I Download?"  
For myself, I need to search another thing in official web due to I want to install dual system.  
So I can find another message called "Dual Booting Kali with Windows" about dual system in "Installation"!  
Accroding to the message, I need two types Image, Live and Installer.  
That's all! But,is it really so?  
No! You also need a software to do this "Burn your image file to the USB drive you have prepared"! The software called "rufus".([Rufus](http://rufus.ie/downloads/) is here!)  
## Install!
1. use rufus to burn the live to U disk.
2. reboot your computer. choose live(amd64)
3. open the Gparted, devide the unallocated space to kali.
4. exit the live, reboot to the windows reburn the installer to U disk
5. reboot your computer and choose installer
6. then you can follow the official installation requirements of kali ([Installing Kali Linux](https://www.kali.org/docs/installation/hard-disk-install/) is here!)

# FAQ
## Q1: secure boot
when I reboot for the first time, I find there haven't apperanced the panel about choosing which OS to boot.
So I reboot again and press F2 (different computer has different key) to get into bios, then you can find secure boot in it, set its option to disabled.  
## Q2: split disk space
when I use Gparted to split disk space, I find that the space belongs to windows is bitlocked, I can't change by Gparted!  
So I split disk space in windows, to get unallocated space.
