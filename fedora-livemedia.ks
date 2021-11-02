#version=F35
# X Window System configuration information
xconfig  --startxonboot
# Keyboard layouts
keyboard --xlayouts='us (mac)','de (mac)'

# System timezone
timezone Europe/Berlin
# System language
lang de_DE.UTF-8
# Firewall configuration
firewall --enabled --service=mdns
url --url="https://dl.fedoraproject.org/pub/fedora/linux/development/35/Everything/x86_64/os/"
# Network information
network  --bootproto=dhcp --device=link --activate

# URLs and REPOs
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-35&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f35&arch=x86_64" --cost=0
# RPMFusion Free
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-35&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-35&arch=x86_64" --cost=0
repo --name=rpmfusion-free-tainted --mirrorlist="https://mirrors.rpmfusion.org/metalink?repo=free-fedora-tainted-35&arch=x86_64"
# RPMFusion NonFree
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-35&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-35&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree-tainted --mirrorlist="https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-tainted-35&arch=x86_64"

# SELinux configuration
selinux --permissive

# System services
services --enabled="NetworkManager,ModemManager,sshd"

# livemedia-creator modifications.
shutdown
# System bootloader configuration
bootloader --location=none
# Clear blank disks or all existing partitions
clearpart --all --initlabel
# rootpw rootme
# Disk partitioning information
reqpart
part / --size=27000

%post
# FIXME: it'd be better to get this installed from a package
cat > /etc/rc.d/init.d/livesys << EOF
#!/bin/bash
#
# live: Init script for live image
#
# chkconfig: 345 00 99
# description: Init script for live image.
### BEGIN INIT INFO
# X-Start-Before: display-manager
### END INIT INFO

. /etc/init.d/functions

if ! strstr "\`cat /proc/cmdline\`" rd.live.image || [ "\$1" != "start" ]; then
    exit 0
fi

if [ -e /.liveimg-configured ] ; then
    configdone=1
fi

exists() {
    which \$1 >/dev/null 2>&1 || return
    \$*
}

