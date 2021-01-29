#!/bin/bash

# By @m4lal0

# Regular Colors
Black='\033[0;30m'      # Black
Red='\033[0;31m'        # Red
Green='\033[0;32m'      # Green
Yellow='\033[0;33m'     # Yellow
Blue='\033[0;34m'       # Blue
Purple='\033[0;35m'     # Purple
Cyan='\033[0;36m'       # Cyan
White='\033[0;97m'      # White
Color_Off='\033[0m'     # Text Reset

# Additional colors
LGray='\033[0;37m'      # Ligth Gray
DGray='\033[0;90m'      # Dark Gray
LRed='\033[0;91m'       # Ligth Red
LGreen='\033[0;92m'     # Ligth Green
LYellow='\033[0;93m'    # Ligth Yellow
LBlue='\033[0;94m'      # Ligth Blue
LPurple='\033[0;95m'    # Light Purple
LCyan='\033[0;96m'      # Ligth Cyan

# Bold
BBlack='\033[1;30m'     # Black
BGray='\033[1;37m'		# Gray
BRed='\033[1;31m'       # Red
BGreen='\033[1;32m'     # Green
BYellow='\033[1;33m'    # Yellow
BBlue='\033[1;34m'      # Blue
BPurple='\033[1;35m'    # Purple
BCyan='\033[1;36m'      # Cyan

# Underline
UBlack='\033[4;30m'     # Black
UGray='\033[4;37m'		# Gray
URed='\033[4;31m'       # Red
UGreen='\033[4;32m'     # Green
UYellow='\033[4;33m'    # Yellow
UBlue='\033[4;34m'      # Blue
UPurple='\033[4;35m'    # Purple
UCyan='\033[4;36m'      # Cyan
UWhite='\033[4;37m'     # White

# Background
On_Black='\033[40m'     # Black
On_Red='\033[41m'       # Red
On_Green='\033[42m'     # Green
On_Yellow='\033[43m'    # Yellow
On_Blue='\033[44m'      # Blue
On_Purple='\033[45m'    # Purple
On_Cyan='\033[46m'      # Cyan
On_White='\033[47m'     # White

export DEBIAN_FRONTEND=noninteractive

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}Saliendo...${Color_Off}"
    stopped
    exit 0
}

function helpPanel(){
    echo -e "\n${BGray}Herramienta hecha en Bash ideal para automatizar ataques WiFi (WEP/WPA/WPA2 - PSK) destinados a la obtención de la contraseña.${Color_Off}\n"
    echo -e "${BGray}USO: \n\t ${BGreen}./wifiAttack.sh${Color_Off}\n"
    echo -e "${BGray}OPCIONES:${Color_Off}"
    echo -e "\t${LBlue}[${BRed}-i , --install${LBlue}] \t${BPurple}Instalación de herramientas para la correcta ejecución del script.${Color_Off}"
    echo -e "\t${LBlue}[${BRed}-h , --help${LBlue}] \t\t${BPurple}Mostrar este panel de ayuda.${Color_Off}\n"
    tput cnorm; exit 0
}

function install(){
    dependencies=(aircrack-ng macchanger terminator net-tools mdk4 hcxdumptool hcxtools hashcat)
    echo -e "\n${LBlue}[${BBlue}+${LBlue}] ${BBlue}Comprobando herramientas necesarias...${Color_Off}\n"
    for program in "${dependencies[@]}"; do
        echo -ne "${LBlue}[${BBlue}*${LBlue}] ${BGray}Herramienta $program...${Color_Off}"
        command -v $program > /dev/null 2>&1
        if [ "$(echo $?)" == "0" ]; then
            echo -e "${LBlue}($BGreen✔${LBlue})${Color_Off}"
        else
            echo -e "${LBlue}(${BRed}✘${LBlue})${Color_Off}"
            echo -e "${LBlue}[${BYellow}!${LBlue}] ${BYellow}Instalando herramienta ${BGreen}$program...${Color_Off}"
            apt-get install $program -y > /dev/null 2>&1
        fi; sleep 1
    done
    if [ ! -d ~/.config/terminator ]; then
        mkdir ~/.config/terminator
        cp src/config ~/.config/terminator
    else
        cp src/config ~/.config/terminator
    fi
    echo -e "\n${LBLue}[${BYellow}!${LBlue}] ${BGreen}Ya puedes ejecutar la herramienta: ./wifiAttack.sh${Color_Off}\n"
    tput cnorm; exit 0
}

function stopped(){
    if [ -f .interface.txt ]; then
        ifconfig $(cat .interface.txt) down
        macchanger -p $(cat .interface.txt) > /dev/null 2>&1
        ifconfig $(cat .interface.txt) up
        airmon-ng stop $(cat .interface.txt) > /dev/null 2>&1 && service network-manager restart > /dev/null 2>&1
        rm .interface.txt .output.txt .attack.txt PKMID* > /dev/null 2>&1
        tput cnorm
    else
        tput cnorm
    fi
}

if [ "$(id -u)" == "0" ]; then
    tput civis
    arg=""
    for arg; do
        delim=""
        case $arg in
            --help)		args="${args}-h";;
            --install)	args="${args}-i";;
            --*)        args="${args}*";;
            *) [[ "${arg:0:1}" == "-" ]] || delim="\""
            args="${args}${delim}${arg}${delim} ";;
        esac
    done

    eval set -- $args
    while getopts "ih" opt; do
        case $opt in
            i) install;;
            h) helpPanel;;
            *) helpPanel;;
        esac
    done

    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BGreen}Iniciando wifiAttack...${Color_Off}"
    sleep 2
    terminator -l wifiAttack
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}Deteniendo wifiAttack...${Color_Off}\n"
    stopped

else
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}Ejecuta el script como r00t!${Color_Off}\n"
fi