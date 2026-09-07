include config.mk

OUT = $(FONT_NAME).bdf

.PHONY: all clean

all: $(OUT)

clean:
	rm -f $(OUT)

$(OUT):
	FONT_NAME=$(FONT_NAME) ./bdf > $(OUT)
