
[org 0x0100]

jmp start

row1: db 0x20 , 0x20 , 0x20
row2: db 0x20 , 0x20 , 0x20
row3: db 0x20 , 0x20 , 0x20
rcnum: db 0x31 , 0x32 , 0x33


turn_player1: db "Player 1 Turn, Sign: X"
turn_player2: db "Player 2 Turn, Sign: 0"
len_disp_players_turn: dw 22

invalidst: db "Invalid Input. Please Enter Again" , 0
len_inv: dw 34

inp1: db "Enter Row: " , 0
len_inp1: dw 12

inp2: db "Enter Column: " , 0
len_inp2: dw 15

chk_game: db 0
inv_inp: db 0

pl1_turn: db 1

pl1_wins: db "Player 1 Wins\./"
pl2_wins: db "Player 2 Wins\./"
drawn: db "Match Drawn" , 11
ress: db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; announcement display;;;;;;;;;;;;;;
Turn1P1:
    push ax
    push cx
    push si
    push es
    push di


    mov ax , 0xb800
    mov es , ax
    mov ah , 0x4F

    mov di , 0
    mov si , turn_player1

    mov cx ,[len_disp_players_turn]
    disp_player1_turn:
        mov al , [si]
        mov [es: di] , ax
        add si , 1
        add di , 2
        loop disp_player1_turn
		
	pop di
	pop es
	pop si
	pop cx
	pop ax
	ret

Turn2P2:
    push ax
    push cx
    push si
    push es
    push di


    mov ax , 0xb800
    mov es , ax
    mov ah , 0x4F

    mov di , 0
    mov si , turn_player2

    mov cx ,[len_disp_players_turn]
    disp_player2_turn:
        mov al , [si]
        mov [es: di] , ax
        add si , 1
        add di , 2
        loop disp_player2_turn
	pop di
	pop es
	pop si
	pop cx
	pop ax
	
	ret
EnterRow:
	push ax
    push cx
    push si
    push es
    push di


	mov ah , 0x4F
    mov cx , [len_inp1]
    mov si , inp1
    mov di , 160
    l1_inpt_game:
        mov al , [si]
        mov [es:di] , ax
        add si , 1
        add di , 2
        loop l1_inpt_game
	pop di
	pop es
	pop si
	pop cx
	pop ax
	ret
EnterColumn:
	push ax
    push cx
    push si
    push es
    push di


	mov ah , 0x4F
    mov cx , [len_inp2]
    mov si , inp2
    mov di , 320
    l2_inpt_game:
        mov al , [si]
        mov [es:di] , ax
        add si , 1
        add di , 2
        loop l2_inpt_game
	pop di
	pop es
	pop si
	pop cx
	pop ax
	ret
Invalid_Input:
	push ax
    push cx
    push si
    push es
    push di


    mov ax , 0xb800
    mov es , ax
    mov ah , 0xCF

    mov di , 680
    mov si , invalidst

    mov cx , [len_inv]
    InvInpt:
        mov al , [si]
        mov [es: di] , ax
        add si , 1
        add di , 2
        loop InvInpt
	pop di
	pop es
	pop si
	pop cx
	pop ax
	
	ret
Player1won:
	push ax
    push es
    push di
    push si
    push cx

    mov ax , 0xb800
    mov es , ax
	mov di , 3260         
    mov si , 0
	
	mov cx , 16
    mov ah , 0xCE
    P1win:
        mov al , [pl1_wins + si]
        add si , 1
        mov [es:di] , ax
        add di , 2
        loop P1win
	pop cx
	pop si
	pop di
	pop es
	pop ax
	ret
Player2won:
	push ax
    push es
    push di
    push si
    push cx

    mov ax , 0xb800
    mov es , ax
	mov di , 3200         ;; announcement display
    add di , 60
    mov si , 0
	
	mov cx , 16
    mov ah , 0xCE
    P2win:
        mov al , [pl2_wins + si]
        add si , 1
        mov [es:di] , ax
        add di , 2
        loop P2win
	pop cx
	pop si
	pop di
	pop es
	pop ax
	ret
