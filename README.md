# Fedora

Kickstart installation of Fedora 31 with useful packages, DNSoverTLS (NextDNS.io + unbound) and RPMFusion, negativo17 nvidia, google-chrome, dracut-crypt-ssh, keybase and riot repositories.

### Download Fedora 31 netinst ISO 

https://dl.fedoraproject.org/pub/fedora/linux/releases/31/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-31-1.9.iso

### Grub Options

Press Strg + e to edit the grub options and append the following option:

inst.ks=https://raw.githubusercontent.com/DRRDietrich/Fedora/master/fedora.ks

Press Strg + x to start the installer with kickstart configuration.
