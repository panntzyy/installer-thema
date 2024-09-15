#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf backupthemapanel.tar.gz pterodactyl
    echo "Installing theme..."
    cd /var/www/pterodactyl
    rm -r pannzyythema
    git clone https://github.com/VanzzTOT/installer-thema/main
    cd pannzyythema
    rm /var/www/pterodactyl/resources/scripts/pannzyythema.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv pannzyythema.css /var/www/pterodactyl/resources/scripts/pannzyythema.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Untuk menginstal thema ketik [y/n] apakah anda menyetujui nya?" yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Please Ketik Y/N.";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/VanzzTOT/installer-thema/main/repair.sh)
}

restoreBackUp(){
    echo "Restoring backup..."
    cd /var/www/
    tar -xvf backupthemapanel.tar.gz
    rm backupthemapanel.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "Copyright (c) 2024 repann | pannzyyxd"
echo "Script thema by pannzyyxd"
echo ""
echo ""
echo "[1] Install Tema Panel"
echo "[2] Restore backup"
echo "[3] Uninstall Panel"
echo "[4] Exit"

read -p "Silahkan pilih angka di atas untuk memulai " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    exit
fi
