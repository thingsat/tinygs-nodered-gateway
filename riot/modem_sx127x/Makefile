
APLICATION = tinygs_modem_sx127x

BOARD ?= nucleo-f411re

include $(RIOTBASE)/tests/Makefile.tests_common


FEATURES_REQUIRED += periph_rtc
FEATURES_OPTIONAL += periph_rtc_ms
FEATURES_OPTIONAL += periph_rtc_mem


CFLAGS += -DSHELL_DEFAULT_BUFSIZE=512

USEMODULE += od
USEMODULE += shell
USEMODULE += shell_commands
USEMODULE += ps
USEMODULE += fmt

DRIVER ?= sx1276

# use SX1276 by default
USEMODULE += $(DRIVER)

include $(RIOTBASE)/Makefile.include
