; main file to nicklausw's
; sudoku game

.include "header.i"

.bank 0 slot 0
.section "notes" free
notes: .incbin "docs\notes.txt"
.db 0
.ends



.ramsection "ram" bank 0 slot 1
    controller db

    timer1 db
    timer2 db

    rand db

    board_cell db
    board_temp dw
    board_dat dsb 162
    board_ava dsb 81
    board_loc dw

    highlight dw
    h_temp dw

    disp_mode db
    table_h db
    table_rc dw
.ends



.org $00
.section "begin" force
    di
    im 1
    ld sp,$dfff
    jp setup
.ends


.org $38
.section "interrupt" force
    push af
    in a,$bf
    pop af
    call ctrlr_handle
    call inc_rand
    call timer
    ei
    reti
.ends


.org $66
.section "pause" force
    retn
.ends


.section "ctrlr_handle" free
ctrlr_handle:
    push af
    in a,$dc
    ld [controller],a
    pop af
    ret
.ends



.section "inc_rand" free
inc_rand:
    push af
    push bc
    ld a,[rand]
    inc a
    ld b,a
    ld a,r
    adc a,b
    ld b,a
    ld a,[timer1]
    adc a,b
    ld [rand],a
    pop bc
    pop af
    ret
.ends



.section "timer" free
timer:
    ld a,[timer1]
    cp 60
    jr z,+
    inc a
    ld [timer1],a
    jr ++
    +: xor a
    ld [timer1],a
    ld a,[timer2]
    inc a
    ld [timer2],a
    ++: ret
.ends



.section "setup" free
setup:
    call VDPStuff
    call PSGInit

    ; Clear RAM
    ld hl,$c000
    ld bc,$e000
    -: xor a
    ld [hl],a
    inc hl
    ld a,h
    cp $e0
    jr nz,-


    ld hl,$0000 | VRAMWrite
    call SetVDP
    ld bc,$4000
    -: xor a
    out (VDPData),a
    dec bc
    ld a,b
    or c
    jr nz, -


    ld hl,$0909
    ld [highlight],hl
    ld a,1
    ld [board_cell],a

    ld hl,title
    ld bc,$0000
    call sonic_depack


    ld hl,title_map
    ld de,$3800 | VRAMWrite
    call STM_tilemap_decompr


    ; Turn screen on
    call ScreenOn


    ei
    ld hl,PaletteData
    call FadeInScreen

    ld hl,title_music
    call PSGPlayNoRepeat


    jp main
.ends



.section "main" free
main:
    ; wait for press one
    -: halt
    call PSGFrame
    ld a,[controller]
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
    ld bc,$E00
    call sonic_depack


    ld hl,board_map
    ld de,$3800 | VRAMWrite
    call STM_tilemap_decompr

    call GenerateBoardData
    call DisplayTable
    ei


    ld hl,PaletteData
    call FadeInScreen

    -: halt
    call PSGFrame
    call Cursor
    call OnePress
    call TwoPress
    call DisplayBoard
    call DisplayTable
    call CheckData
    jr -
.ends



.section "check data"
CheckData:
    ld hl,board_dat+81
    ex de,hl
    ld hl,board_dat
    ld bc,81

    -: ld a,[hl]
    push bc
    ld b,a
    ex de,hl
    ld a,[hl]
    ex de,hl
    cp b
    jr nz,+
    pop bc
    dec bc
    inc hl
    inc de
    ld a,b
    or c
    jr nz,-



    ; They won!
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


    -: halt
    call PSGFrame
    ld a,[controller]
    bit 4,a
    jr z,++
    jr -
    ++: ld hl,PaletteData
    call FadeOutScreen
    call ScreenOff
    call PSGStop
    jp $0000
    +: pop bc
    ret
.ends



.section "BC to HL" free
BCtoHL:
    push af
    ld a,b
    ld h,a
    ld a,c
    ld l,a
    pop af
    ret
.ends