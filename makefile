BASS = bass-untech

OUT = sudoku.sms

EMU = higan

SFILES = $(wildcard *.s)

LIBS = $(wildcard include/*.s)

SUDOKUGEN = tools/sudoku.py

all: $(SFILES) $(LIBS)
	$(RM) puzzles.s; $(SUDOKUGEN) >>puzzles.s
	$(BASS) -benchmark -strict -o $(OUT) sudoku.s
	$(EMU) $(OUT) >/dev/null 2>&1

clean:
	$(RM) $(OUT) puzzles.s
