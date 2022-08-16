# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
   nix.extraOptions = ''
      experimental-features = nix-command
   '';
   }

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
	canTouchEfiVariables = true;
	efiSysMountPoint = "/boot/efi";
};
  boot.loader.grub = {
	configurationLimit = 5;
};
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  #gnome customization
    dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + .etc/nixos/wallpaper.png;
    };
  networking.hostName = "nixos"; # Define your hostname.
  
  #
 # # #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.utf8";
    LC_IDENTIFICATION = "fr_FR.utf8";
    LC_MEASUREMENT = "fr_FR.utf8";
    LC_MONETARY = "fr_FR.utf8";
    LC_NAME = "fr_FR.utf8";
    LC_NUMERIC = "fr_FR.utf8";
    LC_PAPER = "fr_FR.utf8";
    LC_TELEPHONE = "fr_FR.utf8";
    LC_TIME = "fr_FR.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
  [org.gnome.desktop.peripherals.touchpad]
  click-method='default'
'';
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixusr = {
    isNormalUser = true;
    description = "nixusr";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
 #terminal 
	vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  	wget
	gotop
	apg
	openssl
	lf
	tree
#internet
	chromium
	librewolf	
	w3m
	liferea
#hobbies
	steam
	airshipper
	taisei
	zsnes
	pcsxr
	pcsx2
	hakuneko
#fun
	neofetch
	sl
	cowsay
	cmatrix
	lolcat
	fortune
#programing
	vscode
	notepad-next
	electron
	git
	go
	gnumake
	cmake
	ekam
#infra-as-code
	docker
	docker-compose
	ansible
	terraform
#network
	wireshark
	nmap
#content
	vlc
	clementine
	kodi
	libreoffice
	ddrescue
#creativity
	noisetorch
	lmms
	krita
	obs-studio
	kdenlive
	librecad
	gnome.gnome-tweaks
#security
	bacula
	veracrypt
	keepass
    pass
	clamav
#hacking
	burpsuite
	metasploit
	john
	wifite2
#privacy
	tor
	tor-browser-bundle-bin
	wireguard-go
	openvpn
#files
	zip
	unzip
	tmux
];

