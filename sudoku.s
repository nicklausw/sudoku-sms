// main file to nicklausw's
// sudoku game

arch sms.cpu
include "header.i"

macro byte(name) {
  {name}:; db 00
}

macro word(name) {
  {name}:; dw 0000
}

macro multi(name, num) {
  {name}:; fill {num}
}

origin $0100; base $0100
notes:; insert "docs/notes.txt"
db 0


pushvar pc
base $C000; {
    byte(controller)

    byte(timer1)
    byte(timer2)

    byte(rand)

    byte(board_cell)
    word(board_temp)
    multi(board_dat, 162)
    multi(board_ava, 81)
    word(board_loc)

    word(highlight)
    word(h_temp)

    byte(disp_mode)
    byte(table_h)
    word(table_rc)
}; pullvar pc



origin $0000; base $0000
    di
    im 1
    ld sp,$dfff
    jp setup


origin $0038; base $0038
    push af
    in a,($bf)
    pop af
    call ctrlr_handle
    call inc_rand
    call timer
    ei
    reti


origin $0066; base $0066
    retn


origin $0300; base $0300
include "include/psglib.s"
include "include/soniccompr.s"
include "include/stmcomp.s"
include "cursor.s"
include "data.s"
include "display.s"
include "fade.s"
include "gen.s"
include "puzzles.s"
include "vdp.s"

ctrlr_handle:
    push af
    in a,($dc)
    ld (controller),a
    pop af
    ret


inc_rand:
    push af
    push bc
    ld a,(rand)
    inc a
    ld b,a
    ld a,r
    adc a,b
    ld b,a
    ld a,(timer1)
    adc a,b
    ld (rand),a
    pop bc
    pop af
    ret



timer:
    ld a,(timer1)
    cp 60
    jr z,+
    inc a
    ld (timer1),a
    jr ++
  +; xor a
    ld (timer1),a
    ld a,(timer2)
    inc a
    ld (timer2),a
  +; ret



setup:
    call VDPStuff
    call PSGInit

    // Clear RAM
    ld hl,$c000
    ld bc,$e000
  -; xor a
    ld (hl),a
    inc hl
    ld a,h
    cp $e0
    jr nz,-


    ld hl,$0000 | VRAMWrite
    call SetVDP
    ld bc,$4000
  -; xor a
    out (VDPData),a
    dec bc
    ld a,b
    or c
    jr nz,-


    ld hl,$0909
    ld (highlight),hl
    ld a,1
    ld (board_cell),a

    ld hl,title
    ld bc,$0000
    call sonic_depack


    ld hl,title_map
    ld de,$3800 | VRAMWrite
    call STM_tilemap_decompr


    // Turn screen on
    call ScreenOn


    ei
    ld hl,PaletteData
    call FadeInScreen

    ld hl,title_music
    call PSGPlayNoRepeat


    // main routine here

    // wait for press one
  -; halt
    call PSGFrame
    ld a,(controller)
    bit 4,a
    jr nz,-

    call PSGStop

    ld hl,PaletteData
    call FadeOutScreen


    di
    ld hl,board
    ld bc,$0000
    call sonic_depack


    ld hl,numbers
    ld bc,$0E00
    call sonic_depack


    ld hl,board_map
    ld de,$3800 | VRAMWrite
    call STM_tilemap_decompr

    call GenerateBoardData
    call DisplayTable
    ei


    ld hl,PaletteData
    call FadeInScreen

  -; halt
    call PSGFrame
    call Cursor
    call OnePress
    call TwoPress
    call DisplayBoard
    call DisplayTable
    call CheckData
    jr -



CheckData:
    ld hl,board_dat+81
    ex de,hl
    ld hl,board_dat
    ld bc,81

  -; ld a,(hl)
    push bc
    ld b,a
    ex de,hl
    ld a,(hl)
    ex de,hl
    cp b
    jr nz,++
    pop bc
    dec bc
    inc hl
    inc de
    ld a,b
    or c
    jr nz,-



    // They won!
    call PSGStop

    ld hl,PaletteData
    call FadeOutScreen


    di
    ld hl,complete
    ld bc,$0000
    call sonic_depack


    ld hl,complete_map
    ld de,$3800 | VRAMWrite
    call STM_tilemap_decompr
    ei

    ld hl,PaletteData
    call FadeInScreen


  -; halt
    call PSGFrame
    ld a,(controller)
    bit 4,a
    jr z,+
    jr -
  +; ld hl,PaletteData
    call FadeOutScreen
    call ScreenOff
    call PSGStop
    jp $0000
  +; pop bc
    ret



BCtoHL:
    push af
    ld a,b
    ld h,a
    ld a,c
    ld l,a
    pop af
    ret

fill $8000 - origin()
