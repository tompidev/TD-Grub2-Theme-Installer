#!/bin/bash

# install.sh
# @author Tompidev
# @description
# @created 2021-Oct-22 15:05:42
# @copyright (c) 2021 Tompi Developments
# @licence MIT
# @last-modified 2021-Oct-25 07:32:44
# @release v1.0.2


THEME_DIR='/usr/share/grub/themes'
THEME_NAME=''

function echo_title() {     echo -ne "\033[1;44;37m${*}\033[0m\n"; }
function echo_caption() {   echo -ne "\033[0;1;44m${*}\033[0m\n"; }
function echo_bold() {      echo -ne "\033[0;1;34m${*}\033[0m\n"; }
function echo_danger() {    echo -ne "\033[0;31m${*}\033[0m\n"; }
function echo_success() {   echo -ne "\033[0;32m${*}\033[0m\n"; }
function echo_warning() {   echo -ne "\033[0;33m${*}\033[0m\n"; }
function echo_secondary() { echo -ne "\033[0;34m${*}\033[0m\n"; }
function echo_info() {      echo -ne "\033[0;35m${*}\033[0m\n"; }
function echo_primary() {   echo -ne "\033[0;36m${*}\033[0m\n"; }
function echo_error() {     echo -ne "\033[0;1;31mError:\033[0;31m\t${*}\033[0m\n"; }
function echo_label() {     echo -ne "\033[0;1;32m${*}:\033[0m\t"; }
function echo_prompt() {    echo -ne "\033[0;36m${*}\033[0m "; }

function splash() {
    local hr
    hr=" **$(printf "%${#1}s" | tr ' ' '*')** "
    echo_title "${hr}"
    echo_title " * $1 * "
    echo_title "${hr}"
    echo
}

function check_root() {
    # Checking for root access and proceed if it is present
    ROOT_UID=0
    if [[ ! "${UID}" -eq "${ROOT_UID}" ]]; then
        # Error message
        echo_error 'Run me as root.'
        echo_info 'try sudo ./install.sh'
        exit 1
    fi
}

function select_language() {

    PS3=$(echo_prompt "\nSelect Your language: ")
    select i in English Deutsch Magyar; do
        case $i in
            'English')
                echo_prompt '\nYou selected English Language'
                themes_found="\nI found  the following template(s) in the themes directory:"
                abort_run="Abort program"
                theme_number="\nPlease Enter the number of the theme you want to install: "
                interrupted="\nRunning was interrupted by User. Abort run..."
                wrong_selected="\nNone or non-existent theme selected. Abort run..."
                installing_theme="Installing selected theme..."
                enabling_grub="Enabling grub menu"
                set_timeout="\nPlease enter Grub Timeout in seconds (recommended 3-10 sec): "
                wrong_timeout="\nThe specified format is incorrect. Only numbers between 1 and 99 are allowed. Abort run..."
                setting_timeout="Setting grub timeout to given time"
                setting_default="Set the selected theme as default"
                updating_grub="Updating grub config..."
                all_done="All done !"
                break;;
            'Deutsch')
                echo_prompt '\nDu hast Deutsche sprache gewählt'
                themes_found="\nIch habe die folgende(n) Vorlage(n) im Themenverzeichnis gefunden:"
                abort_run="Programm abbrechen"
                theme_number="\nBitte gebe die Nummer des Themes ein, das du installieren möchtest: "
                interrupted="\nDer Lauf wurde vom Benutzer unterbrochen. Lauf abbrechen..."
                wrong_selected="\nKein oder nicht vorhandenes Theme ausgewählt. Lauf abbrechen..."
                installing_theme="Ausgewähltes Thema installieren..."
                enabling_grub="Grub-Menü aktivieren"
                set_timeout="\nBitte Grub Timeout in Sekunden eingeben (empfohlen 3-10 Sek):"
                wrong_timeout="\nDas angegebene Format ist falsch. Es sind nur Zahlen zwischen 1 und 99 erlaubt. Lauf abbrechen..."
                setting_timeout="Grub-Timeout auf die ausgewählte zeit setzen"
                setting_default="Das ausgewählte Thema als Standard festlegen"
                updating_grub="Grub-Konfiguration wird aktualisiert..."
                all_done="Alles erlädigt !"
                break;;
            'Magyar')
                echo_prompt '\nA magyar nyelvet választottad'
                themes_found="\nAz alábbi sablonokat találtam a themes könyvtárban:"
                abort_run="Program megszakítása"
                theme_number="\nKérlek add meg a sablon számát, amelyiket telepíteni szeretnéd: "
                interrupted="\nA felhasználó megszakította a futtatást. Futtatás megszakítása..."
                wrong_selected="\nNem létező sablon, vagy semmi sem lett kiválasztva. Futtatás megszakítása..."
                installing_theme="A kiválasztott sablon telepítése..."
                enabling_grub="Grub menü engedélyezése"
                set_timeout="\nKérlek add meg a Grub időtúllépést másodpercben (ajánlott 3-10 mp): "
                wrong_timeout="\nA megadott formátum helytelen. Csak számok 1 és 99 között megengedettek. Futás megszakítása..."
                setting_timeout="A grub timeout beállítása a választott időre"
                setting_default="A kiválasztott sablon beállítása alapértelmezettként"
                updating_grub="A grub konfiguráció frissítése ..."
                all_done="Minden kész !"
                break;;
        esac
    done
}

