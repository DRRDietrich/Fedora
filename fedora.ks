#version=F34

# URLs and REPOs
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-34&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f34&arch=x86_64" --cost=0
# RPMFusion Free
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-34&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-34&arch=x86_64" --cost=0
repo --name=rpmfusion-free-tainted --mirrorlist="https://mirrors.rpmfusion.org/metalink?repo=free-fedora-tainted-34&arch=x86_64"
# RPMFusion NonFree
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-34&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-34&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree-tainted --mirrorlist="https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-tainted-34&arch=x86_64"
# Negativo17 NVIDIA/CUDA
repo --name=negativo17 --baseurl="https://negativo17.org/repos/nvidia/fedora-34/x86_64/"
# Secure Messenger
repo --name=element --baseurl="https://download.copr.fedorainfracloud.org/results/taw/element/fedora-33-x86_64/"

# Use graphical install
graphical
# Keyboard layouts
keyboard --xlayouts='us (mac)','de (mac)'
# System language
lang de_DE.UTF-8

# Network information
network  --bootproto=dhcp --device=enp3s0 --ipv6=auto --activate
network  --hostname=fedora34
# X Window System configuration information
# xconfig --defaultdesktop GNOME --startxonboot
# System services
services --enabled=chronyd,sshd

# System timezone
timezone Europe/Berlin --isUtc --ntpservers=0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org

# User configuration
# user --groups=wheel --name=fedora --password=PASSWD --iscrypted --gecos="fedora"
# Root password
# ``python -c 'import crypt; print(crypt.crypt("My Password", "$6$My Salt"))'``
# rootpw --iscrypted PASSWD

# SSH Keys (Ed25519 / RSA 4096)
# sshkey --username fedora "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2uNvCh4aHbk8v/Fty9inxQLpda4z7Vb16Dbn24zTfm"
# sshkey --username root "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2uNvCh4aHbk8v/Fty9inxQLpda4z7Vb16Dbn24zTfm"
# sshpw --username root --sshkey "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2uNvCh4aHbk8v/Fty9inxQLpda4z7Vb16Dbn24zTfm" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDrjDqSVdz/vearombs3vomFY+l3VwAesd2BBfQZK51BekjZJlu4Ac6I2w0adf+vXBHMJULluG0Xh21eL0PF2vWkZ6i4yXGcXd/Zdb40HWsFeryKlaWYaLdnjbXKlu9TYkLtNO6le7Oy+BepydzfkPCjepaeHtm/zi/5SxZ+sHfEzCZclf8aYH1yEMGJIMJqJ96rLxfFBmH1RZThq2F7aIObA/sNySrcDZFFOv9i7Kqohqz8kzJwiARCpThBa+jj/3qWd1VyTRk7Sgk0bcgRSZ/zbhkCYGQ5UUr8CxEggvZGvfL7GD4Fb8gUOo4kZe2r5Y6L568BPuGwdfFtN95MJ"

# SELinux is enabled, but only logs things that would be denied in enforcing mode.
# selinux --permissive
# No SELinux policy is loaded.
selinux --disabled

%packages
@workstation-product-environment
@admin-tools
@container-management
@development-tools
@editors
@gnome-desktop
@fonts
@hardware-support
@libreoffice
@office
@sound-and-video
@system-tools

### Gnome
alacarte                 # Menu editor for the GNOME desktop
evolution                # Mail and calendar client for GNOME
gedit                    # Text editor for the GNOME desktop
gnome-calendar           # Simple and beautiful calendar application designed to fit GNOME 3
gnome-clocks             # Clock application designed for GNOME 3
gnome-contacts           # Contacts manager for GNOME
gnome-online-accounts    # Single sign-on framework for GNOME
gnome-terminal           # Terminal emulator for GNOME
gnome-tweaks             # Customize advanced GNOME 3 options
gnome-usage              # A GNOME app to view information about use of system resources
gnome-weather            # A weather application for GNOME
seahorse                 # A GNOME application for managing encryption keys
seahorse-nautilus        # PGP encryption and signing for nautilus
seahorse-sharing         # Sharing of PGP public keys via DNS-SD and HKP
soundconverter           # SoundConverter
# geary                  # beautiful mail client, unfortunately without PGP support so far
# gnome-books            # E-Book Manager
# gnome-kiosk            # Single Application Mode for Gnome
# gnome-firmware         # Install firmware on devices
# gnome-maps             # Map application for GNOME
# gnome-todo             # Personal task manager for GNOME
# gparted                # Gnome Partition Editor

### Gnome Shell Extensions
gnome-extensions-app                        # Manage GNOME Shell extensions
gnome-shell-extension-background-logo       # Background logo extension for GNOME Shell
gnome-shell-extension-system-monitor-applet # A Gnome shell system monitor extension
gnome-shell-extension-apps-menu             # Application menu for GNOME Shell
gnome-shell-extension-dash-to-dock          # Dash to Dock
gnome-shell-extension-places-menu           # Places status menu for GNOME Shell

