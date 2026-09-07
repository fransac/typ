include config.mk

BDFOUT = $(FONT_NAME).bdf
PCFOUT = $(FONT_NAME).pcf

.PHONY: all clean

all: $(BDFOUT) $(PCFOUT)

clean:
	rm -f $(BDFOUT) $(PCFOUT)

$(BDFOUT):
	FONT_NAME=$(FONT_NAME) ./bdf > $(BDFOUT)

$(PCFOUT): $(BDFOUT)
	$(BDFTOPCF) -o $@ $^
