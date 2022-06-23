

La MCU STM32WL55 inclut un transceiver LoRa qui permet des communications longue distance en LoRa et dans un réseau LoRaWAN comme les réseaux publics [TTN](https://eu1.cloud.thethings.network/console/applications) et [Helium](https://console.helium.com/devices) ou bien les réseaux privés opérés avec Chirpstack comme [CampusIoT](https://lns.campusiot.imag.fr).

Les exercices suivants ont pour objectif:
* soit de faire communiquer la carte avec un réseau LoRaWAN composés de stations LoRa et d'un serveur réseau LoRaWAN,
* soit de faire communiquer directement la carte avec une autre carte en utilisant la modulation LoRa,

Ces exercices sont valables pour les quatre cartes en utilisant les paramêtres de la commande `make`:
* NUCLEO-WL55JC avec `make BOARD=nucleo-wl55jc`.
* NUCLEO-WL55JC2 `make BOARD=nucleo-wl55jc REGION=EU433`
* [LoRa E5 Dev](https://wiki.seeedstudio.com/LoRa_E5_Dev_Board/) `make BOARD=lora-e5-dev`
* [LoRa E5 Mini](https://wiki.seeedstudio.com/LoRa_E5_mini/) `make BOARD=lora-e5-dev`
* [Nucleo F446RE](https://www.st.com/en/evaluation-tools/nucleo-f446re.html) et [Semtech SX1272MB2DAS](https://fr.semtech.com/products/wireless-rf/lora-core/sx1272mb2das) `make BOARD=nucleo-f446re LORA_DRIVER=sx1272`

## Construction du firmware de test

Construisez le firmware pour la carte NUCLEO-WL55JC
```bash
cd RIOT/tests/pkg_semtech-loramac/
make BOARD=nucleo-wl55jc LORA_DRIVER=sx126x_stm32wl
```

Construisez le firmware pour la carte NUCLEO-WL55JC2
```bash
cd RIOT/tests/pkg_semtech-loramac/
make BOARD=nucleo-wl55jc LORA_DRIVER=sx126x_stm32wl REGION=EU433
```

Construisez le firmware pour les cartes LoRa E5 Dev ou Mini (pour eu868)
```bash
cd RIOT/tests/pkg_semtech-loramac/
make BOARD=lora-e5-dev LORA_DRIVER=sx126x_stm32wl
```

Construisez le firmware pour les cartes Nucleo F446RE muni d'une [carte fille LoRa Semtech SX1272MB2DAS](https://fr.semtech.com/products/wireless-rf/lora-core/sx1272mb2das)
```bash
cd RIOT/tests/pkg_semtech-loramac/
make make BOARD=nucleo-f446re LORA_DRIVER=sx1272
```

Construisez le firmware pour les cartes Nucleo F446RE muni d'une [carte fille LoRa Semtech SX1276MB1MAS](https://www.semtech.com/products/wireless-rf/lora-core/sx1276mb1mas)
```bash
cd RIOT/tests/pkg_semtech-loramac/
make make BOARD=nucleo-f446re LORA_DRIVER=sx1276
```
ou
```bash
cd RIOT/tests/pkg_semtech-loramac/
make make BOARD=nucleo-f446re LORA_DRIVER=sx1276 REGION=EU433
```

## Chargement du firmware

### Pour les cartes Nucleo

Chargez le firmware sur votre carte (ici pour `nucleo-wl55jc`).
```bash
make BOARD=nucleo-wl55jc LORA_DRIVER=sx126x_stm32wl flash-only
```

> Remarque: `make` execute OpenOCD pour le chargement.

Il se peut que le chargement du firmware avec OpenOCD échoue si la version que vous utilisez est ancienne. Utilisez la version 0.11.0 d'OpenOCD.

Une autre alternative pour charger le firmware est de copier le binaire sur le volume `NOD_WL55JC` de la carte soit via l'explorateur de fichiers, soit via la commande `copy` ou `cp` avec la ligne de commande suivante:
```bash
cp bin/nucleo-wl55jc/tests/tests_pkg_semtech-loramac.bin /Volumes/NOD_WL55JC/
```

### Pour les cartes LoRa E5

Le chargement du firmware sur les cartes LoRa E5 requiert l'application [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html) fournie par ST et préalablement installée.

Connectez le chargeur SWD aux broches SWD de la carte comme l'illustre l'image ci-dessous

![LoRa E5 Dev Connection SWD](site/assets/images/lora/seeestudio_lora_e5_dev_connection.png)
![LoRa E5 Mini Connection SWD](site/assets/images/lora/seeestudio_lora_e5_mini_connection.png)


> Vous pouvez utiliser le flasheur détachable des cartes Nucleo et connecter les 5 premières broches du [connecteur CN4 SWD](https://www.st.com/content/ccc/resource/technical/document/user_manual/98/2e/fa/4b/e0/82/43/b7/DM00105823.pdf/files/DM00105823.pdf/jcr:content/translations/en.DM00105823.pdf):

	Pin 1: VDD_TARGET (VDD from application) --> Fil rouge
	Pin 2: SWCLK (clock)                     --> Fil jaune
	Pin 3: GND (ground)                      --> Fil noir
	Pin 4: SWDIO (SWD data input/output)     --> Fil bleu
	Pin 5: NRST (RESET of target STM32)      --> Fil gris

Chargez le firmware `bin/lora-e5-dev/tests/tests_pkg_semtech-loramac.bin` sur votre carte en utilisant l'application [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html) fournie par ST et préalablement installée et en suivant les [instructions données par Seeedstudio](https://wiki.seeedstudio.com/LoRa_E5_Dev_Board/#23-build-the-lorawan-end-node-example).

## Commandes pour utiliser la carte dans un réseau LoRaWAN

Vous pouvez vous connecter au port console de la carte avec un terminal serie (`minicom`, `pyterm`, `putty` ou mieux un [minitel recylé](https://github.com/fabMSTICLig/ido-horaires)).

```
> help
Command              Description
---------------------------------------
reboot               Reboot the node
version              Prints current RIOT_VERSION
pm                   interact with layered PM subsystem
random_init          initializes the PRNG
random_get           returns 32 bit of pseudo randomness
loramac              Control Semtech loramac stack
```

Définissez les identifiants et la clé principale. Ceux-ci doivent préalablement avoir être enregistrés dans un réseau LoRaWAN dans lequel vous avez un compte ([TTN](https://eu1.cloud.thethings.network/console/applications), [Helium](https://console.helium.com/devices), [CampusIoT](https://lns.campusiot.imag.fr))
```
> loramac set deveui AAAAAAAAAAAAAAAA
> loramac set appeui BBBBBBBBBBBBBBBB
> loramac set appkey CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
```

Dans le cas où vous utilisez TTN, définir la datarate pour la seconde fenêtre de réception (aka RX2) qui doit être DR3 (SF9BW125) comme décrit dans [TTN LoRaWAN Frequencies Overview](https://www.thethingsnetwork.org/docs/lorawan/frequency-plans.html)
```
> loramac set rx2_dr 3
```

Rejoignez le réseau dans lequel est enregistré la carte en suivant la procedure OTAA ([_Over-The-Air Activation_](https://www.thethingsnetwork.org/docs/lorawan/addressing/#over-the-air-activation-otaa))
```
> loramac join otaa
Join procedure failed!
```
> La procédure OTAA peut échouer si la carte (identifiants et clé applicative) n'est pas enregistrée correctement ou bien si aucune station du réseau n'est à portée de votre carte. Dans ce dernier cas, il faut recommencer la procédure en mettant à l'exterieur pour gagner quelques dBm. Une autre raison de l'échec de la procédure OTAA est que la station qui reçoit le message ait épuisé son droit à émettre (_duty cycle_).

> A noter: l'autre procédure d'activation est la procédure ABP ([_Activation by Personalization_](https://www.thethingsnetwork.org/docs/lorawan/addressing/#activation-by-personalization-abp)) pour laquelle il faut définir directement l'adresse réseau (`DevAddr`) et les clés de session (`AppSKey` et `NwkSKey`). La procédure ABP est considérée comme moins sécurisée et n'est pas disponibles chez tous les opérateurs réseau LoRaWAN (Helium, Orange ...).

Rejoignez de nouveau le réseau.
```
> loramac join otaa
Cannot join: dutycycle restriction
```
> La carte a épuisé son droit à émettre (_duty cycle_). Il faut attendre quelques minutes pour recommancer la procédure OTAA.

Rejoignez de nouveau le réseau.
> La procédure OTAA est terminée : la carte et le serveur réseau LoRaWAN se sont échangés les deux clés de session (`AppSKey` et `NwkSkey`). La carte peut désormais transmettre des données et en recevoir (une seconde après la transmission).

```
> loramac join otaa
Join procedure succeeded!
```

Définissez le datarate pour les prochaines transmissions. La datarate 5 utilise les paramètres suivantes de la modulation LoRa (SF7 et BW125).
```
> loramac set dr 5
```

Demandez au serveur un rapport sur la qualité du liaison radio montant (aka `link check`) à la prochaine transmission
```
> loramac link_check
Link check request scheduled
```

Transmettre un message en mode confirmé sur le port 2
```
> loramac tx This\ is\ RIOT! cnf 2
Link check information:
  - Demodulation margin: 13
  - Number of gateways: 5
Received ACK from network
Message sent with success
```
Le message s'affiche dans la console du serveur LoRaWAN.
> Le serveur LoRaWAN répond à la demande de `link check` : le message a été recu par 5 stations et la marge de démodulation est de 13 dBm


Abaissez le datarate et demander au serveur un `link check` à la prochaine transmission. 
```
> loramac set dr 0
> loramac link_check
Link check request scheduled
```

Transmettez un message en mode confirmé sur le port 2
```
> loramac tx This\ is\ RIOT! cnf 2
Link check information:
  - Demodulation margin: 8
  - Number of gateways: 8
Received ACK from network
Message sent with success
```
> Le serveur LoRaWAN répond à la demande de `link check` : le message a été recu par 8 stations et la marge de démodulation est de 8 dBm

Activez l'ADR ([_Adaptative Data Rate_](https://www.thethingsnetwork.org/docs/lorawan/adaptive-data-rate/)) pour les prochaines transmissions
```
> loramac set adr on
```

Demandez au serveur un `link check` à la prochaine transmission. 
```
> loramac link_check
Link check request scheduled
```

Transmettez un message en mode non confirmé sur le port 10
```
> loramac tx This\ is\ RIOT! uncnf 10
Link check information:
  - Demodulation margin: 5
  - Number of gateways: 7
Message sent with success
```

Verifiez si la procédure ADR (_Adaptative Data Rate_) a été effectuée.
```
> loramac get dr
DATARATE: 5
```
> Le serveur a augmenté le _datarate_ à la vue de la bonne qualité du lien entre la carte et les stations voisines.

Ajouter un message descendant pour cet carte dans la console du serveur LoRaWAN. La valuer du message doit être encodé en base64 : `dGVzdA==` dans l'exemple.

Transmettez un message en mode non confirmé sur le port 1
```
> loramac tx test
Data received: This is RIOT!
```
Le message descendant recu par la carte est affiché dans la console.


## Commandes pour utiliser directement le pilote du transceiver SX126x du STM32WL55

Il est possible de se passer d'un réseau LoRaWAN quand on souhaite établir des communications directes entre 2 ou plusieurs cartes. Il faut alors utiliser directement le pilote du du transceiver SX126x du STM32WL55 et convenir des mêmes paramêtres de la modulation LoRa : fréquence centrale (`freq`), _coding rate_ (`cr`), _spreading factor_ (`sf`), bandwidth (`bw`).
> A noter: les commandes du shell ci-dessous ne permettent pas de définir la taille du préambule (_preamble_), ni du symbole de synchronisation (_syncword_), ni la puissance d'émission en dBm (_txpower_).

Construissez le _firmware_.
```
cd RIOT
cd tests/driver_sx126x/
make BOARD=nucleo-wl55jc
```

Chargez le _firmware_.
```
make BOARD=nucleo-wl55jc flash-only
```

Vous pouvez vous connecter au port console de la carte avec un terminal serie (`minicom`, `pyterm`, `putty` ou mieux un [minitel recylé](https://github.com/fabMSTICLig/ido-horaires)).

```
main(): This is RIOT! (Version: 2022.01-devel-217-g43bef)
Initialization successful - starting the shell now
> help
Command              Description
---------------------------------------
sx126x               Control the SX126X radio
reboot               Reboot the node
version              Prints current RIOT_VERSION                   
pm                   interact with layered PM subsystem            
> sx126x                                                           
Usage: sx126x <get|set|rx|tx>                                      
> sx126x get
Usage: sx126x get <type|freq|bw|sf|cr|random>
> sx126x get freq
Frequency: 868300000Hz
> sx126x get bw
Bandwidth: 125kHz
> sx126x get sf
Spreading factor: 7
> sx126x get cr
Coding rate: 1
> sx126x get random
random number: 4294967295
> sx126x tx TEST
sending "TEST" payload (5 bytes)
```

## Commandes pour utiliser directement le pilote du transceiver SX127x de la carte [Semtech SX1272MB2DAS](https://fr.semtech.com/products/wireless-rf/lora-core/sx1272mb2das)

A faire.


## Pour aller plus loin

Vous pouvez contruire et flasher sur les cartes ce programme de [testeur réseau (aka Field Test Device)](https://github.com/CampusIoT/orbimote/blob/master/field_test_device/README.md).

