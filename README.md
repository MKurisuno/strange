# 
## Ubuntu 26.04.10 
# 

#### for kurisuno
#### 　　　　　　　　　　　　　　　　　since 2024.12.02 
#### 　　　　　　　　　　　　　　　　　last update 2026.11.27
　　  
　　  

### file administration with stow 
　　　zsh emacs clangd   
　　　$stow -t $HOME xxx  

## Japanese directory name exchange to English
　　 $ LANG=C xdg-user-dirs-gtk-update


## NVIDIA RTX3060
　　　 1)Check the Kernel to recognize GPU.  
　　　　$ lspci | grep -i nvidia  

　　　 2)Check nvidia-gpu driver avairable.  
　　　　$ sudo ubuntu-drivers list  
　　　　$ sudo apt update  
　　　　$ sudo apt upgrade  
　　　　$ sudo reboot  

　　 3)Auto install nvidia-driver.  
　　　　$ sudo ubuntu-drivers install  
　　　　$ sudo reboot  
　　 4)Check GPU driver exactly loaded.   
　　　　$ nvidia-smi  


## Firewall
#### 　gufw for ufw  
　　　　$ sudo apt install -y gufw  


## for Virus
　　　　   $ sudo apt install clamav clamav-daemon  
　　　　   $ mkdir .clamav  
　　　　   $ mkdir .clamav/history  
　　　　　 edit ~/.clamav/scan.sh   
　　　　　　#/bin/bash  
　　　　　　　/usr/bin/clamscan -i -r $HOME --log="$HOME/.clamav/history/$(date +%Y%m%d.%H%M%S).log”  2>/dev/null   
　　　　   $ chmod 755 ~/clamav/scan.sh  

## crontab
　　　　  $ crontab -e  
　　　　　  0 10 * * * $HOME/.clamav/scan.sh  


##  Default Editor
　　　　$ sudo update-alternatives --config editor  


## bash switch to zsh
　　　To change login-shell   
　　　　$chsh -s /usr/bin/zsh  
　　　To change terminal shell  
　　　Instead of SHELL to load custum command    
　　　.zshrc auto install next package  
　　　　　zinit  
　　　　　zsh-syntax-hightlight  
　　　　　zsh-autosuggestions  
　　　　　zsh-completion  
　　　　　dracula/zsh   


## emacs  
　　　Version > 30.1.50.  
　　　-Set up used by EMACS-build.txt.-  
　　　　  init.el    
　　　　  eraly-init.el  

## ~~gnu-source-highlight~~
　~~download~~ ~~from~~ ftp://ftp.gnu.org/gnu/src-highlite.    
　~~src-hilite-lesspipe.sh~~　  
　~~esc256.outlang~~　  
　~~custom.style~~　  
#### ---> apt install bat (which will be installed as /usr/bin/batcat)

## gnome-terminal
　　　　<https://draculatheme.com/gnome-terminal>  

## alacritty
　　　Dracua theme Download <https://github.com/dracula/alacritty/archive/master.zip>   
　　　Install to  ~/.config/alacrity/themes/dracula   
　　　　$echo  "general.import = ["/path/to/dracula.toml"]"  > ~/.config/alacritty/alacritty.toml  
　　  
　　　　or terminal_setting/alacritty.toml in this Repository.  

## kitty
　　　Kitty theme Download <https://github.com/dracula/kitty/archive/master.zip>  
　　　　 $cp dracula.conf diff.conf ~/config/kitty  
　　　　 $echo "include dracula.conf" >> ~/.config/kitty/kitty.conf  
　　  
　　　　or terminal_setting/kitty.conf in this Repository.  

## python3 environment
　　　Activate virtual environment.  
　　　　 $ mkdir ~/.Apliris  
　　　　 $ python3 -m venv .Aprilis  
　　　　 $ source .Aprilis/bin/active

##  Disable bluetooth service
　　　  $ sudo systemctl disable bluetooth.service  

