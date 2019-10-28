#version=F31

# Configure installation method
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-31&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f31&arch=x86_64" --cost=0 --install
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-31&arch=x86_64" --includepkgs=rpmfusion-free-release --install
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-31&arch=x86_64" --cost=0 --install
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-31&arch=x86_64" --includepkgs=rpmfusion-nonfree-release --install
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-31&arch=x86_64" --cost=0 --install
repo --name=negativo17 --baseurl="https://negativo17.org/repos/nvidia/fedora-31/x86_64/" --install
repo --name=google-chrome --baseurl="http://dl.google.com/linux/chrome/rpm/stable/x86_64" --install
repo --name=RPMFusionforFedora31Freetainted --mirrorlist="https://mirrors.rpmfusion.org/metalink?repo=free-fedora-tainted-31&arch=x86_64" --install
repo --name=RPMFusionforFedora31Nonfreetainted --mirrorlist="https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-tainted-31&arch=x86_64" --install
repo --name=dracut-crypt-ssh --baseurl="https://copr-be.cloud.fedoraproject.org/results/rbu/dracut-crypt-ssh/fedora-31-x86_64/" --install
repo --name=keybase --baseurl="http://prerelease.keybase.io/rpm/x86_64" --install
repo --name=Riot --baseurl="https://copr-be.cloud.fedoraproject.org/results/taw/Riot/fedora-31-x86_64/" --install

# Use graphical install
graphical
# Keyboard layouts
keyboard --xlayouts='us (mac)','de (mac)' --switch=grp:alt_shift_toggle
# System language
lang de_DE.UTF-8

# Network information
network  --bootproto=dhcp --device=enp3s0 --ipv6=auto --activate
network  --hostname=localhost.localdomain
# Root password
# rootpw --iscrypted PASSWD
# X Window System configuration information
xconfig  --startxonboot
# Run the Setup Agent on first boot
firstboot --enable
# System services
services --enabled="chronyd"
# System timezone
timezone Europe/Berlin --isUtc --ntpservers=0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org
# user --groups=wheel --name=fedora --password=PASSWD --iscrypted --gecos="fedora"
# Disk partitioning information
# DELETED

%packages
@^workstation-product-environment
@admin-tools
@development-tools
@editors
@libreoffice
@office
@sound-and-video
@system-tools
akmod-VirtualBox
alacarte
audacity
autoconf
autofs
automake
backintime-qt
baobab
bijiben
blivet-gui
cachefilesd
calibre
clementine
cockpit
cockpit-composer
cockpit-dashboard
cockpit-machines
cockpit-networkmanager
cockpit-packagekit
cockpit-storaged
cockpit-system
colordiff
darktable
diffuse
digikam
distribution-gpg-keys
dnf-plugin-system-upgrade
evince
fdupes
fedora-release-workstation
filezilla
firefox
ffmpeg
flatpak
freerdp
fslint
gedit
gimp
git-all
gnome-calendar
gnome-clocks
gnome-contacts
gnome-maps
gnome-online-accounts
gnome-terminal
gnome-todo
gnome-tweaks
gnome-usage
gnome-weather
gparted
# Unsolved Dependencies
# gstreamer*
gthumb
HandBrake
HandBrake-gui
htop
icedtea-web
iftop
inkscape
java-openjdk
keepassxc
kernel-devel
keybase
langpacks-de
langpacks-en
libgnome-keyring
libimobiledevice-utils
libreoffice
libtool
libvirt
mesa*
neofetch
nextcloud-client
nmap
# Error in POSTIN scriptlet in rpm package nvidia-kmod-common
# nvidia-driver
# nvidia-settings
ocl-icd
octave
opencl-*
openshot
openshot-lang
p7zip
p7zip-gui
p7zip-plugins
pam-u2f
pamu2fcfg
postgresql-server
powertop
qemu
remmina
R
riot
screenfetch
simplescreenrecorder
testdisk
# Too much RPMs for testing
# texlive-scheme-full
# texworks
thunderbird
thunderbird-enigmail
transmission
vim-enhanced
VirtualBox
virtualbox-guest-additions
virtualbox-guest-additions-ogl
virt-manager
vlc
vulkan*
xrdp
youtube-dl

%end


%addon com_redhat_kdump --disable --reserve-mb='128'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

# Reboot After Installation
reboot --eject
