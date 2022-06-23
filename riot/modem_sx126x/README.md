# SX126x Modem

```bash
gmake BOARD=nucleo-wl55jc LORA_DRIVER=sx126x_stm32wl flash -j 8
```

```
sx126x setup 250 10 5
sx126x set freq 436703000
sx126x set syncword 52
sx126x rx start
```

