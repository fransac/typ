include config.mk

OUT = $(ID).bdf

.PHONY: all clean install uninstall

all: $(OUT)

clean:
	rm -f $(OUT)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(ID)
	cp -f $(OUT) $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

$(OUT):
	ID=$(ID) NAME=$(NAME) ./bdf > $@