PlayDrawn:
	push ax
    push es
    push di
    push si
    push cx

    mov ax , 0xb800
    mov es , ax
	mov di , 3200         ;; announcement display
    add di , 60
    mov si , 0
	
	mov cx , 11
    mov ah , 0xCE
    match_drawn:
        mov al , [drawn + si]
        add si , 1
        mov [es:di] , ax
        add di , 2
        loop match_drawn
	pop cx
	pop si
	pop di
	pop es
	pop ax
	ret
	
printgame:
;;;;;;;;;;;;;;;clear screen;;;;;;;;;;;;;;;;;;;
	push es
    push ax
    push cx
    push di
	push si

    mov  ax, 0xb800
    mov  es, ax

    xor  di, di
    
    mov  ax, 0x0720
    mov  cx, 2000

    cld
    rep stosw
	
	;;;;;;;;;;;;;;;;;;;;;;;;;Column Numbering;;;;;;;;;;;;;;;;;;;;
	mov si , rcnum
	mov di , 1178
	mov ah , 0x0F   ;;yellow    ;; col 1
	mov cx , 2
	num1:
	mov al , [si]
	mov [es:di] , ax
	
	add di , 16            ;; col 2
	add si , 1 
	mov al , [si]
	mov [es:di] , ax
	loop num1
    ;;;;;;;;;;;;;;;;;;;;;Row Numbering;;;;;;;;;;;;;;;;;;;;;;
	mov si , rcnum
	mov di , 1642              ;; row 1 , 2 , 3
	mov cx , 2
	num2:
	mov al  , [si]
	mov [es:di] , ax
	
	add di , 640  ; 6 rows down
	add si , 1                
	mov al , [si]
	mov [es:di] , ax
	
	loop num2

    ;;;;;;;;;;;;;;;;;;upper boundry;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov cx , 25
	mov di , 1330
	upper:
	mov word[es:di] , 0x04CD
	add di , 2
	loop upper
    ;;;;;;;;;;;;;;;;;;;;lower boundry;;;;;;;;;;;;;;;;
	mov cx , 25
	mov di , 3090
	lower:
	mov word[es:di] , 0x04CD
	add di , 2
	loop lower
    ;;;;;;;;;;;;;;upper left corner;;;;;;;;;;;;;;;;;;;;
	mov di , 1328
	mov word[es:di] , 0x04C9
    ;;;;;;;;;;;;;;upper right corner;;;;;;;;;;;;;;;
	mov di , 1380
	mov word[es:di] , 0x04BB
    ;;;;;;;;;;;;;lower left corner;;;;;;;;;;;;;;;;;;;
	mov di , 3088
	mov word[es:di] , 0x04C8
	;;;;;;;;;;;;lower right corner;;;;;;;;;;;;;;;;;;;
	 mov di , 3140
	 mov word[es:di] , 0x04BC
    ;;;;;;;;;;;;;;;;left boundry;;;;;;;;;;;;;;;
	mov cx , 10
	mov di , 1488
	left:
	mov word[es:di] , 0x04BA
	add di , 160
		loop left
	
    ;;;;;;;;;;;;;right boundary;;;;;;;;;;;;;;
		mov cx , 10
		mov di , 1540
		right:
		mov word[es:di] ,0x04BA
		add di , 160
		loop right
    ;;;;;;;;;;;;;;;;;;;;;;;;inner map;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov cx , 21
	mov di , 1974     ; 4 columns below the upper boundary and 6 cells next 
	maprow1:
	mov word[es:di] , 0x04CD
	add di , 2
	loop maprow1
	
	mov cx , 21
	mov di , 2614    ; 4 columns below the upper boundary and 6 cells next 
	maprow2:
	mov word[es:di] , 0x04CD
	add di , 2
	loop maprow2
	
	mov cx , 10
	mov di , 1506
	mapcol1:
	mov word[es:di] , 0x04BA
	add di , 160
		loop mapcol1
		
	mov cx , 10
	mov di , 1522
	mapcol2:
	mov word[es:di] , 0x04BA
	add di , 160
		loop mapcol2
	
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;row1;;;;;;;;;;;;;;;;;;;;;;;;;
	mov si , row1
	mov di , 1820
	mov ah , 0x0E
	  
	  
		mov al , [si]           
		mov word[es:di] , ax
	
		
		add si , 1
		add di , 14
		mov al ,[si]
		mov word[es:di] , ax
		
		add si , 1
		add di , 14
		mov al ,[si]
		mov word[es:di] , ax
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; row2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		mov di , 2300		
		
		mov si , row2
		mov ah , 0x0E
		
		mov al , [si]
		mov word[es:di] , ax
		
		add si , 1
		add di , 14
		mov al ,[si]
		mov word[es:di] , ax
		
		
		add si , 1
		add di , 14
		mov al ,[si]
		mov word[es:di] , ax
		
		;;;;;;;;;;;;;;;;;;;;;;;;; row3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		mov di , 2780
		
		
		mov si , row3
		mov ah , 0x0E
		
		mov al , [si]
		mov word[es:di] , ax
		
		
		
		add si , 1
		add di , 14
		mov al ,[si]
		mov word[es:di] , ax
		
	
		
		add si , 1
		add di , 14
		mov al ,[si]
		mov word[es:di] , ax
	
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
	
	
	
	
	pop si
	pop di
	pop cx
	pop ax
	pop es
	
	ret



