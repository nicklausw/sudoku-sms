.memorymap
defaultslot 0
slotsize $8000
slot 0 $0000
slotsize $2000
slot 1 $c000
.endme
.rombankmap
bankstotal 1
banksize $8000
banks 1
.endro



; the usual definitions
.define VDPControl $bf
.define VDPData $be
.define VRAMWrite $4000
.define CRAMWrite $c000

.smstag
.sdsctag 0.2,"sudoku",notes,"nicklausw"
