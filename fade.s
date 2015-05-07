; these fade effects were taken from the SMSPower! wiki.
; Changes: different palette handling and split into
; sections for "optimization".


; usage:
; ld hl,[palette]
; call FadeInScreen/FadeOutScreen

.section "fade in" free

FadeInScreen:
    ex de, hl

    halt                   ; wait for Vblank

    xor a
    out ($bf),a            ; palette index (0)
    ld a,$c0
    out ($bf),a            ; palette write identifier


    ld b,32                ; number of palette entries: 32 (full palette)
    call DEtoHL    ; source
 -: ld a,(hl)              ; load raw palette data
    and %00101010          ; modify color values: 3 becomes 2, 1 becomes 0
    srl a                  ; modify color values: 2 becomes 1
    out ($be),a            ; write modified data to CRAM
    inc hl
    djnz -

    ld b,4                 ; delay 4 frames
 -: halt
    djnz -

    ld b,32                ; number of palette entries: 32 (full palette)
    call DEtoHL   ; source
 -: ld a,(hl)              ; load raw palette data
    and %00101010          ; modify color values: 3 becomes 2, 1 becomes 0
    out ($be),a            ; write modified data to CRAM
    inc hl
    djnz -

    ld b,4                 ; delay 4 frames
 -: halt
    djnz -

    ld b,32                ; number of palette entries: 32 (full palette)
    call DEtoHL    ; source
 -: ld a,(hl)              ; load raw palette data
    out ($be),a            ; write unfodified data to CRAM, palette load complete
    inc hl
    djnz -

ret
.ends

;---------------------------------------------------------------------------------

.section "fade out" free
FadeOutScreen:
    ex de, hl

    halt                   ; wait for Vblank

    xor a
    out ($bf),a            ; palette index (0)
    ld a,$c0
    out ($bf),a            ; palette write identifier

    ld b,32                ; number of palette entries: 32 (full palette)
    call DEtoHL    ; source
 -: ld a,(hl)              ; load raw palette data
    and %00101010          ; modify color values: 3 becomes 2, 1 becomes 0
    out ($be),a            ; write modified data to CRAM
    inc hl
    djnz -

    ld b,4                 ; delay 4 frames
 -: halt
    djnz -

    ld b,32                ; number of palette entries: 32 (full palette)
    call DEtoHL    ; source
 -: ld a,(hl)              ; load raw palette data
    and %00101010          ; modify color values: 3 becomes 2, 1 becomes 0
    srl a                  ; modify color values: 2 becomes 1
    out ($be),a            ; write modified data to CRAM
    inc hl
    djnz -

    ld b,4                 ; delay 4 frames
 -: halt
    djnz -

    ld b, 32               ; number of palette entries: 32 (full palette)
    xor a                  ; we want to blacken the palette, so a is set to 0
 -: out ($be), a           ; write zeros to CRAM, palette fade complete
    djnz -

ret

.ends



.section "DEtoHL" free
DEtoHL:
    push af
    ld a,d
    ld h,a
    ld a,e
    ld l,a
    pop af
    ret
.ends
