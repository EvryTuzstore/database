#!/bin/bash
# Uninstall Script by alxzy-group
# Menghapus semua tema pihak ketiga dan mengembalikan panel ke default

MERAH="\e[31m"
HIJAU="\e[32m"
KUNING="\e[33m"
RESET="\e[0m"

echo -e "${KUNING}==============================================${RESET}"
echo -e "${HIJAU}    🔧 UNINSTALL THEME PTERODACTYL PANEL     ${RESET}"
echo -e "${KUNING}==============================================${RESET}"
sleep 2

if [ ! -d "/var/www/pterodactyl" ]; then
    echo -e "${MERAH}❌ Direktori /var/www/pterodactyl tidak ditemukan.${RESET}"
    echo -e "Pastikan kamu menjalankan skrip ini di server panel."
    exit 1
fi

cd /var/www/pterodactyl

echo -e "${KUNING}🧹 Menghapus file tema pihak ketiga...${RESET}"
rm -rf public/themes
rm -rf resources/scripts/*
rm -rf resources/views/*

echo -e "${KUNING}📥 Mengunduh ulang file panel original...${RESET}"
curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz

echo -e "${KUNING}📦 Mengekstrak file panel bawaan...${RESET}"
tar -xzf panel.tar.gz --strip-components=1
rm -f panel.tar.gz

echo -e "${KUNING}⚙️ Menginstal dependensi composer...${RESET}"
composer install --no-dev --optimize-autoloader > /dev/null 2>&1

echo -e "${KUNING}🧽 Membersihkan cache dan view...${RESET}"
php artisan view:clear
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan migrate --force

echo -e "${KUNING}🔒 Menyesuaikan izin file...${RESET}"
chown -R www-data:www-data /var/www/pterodactyl/*

echo -e "${HIJAU}✅ Tema berhasil dihapus dan panel telah dikembalikan ke default.${RESET}"
echo -e "${KUNING}Jika panel tidak langsung tampil normal, jalankan:${RESET}"
echo -e "${HIJAU}  systemctl restart nginx${RESET}"
echo -e "${HIJAU}  systemctl restart php8.2-fpm${RESET}"
echo -e "${KUNING}==============================================${RESET}"
