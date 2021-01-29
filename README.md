# WifiAttack

[![GitHub top language](https://img.shields.io/github/languages/top/m4lal0/wifiAttack?logo=gnu-bash&style=flat-square)](#)
[![GitHub repo size](https://img.shields.io/github/repo-size/m4lal0/wifiAttack?logo=webpack&style=flat-square)](#)
[![Debian Supported](https://img.shields.io/badge/Debian-Supported-blue?style=flat-square&logo=debian)](#)
[![Kali Supported](https://img.shields.io/badge/Kali-Supported-blue?style=flat-square&logo=linux)](#)
[![Parrot Supported](https://img.shields.io/badge/Parrot-Supported-blue?style=flat-square&logo=linux)](#)
[![By](https://img.shields.io/badge/By-m4lal0-green?style=flat-square&logo=github)](#)

<img src="https://i.ibb.co/tHRw85T/Top-wifi-Attack.png"
	alt="top"
	width="1000"
	style="float: left; margin-right: 10px;" />
</p>

<p align="center">
Herramienta ideal para automatizar ataques WiFi (WEP & WPA/WPA2 - PSK) destinados a la obtención de la contraseña.
</p>

La herramienta **wifiAttack** cuenta con varios modos de ataques. Divididos por el tipo de encriptación del AP objetivo:

#### WEP

+ **Fake Authentication Attack** : Le permite asociarse a un AP. Este ataque es útil en escenarios donde no hay clientes asociados y es necesario falsificar una autenticación en el AP. 
+ **ARP Replay Attack** : El ataque escucha un paquete ARP y luego lo retransmite al punto de acceso.

#### WPA/WPA2 - PSK

Con clientes asociados al AP:
+ **Handshake Attack** : De manera automatizada, se gestiona todo lo necesario para mediante un ataque clásico de de-autenticación y reconexión por parte de una estación, se obtenga un Handshake válido con el que posteriormente poder trabajar para aplicar fuerza bruta.
+ **Authentication DoS Mode** : Generar varias direcciones MAC para asociarlas al AP para volver lenta la red y que el AP expulse a todos los clientes.

Sin clientes asociados al AP:
+ **PKMID ClientLess Attack** : Centra su atención en las redes inalámbricas que no disponen de clientes asociados (Método Moderno).

## Instalación

Ejecutarlo como root:

```bash
git clone https://github.com/m4lal0/wifiAttack
cd wifiAttack; chmod +x wifiAttack.sh
./wifiAttack.sh --install
```

Al ejecutarlo realizará la instalación de las dependencias (Framework aircrack-ng, terminator, hashcat, mdk4 y entre otros). El script de instalación funciona con administradores de paquetes apt (Debian).

## ¿Cómo ejecuto la herramienta?

Para ejecutar la herramienta solo es necesario ejecutarlo de la siguiente manera (como root):

```bash
./wifiAttack.sh
```

La herramienta ejecutará la terminal Terminator con 4 divisiones.

**Arriba a la izquierda** : Activacion del modo monitor, escane todos los puntos de acceso que se tienen al rededor.

**Arriba a la derecha** : Seleccionar y captura de paquetes de la red inalámbrica objetivo.

**Abajo a la izquierda** : Seleccionar el tipo de ataque de acuerdo al protocolo de encriptacion de la red inalámbrica objetivo (WEP & WPA/WPA2 - PSK).

**Abajo a la derecha** : Obtención de la contraseña. Lanzamiento del cracking password de acuerdo al tipo de ataque seleccionado.

<img src="https://i.ibb.co/LZ31j1L/Start-Wifi-Attack.png"
	alt="wifiAttack-Start"
	width="1000"
	style="float: left; margin-right: 10px;" />
</p>
<br>
<img src="https://i.ibb.co/S0gmPMC/Exec-Wifi-Attack.png"
	alt="wifiAttack-Exec"
	width="1000"
	style="float: left; margin-right: 10px;" />
</p>
<br>

## Descargo de responsabilidad

Cualquier acción y / o actividad realizada mediante el uso de wifiAttack es de su exclusiva responsabilidad. El mal uso de wifiAttack puede resultar en cargos criminales contra las personas en cuestión. El autor no será responsable en caso de que se presenten cargos penales contra cualquier persona que haga un uso indebido de wifiAttack para infringir la ley.