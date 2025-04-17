KDIR ?= /lib/modules/`uname -r`/build
M := $(shell pwd)/drivers/net/wireless/mediatek/mt76

all: mt76all

mt%: configs/config.mt% build
	@echo 'Config:' $$(xargs <$<)
	$(MAKE) -C '$(KDIR)' 'M=$(M)' $$(xargs <$<)
.PHONY: build

install:
	$(MAKE) -C '$(KDIR)' 'M=$(M)' modules_install

clean:
	$(MAKE) -C '$(KDIR)' 'M=$(M)' clean
