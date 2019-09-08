
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --lockdown-on
firewall-cmd --zone=drop --permanent --add-icmp-block=destination-unreachable
firewall-cmd --set-default-zone=drop
firewall-cmd --complete-reload
firewall-cmd --permanent --direct --get-all-rules
firewall-cmd --direct --get-all-rules
firewall-cmd --list-all
sleep 3s
systemctl restart selinux-basics.service
sestatus
sleep 3s
systemctl disable chronyd.service
systemctl disable cups.service
systemctl disable bluetooth.service
systemctl disable nfs-client.target
systemctl disable nfs-convert.service
systemctl disable qemu-guest-agent.service
systemctl disable spice-vdagentd.socket
systemctl disable vboxservice.service
systemctl disable sshd
systemctl stop sshd
systemctl daemon-reload

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add fedora oci+https://registry.fedoraproject.org
flatpak remote-add --from org.mozilla.FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo

dnf upgrade -y
dnf install zsh toolbox cockpit gnome-tweaks tilix rofi unclutter git htop w3m-img xfce4-power-manager rsync chromium feh neovim ranger bleachbit surf newsboat feh mupdf tuned prename youtube-dl -y
