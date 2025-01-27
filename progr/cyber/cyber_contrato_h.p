/* cyber/cyber_contrato_h.p      */
{admcab.i}
def input parameter par-rec as recid.
find cyber_contrato where recid(cyber_contrato) = par-rec no-lock.

def var recatu1         as recid.
def var reccont         as int.
def var esqpos1         as int.
def var esqascend       as log.
def var esqcom1         as char format "x(13)" extent 5
        init  [" Consulta ","Consulta Lote",""].

def buffer bcyber_contrato_h       for cyber_contrato_h.

form
    esqcom1
    with frame f-com1 row 5 no-box no-labels column 1 centered.
assign
    esqpos1  = 1.
    
form
        cyber_contrato_h.clicod
        cyber_contrato_h.contnum
        with frame frame-a.

bl-princ:
repeat:
    disp esqcom1 with frame f-com1.
    if recatu1 = ?
    then
        run leitura (input "pri").
    else
        find cyber_contrato_h where recid(cyber_contrato_h) = recatu1 no-lock.
    if not available cyber_contrato_h
    then do.
        message "Sem registros" view-as alert-box.
        leave.
    end.
    clear frame frame-a all no-pause.
        run frame-a.

    recatu1 = recid(cyber_contrato_h).
    color display message esqcom1[esqpos1] with frame f-com1.
    repeat:
        run leitura (input "seg").
        if not available cyber_contrato_h
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down
            with frame frame-a.
        run frame-a.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        find cyber_contrato_h where recid(cyber_contrato_h) = recatu1 no-lock.

        status default "".
        run color-message.
        choose field cyber_contrato_h.DtEnvio help ""
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      PF4 F4 ESC return) .
        run color-normal.
        status default "".

            if keyfunction(lastkey) = "cursor-right"
            then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 5 then 5 else esqpos1 + 1.
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
                    if not avail cyber_contrato_h
                    then leave.
                    recatu1 = recid(cyber_contrato_h).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail cyber_contrato_h
                    then leave.
                    recatu1 = recid(cyber_contrato_h).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail cyber_contrato_h
                then next.
                color display white/red cyber_contrato_h.DtEnvio with frame frame-a.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail cyber_contrato_h
                then next.
                color display white/red cyber_contrato_h.DtEnvio with frame frame-a.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return"
        then do:
            form cyber_contrato_h
                 with frame f-cyber_contrato_h color black/cyan
                      centered side-label row 7 1 col.
            hide frame frame-a no-pause.
                display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                        with frame f-com1.

                if esqcom1[esqpos1] = "Consulta Lote" 
                then do with frame f-cyber_contrato_h on error undo.
                    find lotcre of cyber_contrato_h no-lock no-error.
                    if avail lotcre
                    then run cyber/lotcre_cyber.p (recid(lotcre)).
                    recatu1 = recid(cyber_contrato_h).
                    leave.
                end.
                if esqcom1[esqpos1] = " Consulta "
                then do with frame f-cyber_contrato_h.
                    disp cyber_contrato_h.
                end.
        end.
        run frame-a.
        display esqcom1[esqpos1] with frame f-com1.
        recatu1 = recid(cyber_contrato_h).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame frame-a no-pause.

procedure frame-a.
    find lotcre of cyber_contrato_h no-lock no-error.
    if avail lotcre
    then find lotcretp of lotcre no-lock no-error.
    display
        cyber_contrato_h.clicod column-label "Cliente"
        cyber_contrato_h.contnum
        cyber_contrato_h.dtenvio
        string(cyber_contrato_h.HrEnvio,"HH:MM") no-label   format "x(5)"
        cyber_contrato_h.LtCreCod column-label "Lote"
        lotcretp.LtCreTNom   format "x(25)" when avail lotcretp
        with frame frame-a 11 down centered color white/red row 6.
end procedure.


procedure color-message.
color display message
        cyber_contrato_h.DtEnvio
        with frame frame-a.
end procedure.


procedure color-normal.
color display normal
        cyber_contrato_h.DtEnvio
        with frame frame-a.
end procedure.


procedure leitura . 
def input parameter par-tipo as char.
        
if par-tipo = "pri" 
then  
    if esqascend  
    then  
        find first cyber_contrato_h where of cyber_contrato
                            use-index cyber_contrato_h3
                                                no-lock no-error.
    else  
        find last cyber_contrato_h  where of cyber_contrato
                            use-index cyber_contrato_h3
                                                 no-lock no-error.
                                             
if par-tipo = "seg" or par-tipo = "down" 
then  
    if esqascend  
    then  
        find next cyber_contrato_h  where of cyber_contrato
                            use-index cyber_contrato_h3
                                                no-lock no-error.
    else  
        find prev cyber_contrato_h   where of cyber_contrato
                            use-index cyber_contrato_h3
                                                no-lock no-error.
             
if par-tipo = "up" 
then                  
    if esqascend   
    then   
        find prev cyber_contrato_h where of cyber_contrato  
                            use-index cyber_contrato_h3
                                        no-lock no-error.
    else   
        find next cyber_contrato_h where of cyber_contrato 
                            use-index cyber_contrato_h3
                                        no-lock no-error.
        
end procedure.
         
