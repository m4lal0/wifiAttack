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

function readInterface(){
    test -f .interface.txt
    if [ "$(echo $?)" == "0" ]; then
        INTERFACE=$(cat .interface.txt)
    else
        clear
        echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Configurar primero la interfaz en modo monitor...${Color_Off}\n"
        echo -en "${BGray}Presiona ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}cuando lo hayas realizado.${Color_Off}" && read
        readInterface
    fi
}

function output_dir_check() {
	if [ -d "output/$ESSID" ];then
			echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}El directorio ya existe.${Color_Off}"
			question "Coloca otro nombre del objetivo (ESSID): "
			ESSID=$input
			output_dir_check
	fi
}

function airodump(){
    clear
    echo -e "\n${LBlue}[${BBlue}*${LBlue}] ${BBlue}Iniciando la captura del Objetivo${Color_Off}\n"
    echo -e "${BPurple}Interface: ${BBlack}${On_White}$INTERFACE${Color_Off}\n"
    question "Nombre del AP objetivo (ESSID)"
    ESSID=$input
    output_dir_check
    echo $ESSID > .output.txt 2> /dev/null
    mkdir output/$ESSID 2> /dev/null
    echo "ESSID|$ESSID" > output/$ESSID/.target.txt 2> /dev/null
    question "MAC del AP objetivo (BSSID)"
    BSSID=$input
    echo "BSSID|$BSSID" >> output/$ESSID/.target.txt 2> /dev/null
    question "Canal del AP Objetivo"
    CHANNEL=$input
    echo "CHANNEL|$CHANNEL" >> output/$ESSID/.target.txt 2> /dev/null
    echo -en "\n\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}para iniciar la captura del AP Pbjetivo: ${BRed}$ESSID${Color_Off} " && read
    cd output/$ESSID 2> /dev/null
    iwconfig $INTERFACE channel $CHANNEL 2> /dev/null
    airodump-ng -c $CHANNEL --bssid $BSSID -w $ESSID $INTERFACE 2> /dev/null
}

function main(){
    readInterface
    airodump
}

main