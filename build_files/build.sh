#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Add Librewolf repo
curl -fsSL https://repo.librewolf.net/librewolf.repo > /etc/yum.repos.d/librewolf.repo

COPR_REPOS=(
yalter/niri
ublue-os/packages
secureblue/bubblejail
)

PACKAGES=(
NetworkManager-tui
bubblejail
librewolf
niri
greetd
gtkgreet
cage
labwc
fastfetch
alacritty
fish
ublue-brew
neovim
)

for i in ${COPR_REPOS[@]}; do
  dnf -y copr enable $i
done

dnf5 -y install ${PACKAGES[@]}

# SELinux breaks tdm unfortunately
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# Enable tdm
systemctl enable tdm

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File
systemctl enable podman.socket