### Essential Tools
asciinema                # recording and sharing terminal sessions
blivet-gui               # Tool for data storage configuration
dbus-x11                 # necessary for nm-connection-editor
distribution-gpg-keys    # GPG keys of various Linux distributions
dnf-automatic            # Package manager - automated upgrades
dnf-plugin-system-upgrade  # System Upgrade Plugin for DNF
exfat-utils              # Utilities for exFAT file system
fdupes                   # Finds duplicate files in a given set of directories
fedora-release-workstation # Base package for Fedora Workstation-specific default configurations
flatpak                  # Application deployment framework for desktop apps
keepassxc                # Cross-platform password manager
langpacks-de             # German langpacks meta-package
langpacks-en             # English langpacks meta-package
libgnome-keyring         # Framework for managing passwords and other secrets
libheif                  # .heif, .heic support
libimobiledevice-utils   # iOS support
neofetch                 # CLI system information tool written in Bash
# screenfetch            # like neofetch, but not as nice as neofetch, but with disk usage
p7zip                    # Very high compression ratio file archiver
p7zip-plugins            # Additional plugins for p7zip
pam-u2f                  # Implements PAM authentication over U2F
pamu2fcfg                # Configures PAM authentication over U2F
pcsc-lite                # PC/SC Lite smart card framework and applications, like https://en.wikipedia.org/wiki/OpenPGP_card
reptyr                   # Attach a running process to a new terminal
terminator               # Multiple GNOME terminals in one window.
vim-enhanced             # A version of the VIM editor which includes recent enhancements
# baobab                 # A graphical directory tree analyzer
# distribution-gpg-keys-copr # GPG keys for Copr projects
# nextcloud-client       # The Nextcloud Client
# p7zip-gui              # 7zG - 7-Zip GUI version

### Internet
# chromium               # A WebKit (Blink) powered web browser
chromium-freeworld       # Chromium built with all freeworld codecs and VA-API support
element                  # A decentralized, secure messaging client for collaborative group communication (Riot)
filezilla                # FTP, FTPS and SFTP client
firefox                  # Mozilla Firefox Web browser
freerdp                  # Free implementation of the Remote Desktop Protocol (RDP)
remmina                  # Remote Desktop Client (For performance reasons, use `xfreerdp /rfx /gfx:RFX /u:USER /v:SERVER /multimon` instead)
thunderbird              # Mozilla Thunderbird mail/newsgroup client
xrdp                     # Open source remote desktop protocol (RDP) server
xorgxrdp                 # xorgxrdp is a set of X11 modules that make Xorg act as a backend for xrdp.
# keybase                # The Keybase Go client, filesystem, and GUI
# transmission           # A lightweight GTK+ BitTorrent client. Does anyone still use torrents?

### Multimedia
# audacity               # Multitrack audio editor
audacity-freeworld       # Multitrack audio editor WITH mp3 support
clementine               # A music player and library organizer
digikam                  # A digital camera accessing & photo management application
kdenlive                 # Non-linear video editor
ffmpeg                   # Digital VCR and streaming server
gimp                     # GNU Image Manipulation Program
gstreamer1*              # Issue 3 # GStreamer streaming media framework runtime
gthumb                   # Image viewer, editor, organizer
HandBrake                # An open-source multiplatform video transcoder
HandBrake-gui            # HandBrake GUI
inkscape                 # Vector-based drawing program using SVG
simplescreenrecorder     # Simple Screen Recorder is a screen recorder for Linux
vlc                      # The cross-platform open-source multimedia framework, player and server
youtube-dl               # A small command-line program to download online videos
# chromaprint-tools      # Chromaprint audio fingerprinting tools
# gydl                   # GUI wrapper around youtube-dl program
# darktable              # Utility to organize and develop raw images
# kid3                   # Efficient KDE ID3 tag editor
# krita                  # Sketching and painting program
# openshot               # replaced by kdenlive
# openshot-lang          # replaced by kdenlive
# moc                    # music on console (needs a config-file, so run the following command) # echo "TiMidity_Config = /etc/timidity.cfg" >> .moc/config
# obs-studio             # Open Broadcaster Software
# picard                 # MusicBrainz-based audio tagger

### Office
evince                   # Document viewer
libreoffice              # Free Software Productivity Suite
# bijiben                # Simple Note Viewer
# calibre                # E-book converter and library manager

### Virtualization
libvirt                  # Library providing a simple virtualization API
spice-gtk                # High performance VM with OpenGL
qemu                     # QEMU is a FAST! processor emulator
virt-manager             # Desktop tool for managing virtual machines via libvirt

### Backup
backintime-qt            # Qt frontend for backintime
borgbackup               # very efficient tool for encrypted, deduplicated, optionally append-only remote backups.
borgmatic                # Simple Python wrapper script for borgbackup
# testdisk               # Tool to check and undelete partition, PhotoRec recovers lost files

### Science
plantumlqeditor          # UML diagram Editor, latest plantuml version https://plantuml.com/de/download
texlive-scheme-small     # small scheme (most used packages)
# texlive-scheme-full    # full scheme (everything)
# texworks               # A simple IDE for authoring TeX documents
texstudio                # A complex IDE for authoring TeX documents
tikzit                   # Diagram editor for pgf/TikZ
texlive-plantuml         # PlantUML diagrams in (Lua)LaTeX
# octave                 # A high-level language for numerical computations
# R                      # A language for data analysis and graphics

