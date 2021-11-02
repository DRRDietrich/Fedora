# Fedora 35

Kickstart installation of Fedora 35 with useful packages and RPMFusion, negativo17 nvidia, dracut-crypt-ssh, keybase and element repositories.

### Download Fedora netinst ISO

https://download.fedoraproject.org/pub/fedora/linux/releases/35/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-35-1.2.iso

### Download `Fedora Productivity`

This is a custom Fedora Workstation livemedia containing all packages of the kickstart file. You can use it to try Fedora or to install it on your computer or a VM.

[https://smart-tux.de/files/Fedora-Productivity-35.iso](https://smart-tux.de/files/Fedora-Productivity-35.iso)[^1]

[^1]: SHA3-256: 2d913dd0c7eda5c4 f9b2e4d8a23841d9 f587c083aca5191e 7b22c68ba6d96295

### Grub Options

Press `e`, `Strg + e` or `Tab` to edit the grub options and append the following option:

inst.ks=https://raw.githubusercontent.com/DRRDietrich/Fedora/master/fedora.ks

Press `Strg + x` to start the installer with kickstart configuration.

### System Requirements
- 1,5 GB RAM
- 30 GB free disk space

### List of additional packages

| Name | Description |
| ---- | ----------- |
| AusweisApp2 | AusweisApp2 |
| DBeaverCommunity | Database administration software |
| HandBrake | An open-source multiplatform video transcoder |
| Jabref | Open-sourced, cross-platform citation and reference management software |
| NetworkManager-* | Network connection manager and user applications |
| Portfolio Performance | Open Source Portfolio |
| WhatsAppQT | Unofficial WhatsApp Client |
| Zoom | Zoom Meetings & Chats |
| age | Simple, modern and secure encryption tool |
| alacarte | Menu editor for the GNOME desktop |
| anaconda | Install Fedora |
| asciinema | Recording and sharing terminal sessions |
| audacious | Audio Player (resource-saving) |
| audacity-freeworld | Multitrack audio editor WITH mp3 support |
| backintime-qt | Qt frontend for backintime |
| baobab | A graphical directory tree analyzer |
| bijiben | Simple Note Viewer |
| blivet-gui | Tool for data storage configuration |
| borgbackup | very efficient tool for encrypted, deduplicated, optionally append-only remote backups |
| borgmatic | Simple Python wrapper script for borgbackup |
| brasero | Gnome CD/DVD burning application |
| calibre | E-book converter and library manager |
| certbot | A free, automated certificate authority client |
| chromium-freeworld | Chromium built with all freeworld codecs and VA-API support |
| clementine | A music player and library organizer |
| cockpit | Web Console for Linux servers |
| code | Visual Studio Code |
| czkawka | Multi functional app to find duplicates, empty folders, similar images etc. |
| darktable | Utility to organize and develop raw images |
| ddrescue | Data recovery tool trying hard to rescue data in case of read errors |
| dialect | Google Translator |
| digikam | A digital camera accessing & photo management application |
| dnf-automatic | Package manager - automated upgrades |
| dnf-plugin-system-upgrade | System Upgrade Plugin for DNF |
| dvdisaster | Additional error protection for CD/DVD media |
| element | Group Messaging |
| evince | Document viewer |
| evolution | Mail and calendar client for GNOME |
| exfat-utils | Utilities for exFAT file system |
| fdupes | Finds duplicate files in a given set of directories |
| fedora-release-workstation | Base package for Fedora Workstation-specific default configurations |
| ffmpeg | Digital VCR and streaming server |
| filezilla | FTP, FTPS and SFTP client |
| firefox | Mozilla Firefox Web browser |
| flatpak | Application deployment framework for desktop apps |
| freerdp | Free implementation of the Remote Desktop Protocol (RDP) |
| gedit | Text editor for the GNOME desktop |
| gimp | GNU Image Manipulation Program |
| git-all | Meta-package to pull in all git tools |
| gnome-books | Gnome books |
| gnome-calendar | Simple and beautiful calendar application designed to fit GNOME 3 |
| gnome-chess | Gnome chess game |
| gnome-clocks | Clock application designed for GNOME 3 |
| gnome-contacts | Contacts manager for GNOME |
| gnome-extensions-app | Manage GNOME Shell extensions |
| gnome-firmware | Gnome firmware |
| gnome-maps | Gnome maps |
| gnome-online-accounts | Single sign-on framework for GNOME |
| gnome-shell-extension-apps-menu | Application menu for GNOME Shell |
| gnome-shell-extension-background-logo | Background logo extension for GNOME Shell |
| gnome-shell-extension-dash-to-dock | Dash to Dock |
| gnome-shell-extension-places-menu | Places status menu for GNOME Shell |
| gnome-shell-extension-system-monitor-applet | A Gnome shell system monitor extension |
| gnome-terminal | Terminal emulator for GNOME |
| gnome-todo | Gnome todo |
| gnome-tweaks | Customize advanced GNOME 3 options |
| gnome-usage | A GNOME app to view information about use of system resources |
| gnome-weather | A weather application for GNOME |
| gnucash | Finance management application |
| gparted | Gnome Partition Editor |
| gst | System utility designed to stress and monitoring various hardware components |
| gstreamer1* | GStreamer streaming media framework runtime |
| gthumb | Image viewer, editor, organizer |
| guestfs-tools | Tools to access and modify virtual machine disk images |
| htop | Interactive process viewer |
| icedtea-web | Additional Java components for OpenJDK - Java Web Start implementation |
| iftop | Command line tool that displays bandwidth usage on an interface |
| inkscape | Vector-based drawing program using SVG |
| java-openjdk | Java |
| k3b | CD/DVD/Blu-ray burning application |
| kdenlive | Non-linear video editor |
| keepassxc | Cross-platform password manager |
| kid3 | Efficient KDE ID3 tag editor |
| krita | Sketching and painting program |
| libaacs | Blu-ray AACS Library |
| libbdplus | Blu-ray BD+ Library |
| libbluray-utils | Blu-ray Library |
| libgnome-keyring | Framework for managing passwords and other secrets |
| libheif | .heif, .heic support |
| libimobiledevice-utils | iOS support |
| libreoffice | Free Software Productivity Suite |
| libtool | The GNU Portable Library Tool |
| libva-intel* | VAAPI driver and tools |
| libva-utils | VAAPI driver and tools |
| libva-vdpau-driver | VAAPI driver and tools |
| libvirt | Library providing a simple virtualization API |
| marker | GTK 3 markdown editor |
| memtest86+ | Stand-alone memory tester for x86 and x86-64 computers |
| mesa* | Mesa |
| nemo | File manager with more options than nautilus. Fork of nautilus. |
| neofetch | CLI system information tool written in Bash |
| nmap | Network exploration tool and security scanner |
| nutty | Simple utility for network information |
| obs-studio | Open Broadcaster Software |
| ocl-icd | OpenCL Library (Installable Client Library) Bindings |
| opencl-* | Useful OpenCL tools and utilities |
| p7zip | Very high compression ratio file archiver |
| pam-u2f | Implements PAM authentication over U2F |
| pamu2fcfg | Implements PAM authentication over U2F |
| paperkey | OpenPGP key archiver |
| pcsc-lite | PC/SC Lite smart card framework and applications |
| phoronix-test-suite | An Automated, Open-Source Testing Framework |
| picard | MusicBrainz-based audio tagger |
| plantumlqeditor | UML diagram Editor, latest plantuml version https://plantuml.com/de/download |
| powertop | Power consumption monitor |
| python3-certbot-apache |  |
| python3-dnf-plugin-local | Automatically copy all downloaded packages to a repository on the local filesystem and generating repo metadata |
| python3-dnf-plugins-extras-snapper |  |
| qemu | QEMU is a FAST! processor emulator |
| remmina | Remote Desktop Client (For performance reasons, use `xfreerdp /rfx /gfx:RFX /u:USER /v:SERVER /multimon` instead) |
| reptyr | Attach a running process to a new terminal |
| screenfetch | like neofetch, but not as nice as neofetch, but with disk usage |
| seahorse | A GNOME application for managing encryption keys |
| sha3sum | SHA3 Hash |
| signal | Signal Messenger |
| simplescreenrecorder | Simple Screen Recorder is a screen recorder for Linux |
| snapper | btrfs snapshots |
| soundconverter | SoundConverter |
| spice-gtk | High performance VM with OpenGL |
| ssss | Shamir's secret sharing scheme |
| syncthing | P2P Synchronisation |
| sysbench | System performance benchmark |
| syslinux | Simple kernel loader which boots from a FAT filesystem |
| terminator | Multiple GNOME terminals in one window |
| testdisk | Tool to check and undelete partition, PhotoRec recovers lost files |
| texlive-plantuml | PlantUML diagrams in (Lua)LaTeX |
| texlive-scheme-small | small scheme (most used packages). Workaround for `texlive-scheme-full` |
| texstudio | A complex IDE for authoring TeX documents |
| thunderbird | Mozilla Thunderbird mail/newsgroup client |
| tikzit | Diagram editor for pgf/TikZ |
| tldr | Simplified and community-driven man pages |
| transmission | A lightweight GTK+ BitTorrent client. |
| usbguard | The USBGuard software framework helps to protect your computer against rogue USB devices by implementing basic whitelisting/blacklisting capabilities based on USB device attributes |
| vim-enhanced | A version of the VIM editor which includes recent enhancements |
| virt-manager | Desktop tool for managing virtual machines via libvirt |
| virt-viewer | Virtual Machine Viewer |
| vlc | The cross-platform open-source multimedia framework, player and server |
| vulkan* | Vulkan |
| xorgxrdp | xorgxrdp is a set of X11 modules that make Xorg act as a backend for xrdp |
| xrdp | Open source remote desktop protocol (RDP) server |
| youtube-dl| A small command-line program to download online videos |

## [Legacy Geek Code](https://media.ccc.de/v/36c3-10608-das_nutzlich-unbedenklich_spektrum#t=2600)

O++S++I+CEMV+PS++D++
