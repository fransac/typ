include config.mk

BDFOUT = $(FONT_ID).bdf
TTFOUT = $(FONT_ID).ttf

.PHONY: all bdf clean

all: $(BDFOUT) $(TTFOUT)
bdf: $(BDFOUT)

clean:
	rm -f $(BDFOUT) $(TTFOUT)

$(BDFOUT):
	FONT_NAME=$(FONT_NAME) FONT_VERSION=$(FONT_VERSION) ./bdf > $(BDFOUT)

$(TTFOUT): $(BDFOUT)
	$(BDF2TTF) -o $@ $^
