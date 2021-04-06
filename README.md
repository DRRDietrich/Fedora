# Fedora 34

Kickstart installation of Fedora 34 with useful packages and RPMFusion, negativo17 nvidia, dracut-crypt-ssh, keybase and element repositories.

### Download Fedora 34 netinst ISO

https://ftp-stud.hs-esslingen.de/pub/fedora/linux/releases/test/34_Beta/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-34_Beta-1.3.iso

### Grub Options

Press `e` or `Strg + e` to edit the grub options and append the following option:

inst.ks=https://raw.githubusercontent.com/DRRDietrich/Fedora/F34-Nvidia/fedora.ks

Press `Strg + x` to start the installer with kickstart configuration.

### System Requirements
- 1,5 GB RAM
- 18 GB free disk space
- 4,3 GB to download (3,4 GB for 3068 PRMs + 900 MB for post-installation scripts) (As of today: 2021-02-12)

## Legacy Geek Code

O++S++I+CEMV+PS++D++