input_game:
    push bp
    mov bp , sp
    sub sp , 4
    push ax
    push cx
    push dx
    push si
    push es
    push di

    mov ax , 0xb800
    mov es , ax
    mov ah , 0x4F

    mov di , 0

    cmp byte [inv_inp] , 0
    jz cont_inp_game

	call Invalid_Input
	
    mov byte [inv_inp] , 0

    cont_inp_game:
    
	call EnterRow

    mov ah , 0x1
    int 0x21

    cmp al , 0x31
    jb end__inpgame_inv_inp

    cmp al , 0x33
    ja end__inpgame_inv_inp

    mov ah , 0x4F
	mov di , 180
    mov [es:di] , ax

    mov ah , 0
    mov [bp - 2] , ax

    call EnterColumn

    mov ah , 0x1
    int 0x21

    cmp al , 0x31
    jb end__inpgame_inv_inp

    cmp al , 0x33
    ja end__inpgame_inv_inp

    mov ah , 0x4F
	mov di , 346
    mov [es:di] , ax

    mov ah , 0
    mov [bp - 4] , ax

    push word [bp - 2]
    push word [bp - 4]
    call check_inpt

    jmp end__correct_inpts_inpgame

    end__inpgame_inv_inp:
        mov byte [inv_inp] , 1
    
    end__correct_inpts_inpgame:
    pop di
    pop es
    pop si
    pop dx
    pop cx
    pop ax
    add sp , 4
    pop bp
    ret 14

check_inpt:
    push bp
    mov bp , sp
    push ax
    push cx
    push si

    mov ax , 3
    mov cx , [bp + 6]
    sub cx , 0x30
    dec cx
    
    mul cl

    mov cx , [bp + 4]
    sub cx , 0x30
    dec cx
    add ax , cx

    mov si , ax

    cmp byte [row1 + si] , 0x20
    jnz inv_inp__check_inpt

    cmp byte [pl1_turn] , 1
    jnz pl2_turn

        mov byte [row1 + si] , 0x58
        mov byte [pl1_turn] , 0
        jmp end__check_inpt

    pl2_turn:

        mov byte [row1 + si] , 0x4F
        mov byte [pl1_turn] , 1
        jmp end__check_inpt

    inv_inp__check_inpt:
        mov byte [inv_inp] , 1

    end__check_inpt
    pop si
    pop cx
    pop ax
    pop bp
    ret 4

    
