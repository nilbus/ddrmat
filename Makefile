obj-m := ddrmat.o
PWD:= $(shell pwd)
KERNEL_VERSION_NUMBER ?= $(shell uname -r)
KERNEL_SOURCE ?= /lib/modules/$(KERNEL_VERSION_NUMBER)/build
MODULE_PATH ?= $(DESTDIR)/lib/modules/$(KERNEL_VERSION_NUMBER)/kernel/drivers/char/joystick
ifeq "$(shell echo $(KERNEL_VERSION_NUMBER)|cut -b 1-3)" "2.6"
EXT:=ko
else
EXT:=o
endif

Default:
ifeq "$(shell echo $(KERNEL_VERSION_NUMBER)|cut -b 1-3)" "2.6"
	$(MAKE) -C $(KERNEL_SOURCE) SUBDIRS=$(PWD) modules
else
	$(CC) -D__KERNEL__ -I$(KERNEL_SOURCE)/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fomit-frame-pointer -fno-strict-aliasing -fno-common -pipe -mpreferred-stack-boundary=2 -falign-functions=4 -DMODULE -DMODVERSIONS -include $(KERNEL_SOURCE)/include/linux/modversions.h -c ddrmat.c
endif

install:
	install -D -m 644 ddrmat.$(EXT) $(MODULE_PATH)/ddrmat.$(EXT)
	@echo "Be sure to run depmod -ae."

clean:
	rm -rf *~ *.o *.ko *.mod.* .*.cmd .tmp*