livedir="LiveOS"
for arg in \`cat /proc/cmdline\` ; do
  if [ "\${arg##rd.live.dir=}" != "\${arg}" ]; then
    livedir=\${arg##rd.live.dir=}
    return
  fi
  if [ "\${arg##live_dir=}" != "\${arg}" ]; then
    livedir=\${arg##live_dir=}
    return
  fi
done

# enable swaps unless requested otherwise
swaps=\`blkid -t TYPE=swap -o device\`
if ! strstr "\`cat /proc/cmdline\`" noswap && [ -n "\$swaps" ] ; then
  for s in \$swaps ; do
    action "Enabling swap partition \$s" swapon \$s
  done
fi
if ! strstr "\`cat /proc/cmdline\`" noswap && [ -f /run/initramfs/live/\${livedir}/swap.img ] ; then
  action "Enabling swap file" swapon /run/initramfs/live/\${livedir}/swap.img
fi

mountPersistentHome() {
  # support label/uuid
  if [ "\${homedev##LABEL=}" != "\${homedev}" -o "\${homedev##UUID=}" != "\${homedev}" ]; then
    homedev=\`/sbin/blkid -o device -t "\$homedev"\`
  fi

  # if we're given a file rather than a blockdev, loopback it
  if [ "\${homedev##mtd}" != "\${homedev}" ]; then
    # mtd devs don't have a block device but get magic-mounted with -t jffs2
    mountopts="-t jffs2"
  elif [ ! -b "\$homedev" ]; then
    loopdev=\`losetup -f\`
    if [ "\${homedev##/run/initramfs/live}" != "\${homedev}" ]; then
      action "Remounting live store r/w" mount -o remount,rw /run/initramfs/live
    fi
    losetup \$loopdev \$homedev
    homedev=\$loopdev
  fi

  # if it's encrypted, we need to unlock it
  if [ "\$(/sbin/blkid -s TYPE -o value \$homedev 2>/dev/null)" = "crypto_LUKS" ]; then
    echo
    echo "Setting up encrypted /home device"
    plymouth ask-for-password --command="cryptsetup luksOpen \$homedev EncHome"
    homedev=/dev/mapper/EncHome
  fi

  # and finally do the mount
  mount \$mountopts \$homedev /home
  # if we have /home under what's passed for persistent home, then
  # we should make that the real /home.  useful for mtd device on olpc
  if [ -d /home/home ]; then mount --bind /home/home /home ; fi
  [ -x /sbin/restorecon ] && /sbin/restorecon /home
  if [ -d /home/liveuser ]; then USERADDARGS="-M" ; fi
}

findPersistentHome() {
  for arg in \`cat /proc/cmdline\` ; do
    if [ "\${arg##persistenthome=}" != "\${arg}" ]; then
      homedev=\${arg##persistenthome=}
      return
    fi
  done
}

if strstr "\`cat /proc/cmdline\`" persistenthome= ; then
  findPersistentHome
elif [ -e /run/initramfs/live/\${livedir}/home.img ]; then
  homedev=/run/initramfs/live/\${livedir}/home.img
fi

# if we have a persistent /home, then we want to go ahead and mount it
if ! strstr "\`cat /proc/cmdline\`" nopersistenthome && [ -n "\$homedev" ] ; then
  action "Mounting persistent /home" mountPersistentHome
fi

if [ -n "\$configdone" ]; then
  exit 0
fi

# add fedora user with no passwd
action "Adding live user" useradd \$USERADDARGS -c "Live System User" liveuser
passwd -d liveuser > /dev/null
usermod -aG wheel liveuser > /dev/null

# Remove root password lock
passwd -d root > /dev/null

# turn off firstboot for livecd boots
systemctl --no-reload disable firstboot-text.service 2> /dev/null || :
systemctl --no-reload disable firstboot-graphical.service 2> /dev/null || :
systemctl stop firstboot-text.service 2> /dev/null || :
systemctl stop firstboot-graphical.service 2> /dev/null || :

# don't use prelink on a running live image
sed -i 's/PRELINKING=yes/PRELINKING=no/' /etc/sysconfig/prelink &>/dev/null || :

# turn off mdmonitor by default
systemctl --no-reload disable mdmonitor.service 2> /dev/null || :
systemctl --no-reload disable mdmonitor-takeover.service 2> /dev/null || :
systemctl stop mdmonitor.service 2> /dev/null || :
systemctl stop mdmonitor-takeover.service 2> /dev/null || :

# don't enable the gnome-settings-daemon packagekit plugin
gsettings set org.gnome.software download-updates 'false' || :

# don't start cron/at as they tend to spawn things which are
# disk intensive that are painful on a live image
systemctl --no-reload disable crond.service 2> /dev/null || :
systemctl --no-reload disable atd.service 2> /dev/null || :
systemctl stop crond.service 2> /dev/null || :
systemctl stop atd.service 2> /dev/null || :

# turn off abrtd on a live image
systemctl --no-reload disable abrtd.service 2> /dev/null || :
systemctl stop abrtd.service 2> /dev/null || :

# Don't sync the system clock when running live (RHBZ #1018162)
sed -i 's/rtcsync//' /etc/chrony.conf

# Mark things as configured
touch /.liveimg-configured

# add static hostname to work around xauth bug
# https://bugzilla.redhat.com/show_bug.cgi?id=679486
echo "localhost" > /etc/hostname

EOF

# bah, hal starts way too late
cat > /etc/rc.d/init.d/livesys-late << EOF
#!/bin/bash
#
# live: Late init script for live image
#
# chkconfig: 345 99 01
# description: Late init script for live image.

. /etc/init.d/functions

if ! strstr "\`cat /proc/cmdline\`" rd.live.image || [ "\$1" != "start" ] || [ -e /.liveimg-late-configured ] ; then
    exit 0
fi

exists() {
    which \$1 >/dev/null 2>&1 || return
    \$*
}

touch /.liveimg-late-configured

# read some variables out of /proc/cmdline
for o in \`cat /proc/cmdline\` ; do
    case \$o in
    ks=*)
        ks="--kickstart=\${o#ks=}"
        ;;
    xdriver=*)
        xdriver="\${o#xdriver=}"
        ;;
    esac
done

# if liveinst or textinst is given, start anaconda
if strstr "\`cat /proc/cmdline\`" liveinst ; then
   plymouth --quit
   /usr/sbin/liveinst \$ks
fi
if strstr "\`cat /proc/cmdline\`" textinst ; then
   plymouth --quit
   /usr/sbin/liveinst --text \$ks
fi

# configure X, allowing user to override xdriver
if [ -n "\$xdriver" ]; then
   cat > /etc/X11/xorg.conf.d/00-xdriver.conf <<FOE
Section "Device"
	Identifier	"Videocard0"
	Driver	"\$xdriver"
EndSection
FOE
fi

EOF

chmod 755 /etc/rc.d/init.d/livesys
/sbin/restorecon /etc/rc.d/init.d/livesys
/sbin/chkconfig --add livesys

chmod 755 /etc/rc.d/init.d/livesys-late
/sbin/restorecon /etc/rc.d/init.d/livesys-late
/sbin/chkconfig --add livesys-late

# enable tmpfs for /tmp
systemctl enable tmp.mount

# make it so that we don't do writing to the overlay for things which
# are just tmpdirs/caches
# note https://bugzilla.redhat.com/show_bug.cgi?id=1135475
cat >> /etc/fstab << EOF
vartmp   /var/tmp    tmpfs   defaults   0  0
EOF

# work around for poor key import UI in PackageKit
rm -f /var/lib/rpm/__db*
releasever=$(rpm -q --qf '%{version}\n' --whatprovides system-release)
basearch=$(uname -i)
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
echo "Packages within this LiveCD"
rpm -qa
# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

# go ahead and pre-make the man -k cache (#455968)
/usr/bin/mandb

# make sure there aren't core files lying around
rm -f /core*

# convince readahead not to collect
# FIXME: for systemd

echo 'File created by kickstart. See systemd-update-done.service(8).' \
    | tee /etc/.updated >/var/.updated

# Remove random-seed
rm /var/lib/systemd/random-seed

# Remove the rescue kernel and image to save space
# Installation will recreate these on the target
rm -f /boot/*-rescue*
%end

%post

cat >> /etc/rc.d/init.d/livesys << EOF


# disable updates plugin
cat >> /usr/share/glib-2.0/schemas/org.gnome.software.gschema.override << FOE
[org.gnome.software]
download-updates=false
FOE

# don't autostart gnome-software session service
rm -f /etc/xdg/autostart/gnome-software-service.desktop

# disable the gnome-software shell search provider
cat >> /usr/share/gnome-shell/search-providers/org.gnome.Software-search-provider.ini << FOE
DefaultDisabled=true
FOE

# don't run gnome-initial-setup
mkdir ~liveuser/.config
touch ~liveuser/.config/gnome-initial-setup-done

# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Show harddisk install in shell dash
  sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop ""
  # need to move it to anaconda.desktop to make shell happy
  mv /usr/share/applications/liveinst.desktop /usr/share/applications/anaconda.desktop

  cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
[org.gnome.shell]
favorite-apps=['firefox.desktop', 'evolution.desktop', 'rhythmbox.desktop', 'shotwell.desktop', 'org.gnome.Nautilus.desktop', 'anaconda.desktop']
FOE

  # Make the welcome screen show up
  if [ -f /usr/share/anaconda/gnome/fedora-welcome.desktop ]; then
    mkdir -p ~liveuser/.config/autostart
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop /usr/share/applications/
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop ~liveuser/.config/autostart/
  fi

  # Copy Anaconda branding in place
  if [ -d /usr/share/lorax/product/usr/share/anaconda ]; then
    cp -a /usr/share/lorax/product/* /
  fi
fi

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# set up auto-login
cat > /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
FOE

# Turn off PackageKit-command-not-found while uninstalled
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF

%end

%post
# Repositories
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm https://prerelease.keybase.io/keybase_amd64.rpm
# Element
dnf -y copr enable taw/element && dnf -y install element
# negativo17 nvidia repository
dnf -y config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo
# Packages
dnf -y install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted --refresh
# NVIDIA
# dnf -y install nvidia-driver nvidia-settings
# Signal Desktop as Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub org.signal.Signal
# Czkawka as Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.github.qarmin.czkawka
# Portfolio Performance
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub info.portfolio_performance.PortfolioPerformance
# DBeaverCommunity
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub io.dbeaver.DBeaverCommunity
# AusweisApp2
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub de.bund.ausweisapp.ausweisapp2
# WhatsAppQT
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub io.bit3.WhatsAppQT
# Zoom
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub us.zoom.Zoom
# Jabref
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub org.jabref.jabref

# Enable nemo as file manager (default: only available under cinnamon)
sed -i '/OnlyShowIn=X-Cinnamon/I s/^/#/' /usr/share/applications/nemo.desktop
# Set nemo as default file manager
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

# dnf-automatic security upgrades
# timer configuration: /etc/systemd/system/multi-user.target.wants/dnf-automatic.timer
# echo -n '[commands]
# upgrade_type = security
# random_sleep = 0
# download_updates = yes
# apply_updates = yes

# [emitters]
# emit_via = stdio

# [email]
# email_from = dnf@localhost
# email_to = root@localhost
# email_host = localhost

# [command]

# [command_email]
# email_from = dnf@localhost
# email_to = root@localhost

# [base]
# debuglevel = 1' > /etc/dnf/automatic.conf;
# systemctl enable --now dnf-automatic.timer

# usbguard configuration #
# usbguard generate-policy > rules.conf
# cp rules.conf /etc/usbguard/rules.conf
# chmod 0600 /etc/usbguard/rules.conf
# edit configuration #
# vim /etc/usbguard/usbguard-daemon.conf
# systemctl enable --now usbguard
# enable notifier for user #
# systemctl enable --now --user usbguard-notifier.service

# For every user who wants to use Syncthing.
# systemctl enable --now syncthing@USER.service

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
dnf -y install code
%end

%packages
@anaconda-tools
@base-x
@core
@firefox
@fonts
@guest-desktop-agents
@hardware-support
@libreoffice
@multimedia
@networkmanager-submodules
@printing
@workstation-product

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

gnome-terminal
anaconda
anaconda-live
dracut-config-generic
dracut-live
glibc-all-langpacks
kernel
# Make sure that DNF doesn't pull in debug kernel to satisfy kmod() requires
kernel-modules
kernel-modules-extra
memtest86+
syslinux
-@dial-up
-@input-methods
-@standard
-gfs2-utils
-reiserfs-utils

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
nemo                     # File manager with more options than nautilus. Fork of nautilus.
nemo-audio-tab           # Audio tag information extension for Nemo
nemo-compare             # Context menu comparison extension for nemo
nemo-extensions          # Nemo extensions library
nemo-fileroller          # File Roller extension for Nemo
nemo-preview             # A quick previewer for Nemo
nemo-python              # Python scripting extension for Nemo
nemo-seahorse            # PGP encryption and signing for Nemo
nemo-search-helpers      # Nemo search helpers
seahorse                 # A GNOME application for managing encryption keys
seahorse-nautilus      # PGP encryption and signing for nautilus
seahorse-sharing         # Sharing of PGP public keys via DNS-SD and HKP
soundconverter           # SoundConverter
# geary                  # beautiful mail client, unfortunately without PGP support so far
gnome-books            # E-Book Manager
# gnome-kiosk            # Single Application Mode for Gnome
gnome-firmware         # Install firmware on devices
gnome-maps             # Map application for GNOME
gnome-todo             # Personal task manager for GNOME
gparted                # Gnome Partition Editor

### Gnome Shell Extensions
gnome-extensions-app                        # Manage GNOME Shell extensions
gnome-shell-extension-background-logo       # Background logo extension for GNOME Shell
gnome-shell-extension-system-monitor-applet # A Gnome shell system monitor extension
gnome-shell-extension-apps-menu             # Application menu for GNOME Shell
gnome-shell-extension-dash-to-dock          # Dash to Dock
gnome-shell-extension-places-menu           # Places status menu for GNOME Shell

### Essential Tools
age                      # Simple, modern and secure encryption tool
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
marker                   # GTK3 markdown editor
neofetch                 # CLI system information tool written in Bash
screenfetch            # like neofetch, but not as nice as neofetch, but with disk usage
p7zip                    # Very high compression ratio file archiver
p7zip-plugins            # Additional plugins for p7zip
pam-u2f                  # Implements PAM authentication over U2F
pamu2fcfg                # Configures PAM authentication over U2F
pcsc-lite                # PC/SC Lite smart card framework and applications, like https://en.wikipedia.org/wiki/OpenPGP_card
reptyr                   # Attach a running process to a new terminal
terminator               # Multiple GNOME terminals in one window.
vim-enhanced             # A version of the VIM editor which includes recent enhancements
baobab                 # A graphical directory tree analyzer
distribution-gpg-keys-copr # GPG keys for Copr projects
# nextcloud-client       # The Nextcloud Client
# p7zip-gui              # 7zG - 7-Zip GUI version

### Internet
# chromium               # A WebKit (Blink) powered web browser
chromium-freeworld       # Chromium built with all freeworld codecs and VA-API support
# element                  # A decentralized, secure messaging client for collaborative group communication (Riot)
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
audacious		 # Audio Player (resource-saving)
# audacity               # Multitrack audio editor
audacity-freeworld       # Multitrack audio editor WITH mp3 support
clementine               # A music player and library organizer
digikam                  # A digital camera accessing & photo management application
kdenlive                 # Non-linear video editor
ffmpeg                   # Digital VCR and streaming server
gimp                     # GNU Image Manipulation Program
gmic-gimp                # Must have gimp plugin
gimp-heif-plugin         # A plugin for loading and saving HEIF images
gimp-jxl-plugin          # A plugin for loading and saving JPEG-XL images
gimp-lensfun             # Gimp plugin to correct lens distortion
gimp-resynthesizer       # Gimp plug-in for texture synthesis (magically repairing areas)
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
darktable                # Utility to organize and develop raw images
kid3                     # Efficient KDE ID3 tag editor
krita                    # Sketching and painting program
# openshot               # replaced by kdenlive
# openshot-lang          # replaced by kdenlive
# moc                    # replaced by audacious; music on console (needs a config-file, so run the following command) # echo "TiMidity_Config = /etc/timidity.cfg" >> .moc/config
obs-studio               # Open Broadcaster Software
picard                   # MusicBrainz-based audio tagger

### Office
evince                   # Document viewer
gnucash
dialect
virt-viewer
transmission
gnome-chess
phoronix-test-suite
gst
sysbench
libreoffice              # Free Software Productivity Suite
bijiben                  # Simple Note Viewer
calibre                  # E-book converter and library manager

### Virtualization
guestfs-tools            # Tools to access and modify virtual machine disk images
libvirt                  # Library providing a simple virtualization API
spice-gtk                # High performance VM with OpenGL
qemu                     # QEMU is a FAST! processor emulator
virt-manager             # Desktop tool for managing virtual machines via libvirt

### Backup
backintime-qt            # Qt frontend for backintime
borgbackup               # very efficient tool for encrypted, deduplicated, optionally append-only remote backups.
borgmatic                # Simple Python wrapper script for borgbackup
testdisk                 # Tool to check and undelete partition, PhotoRec recovers lost files

### Science
plantumlqeditor          # UML diagram Editor, latest plantuml version https://plantuml.com/de/download
# texlive-scheme-small     # small scheme (most used packages)
texlive-scheme-full    # full scheme (everything) # Bug psutil
# texworks               # A simple IDE for authoring TeX documents
texstudio                # A complex IDE for authoring TeX documents
tikzit                   # Diagram editor for pgf/TikZ
texlive-plantuml         # PlantUML diagrams in (Lua)LaTeX
# octave                 # A high-level language for numerical computations
# R                      # A language for data analysis and graphics

### Server
certbot                # A free, automated certificate authority client
python3-certbot-apache # The apache plugin for certbot
cockpit                # Web Console for Linux servers
# cockpit-composer       # Composer GUI for use with Cockpit
# cockpit-dashboard      # Cockpit remote server dashboard
cockpit-machines       # Cockpit user interface for virtual machines
cockpit-networkmanager # Cockpit user interface for networking, using NetworkManager
cockpit-packagekit     # Cockpit user interface for packages
cockpit-storaged       # Cockpit user interface for storage, using udisks
cockpit-system         # Cockpit admin interface package for configuring and troubleshooting a system
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
# bashtop                  # Linux resource monitor
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
brasero                # Gnome CD/DVD burning application
ddrescue               # Data recovery tool trying hard to rescue data in case of read errors
# dvdautho               # Make a disc image or burn the disc: this is left to tools like mkisofs and dvd+rw-tools
dvdisaster             # Additional error protection for CD/DVD media
k3b                    # CD/DVD/Blu-ray burning application
libaacs                  # Blu-ray AACS Library
libbdplus                # Blu-ray BD+ Library
libbluray-utils          # Blu-ray Library
# vcdimager              # VideoCD (pre-)mastering and ripping tool


# All Other
sha3sum                  # SHA3 Hash
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
tldr                     # Simplified and community-driven man pages
python3-dnf-plugin-local # Automatically copy all downloaded packages to a repository on the local filesystem and generating repo metadata.
python3-dnf-plugins-extras-snapper #
ssss                     # Shamir's secret sharing scheme
syncthing                # P2P Synchronisation (https://syncthing.net/downloads/)
usbguard               # The USBGuard software framework helps to protect your computer against rogue USB devices by implementing basic whitelisting/blacklisting capabilities based on USB device attributes.
usbguard-notifier      # Notifier for usbguard
vulkan*                  # Vulkan
# modem-manager-gui      # ModemManager GUI

# This package is needed to boot the iso on UEFI
shim
shim-ia32
grub2
grub2-efi
grub2-efi-*-cdboot
grub2-efi-ia32
efibootmgr

# no longer in @core since 2018-10, but needed for livesys script
initscripts
chkconfig

# workaround

%end
