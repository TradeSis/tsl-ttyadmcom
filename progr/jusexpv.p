
{admcab.i}

def var recatu1         as recid.
def var recatu2         as recid.
def var reccont         as int.
def var esqpos1         as int.
def var esqpos2         as int.
def var esqregua        as log.
def var esqvazio        as log.
def var esqascend     as log initial yes.
def var esqcom1         as char format "x(12)" extent 5
    initial [" Inclusao "," Alteracao "," Consulta ","",""].
def var esqcom2         as char format "x(12)" extent 5
            initial [" "," ","","",""].
def var esqhel1         as char format "x(80)" extent 5
    initial [" Inclusao  de jusexpv ",
             " Alteracao da jusexpv ",
             " Exclusao  da jusexpv ",
             " Consulta  da jusexpv ",
             " Listagem  Geral de jusexpv "].
def var esqhel2         as char format "x(12)" extent 5
   initial ["  ",
            " ",
            " ",
            " ",
            " "].


def buffer bjusexpv       for jusexpv.


form
    esqcom1
    with frame f-com1
                 row 4 no-box no-labels side-labels column 1 centered.
form
    esqcom2
    with frame f-com2
                 row screen-lines no-box no-labels side-labels column 1
                 centered.
assign
    esqregua = yes
    esqpos1  = 1
    esqpos2  = 1.

