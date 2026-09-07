include config.mk

BDFOUT = $(FONT_NAME).bdf
PCFOUT = $(FONT_NAME).pcf
TTFOUT = $(FONT_NAME).ttf

.PHONY: all clean

all: $(BDFOUT) $(PCFOUT) $(TTFOUT)

clean:
	rm -f $(BDFOUT) $(PCFOUT) $(TTFOUT)

$(BDFOUT):
	FONT_NAME=$(FONT_NAME) FONT_VERSION=$(FONT_VERSION) ./bdf > $(BDFOUT)

$(PCFOUT): $(BDFOUT)
	$(BDFTOPCF) -o $@ $^

$(TTFOUT): $(BDFOUT)
	$(BDF2TTF) -o $@ $^
