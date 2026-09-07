include config.mk

BDFOUT = $(FONT_NAME).bdf
TTFOUT = $(FONT_NAME).ttf

.PHONY: all bdf ttf clean

all: $(BDFOUT) $(TTFOUT)

bdf: $(BDFOUT)
ttf: $(TTFOUT)

clean:
	rm -f $(BDFOUT) $(TTFOUT)

$(BDFOUT):
	FONT_NAME=$(FONT_NAME) FONT_VERSION=$(FONT_VERSION) ./bdf > $(BDFOUT)

$(TTFOUT): $(BDFOUT)
	$(BDF2TTF) -o $@ $^
