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
    test -f .interface.txt
    if [ "$(echo $?)" == "0" ]; then
        airodump
    else
        main
    fi
}

function banner(){
    clear
    echo -e "\t${BGreen}██╗    ██╗██╗███████╗██╗ ${BRed}  █████╗ ████████╗████████╗ █████╗  ██████╗██╗  ██╗${Color_Off}"
    echo -e "\t${BGreen}██║    ██║██║██╔════╝██║ ${BRed} ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝${Color_Off}"
    echo -e "\t${BGreen}██║ █╗ ██║██║█████╗  ██║ ${BRed} ███████║   ██║      ██║   ███████║██║     █████╔╝ ${Color_Off}"
    echo -e "\t${BGreen}██║███╗██║██║██╔══╝  ██║ ${BRed} ██╔══██║   ██║      ██║   ██╔══██║██║     ██╔═██╗ ${Color_Off}"
    echo -e "\t${BGreen}╚███╔███╔╝██║██║     ██║ ${BRed} ██║  ██║   ██║      ██║   ██║  ██║╚██████╗██║  ██╗${Color_Off}"
    echo -e "\t${BGreen} ╚══╝╚══╝ ╚═╝╚═╝     ╚═╝ ${BRed} ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝${Color_Off}"
    echo -e "\t\t\t\t\t\t\t\t\t${BBlue}By ${BGray}@m4lal0${Color_Off}\n"
}

function selectInterface(){
    banner
    echo -e "\n${LBlue}[${BBlue}+${LBlue}] ${BBlue}Interfaces Disponibles${Color_Off}"

    ifconfig -a | cut -d ' ' -f 1 | xargs | tr ' ' '\n' | tr -d ':' > iface
	counter=1; for interface in $(cat iface); do
		echo -e "\t\n${BBlue}$counter.${BGreen} $interface${Color_Off}"; sleep 0.26
		let counter++
	done
	checker=0; while [ $checker -ne 1 ]; do
		echo -en "\n${LBlue}[${BPurple}?${LBlue}] ${BGray}Interfaz a usar (Ej: wlan0):${Color_Off} " && read input
        for interface in $(cat iface); do
			if [ "$input" == "$interface" ]; then
				checker=1
			fi
		done; if [ $checker -eq 0 ]; then echo -e "\n${LBlue}[${BRed}✘${LBlue}] ${BRed}La interfaz proporcionada no existe${Color_Off}\n"; fi
    done
    rm iface 2>/dev/null

    # iwconfig
    # input=""
    # while [ "$input" == "" ]; do
    #     echo -en "${LBlue}[${BPurple}?${LBlue}] ${BGray}Interfaz a usar:${Color_Off} " && read input
    # done
    INTERFACE=$input
    echo $INTERFACE > .interface.txt
}

function modeMonitor(){
    banner
    airmon-ng check kill > /dev/null 2>&1
    echo -e "${LBlue}[${BYellow}!${LBlue}] ${BGreen}Habilitando modo monitor en la interface $INTERFACE${Color_Off}\n"
    ifconfig $INTERFACE down
    macchanger -a $INTERFACE > /dev/null 2>&1
    echo -e "\t${LBlue}[${BBlue}*${LBlue}] ${BBlue}Cambio de MAC en $INTERFACE: ${BGreen}$(macchanger -s $INTERFACE | grep "Current" | xargs | cut -d ' ' -f 3-100)${Color_Off}\n"
    iwconfig $INTERFACE mode monitor
    ifconfig $INTERFACE up
    echo -e "\t${LBlue}[${BBlue}*${LBlue}] ${BBlue}Tipo de modo en $INTERFACE: ${BGreen}$(iwconfig $INTERFACE | grep Mode | xargs | cut -d ' ' -f 1 | cut -d ':' -f 2)${Color_Off}\n"
    sleep 3
}

function airodump(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Iniciando escaneo de redes inalámbricas.${Color_Off}"
    echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}para continuar...${Color_Off}" && read
    airodump-ng $INTERFACE
}

function main(){
    selectInterface
    modeMonitor
    airodump
}

main