function select_theme() {

    cd ./themes
    declare -a dirs
        i=1
        for d in */
        do
            dirs[i++]="${d%/}"
        done

    echo_warning "${themes_found}"

    echo "0 | ${abort_run}"
    for((i=1;i<=${#dirs[@]};i++))
        do
            echo $i "| ${dirs[i]}"
        done

    echo_prompt "${theme_number}"

    read i

    THEME_NAME="${dirs[$i]}"

    if [[ i -le 0 ]]; then
        echo_warning "${interrupted}"
        exit 1
    fi

}

function selected_theme() {
    # Check if valid theme nummer selected
    if [[ ! -e "${THEME_NAME}" ]]; then
        echo_error "${wrong_selected}"

        exit 1
    fi
}

function set_timeout(){
    # Waiting for user to enter Grub Timeout between 1 and 99

    echo_prompt "${set_timeout}"

    read GRUB_TIMEOUT

    format='^[0-9]{1,2}$'

    if [[ ! $GRUB_TIMEOUT =~ $format ]]; then

        echo_error "${wrong_timeout}"

       exit 1
    fi

    if [[ $GRUB_TIMEOUT -le 0 ]]; then

        echo_error "${wrong_timeout}"

        exit 1
    fi
}

function backup() {
    # Backup grub config
    echo_info 'cp -an /etc/default/grub /etc/default/grub.bak'
    cp -an /etc/default/grub /etc/default/grub.bak
}

function install_theme() {
    # create themes directory if not exists
    if [[ ! -d "${THEME_DIR}/${THEME_NAME}" ]]; then
        # Copy theme
        echo_primary "${installing_theme}"

        echo_info "mkdir -p \"${THEME_DIR}/${THEME_NAME}\""
        mkdir -p "${THEME_DIR}/${THEME_NAME}"

        echo_info "cp -a ./\"${THEME_NAME}\"/* \"${THEME_DIR}/${THEME_NAME}\""
        cp -a "${THEME_NAME}"/* "${THEME_DIR}/${THEME_NAME}"
    fi
}

function config_grub() {
    echo_primary "${enabling_grub}"
    # remove default grub style if any
    echo_info "sed -i '/GRUB_TIMEOUT_STYLE=/d' /etc/default/grub"
    sed -i '/GRUB_TIMEOUT_STYLE=/d' /etc/default/grub

    echo_info "echo 'GRUB_TIMEOUT_STYLE=\"menu\"' >> /etc/default/grub"
    echo 'GRUB_TIMEOUT_STYLE="menu"' >> /etc/default/grub

    #--------------------------------------------------

    echo_primary "${setting_timeout}"
    # remove default timeout if any
    echo_info "sed -i '/GRUB_TIMEOUT=/d' /etc/default/grub"
    sed -i '/GRUB_TIMEOUT=/d' /etc/default/grub

    echo_info "echo 'GRUB_TIMEOUT=\""${GRUB_TIMEOUT}"\"' >> /etc/default/grub"
    echo "GRUB_TIMEOUT=\"${GRUB_TIMEOUT}\"" >> /etc/default/grub

    #--------------------------------------------------

    echo_primary "${setting_default}"
    # remove theme if any
    echo_info "sed -i '/GRUB_THEME=/d' /etc/default/grub"
    sed -i '/GRUB_THEME=/d' /etc/default/grub

    echo_info "echo \"GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"\" >> /etc/default/grub"
    echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub
}

function update_grub() {
    # Update grub config
    echo_primary "${updating_grub}"
    if [[ -x "$(command -v update-grub)" ]]; then
        echo_info 'update-grub'
        update-grub

    elif [[ -x "$(command -v grub-mkconfig)" ]]; then
        echo_info 'grub-mkconfig -o /boot/grub/grub.cfg'
        grub-mkconfig -o /boot/grub/grub.cfg

    elif [[ -x "$(command -v grub2-mkconfig)" ]]; then
        if [[ -x "$(command -v zypper)" ]]; then
            echo_info 'grub2-mkconfig -o /boot/grub2/grub.cfg'
            grub2-mkconfig -o /boot/grub2/grub.cfg

        elif [[ -x "$(command -v dnf)" ]]; then
            echo_info 'grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg'
            grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
        fi
    fi
}

function main() {
    splash 'TD Grub2 Theme Installer'

    check_root

    select_language

    select_theme

    selected_theme

    set_timeout

    install_theme

    config_grub

    update_grub

    echo_success "${all_done}"
}

main
