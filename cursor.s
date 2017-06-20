arch sms.cpu

macro wait_release(button) {
    push af
  -; halt
    call PSGFrame
    ld a,(controller)
    bit {button},a
    jr z,-
    pop af
}


scope TwoPress: {
    ld a,(controller)
    bit 5,a
    jr z,_yes
    ret

  _yes:; ld a,(board_cell)
    ld c,a
    xor a
    ld b,a
    ld hl,board_ava
    adc hl,bc
    ld a,(hl)
    cp 1
    jr z,_canchange
    ret

  _canchange:; xor a
    ld hl,board_dat
    adc hl,bc
    dec hl
    ld (hl),a
    ret
}



scope OnePress: {
    ld a,(controller)
    bit 4,a
    jr z,_yes
    ret

  _yes:;
    ld a,(board_cell)
    ld c,a
    xor a
    ld b,a
    ld hl,board_ava
    adc hl,bc
    ld a,(hl)
    cp 1
    jr z,_canchange
    call DisplayBoard
    ret

  _canchange:
    wait_release(4)
    ld a,1
    ld (table_h),a
    ld (disp_mode),a
    ld hl,$0101
    ld (table_rc),hl


  -; halt
    call PSGFrame
    call DisplayBoard
    call DisplayTable
    call TableCursor
    call Table_OnePress
    cp 1
    jr z,+
    jr -
  +; xor a
    call DisplayBoard
    ret
}



Table_OnePress:
    ld a,(controller)
    bit 4,a
    jr nz,+


    xor a
    ld (disp_mode),a
    ld a,(board_cell)
    ld c,a
    xor a
    ld b,a

    ld hl,board_dat-1
    adc hl,bc
    ld a,(table_h)
    ld (hl),a

    ld a,1
    wait_release(4)
    jr ++
  +; xor a
  +; ret



scope TableCursor: {
    ld a,(controller)

    bit 0,a
    call z,_up

    bit 1,a
    call z,_down

    bit 2,a
    call z,_left

    bit 3,a
    call z,_right

    ret



_up:; push af
    ld a,(table_rc)
    cp 1
    jr z,+
    dec a
    ld (table_rc),a
    ld a,(table_h)
    dec a
    dec a
    dec a
    ld (table_h),a
    call DisplayTable
  +; wait_release(0)
    pop af
    ret



_down:; push af
    ld a,(table_rc)
    cp 3
    jr z,+
    inc a
    ld (table_rc),a
    ld a,(table_h)
    inc a
    inc a
    inc a
    ld (table_h),a
    call DisplayTable
  +; wait_release(1)
    pop af
    ret



_left:; push af
    ld a,(table_rc+1)
    cp 1
    jr z,+
    dec a
    ld (table_rc+1),a
    ld a,(table_h)
    dec a
    ld (table_h),a
    call DisplayTable
  +; wait_release(2)
    pop af
    ret



_right:; push af
    ld a,(table_rc+1)
    cp 3
    jr z,+
    inc a
    ld (table_rc+1),a
    ld a,(table_h)
    inc a
    ld (table_h),a
    call DisplayTable
  +; wait_release(3)
    pop af
    ret
  }



scope Cursor: {
    ld a,(controller)

    bit 0,a
    call z,_up

    bit 1,a
    call z,_down

    bit 2,a
    call z,_left

    bit 3,a
    call z,_right

    ret

_up:; push af
    ld a,(highlight)
    cp 9
    jr z,+
    inc a
    ld (highlight),a
    ld a,(board_cell)
    or a; sbc a,9
    ld (board_cell),a
    call DisplayBoard
  +; wait_release(0)
    pop af
    ret


_down:; push af
    ld a,(highlight)
    cp 1
    jr z,+
    dec a
    ld (highlight),a
    ld a,(board_cell)
    add a,9
    ld (board_cell),a
    call DisplayBoard
  +;; wait_release(1)
    pop af
    ret


_left:; push af
    ld a,(highlight+1)
    cp 9
    jr z,+
    inc a
    ld (highlight+1),a
    ld a,(board_cell)
    dec a
    ld (board_cell),a
    call DisplayBoard
  +; wait_release(2)
    pop af
    ret


_right:; push af
    ld a,(highlight+1)
    cp 1
    jr z,+
    dec a
    ld (highlight+1),a
    ld a,(board_cell)
    inc a
    ld (board_cell),a
    call DisplayBoard
  +; wait_release(3)
    pop af
    ret
}
