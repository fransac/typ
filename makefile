include config.mk

BDF_OUT = $(ID).bdf
PCF_OUT = $(ID).pcf
TTF_OUT = $(ID).ttf

TINY_BDF_OUT = $(TINY_ID).bdf
TINY_PCF_OUT = $(TINY_ID).pcf
TINY_TTF_OUT = $(TINY_ID).ttf

.PHONY: all bdf pcf ttf clean \
        install-bdf install-pcf install-ttf \
        install uninstall

all: bdf pcf ttf
bdf: $(BDF_OUT) $(TINY_BDF_OUT)
pcf: $(PCF_OUT) $(TINY_PCF_OUT)
ttf: $(TTF_OUT) $(TINY_TTF_OUT)

clean:
	rm -f $(BDF_OUT) $(PCF_OUT) $(TTF_OUT) \
	      $(TINY_BDF_OUT) $(TINY_PCF_OUT) $(TINY_TTF_OUT)

install-bdf: bdf
	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(ID)
	cp -f $(BDF_OUT) $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(TINY_ID)
	cp -f $(TINY_BDF_OUT) $(DESTDIR)$(PREFIX)/share/fonts/$(TINY_ID)

install-pcf: pcf
	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(ID)
	cp -f $(PCF_OUT) $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(TINY_ID)
	cp -f $(TINY_PCF_OUT) $(DESTDIR)$(PREFIX)/share/fonts/$(TINY_ID)

install-ttf: ttf
	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(ID)
	cp -f $(TTF_OUT) $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(TINY_ID)
	cp -f $(TINY_TTF_OUT) $(DESTDIR)$(PREFIX)/share/fonts/$(TINY_ID)

install: install-bdf install-pcf install-ttf

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/share/fonts/$(ID) \
	       $(DESTDIR)$(PREFIX)/share/fonts/$(TINY_ID)

$(BDF_OUT):
	ID=$(ID) NAME=$(NAME) VERSION=$(VERSION) ./bdf > $@

$(PCF_OUT): $(BDF_OUT)
	$(BDF2PCF) -o $@ $^

$(TTF_OUT): $(BDF_OUT)
	$(BDF2TTF) -o $@ $^

$(TINY_BDF_OUT):
	ID=$(TINY_ID) NAME=$(TINY_NAME) VERSION=$(VERSION) ./bdf > $@

$(TINY_PCF_OUT): $(TINY_BDF_OUT)
	$(BDF2PCF) -o $@ $^

$(TINY_TTF_OUT): $(TINY_BDF_OUT)
	$(BDF2TTF) -o $@ $^
