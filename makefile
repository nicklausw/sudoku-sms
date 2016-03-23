CC = wla-z80
LD = wlalink

OUT = sudoku.sms

EMU = d:/dev/emu/meka/mekaw.exe

SFILES = $(wildcard *.s)
OFILES = $(subst .s,.o,$(SFILES))

LIBS = $(wildcard include/*.s)
LIBSO = $(subst .s,.l,$(LIBS))

$(OUT): $(OFILES) $(LIBSO)
	$(LD) -vd linkfile.txt $(OUT)
	$(EMU) $(OUT) >/dev/null 2>&1

%.o: %.s
	$(CC) -o $< $@

include/%.l: include/%.s
	$(CC) -l $< $@

clean:
	rm -f $(OFILES) $(OUT) $(LIBSO)
