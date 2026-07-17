# 
# Ubuntu 26.04.10 
# 

### for kurisuno
### since 2024.12.02 
### update 2026.06.27 

## files 
dot.early-init.el  
dot.init.el  
dot.zshrc  
dot.gitconfig  
src-hilite-lesspipe.sh  
esc256.outlang  
src-hilite-lesspipe.sh  

## Japanese directory name exchange to English
 $ LANG=C xdg-user-dirs-gtk-update
 

## NVIDIA RTX3060
 Check the Kernel to recognize GPU.  
  $ lspci | grep -i nvidia  

 Check nvidia-gpu driver avairable.  
  $ sudo ubuntu-drivers list  
  $ sudo apt update  
  $ sudo apt upgrade  
  $ sudo reboot  
  
 Auto install nvidia-driver.  
  $ sudo ubuntu-drivers install  
  $ sudo reboot  
 Check GPU driver exactly loaded.   
  $ nvidia-smi  


## for firewall  
  gufw for ufw  
   $ sudo apt install -y gufw  


## for Virus  
   $ sudo apt install clamav  clamav-daemon  
   $ mkdir .clamav  
   $ mkdir .clamav/history  
   $ chmod 755 scan.sh  
   ---.clamav/scan.sh ---   
   	#!/bin/bash  
       	    /usr/bin/clamscan \  
            -i \  
            -r $HOME \  
            --log="$HOME/.clamav/history/$(date +\%Y\%m\%d\.%H\%M\%S).log" \  
            2>/dev/null  
    --- end of scan.sh ---  

### crontab   
  $ crontab -e  
  0 10 * * * $HOME/.clamav/scan.sh  


##  Default Editor
 $ sudo update-alternatives --config editor  



## bash switch to zsh
  To change login-shell   
  $chsh -s /usr/bin/zsh  
  To change terminal shell  
     Instead of SHELL to load custum command    
     custum command is  /usr/bin/zsh   
  ---dot.zshrc---  
      zinit  
	zsh-syntax-hightlight  
	zsh-autosuggestions  
	zsh-completion  
   	dracula/zsh   

## emacs 
   init.el    
   eraly-init.el  
   For drucura-theme  
       $ ln -s duracura-theme-**/dracura-theme.el  .emacs.d/themes/dracura-theme.el 

## gnu-source-highlight
  download from 
         ftp://ftp.gnu.org/gnu/src-highlite     
    install  ~/.source-hightlight/   
  src-hilite-lesspipe.sh ---> ~/bin/      
  esc256.outlang         ---> .source-highlight/  
  custom.style           ---> .source-highlight/    


## Clangd 
  ~/.config/clangd/config.yaml  


## git 
   MKurisuno/strange.git  dot.gitconfig   


## gnome-terminal
  https://draculatheme.com/gnome-terminal  


##  Disable bluetooth service
  $ sudo systemctl disable bluetooth.service  
  
##  Disable printer service  
  $ sudo systemctl stop cups.service  
  $ sudo systemctl disable cups.service  
  


##  Wifi pawer-save-mode off
 $ sudo emacs /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf  
   File to be place under /etc/NetworkManager/conf.d   
   [connection]  
   Values are 0 (use default),  
   1 (ignore/don't touch),  
   2 (disable) or  
   3 (enable).  
   wifi.powersave = 2  



