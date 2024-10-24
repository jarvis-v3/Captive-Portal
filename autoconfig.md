# Panduan Penggunaan `autoconfig.sh`

Skrip `autoconfig.sh` ini bertujuan untuk mengotomatisasi proses pembuatan hotspot dengan captive portal di WSL (Windows Subsystem for Linux) tanpa menggunakan Raspberry Pi. Skrip ini akan mengonfigurasi `dnsmasq`, `hostapd`, dan `apache2` untuk menciptakan jaringan Wi-Fi terbuka dengan captive portal.

## Cara Penggunaan

### Langkah-langkah

1. **Simpan Skrip**
   - Salin skrip `autoconfig.sh` ke dalam file dengan nama `autoconfig.sh`.
   - Simpan file tersebut di direktori yang Anda inginkan.

2. **Beri Izin Eksekusi**
   - Buka terminal dan navigasi ke direktori tempat `autoconfig.sh` disimpan.
   - Jalankan perintah berikut untuk memberi izin eksekusi pada skrip:
     ```bash
     chmod +x autoconfig.sh
     ```

3. **Jalankan Skrip**
   - Jalankan skrip dengan perintah berikut untuk memulai proses konfigurasi:
     ```bash
     sudo ./autoconfig.sh
     ```

Skrip ini akan melakukan langkah-langkah berikut secara otomatis:
- Memperbarui paket dan menginstal `dnsmasq`, `hostapd`, dan `apache2`.
- Mengonfigurasi `dnsmasq` untuk menggunakan antarmuka `eth0` dan mengatur rentang DHCP.
- Mengonfigurasi `hostapd` untuk membuat jaringan Wi-Fi terbuka dengan SSID "WifiGratis".
- Memulai layanan `dnsmasq` dan `hostapd`.
- Mengonfigurasi Apache untuk captive portal.
- Mengaktifkan situs Apache dan memulai ulang layanan.

Jika terjadi kesalahan selama proses, skrip ini akan menampilkan pesan kesalahan dalam bahasa Indonesia yang menjelaskan identifikasi dari permasalahan yang terjadi.

## Catatan

- Pastikan firewall WSL dikonfigurasi dengan benar untuk mengizinkan lalu lintas HTTP dan HTTPS.
- Anda mungkin perlu melakukan penyesuaian tambahan tergantung pada konfigurasi jaringan komputer Anda.
- Jika Anda mengalami masalah, periksa log dari `dnsmasq`, `hostapd`, dan `apache2` untuk mendapatkan petunjuk lebih lanjut.

Dengan mengikuti langkah-langkah ini, Anda akan dapat membuat hotspot dengan captive portal secara otomatis di WSL. Jika ada pertanyaan atau membutuhkan bantuan lebih lanjut, jangan ragu untuk menghubungi saya!
