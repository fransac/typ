include config.mk

BDFOUT = $(FONT_ID).bdf
TTFOUT = $(FONT_ID).ttf

.PHONY: all bdf clean install uninstall

all: $(BDFOUT) $(TTFOUT)
bdf: $(BDFOUT)

clean:
	rm -f $(BDFOUT) $(TTFOUT)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(FONT_ID)
	cp -f $(BDFOUT) $(TTFOUT) $(DESTDIR)$(PREFIX)/share/fonts/$(FONT_ID)

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/share/fonts/$(FONT_ID)

$(BDFOUT):
	FONT_NAME=$(FONT_NAME) FONT_VERSION=$(FONT_VERSION) ./bdf > $(BDFOUT)

$(TTFOUT): $(BDFOUT)
	$(BDF2TTF) -o $@ $^
