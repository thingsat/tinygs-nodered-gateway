# LoRa PHY Modem for TinyGS

This is a LoRa PHY modem based on the RIOT manual test application for the SX127X radio driver.

By default the application builds the SX1276 version of the driver. If you
want to use this application with a SX1272 module, set the variable `DRIVER` in
the application [Makefile](Makefile):
```
DRIVER = sx1272
```	
instead of
```
DRIVER = sx1276
```

## Prerequises

Change into `sys/include/shell.h`

```c
/**
 * @brief Default shell buffer size (maximum line length shell can handle)
 */
#ifndef SHELL_DEFAULT_BUFSIZE
#define SHELL_DEFAULT_BUFSIZE   (128)
#endif
```

You can also pass `DRIVER` when building the application:
```bash
export RIOTBASE=~/github/RIOT-OS/RIOT
gmake BOARD=nucleo-f411re DRIVER=sx1272 flash term -j 8
gmake BOARD=nucleo-f401re DRIVER=sx1276 flash term -j 8
```

```
> help
Command              Description
---------------------------------------
setup                Initialize LoRa modulation settings
implicit             Enable implicit header
crc                  Enable CRC
iq                   Enable IQ
payload              Set payload length (implicit header)
random               Get random number from sx127x
syncword             Get/Set the syncword
rx_timeout           Set the RX timeout
channel              Get/Set channel frequency (in Hz)
register             Get/Set value(s) of registers of sx127x
send                 Send raw payload string
listen               Start raw payload listener
reset                Reset the sx127x device
pm                   interact with layered PM subsystem
ps                   Prints information about running threads.
reboot               Reboot the node
rtc                  control RTC peripheral interface
version              Prints current RIOT_VERSION
```

```
version
rtc
rtc get
```

## Usage

### With Gateway STM32 LRWAN3

#### Gateway console

Show eu433 Frequency Plan

```
AT+HELP
```
```
...
```

```
AT+CH
```
```
+CH: 0, 433175000, A, SF7/SF12, BW125KHz (LORA_MULTI_SF)
+CH: 1, 433375000, A, SF7/SF12, BW125KHz (LORA_MULTI_SF)
+CH: 2, 433575000, A, SF7/SF12, BW125KHz (LORA_MULTI_SF)
+CH: 3, 433775000, A, SF7/SF12, BW125KHz (LORA_MULTI_SF)
+CH: 4, 433975000, B, SF7/SF12, BW125KHz (LORA_MULTI_SF)
+CH: 5, 434175000, B, SF7/SF12, BW125KHz (LORA_MULTI_SF)
+CH: 6, 434375000, B, SF7/SF12, BW125KHz (LORA_MULTI_SF)
+CH: 7, 434575000, B, SF7/SF12, BW125KHz (LORA_MULTI_SF)
+CH: 8, OFF                              (LORA_STANDARD)
+CH: 9, OFF                              (FSK)
```

```
AT+LORAWAN
```
```
+LORAWAN: PUBLIC
```

#### Modem console

```
setup 125 7 5
channel set 433175000
syncword set 34
crc set 1
send Hello\ World
hex set 1
send 000102030480FF0010123456789012345678
```

```
setup 125 12 8
channel set 433375000
syncword set 34
crc set 1
hex set 0
send Hello\ Thingsat
hex set 1
send 000102030480FF0010123456789012345678
```

Transmitting with IQ inverted (instead of normal)
```
crc set 0
iq set 1
hex set 1
send 000102030480FF0010123456789012345678
```

Listen 
```
setup 125 7 5
channel set 433175000
syncword set 34
crc set 1
hex set 1
rx_timeout set 10
listen
```


### With TinyGS ESP32 Heltec 433

Norby packet:
```
echo "jv////8KBgHJcCwAAAAA8Q8AAHZSj+VYAEJSSyBNVyBWRVI6MDVhXzAxAAAAAAAOAQD9BwAAAAcZAAjICpKoIQcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMA9v/H/8T9AAAAAAAAFAQEDw8PDw8PAA8QtwgwIACCNw4MAAwAAAQD/QJvBRMUEgBgEHggtiw=" | base64 -d | xxd -u -p -c 10000
```
Generate
```
8EFFFFFFFF0A0601C9702C00000000F10F000076528FE5580042524B204D57205645523A3035615F303100000000000E0100FD0700000007190008C80A92A8210700000000000000000000000000000000000000000000002300F6FFC7FFC4FD0000000000001404040F0F0F0F0F0F000F10B70830200082370E0C000C00000403FD026F051314120060107820B62C
```

🛰 Norby
```
setup 250 10 5
channel set 436703000
syncword set 12
crc set 1
hex set 1
listen start
```

🛰 FossaSAT-2x
```
setup 125 11 8
channel set 401700000
syncword set 12
crc set 1
hex set 1
listen start
```



## TinyGS Cubesats

[CSV File](./cubesats.csv)

|Name|NORAD|Mod|Freq|BW|SF|CR|CRC|IQ|Preamble|
|-|-|-|-|-|-|-|-|-|-|
|Norby|46494|LoRa|436703000|250|10|5|1|0|8|
|FEES|99738|LoRa|437200000|125|9|5|1|0|8|
|FossaSat-2E2|50984|LoRa|401700000|125|11|8|1|0|8|
|FossaSat-2E1|50985|LoRa|401700000|125|11|8|1|0|8|
|SATLLA-2B|99490|LoRa|437250000|62.5|10|5|1|0|8|

## TODO
* [ ] add Teseo GNSS shield
