# Panduan Membuat Hotspot dengan Captive Portal di WSL (Windows Subsystem for Linux)
File ini menjelaskan langkah-langkah untuk membuat hotspot dengan captive portal di WSL (Windows Subsystem for Linux) tanpa menggunakan Raspberry Pi.
1. Persiapan
Pastikan WSL Anda terhubung ke internet.
Install paket yang dibutuhkan:
```
    sudo apt update
    sudo apt install dnsmasq hostapd apache2
```
2. Konfigurasi dnsmasq
Buka file konfigurasi dnsmasq:
```
    nano /etc/dnsmasq.conf
```
Ubah baris interface=eth0 menjadi:
```
    interface=eth0
```
Ubah dhcp-range untuk menyesuaikan dengan subnet Anda:
```
    dhcp-range=172.27.221.10,172.27.221.200,255.255.240.0
```
Simpan file dengan menekan Ctrl + X, Y, dan Enter.
3. Konfigurasi hostapd
Buka file konfigurasi hostapd:
```
    nano /etc/hostapd/hostapd.conf
```
Ubah baris interface=eth0 menjadi:
```
    interface=eth0
```
Simpan file dengan menekan Ctrl + X, Y, dan Enter.
4. Jalankan dnsmasq dan hostapd
Jalankan dnsmasq:
```
    sudo dnsmasq -C /etc/dnsmasq.conf
```
Jalankan hostapd:
```
    sudo hostapd /etc/hostapd/hostapd.conf
```
5. Konfigurasi Captive Portal
Letakkan file captive portal Anda di direktori /var/www/html.
Buat file konfigurasi Apache:
```
    nano /etc/apache2/sites-available/000-default.conf
```
Tambahkan baris berikut ke dalam file:
```
    <Directory "/var/www/html">
    RewriteEngine On
    RewriteBase /
    RewriteCond %{HTTP_POST} ^www\.(.*)$ [NC]
    RewriteRule (.*)$ http://%1/$1 [R=301,L]

    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)$ / [L,QSA]
    </Directory>
```
Simpan file dengan menekan Ctrl + X, Y, dan Enter.
Aktifkan situs Apache:
```
    sudo a2ensite 000-default.conf
```
Mulai layanan Apache:
```
    sudo systemctl restart apache2
```
6. Mengakses Hotspot
Hubungkan perangkat lain ke jaringan komputer Anda (subnet 172.27.221.0).
Anda akan diarahkan ke captive portal yang Anda buat.
Setelah Anda login, Anda akan dapat mengakses internet.
Catatan
Pastikan firewall WSL dikonfigurasi dengan benar untuk mengizinkan lalu lintas HTTP dan HTTPS.
Anda mungkin perlu melakukan penyesuaian tambahan tergantung pada konfigurasi jaringan komputer Anda.
Jika Anda mengalami masalah, periksa log dari dnsmasq dan hostapd untuk mendapatkan petunjuk.
