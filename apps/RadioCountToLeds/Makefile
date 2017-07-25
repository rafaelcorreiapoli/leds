COMPONENT=RadioCountToLedsAppC
BUILD_EXTRA_DEPS = RadioCountMsg.py RadioCountMsg.class
# TOSMAKE_PRE_EXE_DEPS = RadioCountMsg.py RadioCountMsg.class
# TOSMAKE_CLEAN_EXTRA = RadioCountMsg.py RadioCountMsg.class RadioCountMsg.java

RadioCountMsg.py: RadioCountToLeds.h
	mig python -target=$(PLATFORM) $(CFLAGS)	-python-classname=RadioCountMsg RadioCountToLeds.h radio_count_msg -o $@

RadioCountMsg.class: RadioCountMsg.java
	javac RadioCountMsg.java

RadioCountMsg.java: RadioCountToLeds.h
	mig java -target=$(PLATFORM) (CFLAGS) -java-classname=RadioCountMsg RadioCountToLeds.h radio_count_msg -o $@


TINYOS_ROOT_DIR?=../..
include $(TINYOS_ROOT_DIR)/Makefile.include
CFLAGS += -I$(TINYOS_OS_DIR)/lib/printf
CFLAGS += -DPRINTF_BUFFER_SIZE=1024
