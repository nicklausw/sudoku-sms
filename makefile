BASS = C:/dev/bass-ultima/bass/out/bass-ultima

OUT = sudoku.sms

EMU = higan

SFILES = $(wildcard *.s)

LIBS = $(wildcard include/*.s)

SUDOKUGEN = tools/sudoku.py

$(OUT): $(SFILES) $(LIBS)
	$(RM) puzzles.s
	$(SUDOKUGEN) >>puzzles.s
	$(BASS) -benchmark -strict -create -o $(OUT) sudoku.s
	$(EMU) $(OUT) >/dev/null 2>&1

clean:
	$(RM) $(OUT) puzzles.s