##  Disable printer service  
　　　  $ sudo systemctl stop cups.service  
　　　  $ sudo systemctl disable cups.service  

##  Wifi pawer-save-mode off
#### if wifi is unstable
　　$ sudo emacs /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf  
　　　File to be place under /etc/NetworkManager/conf.d   
　　　[connection]  
　　　Values are 0 (use default),  
　　　1) (ignore/don't touch)    
　　　2) (disable)   
　　　3) (enable)   
　　　　wifi.powersave = 2  

## Emacs eglot LanguageServer
### - C/C++ LanguageServer : Clangd 
　　Download clang and clangd from  <https://apt.llvm.org/#llvmsh>   
　　　clangd and config files are installed in   
　　　　~/.config/clangd/config.yaml    
　　　　{project}/.clangd    
　　　　{project}/.clang-tidy    
　　　　{project}/.clang-format   

### Node.js to install 
　　Install Node.js  
　　　　 $sudo apt update  
　　　　 $sudo apt install -y curl ca-certificates  
　　　　 $curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -  
　　　　 $sudo apt install -y nodejs  

### - PHP_LanguageServer: Intelephense
　　無償版はformatter機能が無効なのでフォーマットはapheleia  
　　1) Install Intelephense  
　　　　$sudo npm install -g intelephense  
　　2) Insert those at eglot block in initi.el  
　　　　(add-to-list 'eglot-server-programs '(php-ts-mode .("intelephense" "--stdio")))  

### - PHP_LanguageServer: PHPactor
　　[PHPactor]	<https://phpactor.readthedocs.io/en/master/usage/standalone.html>  
	
	
### - Python_LanguageServer:Pyright
　　1) Install pyright  
　　　　$sudo npm install -g pyright  
　　2) Insert at eglot block in init.el  
　　　　(add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio")))  

### - TypeScript_JavaScript_LanguageServer
　　1) install  
　　　　$sudo npm install -g typescript-language-server typescript@6  
　　2) Insert those at eglot block in init.el  
　　　　(add-to-list 'eglot-server-programs '((typescript-ts-mode) . ("typescript-language-server" "--stdio")))  
　　　　(add-to-list 'eglot-server-programs '((tsx-ts-mode) . ("typescript-language-server" "--stdio")))  
　　　　(add-to-list 'eglot-server-programs '((js-ts-mode) . ("typescript-language-server" "--stdio")))  

### - HTML LanguageServer:vscode-langservers-extracted
　　1) install  
　　　　$sudo npm install -g vscode-langservers-extracted  
　　2) Insert next at wglot block in init.el.     
　　　　(add-to-list 'eglot-server-programs '((web-mode) . ("vscode-html-language-server" "--stdio")))  


## Apheleia
### -Python-
　　1) Install ruff  
　　　　$pip install -U ruff  
　　2) Insert next at Apeleia block in init.el.  
　　　　(setf (alist-get 'python-ts-mode apheleia-mode-alist) '(ruff-isort ruff))    

### -PHP- 
　　1) Install php-cs-fixer  
　　　　$cd Project-Root  
　　　　$composer require --dev friendsofphp/php-cs-fixer  
　　2) Insert next at Apheleia block   
　　　　php-cs-fixerは標準関数では無いので、apheleia-formattersに登録が必要。ついでにオプションを追加。  
　　　　(setf (alist-get 'php-cs-fixer apheleia-formatters)  
　　　　　　'("php-cs-fixer" "fix" "--quiet" "--no-interaction" "--using-cache=no" file))  
　　　　(setf (alist-get 'php-ts-mode apheleia-mode-alist) 'php-cs-fixer)  
	
### -Typescript- -Java-Script- ...
　　1) Install Prettir  
　　　　$sudo  npm i -g prettier  
　　2) Inset next at Apheleia block in init.el.  
　　　　(setf (alist-get 'typescript-ts-mode aphele ia-mode-alist) 'prettier)  
　　　　(setf (alist-get 'json-ts-mode apheleia-mode-alist) 'prettier)  