bl-princ:
repeat:

    disp esqcom1 with frame f-com1.
    disp esqcom2 with frame f-com2.
    if recatu1 = ?
    then
        run leitura (input "pri").
    else
        find jusexpv where recid(jusexpv) = recatu1 no-lock.
    if not available jusexpv
    then esqvazio = yes.
    else esqvazio = no.
    clear frame frame-a all no-pause.
    if not esqvazio
    then do:
        run frame-a.
    end.

    recatu1 = recid(jusexpv).
    if esqregua
    then color display message esqcom1[esqpos1] with frame f-com1.
    else color display message esqcom2[esqpos2] with frame f-com2.
    if not esqvazio
    then repeat:
        run leitura (input "seg").
        if not available jusexpv
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down
            with frame frame-a.
        run frame-a.
    end.
    if not esqvazio
    then up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        if not esqvazio
        then do:
            find jusexpv where recid(jusexpv) = recatu1 no-lock.

            /*status default
                if esqregua
                then esqhel1[esqpos1] + if esqpos1 > 1 and
                                           esqhel1[esqpos1] <> ""
                                        then  string(jusexpv.<tab>nom)
                                        else ""
                else esqhel2[esqpos2] + if esqhel2[esqpos2] <> ""
                                        then string(jusexpv.<tab>nom)
                                        else "".*/
                                        
            run color-message.
            
            choose field jusexpv.juscod 
                         jusexpv.jusdes
                help ""
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      tab PF4 F4 ESC return).

            run color-normal.
            
            status default "".

        end.
            if keyfunction(lastkey) = "TAB"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    color display message esqcom2[esqpos2] with frame f-com2.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    color display message esqcom1[esqpos1] with frame f-com1.
                end.
                esqregua = not esqregua.
            end.
            if keyfunction(lastkey) = "cursor-right"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 5 then 5 else esqpos1 + 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    esqpos2 = if esqpos2 = 5 then 5 else esqpos2 + 1.
                    color display messages esqcom2[esqpos2] with frame f-com2.
                end.
                next.
            end.
            if keyfunction(lastkey) = "cursor-left"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 1 then 1 else esqpos1 - 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    esqpos2 = if esqpos2 = 1 then 1 else esqpos2 - 1.
                    color display messages esqcom2[esqpos2] with frame f-com2.
                end.
                next.
            end.
            if keyfunction(lastkey) = "page-down"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "down").
                    if not avail jusexpv
                    then leave.
                    recatu1 = recid(jusexpv).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail jusexpv
                    then leave.
                    recatu1 = recid(jusexpv).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail jusexpv
                then next.
                color display white/red jusexpv.juscod
                                        jusexpv.jusdes 
                                        with frame frame-a.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail jusexpv
                then next.
                color display white/red jusexpv.juscod
                                        jusexpv.jusdes with frame frame-a.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return" or esqvazio
        then do:

            form skip(1) space(3)
                 jusexpv.juscod label "Codigo......." skip
                 space(3) jusexpv.jusdes label "Justificativa"
                 space(3) skip(1)
                 with frame f-jusexpv  centered side-label row 8.
                      
            hide frame frame-a no-pause.
            if esqregua
            then do:
                display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                        with frame f-com1.

                if esqcom1[esqpos1] = " Inclusao " or esqvazio
                then do with frame f-jusexpv on error undo.
                    
                    find last bjusexpv no-lock no-error.
                    
                    create jusexpv.

                    if avail bjusexpv
                    then jusexpv.juscod = bjusexpv.juscod + 1.
                    else jusexpv.juscod = 1.

                    disp   jusexpv.juscod.
                    update jusexpv.jusdes.
                           
                    jusexpv.exportado = no.
                           
                    recatu1 = recid(jusexpv).
                    leave.
                end.
                if esqcom1[esqpos1] = " Consulta " or
                   esqcom1[esqpos1] = " Exclusao " or
                   esqcom1[esqpos1] = " Alteracao "
                then do with frame f-jusexpv.
                    disp jusexpv.juscod
                         jusexpv.jusdes.
                end.
                if esqcom1[esqpos1] = " Alteracao "
                then do with frame f-jusexpv on error undo.
                    find jusexpv where
                            recid(jusexpv) = recatu1 
                        exclusive.
                    update /*jusexpv.juscod*/
                           jusexpv.jusdes.
                    jusexpv.exportado = no.
                end.

                /**
                if esqcom1[esqpos1] = " Exclusao "
                then do with frame f-exclui  row 5 1 column centered
                        on error undo.
                    message "Confirma Exclusao de" jusexpv.<tab>nom
                            update sresp.
                    if not sresp
                    then undo, leave.
                    find next jusexpv where true no-error.
                    if not available jusexpv
                    then do:
                        find jusexpv where recid(jusexpv) = recatu1.
                        find prev jusexpv where true no-error.
                    end.
                    recatu2 = if available jusexpv
                              then recid(jusexpv)
                              else ?.
                    find jusexpv where recid(jusexpv) = recatu1
                            exclusive.
                    delete jusexpv.
                    recatu1 = recatu2.
                    leave.
                end.
                
                if esqcom1[esqpos1] = " Listagem "
                then do with frame f-Lista:
                    update "Deseja Imprimir todas ou a selecionada "
                           sresp format "Todas/Selecionada"
                                 help "Todas/Selecionadas"
                           with frame f-lista row 15 centered color black/cyan
                                 no-label.
                    if sresp
                    then run ljusexpv.p (input 0).
                    else run ljusexpv.p (input jusexpv.<tab>cod).
                    leave.
                end.**/
                
            end.
            else do:
                display caps(esqcom2[esqpos2]) @ esqcom2[esqpos2]
                        with frame f-com2.
                if esqcom2[esqpos2] = "  "
                then do:
                    hide frame f-com1  no-pause.
                    hide frame f-com2  no-pause.
                    /* run programa de relacionamento.p (input ). */
                    view frame f-com1.
                    view frame f-com2.
                end.
                leave.
            end.
        end.
        if not esqvazio
        then do:
            run frame-a.
        end.
        if esqregua
        then display esqcom1[esqpos1] with frame f-com1.
        else display esqcom2[esqpos2] with frame f-com2.
        recatu1 = recid(jusexpv).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame f-com2  no-pause.
hide frame frame-a no-pause.

procedure frame-a.
    display jusexpv.juscod column-label "Codigo"
            jusexpv.jusdes column-label "Justificativa"
            with frame frame-a 11 down centered color white/red row 5.
end procedure.
procedure color-message.
    color display message
            jusexpv.juscod
            jusexpv.jusdes
            with frame frame-a.
end procedure.
procedure color-normal.
    color display normal
            jusexpv.juscod
            jusexpv.jusdes
            with frame frame-a.
end procedure.




procedure leitura . 
def input parameter par-tipo as char.
        
if par-tipo = "pri" 
then  
    if esqascend  
    then  
        find first jusexpv where true
                                                no-lock no-error.
    else  
        find last jusexpv  where true
                                                 no-lock no-error.
                                             
if par-tipo = "seg" or par-tipo = "down" 
then  
    if esqascend  
    then  
        find next jusexpv  where true
                                                no-lock no-error.
    else  
        find prev jusexpv   where true
                                                no-lock no-error.
             
if par-tipo = "up" 
then                  
    if esqascend   
    then   
        find prev jusexpv where true  
                                        no-lock no-error.
    else   
        find next jusexpv where true 
                                        no-lock no-error.
        
end procedure.
         
