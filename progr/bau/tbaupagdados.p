/* medico na tela 042022 - helio */

{admcab.i}
def input param precid as recid.
def var vhrinc as char column-label "hora".
def var vhelp as char.
def var xtime as int.
def var vconta as int.
def var recatu1         as recid.
def var recatu2     as reci.
def var reccont         as int.
def var esqpos1         as int.
def var esqcom1         as char format "x(11)" extent 6
    initial ["","",""].

form
    esqcom1
    with frame f-com1 row 5 no-box no-labels column 1 centered.

assign
    esqpos1  = 1.

def var vsel as int.
def var vabe as dec.


def var vvlcobrado   as dec.
    form  
        baupagdados.idcampo skip space(15)
        baupagdados.conteudo

        with frame frame-a 6 down  row 6 no-underline centered.



find baupagamento where recid(baupagamento) = precid no-lock.

disp 
    baupagamento.cpf baupagamento.idpagamento
        with frame ftit
            side-labels
            row 4
            centered
            no-box
            color messages.

bl-princ:
repeat:
    

    disp esqcom1 with frame f-com1.
    if recatu1 = ?
    then run leitura (input "pri").
    else find baupagdados where recid(baupagdados) = recatu1 no-lock.
    if not available baupagdados
    then do.
        message "nenhum registro encontrato".
        return.
        
    end.
    clear frame frame-a all no-pause.
    run frame-a.

    recatu1 = recid(baupagdados).
    color display message esqcom1[esqpos1] with frame f-com1.
    repeat:
        run leitura (input "seg").
        if not available baupagdados
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down with frame frame-a.
        run frame-a.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        find baupagdados where recid(baupagdados) = recatu1 no-lock.

        esqcom1[2] = "".

        
                        
                     
        def var vx as int.
        def var va as int.
        va = 1.
        do vx = 1 to 6.
            if esqcom1[vx] = ""
            then next.
            esqcom1[va] = esqcom1[vx].
            va = va + 1.  
        end.
        vx = va.
        do vx = va to 6.
            esqcom1[vx] = "".
        end.     
        
    hide message no-pause.

        
        
        disp esqcom1 with frame f-com1.
        
        run color-message.
/*        vhelp = "".
        
        status default vhelp. */
        choose field baupagdados.idcampo
                      help ""
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      L l
                      tab PF4 F4 ESC return).

        if keyfunction(lastkey) <> "return"
        then run color-normal.

        hide message no-pause.
                 
        pause 0. 

                                                                
            if keyfunction(lastkey) = "cursor-right"
            then do:
                color display normal esqcom1[esqpos1] with frame f-com1.
                esqpos1 = if esqpos1 = 6 then 6 else esqpos1 + 1.
                color display messages esqcom1[esqpos1] with frame f-com1.
                next.
            end.
            if keyfunction(lastkey) = "cursor-left"
            then do:
                color display normal esqcom1[esqpos1] with frame f-com1.
                esqpos1 = if esqpos1 = 1 then 1 else esqpos1 - 1.
                color display messages esqcom1[esqpos1] with frame f-com1.
                next.
            end.
            if keyfunction(lastkey) = "page-down"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "down").
                    if not avail baupagdados
                    then leave.
                    recatu1 = recid(baupagdados).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail baupagdados
                    then leave.
                    recatu1 = recid(baupagdados).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail baupagdados
                then next.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail baupagdados
                then next.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.
                
                
        if keyfunction(lastkey) = "return"
        then do:
            
            

                
             
        end. 
        
        run frame-a.
        display esqcom1[esqpos1] with frame f-com1.
        recatu1 = recid(baupagdados).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame frame-a no-pause.
hide frame ftit no-pause.
hide frame ftot no-pause.
return.
 
procedure frame-a.
  
        
    display  
        
        baupagdados.idcampo
        baupagdados.conteudo
 
        with frame frame-a.


end procedure.

procedure color-message.
    color display message
        baupagdados.idcampo
        baupagdados.conteudo
                    
        with frame frame-a.
end procedure.


procedure color-input.
    color display input
        baupagdados.idcampo
        baupagdados.conteudo
                     
        with frame frame-a.
end procedure.


procedure color-normal.
    color display normal
        baupagdados.idcampo
        baupagdados.conteudo
 
        with frame frame-a.
end procedure.

procedure leitura . 
def input parameter par-tipo as char.

    if par-tipo = "pri" 
    then do:
        find first baupagdados of baupagamento
            no-lock no-error.
    end.    
    if par-tipo = "seg" or par-tipo = "down" 
    then do:
        find next baupagdados of baupagamento
            no-lock no-error.
    end.    
    if par-tipo = "up" 
    then do:
        find prev baupagdados of baupagamento
            no-lock no-error.
    end.    

        
end procedure.