check_game:
    push bp
    mov bp , sp
    sub sp , 4
    push cx

    mov cx , [bp + 4]
    cmp cx , 5
    ja no_need_to_check
    jmp need_to_check

    no_need_to_check:
        jmp end__checking

    need_to_check:
    mov word [bp - 2] , 0x58
    mov word [bp - 4] , 0
    mov ah , 0
    mov cx , 2
    m_loop_check_game:

        chk_1:
            mov word [bp - 4] , 0
            mov si , 0
            loop_chk1:
                mov al , [row1 + si]
                add si , 1
                cmp ax , [bp - 2]
                jnz chk_2
                add word [bp - 4] , 1
                cmp word [bp - 4] , 3
                jnz loop_chk1
                chk_1_sucess:
                    jmp end__checking

        chk_2:
            mov word [bp - 4] , 0
            mov si , 0
            loop_chk2:
                mov al , [row2 + si]
                add si , 1
                cmp ax , [bp - 2]
                jnz chk_3
                add word [bp - 4] , 1
                cmp word [bp - 4] , 3
                jnz loop_chk2
                chk_2_sucess:
                    jmp end__checking

        chk_3:
            mov word [bp - 4] , 0
            mov si , 0
            loop_chk3:
                mov al , [row3 + si]
                add si , 1
                cmp ax , [bp - 2]
                jnz chk_4
                add word [bp - 4] , 1
                cmp word [bp - 4] , 3
                jnz loop_chk3
                chk_3_sucess:
                    jmp end__checking

        chk_4:
            mov word [bp - 4] , 0
            mov si , 0
            loop_chk4:
                mov al , [row1 + si]
                add si , 3
                cmp ax , [bp - 2]
                jnz chk_5
                add word [bp - 4] , 1
                cmp word [bp - 4] , 3
                jnz loop_chk4
                chk_4_sucess:
                    jmp end__checking

        chk_5:
            mov word [bp - 4] , 0
            mov si , 1
            loop_chk5:
                mov al , [row1 + si]
                add si , 3
                cmp ax , [bp - 2]
                jnz chk_6
                add word [bp - 4] , 1
                cmp word [bp - 4] , 3
                jz end__checking
                jnz loop_chk5

        chk_6:
            mov word [bp - 4] , 0
            mov si , 2
            loop_chk6:
                mov al , [row1 + si]
                add si , 3
                cmp ax , [bp - 2]
                jnz chk_7
                add word [bp - 4] , 1
                cmp word [bp - 4] , 3
                jz end__checking
                jnz loop_chk6

        chk_7:
            mov word [bp - 4] , 0
            mov si , 0
            loop_chk7:
                mov al , [row1 + si]
                add si , 4
                cmp ax , [bp - 2]
                jnz chk_8
                add word [bp - 4] , 1
                cmp word [bp - 4] , 3
                jz end__checking
                jnz loop_chk7

        chk_8:
            mov word [bp - 4] , 0
            mov si , 2
            loop_chk8:
                mov al , [row1 + si]
                add si , 2
                cmp ax , [bp - 2]
                jnz end__checking
                add word [bp - 4] , 1
                cmp word [bp - 4] , 3
                jz end__checking
                jnz loop_chk8


        end__checking:
            cmp word [bp - 4] , 3
            jz end__chk_game
            mov word [bp - 4] , 0
            mov word [bp - 2] , 0x4F
            dec cx
            cmp cx , 0
            jz end__chk_game
        jmp m_loop_check_game

    end__chk_game:
    cmp word [bp - 4] , 0
    jz no__res

    cmp word [bp - 2] , 0x58
    jnz player2_won

        mov word [bp - 4] , 1
        jmp no__res

    player2_won:
        mov word [bp - 4] , 2

    no__res:
    mov ax , [bp - 4]
    pop cx
    add sp , 4
    pop bp
    ret 

announce_result:
    push bp
    mov bp , sp
    push ax

    mov ax , [bp + 4]
    cmp ax , 1
    jnz pl1_didnt_win

    call Player1won

    jmp end__announcing_result

    pl1_didnt_win:
    cmp ax , 2
    jnz pl2_didnt_win
	
	call Player2won
	
    jmp end__announcing_result

    pl2_didnt_win:
	
    call PlayDrawn

    end__announcing_result:
    
    pop ax
    pop bp
    ret 2


start:
mov cx , 9
m_loop_start:
    call printgame

    loop_inpt_start:
        cmp byte [pl1_turn] , 1
        jnz push_pl2_disp

            call Turn1P1
            jmp cont_inpt_start

        push_pl2_disp:
            call Turn2P2
        
        cont_inpt_start:
        push word [len_disp_players_turn]
        push word invalidst
        push word [len_inv]
        push word [len_inp2]
        push word inp2
        push word [len_inp1]
        push word inp1
        call input_game

        cmp byte [inv_inp] , 1
        jz loop_inpt_start

    push cx
    call check_game

    cmp ax , 0
    jnz end__start

    loop m_loop_start

end__start:
call printgame
push ax
call announce_result
mov ah , 0x1
int 0x21
mov ax , 0x4c00
int 0x21