environment.interactiveShellInit = ''
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls -a -h -l --color=auto'
alias lsg='ls | grep'
alias lsf='ls -a -h -l *.*'
alias lsl='ls -lhFA | less'
alias lsu='lsusb'
alias udev='udevadm monitor --udev'
alias lsd='ls | lolcat'
# network
alias gg='ping google.com'
alias localhost='w3m localhost'
alias dnsup='savepoint ; cd ~/Documents/docker/pihole ; sudo docker-compose up -d ; returnsave'
alias dnsdown='savepoint ; cd ~/Documents/docker/pihole ; sudo docker-compose down ; returnsave'
alias resolvup='sudo systemctl enable systemd-resolved ; sudo systemctl start systemd-resolved ; sudo systemctl restart systemd-resolved '
alias resolvdown='sudo systemctl disable systemd-resolved ; sudo systemctl stop systemd-resolved sudo systemctl restart systemd-resolved'
alias piup='resolvdown ; dnsup '
alias pidown='dnsdown ; resolvup'
alias p8='ping -w 3 8.8.8.8'
alias pnmap='sudo nmap -sn 192.168.0.0/24'
alias wireshark='sudo wireshark &'
alias pubip='curl ip.me'
alias privip='ip addr | grep 192.168 ; ip addr | grep 10.' 
alias workip='ip addr | grep 10.' 
alias homeip='ip addr | grep 192.168' 
alias www='w3m'
alias toron='systemctl start tor.service'
alias toroff='systemctl stop tor.service'
alias toren='systemctl enable tor.service'
alias tordis='systemctl disable tor.service'
alias torrest='systemctl restart tor.service'
alias serve='python -m SimpleHTTPServer'
alias ports='sudo netstat -tulanp'
alias sshweb='ssh root@lesueurclement.com'
# files
alias savepoint='pwd > ~/.path && echo path saved to $(pwd)'
alias returnsave='cd $(cat ~/.path) && echo path returned to $(pwd)'
alias cd1='cd ..'
alias cd2='cd ../..'
alias cd3='cd ../../..'
alias cd4='cd ../../../..'
alias cd5='cd ../../../../..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd......='cd ../../../../..'
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../../..'
alias .1='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias cp='echo jeffreyepstein ; sudo cp -d -r'
alias mkdir='mkdir -v'
alias mkcd='mkdircd(){ mkdir $1; cd $1; }; mkdircd'
alias cdls='cdls(){ cd $1; ls; }; cdls'
alias cdrm='cdrm(){ cd ..; rm $1; }; cdrm'
alias catg='catg(){ cat $1 | grep $2; }; catg'
alias bak='backup(){ cp $1 $1.bak }; backup'
alias snipe='snipe(){ savepoint ; cd $1 ; rm $2 ; returnsave }; smipe'
alias cx='chmod +x'
alias rm='sudo rm -I -v -d -r'
alias ariska='if [ -f "$1" ]; then
echo "File exists"
else
echo "File does not exist"
fi'
alias ndir='
if [ -d "$1" ]
then
echo "Directory exist"
else
`mkdir $1`
echo "$1 created"
fi'
alias mv='mv -f -v'
alias whereami='pwd'
# docker
alias docekr='sudo docker'
alias dockr='sudo docker'
alias doker='sudo docker'
alias dokcer='sudo docker'
alias docker='sudo docker'
alias docke='sudo docker'
alias dco='docker-compose'
alias dcou='docker-compose up'
alias dcod='docker-compose down'
alias dcoud='docker-compose up -d'
alias dockercompose='sudo docker-compose'
alias docker-compose='sudo docker-compose'
alias dockercomp='sudo docker-compose'
alias dcomp='sudo docker-compose'
alias dcor='dcod ; dcoud'
alias dl="sudo docker ps -l -q"
alias dps="sudo docker ps"
alias di="sudo docker images"
alias dip="sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dkd="sudo docker run -d -P"
alias dki="sudo docker run -i -t -P"
alias dex="sudo docker exec -i -t"
alias drmf='sudo docker stop $(sudo docker ps -a -q) && sudo docker rm $(sudo docker ps -a -q)'
#kubernetes
alias k="kubectl"
alias ka="kubectl apply -f"
alias kpa="kubectl patch -f"
alias ked="kubectl edit"
alias ksc="kubectl scale"
alias kex="kubectl exec -i -t"
alias kg="kubectl get"
alias kga="kubectl get all"
alias kgall="kubectl get all --all-namespaces"
alias kinfo="kubectl cluster-info"
alias kdesc="kubectl describe"
alias ktp="kubectl top"
alias klo="kubectl logs -f"
alias kn="kubectl get nodes"
alias kpv="kubectl get pv"
alias kpvc="kubectl get pvc"
#nix
alias nixe="sudo vim /etc/nixos/configuration.nix"
alias nixs="sudo nixos-rebuild switch"
alias nixwtf="man configuration.nix"
alias nixmaj="sudo nix upgrade-nix"
# fun
alias unix='cowsay -f gnu "Unix is love, Unix is life" | lolcat'
alias apple='cowsay -f sheep "I love macos" | lolcat'
alias cowquote='fortune | cowsay | lolcat'
alias map='telnet mapscii.me'
alias countryroad='cd ~'
alias oneko='oneko &'
alias zsnes='cd ~/Downloads/rom ; zsnes &'
alias tableflip="echo '(°□°)︵ ━' | lolcat"
alias tabledown="echo '─ノ( º _ ºノ)'"
alias fuck=tableflip
alias shit=tableflip
alias animation='docker ps ; savepoint ; gotop ; cd ~ ; pwd ; cd / ; pwd ; ls ; unix ; apple ; cowquote ; sl ; p8 ; tree ; piup ; pidown ; fizzbuzz ; neofetch ; traceroute 8.8.8.8 ; curl wttr.in/Paris ; curl wttr.in/Tokyo ; curl wttr.in/Newyork ; cp ; fuck ; aptu ; cmatrix ; map ; returnsave ; quotec'
alias weather='weather(){ curl wttr.in/$1 }; weather'
alias quotec='while (true) ; do cowquote & sleep 7 ; done'
alias lmfao='echo lmfao | lolcat'
alias nethack='telnet nethack.alt.org'
alias lol='tableflip ; tabledown'
alias funky='funky(){ echo $1 | lolcat }; funky'
alias dealwithit="echo '(•_•)' ; echo '( •_•)>⌐■-■' ; echo '(⌐■_■)' ; sleep 1 ; echo '(▀̿Ĺ̯▀̿ ̿)'"
# simplify
alias sd='sudo'
alias cls='clear'
alias please='sudo'
alias pls='sudo'
alias aptu='sudo apt update ; sudo apt upgrade -y ; sudo apt full-upgrade - y; sudo apt autoremove -y ; sudo remove --purge -y ; sudo apt clean ; sudo apt autoclean'
alias asearch='sudo apt search'
alias areinstall='sudo apt reinstall'
alias sys='sudo systemctl'
alias ainstall='sudo apt install -y'
alias aremove='sudo apt remove -y'
alias bye='sudo poweroff'
alias brb='sudo reboot'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias killn='pkill'
alias gerp='grep'
alias uso='sudo'
alias ps='ps auxf'
alias top='gotop'
alias tgz='tar -zxvf'
alias tbz='tar -jxvf'
alias pdw='pwd'
alias vi='sudo vim'
alias s='sudo '
alias yd='youtube-dl'
alias q='exit'
alias vim='sudo vim'
alias again='!:0 !:*'
alias againn='for i in {1...$1} do
again
done' 
alias fck='sudo !!'
alias fcks='!!:s/'
alias fckn='fckn(){ sudo !-$1 }; smipe'
# troubleshoot
alias hisg='history | grep'
alias aliase='vim ~/.bashrc'
alias aliasg='alias | grep'
alias aliasl='alias | less'
alias his='history'
alias hisv='vim ~/.bash_history'
alias crone='sudo vim /etc/crontab'
alias totalusage='df -hl --total | grep total'
alias most='du -hsx * | sort -rh | head -10'
# video
alias listvideos='ls | egrep -i $VIDEO_TYPE | sort -h'
alias listvideosR='find . | egrep -i $VIDEO_TYPE | sort -h'
alias playvideos='listvideos | xargs -d "\n" mpv'
alias playvideosr='listvideos | sort -R | xargs -d "\n" mpv'
alias playvideosR='listvideosR | xargs -d "\n" mpv'
alias playvideosRr='listvideosR| sort -R | xargs -d "\n" mpv'
# git
alias gap='git add --patch'
alias gd='git diff'
alias gca='git commit -a'
alias gc='git clone'
alias gco='git commit'
alias gp='git push'
alias gb='git branch'
alias gs='git status'
#everyday stuff
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias spa='/home/workpad/spa/SPA/spa.sh'
alias bashv='bash --version'
# interview question
alias fizzbuzz='for i in {1..100}; do
    echo -n "$i"
    
    if (( i % 3 == 0 )); then # or if (( i / 3 * 3 == i )); then
        echo -ne "\\rFizz"
        three="1"
	sleep 1
    fi
    
    if (( i % 5 == 0 )); then
        if (( three )); then
            echo -ne "Buzz"
        else
            echo -ne "\\rBuzz"
        fi
	sleep 1
    fi
    
    echo
    
    three=""
done'
'';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  #allow docker deamon to run
  virtualisation.docker.enable = true;
  
  programs.gnupg.agent = {
  enable = true;
  pinentryFlavor = "gnome3";
    };
  
  #launch PI Hole when starting the computer
  xsession = {
      enable = true;
      profileExtra =
        ''
          ${pkgs.docker-compose}/bin/docker-compose up /etc/nixos/docker-compose.yml
        '';
    };
    
  #shut down the computer after an hour of inactivity
  imports = [
  (fetchTarball "https://github.com/samuela/nixos-idle-shutdown/tarball/main")
  ];
  
  #veloren
  environment.systemPackages = [
    pkgs.airshipper    
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
