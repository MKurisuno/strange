# 
# Ubuntu 24.10 
# 
# 
#                  for kurisuno
#                  2024.12.02 
# 
# 
  dot.early-init.el
  dot.init.el
  dot.zshrc
  dot.gitconfig


# for firewall
  ufw

# for Virus
   sudo apt install clamav  clamav-daemon
   mkdir .clamav
   mkdir .clamav/history
   chmod 755 scan.sh
   ---.clamav/scan.sh --- 
   	#!/bin/bash
       	    /usr/bin/clamscan \
            -i \
            -r $HOME \
            --log="$HOME/.clamav/history/$(date +\%Y\%m\%d\.%H\%M\%S).log" \
            2>/dev/null
    --- end of scan.sh ---

# crontab 
  crontab -e
  # m h dom mon dow command 
  0 10 * * * /home/kurisuno/.clamav/scan.sh


#Default Editor
 sudo update-alternatives --config editor



# bash switch to zsh
  MKurisuno/strange.git  dot.zshrc
      zinit
	zsh-syntax-hightlight
	zsh-autosuggestions
	zsh-completion
   	dracula/zsh


# emacs 
   Set up for c,c++mode using lsp-mode.
   MKurisuno/strange.git
	dot.early-init.el (require dracula-theme)
	dot.init.el
   only  dracula-theme(github:dracula/emacs) needs manual install
   another packages would be installed at start-up emacs with Leaf.


# git 
   MKurisuno/strange.git  dot.gitconfig

# gnome-terminal
   https://draculatheme.com/gnome-terminal



# Disable bluetooth service
  sudo systemctl disable bluetooth.service
  
# Disable printer service
  sudo systemctl stop cups.service
  sudo systemctl disable cups.service
  


# Wifi pawer-save-mode off
 sudo iwconfig
 sudo iwconfig wlp3s0 power off

 sudo emacs /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
  # File to be place under /etc/NetworkManager/conf.d
   [connection]
  # Values are 0 (use default), 1 (ignore/don't touch), 2 (disable) or 3 (enable).
   wifi.powersave = 2

