include config.mk

BDF_OUT = $(ID).bdf
TTF_OUT = $(ID).ttf

SMALL_BDF_OUT = $(SMALL_ID).bdf
SMALL_TTF_OUT = $(SMALL_ID).ttf

.PHONY: all bdf clean install uninstall

all: $(BDF_OUT) $(TTF_OUT) $(SMALL_BDF_OUT) $(SMALL_TTF_OUT)
bdf: $(BDF_OUT) $(SMALL_BDF_OUT)

clean:
	rm -f $(BDF_OUT) $(TTF_OUT) $(SMALL_BDF_OUT) $(SMALL_TTF_OUT)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(ID)
	cp -f $(BDF_OUT) $(TTF_OUT) $(DESTDIR)$(PREFIX)/share/fonts/$(ID)

	mkdir -p $(DESTDIR)$(PREFIX)/share/fonts/$(SMALL_ID)
	cp -f $(SMALL_BDF_OUT) $(SMALL_TTF_OUT) \
	      $(DESTDIR)$(PREFIX)/share/fonts/$(SMALL_ID)

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/share/fonts/$(ID) \
	       $(DESTDIR)$(PREFIX)/share/fonts/$(SMALL_ID)

$(BDF_OUT):
	ID=$(ID) NAME=$(NAME) VERSION=$(VERSION) ./bdf > $@

$(TTF_OUT): $(BDF_OUT)
	$(BDF2TTF) -o $@ $^

$(SMALL_BDF_OUT):
	ID=$(SMALL_ID) NAME=$(SMALL_NAME) VERSION=$(VERSION) ./bdf > $@

$(SMALL_TTF_OUT): $(SMALL_BDF_OUT)
	$(BDF2TTF) -o $@ $^
