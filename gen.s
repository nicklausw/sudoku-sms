arch sms.cpu
scope GenerateBoardData {
    ld hl,puzzles
    ld a,(rand)

    cp 127
    jr c,+
    sbc a,127

  +; ld b,a
    cp 0
    jr z,+
  -; push bc
    ld bc,162
    adc hl,bc
    pop bc
    djnz -

  +; dec hl
    ld (board_loc),hl

    ld bc,163
    ld de,board_dat-1

  -; ld a,(hl)
    ex de,hl
    ld (hl),a
    ex de,hl
    inc de
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,-

    ld hl,(board_loc)
    ld bc,82
    ld de,board_ava

  -; ld a,(hl)
    cp 1
    call c,_one
    inc de
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,-
    ret


_one:; ex de,hl
    ld a,1
    ld (hl),a
    ex de,hl
    ret
}
