include config.mk

BDFOUT = $(FONT_NAME).bdf

.PHONY: all clean

all: $(BDFOUT)

clean:
	rm -f $(BDFOUT)

$(BDFOUT):
	FONT_NAME=$(FONT_NAME) ./bdf > $(BDFOUT)
