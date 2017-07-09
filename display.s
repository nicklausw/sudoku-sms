DisplayBoard:
    xor a
    push af
    push hl
    push de

    ld hl,$7896
    call SetVDP

    ex de,hl
    ld hl,board_dat

    ld b,9
    ld c,9

  -; ex de,hl
    call SetVDP
    ex de,hl
    ld a,(hl)
    adc a,$70
    out (VDPData),a
    ld a,(highlight)
    cp b
    jr nz,+
    ld a,(highlight+1)
    cp c
    jr nz,+
    ld a,$08
    jr ++
  +; xor a
  +; out (VDPData),a
    inc hl

    inc de
    inc de
    inc de
    inc de

    dec c
    ld a,c
    cp 0
    jr nz,-

    ex de,hl
    push bc
    ld bc,$005c
    add hl,bc
    pop bc


    call SetVDP
    ex de,hl
    dec b
    ld c,9
    ld a,b
    cp 0
    jp nz,-

    pop de
    pop hl
    pop af
    ret


// bad argument names but I don't remember
// what this even does
macro table_m(one, two) {
    ld hl,{two}
    call SetVDP
    ld a,{one}
    out (VDPData),a
    ld a,(disp_mode)
    cp 1
    jr nz,+
    ld b,(({one})-($70))
    ld a,(table_h)
    cp b
    jr nz,+
    ld a,$08
    jr ++
  +; xor a
  +; out (VDPData),a
}


DisplayTable:
    push af
    push bc
    push hl
    table_m($71, $7b04)
    table_m($72, $7b08)
    table_m($73, $7b0c)
    table_m($74, $7b84)
    table_m($75, $7b88)
    table_m($76, $7b8c)
    table_m($77, $7c04)
    table_m($78, $7c08)
    table_m($79, $7c0c)
    pop hl
    pop bc
    pop af
    ret