### Server
# certbot                # A free, automated certificate authority client
# python3-certbot-apache # The apache plugin for certbot
# cockpit                # Web Console for Linux servers
# cockpit-composer       # Composer GUI for use with Cockpit
# cockpit-dashboard      # Cockpit remote server dashboard
# cockpit-machines       # Cockpit user interface for virtual machines
# cockpit-networkmanager # Cockpit user interface for networking, using NetworkManager
# cockpit-packagekit     # Cockpit user interface for packages
# cockpit-storaged       # Cockpit user interface for storage, using udisks
# cockpit-system         # Cockpit admin interface package for configuring and troubleshooting a system
# postgresql-server      # PostgreSQL server

### Development
git-all                  # Meta-package to pull in all git tools
# autoconf               # A GNU tool for automatically configuring source code
# autofs                 # autofs daemon
# automake               # A GNU tool for automatically creating Makefiles
# cachefilesd            # CacheFiles user-space management daemon
# colordiff              # Color terminal highlighter for diff files
# diffuse                # Graphical tool for merging and comparing text files

### Monitoring
bashtop                  # Linux resource monitor
htop                     # Interactive process viewer
iftop                    # Command line tool that displays bandwidth usage on an interface
powertop                 # Power consumption monitor
nmap                     # Network exploration tool and security scanner
nutty                    # Simple utility for network information
# etherape               # Graphical network monitor for Unix
# netdata                # PCP Monitoring on localhost:19999, https://github.com/netdata/netdata
# nethogs                # Network-Monitoring
# stacer                 # Linux System Optimizer and Monitor

### CD/DVD/BD
# brasero                # Gnome CD/DVD burning application
# ddrescue               # Data recovery tool trying hard to rescue data in case of read errors
# dvdautho               # Make a disc image or burn the disc: this is left to tools like mkisofs and dvd+rw-tools
# dvdisaster             # Additional error protection for CD/DVD media
# k3b                    # CD/DVD/Blu-ray burning application
libaacs                  # Blu-ray AACS Library
libbdplus                # Blu-ray BD+ Library
libbluray-utils          # Blu-ray Library
# vcdimager              # VideoCD (pre-)mastering and ripping tool


# All Other
icedtea-web              # Additional Java components for OpenJDK - Java Web Start implementation
java-openjdk             # Java
libtool                  # The GNU Portable Library Tool
libva-intel*             # VAAPI driver and tools
libva-utils              # VAAPI driver and tools
libva-vdpau-driver       # VAAPI driver and tools
mesa*                    # Mesa
NetworkManager-*         # Network connection manager and user applications
ocl-icd                  # OpenCL Library (Installable Client Library) Bindings
opencl-*                 # Useful OpenCL tools and utilities
paperkey                 # OpenPGP key archiver
snapper                  # btrfs snapshots (https://dustymabe.com/2019/01/06/fedora-btrfs-snapper---the-fedora-29-edition/)
python3-dnf-plugin-local # Automatically copy all downloaded packages to a repository on the local filesystem and generating repo metadata.
python3-dnf-plugins-extras-snapper #
ssss                     # Shamir's secret sharing scheme
syncthing                # P2P Synchronisation (https://syncthing.net/downloads/)
vulkan*                  # Vulkan
# modem-manager-gui      # ModemManager GUI

%end

%addon com_redhat_kdump --disable --reserve-mb='128'

%end

%anaconda
# --minquality does not seem to work
pwpolicy root --minlen=10 --minquality=50 --strict --notempty --nochanges
pwpolicy user --minlen=8  --minquality=30 --strict --notempty --nochanges
pwpolicy luks --minlen=10 --minquality=50 --strict --notempty --nochanges
%end

%post
# Repositories
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm https://prerelease.keybase.io/keybase_amd64.rpm
# Element
dnf -y copr enable taw/element
# negativo17 nvidia repository
dnf config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo
# Packages
dnf -y install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted --refresh
# NVIDIA
dnf -y install nvidia-driver nvidia-settings
# Signal Desktop as Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub org.signal.Signal
# Czkawka as Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y com.github.qarmin.czkawka

# dnf-automatic security upgrades
# timer configuration: /etc/systemd/system/multi-user.target.wants/dnf-automatic.timer
echo -n '[commands]
upgrade_type = security
random_sleep = 0
download_updates = yes
apply_updates = yes

[emitters]
emit_via = stdio

[email]
email_from = dnf@localhost
email_to = root@localhost
email_host = localhost

[command]

[command_email]
email_from = dnf@localhost
email_to = root@localhost

[base]
debuglevel = 1' > /etc/dnf/automatic.conf;
systemctl enable --now dnf-automatic.timer

# For every user who wants to use Syncthing.
# systemctl enable --now syncthing@USER.service
%end

# Reboot After Installation
reboot --eject
