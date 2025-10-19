#!/bin/bash
# Safe Uninstall Script by ChatGPT
# Hanya menghapus tema pihak ketiga dan mengembalikan panel ke default

MERAH="\e[31m"
HIJAU="\e[32m"
KUNING="\e[33m"
RESET="\e[0m"

echo -e "${KUNING}==============================================${RESET}"
echo -e "${HIJAU}    🔧 SAFE UNINSTALL THEME PTERODACTYL    ${RESET}"
echo -e "${KUNING}==============================================${RESET}"
sleep 2

# Pastikan direktori panel ada
if [ ! -d "/var/www/pterodactyl" ]; then
    echo -e "${MERAH}❌ Direktori /var/www/pterodactyl tidak ditemukan.${RESET}"
    exit 1
fi

cd /var/www/pterodactyl

# Backup file penting
echo -e "${KUNING}💾 Backup file konfigurasi penting (.env)...${RESET}"
cp .env .env.backup

# Hapus tema pihak ketiga
echo -e "${KUNING}🧹 Menghapus folder tema pihak ketiga...${RESET}"
rm -rf public/themes/*

# Unduh file default untuk folder views dan scripts jika hilang
echo -e "${KUNING}📥 Memeriksa dan mengembalikan file default...${RESET}"
# Contoh sederhana: hanya jika folder kosong
[ ! "$(ls -A resources/scripts)" ] && git checkout resources/scripts
[ ! "$(ls -A resources/views)" ] && git checkout resources/views

# Bersihkan cache dan view
echo -e "${KUNING}🧽 Membersihkan cache dan view...${RESET}"
php artisan view:clear
php artisan cache:clear
php artisan config:clear
php artisan route:clear

# Set permission
echo -e "${KUNING}🔒 Menyesuaikan izin file...${RESET}"
chown -R www-data:www-data /var/www/pterodactyl
chmod -R 755 /var/www/pterodactyl

echo -e "${HIJAU}✅ Tema berhasil dihapus. Panel seharusnya kembali normal.${RESET}"
echo -e "${KUNING}Jika panel belum normal, restart service:${RESET}"
echo -e "${HIJAU}  systemctl restart php8.2-fpm${RESET}"
echo -e "${HIJAU}  systemctl restart nginx${RESET}"
echo -e "${KUNING}==============================================${RESET}"
