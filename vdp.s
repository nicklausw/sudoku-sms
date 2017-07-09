SetVDP:
    push bc
    ld c,VDPControl
    out (c),l
    out (c),h
    pop bc
    ret



CopyVDP:
    push hl
    call BCtoHL
    ld bc,$4000
    adc hl,bc
    call SetVDP
    pop hl

  -; ld a,(hl)
    out (VDPData),a
    inc hl
    dec de
    ld a,d
    or e
    jr nz,-
    ret



PaletteData:
db $00,$02,$08,$0A,$20,$22,$28,$2A,$3F,$03,$0C,$0F,$30,$33,$3C,$3F
db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0C



ScreenOn:
    ld a,%01100000
    out (VDPControl),a
    ld a,$81
    out (VDPControl),a
    ret



ScreenOff:
    ld a,%00100000
    out (VDPControl),a
    ld a,$81
    out (VDPControl),a
    ret



// VDP initialisation data
VDPStuff:
    ld hl,VDPI
    ld b,$80
    ld c,VDPE-VDPI
  -; ld a,(hl)
    out (VDPControl),a
    ld a,b
    out (VDPControl),a
    inc hl
    dec c
    inc b
    ld a,c
    cp 0
    jr nz,-
    ret

VDPI:
    db $6,$a0,$ff,$ff,$ff,$ff,$00,$00,$00,$00,$ff
VDPE:
