#!/usr/env/bin bash
# Abundance of caution.
# Prevent Apt doing anything funky during a long build.
systemctl stop apt-daily.timer;
systemctl stop apt-daily-upgrade.timer;
systemctl disable apt-daily.timer;
systemctl disable apt-daily-upgrade.timer;
systemctl mask apt-daily.service;
systemctl mask apt-daily-upgrade.service;
systemctl daemon-reload;

# Disable periodic activities of apt to be safe
cat <<EOF >/etc/apt/apt.conf.d/10periodic;
APT::Periodic::Enable "0";
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
EOF

# Clean and nuke the package from orbit
rm -rf /var/log/unattended-upgrades;
apt-get -y purge unattended-upgrades;

echo `ps aux | grep [a]pt`

opts='--assume-yes --fix-missing --quiet --auto-remove'
pkgs='build-essential cmake gfortran libatomic1 m4 perl pkg-config python wget'
${sudo} apt-get install ${opts} ${pkgs}
