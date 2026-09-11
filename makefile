include config.mk

BDFOUT = $(ID).bdf
TTFOUT = $(ID).ttf

.PHONY: all bdf clean install uninstall

all: $(BDFOUT) $(TTFOUT)
bdf: $(BDFOUT)

clean:
	rm -f $(BDFOUT) $(TTFOUT)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(ID)
	cp -f $(BDFOUT) $(TTFOUT) $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

$(BDFOUT):
	NAME=$(NAME) VERSION=$(VERSION) ./bdf > $(BDFOUT)

$(TTFOUT): $(BDFOUT)
	$(BDF2TTF) -o $@ $^
