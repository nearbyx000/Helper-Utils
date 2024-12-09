#!/bin/bash

# Проверка на наличие root-прав
if [[ $EUID -ne 0 ]]; then
    echo "Этот скрипт нужно запускать с правами root."
    exit 1
fi

detect_distro() {
    if command -v hostnamectl &> /dev/null; then
        hostnamectl | grep "Operating System" | awk -F': ' '{print tolower($2)}'
    else
        echo "unknown"
    fi
}


# Установка библиотек
install_packages() {
    case "$1" in
        ubuntu|debian|)
            apt update
            apt install -y tigervnc-standalone-server tigervnc-common

            ;;
        arch)
            pacman -Sy --noconfirm tigervnc
            ;;
        fedora|mos)
            dnf update
            dnf install -y tigervnc-server tigervnc
            ;;

        *)
            echo "Неизвестный дистрибутив. Скрипт поддерживает только MOS, Ubuntu и Arch."
            exit 1
            ;;
    esac
}



