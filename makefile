include config.mk

BDF_OUT = $(ID).bdf
TTF_OUT = $(ID).ttf

.PHONY: all bdf clean install uninstall

all: $(BDF_OUT) $(TTF_OUT)
bdf: $(BDF_OUT)

clean:
	rm -f $(BDF_OUT) $(TTF_OUT)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(ID)
	cp -f $(BDF_OUT) $(TTF_OUT) $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

$(BDF_OUT):
	ID=$(ID) NAME=$(NAME) VERSION=$(VERSION) ./bdf > $@

$(TTF_OUT): $(BDF_OUT)
	$(BDF2TTF) -o $@ $^
