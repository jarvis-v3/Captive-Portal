#!/bin/bash

# Persiapan
echo "Memperbarui paket dan menginstal dependensi..."
if ! sudo apt update && sudo apt install -y dnsmasq hostapd apache2; then
    echo "Terjadi kesalahan saat menginstal paket. Mohon periksa koneksi internet Anda atau coba lagi nanti."
    exit 1
fi

# Konfigurasi dnsmasq
echo "Mengonfigurasi dnsmasq..."
if ! sudo bash -c 'cat > /etc/dnsmasq.conf << EOF
interface=eth0
dhcp-range=172.27.221.10,172.27.221.200,255.255.240.0
EOF'; then
    echo "Terjadi kesalahan saat mengonfigurasi dnsmasq. Mohon periksa file konfigurasi di /etc/dnsmasq.conf."
    exit 1
fi

# Konfigurasi hostapd
echo "Mengonfigurasi hostapd..."
if ! sudo bash -c 'cat > /etc/hostapd/hostapd.conf << EOF
interface=eth0
driver=nl80211
ssid=WifiGratis
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
EOF'; then
    echo "Terjadi kesalahan saat mengonfigurasi hostapd. Mohon periksa file konfigurasi di /etc/hostapd/hostapd.conf."
    exit 1
fi

# Jalankan dnsmasq dan hostapd
echo "Menjalankan dnsmasq dan hostapd..."
if ! sudo systemctl start dnsmasq; then
    echo "Terjadi kesalahan saat menjalankan dnsmasq. Mohon periksa status layanan dengan 'systemctl status dnsmasq' atau log di /var/log/syslog."
    exit 1
fi

if ! sudo systemctl start hostapd; then
    echo "Terjadi kesalahan saat menjalankan hostapd. Mohon periksa status layanan dengan 'systemctl status hostapd' atau log di /var/log/syslog."
    exit 1
fi

# Konfigurasi Captive Portal
echo "Mengonfigurasi Captive Portal di Apache..."
if ! sudo bash -c 'cat > /etc/apache2/sites-available/000-default.conf << EOF
<Directory "/var/www/html">
    RewriteEngine On
    RewriteBase /
    RewriteCond %{HTTP_POST} ^www\.(.*)$ [NC]
    RewriteRule (.*)$ http://%1/$1 [R=301,L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)$ / [L,QSA]
</Directory>
EOF'; then
    echo "Terjadi kesalahan saat mengonfigurasi Apache. Mohon periksa file konfigurasi di /etc/apache2/sites-available/000-default.conf."
    exit 1
fi

# Aktifkan situs dan restart Apache
echo "Mengaktifkan situs Apache dan memulai ulang layanan..."
if ! sudo a2ensite 000-default.conf; then
    echo "Terjadi kesalahan saat mengaktifkan situs Apache. Mohon periksa status dengan 'apache2ctl configtest'."
    exit 1
fi

if ! sudo systemctl restart apache2; then
    echo "Terjadi kesalahan saat memulai ulang layanan Apache. Mohon periksa status layanan dengan 'systemctl status apache2' atau log di /var/log/apache2/error.log."
    exit 1
fi

echo "Konfigurasi selesai. Hotspot dengan captive portal telah dibuat."
