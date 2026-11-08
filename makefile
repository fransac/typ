include config.mk

OUT = typ.bdf

.PHONY: all clean install uninstall

all: $(OUT)

clean:
	rm -f $(OUT)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts
	cp -f $(OUT) $(DESTDIR)$(PREFIX)/share/fonts

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/share/fonts/$(OUT)

$(OUT):
	NAME=Typ ./build.sh > $@
