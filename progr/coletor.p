/*
*
*    Esqueletao de Programacao
*
*/
{admcab.i}
def var vtotest         as int.
def var vtotqtd         as int.
def var vdif            as char.
def var vest            like estoq.estatual.
def var vetbcod         like estab.etbcod.
def var vdata           like plani.pladat.
def var reccont         as int.
def var vinicio         as log.
def var recatu1         as recid.
def var recatu2         as recid.
def var esqpos1         as int.
def var esqpos2         as int.
def var esqregua        as log.
def var esqcom1         as char format "x(12)" extent 5
            initial ["Inclusao","Alteracao","Exclusao","Procura","Listagem"].
def var esqcom2         as char format "x(12)" extent 5
            initial ["","","","",""].


def buffer bcoletor       for coletor.
def var vprocod         like coletor.procod.


    form
        esqcom1
            with frame f-com1
                 row 3 no-box no-labels side-labels centered.
    form
        esqcom2
            with frame f-com2
                 row screen-lines no-box no-labels side-labels column 1.
    esqregua  = yes.
    esqpos1  = 1.
    esqpos2  = 1.
repeat:

    vtotqtd = 0.
    vtotest = 0.
    update vetbcod label "Filial"
           vdata   label "Data Confronto" 
                with frame f-1 side-label width 80.

    
    for each coletor where coletor.etbcod = vetbcod and
                           coletor.coldat = vdata no-lock.
    
        vtotqtd = vtotqtd + coletor.colqtd.
        
    end.
    
bl-princ:
repeat:

    disp esqcom1 with frame f-com1.
    disp esqcom2 with frame f-com2.
    if recatu1 = ?
    then
        find first coletor where coletor.etbcod = vetbcod and
                                 coletor.coldat = vdata no-error.
    else
        find coletor where recid(coletor) = recatu1.
    vinicio = yes.
    if not available coletor
    then do:
        message "Nenhum coletor para esta filial".
        pause .
        undo, retry.
    end.
    clear frame frame-a all no-pause.
    find produ where produ.procod = coletor.procod no-lock.
    

    if coletor.coldec > 0
    then assign vest = coletor.coldec + coletor.colqtd
                vdif = "Sobra " + string(coletor.coldec).
    
    if coletor.colacr > 0
    then assign vest = coletor.colqtd - coletor.colacr
                vdif = "Falta " + string(coletor.colacr).
    
    
    if coletor.colacr = 0 and
       coletor.coldec = 0
    then assign vest = coletor.colqtd
                vdif = "".

    
    
    
    display "TOTAIS...."
            vtotest no-label  to 42 format "-zzzz9"
            vtotqtd no-label  to 48 format "zzzz9"
                with frame f-tot 
                    side-label color 
                        message row 21 no-box width 74 centered.
     
    display coletor.procod column-label "Codigo"
            produ.pronom format "x(30)"
            vest column-label "Qtd." format "->>>>9"
            coletor.colqtd column-label "Dig." format ">>>>9"
            coletor.colacr format ">>>>>>9"
                        when colacr > 0 column-label "Acr."
            coletor.coldec format ">>>>>>9"
                        when coldec > 0 column-label "Dec."
            vdif column-label "Dif" format "x(11)"           
                with frame frame-a 13 down centered.

    
    
    recatu1 = recid(coletor).
    color display message
        esqcom1[esqpos1]
            with frame f-com1.
    repeat:
        find next coletor where coletor.etbcod = vetbcod and
                                coletor.coldat = vdata.
        if not available coletor
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        if vinicio
        then down
            with frame frame-a.
        find produ where produ.procod = coletor.procod no-lock.
        
        if coletor.coldec > 0
        then assign vest = coletor.coldec + coletor.colqtd
                    vdif = "Sobra " + string(coletor.coldec).
    
        if coletor.colacr > 0
        then assign vest = coletor.colqtd - coletor.colacr
                    vdif = "Falta " + string(coletor.colacr).
    
    
        if coletor.colacr = 0 and
           coletor.coldec = 0
        then assign vest = coletor.colqtd
                    vdif = "".

        
        
        display vtotest 
                vtotqtd with frame f-tot. 
     
    
        
        display coletor.procod
                produ.pronom 
                vest  
                coletor.colqtd 
                coletor.colacr when colacr > 0  
                coletor.coldec when coldec > 0
                vdif
                with frame frame-a.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        find coletor where recid(coletor) = recatu1.

        choose field coletor.procod
            go-on(cursor-down cursor-up
                  cursor-left cursor-right
                  page-down page-up
                  tab PF4 F4 ESC return).
        if keyfunction(lastkey) = "TAB"
        then do:
            if esqregua
            then do:
                color display normal
                    esqcom1[esqpos1]
                    with frame f-com1.
                color display message
                    esqcom2[esqpos2]
                    with frame f-com2.
            end.
            else do:
                color display normal
                    esqcom2[esqpos2]
                    with frame f-com2.
                color display message
                    esqcom1[esqpos1]
                    with frame f-com1.
            end.
            esqregua = not esqregua.
        end.
        if keyfunction(lastkey) = "cursor-right"
        then do:
            if esqregua
            then do:
                color display normal
                    esqcom1[esqpos1]
                    with frame f-com1.
                esqpos1 = if esqpos1 = 5
                          then 5
                          else esqpos1 + 1.
                color display messages
                    esqcom1[esqpos1]
                    with frame f-com1.
            end.
            else do:
                color display normal
                    esqcom2[esqpos2]
                    with frame f-com2.
                esqpos2 = if esqpos2 = 5
                          then 5
                          else esqpos2 + 1.
                color display messages
                    esqcom2[esqpos2]
                    with frame f-com2.
            end.
            next.
        end.

        if keyfunction(lastkey) = "page-down"
        then do:
            do reccont = 1 to frame-down(frame-a):
                find next coletor where coletor.etbcod = vetbcod and
                                        coletor.coldat = vdata no-error.
                if not avail coletor
                then leave.
                recatu1 = recid(coletor).
            end.
            leave.
        end.
        if keyfunction(lastkey) = "page-up"
        then do:
            do reccont = 1 to frame-down(frame-a):
                find prev coletor where coletor.etbcod = vetbcod and
                                        coletor.coldat = vdata no-error.
                if not avail coletor
                then leave.
                recatu1 = recid(coletor).
            end.
            leave.
        end.


        if keyfunction(lastkey) = "cursor-left"
        then do:
            if esqregua
            then do:
                color display normal
                    esqcom1[esqpos1]
                    with frame f-com1.
                esqpos1 = if esqpos1 = 1
                          then 1
                          else esqpos1 - 1.
                color display messages
                    esqcom1[esqpos1]
                    with frame f-com1.
            end.
            else do:
                color display normal
                    esqcom2[esqpos2]
                    with frame f-com2.
                esqpos2 = if esqpos2 = 1
                          then 1
                          else esqpos2 - 1.
                color display messages
                    esqcom2[esqpos2]
                    with frame f-com2.
            end.
            next.
        end.
        if keyfunction(lastkey) = "cursor-down"
        then do:
            find next coletor where coletor.etbcod = vetbcod and
                                    coletor.coldat = vdata no-error.
            if not avail coletor
            then next.
            color display normal
                coletor.procod.
            if frame-line(frame-a) = frame-down(frame-a)
            then scroll with frame frame-a.
            else down with frame frame-a.
        end.
        if keyfunction(lastkey) = "cursor-up"
        then do:
            find prev coletor where coletor.etbcod = vetbcod and
                                    coletor.coldat = vdata no-error.
            if not avail coletor
            then next.
            color display normal
                coletor.procod.
            if frame-line(frame-a) = 1
            then scroll down with frame frame-a.
            else up with frame frame-a.
        end.
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return"
        then do on error undo, retry on endkey undo, leave.
        hide frame frame-a no-pause.

          if esqregua
          then do:
            display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                with frame f-com1.

            if esqcom1[esqpos1] = "Inclusao"
            then do with frame f-inclui overlay row 6 1 column centered.
                create coletor.
                update produ.pronom
                       coletor.procod.
                recatu1 = recid(coletor).
                leave.
            end.
            if esqcom1[esqpos1] = "Alteracao"
            then do with frame f-altera overlay row 6 1 column centered.
                update coletor with frame f-altera no-validate.
            end.
            if esqcom1[esqpos1] = "Procura"
            then do with frame f-procura overlay row 6 1 column centered.
                update vprocod label "Produto".
                find coletor where coletor.etbcod = vetbcod and
                                   coletor.coldat = vdata   and
                                   coletor.procod = vprocod no-lock no-error.
                if not avail coletor
                then do:
                    message "Produto nao encontrado".
                    pause.
                end.
                else recatu1 = recid(coletor).
                leave.
                
                    
                                   
                disp coletor with frame f-consulta no-validate.
            end.
            if esqcom1[esqpos1] = "Exclusao"
            then do with frame f-exclui overlay row 6 1 column centered.
                message "Confirma Exclusao de" produ.pronom update sresp.
                if not sresp
                then leave.
                find next coletor where coletor.etbcod = vetbcod and
                                        coletor.coldat = vdata no-error.
                if not available coletor
                then do:
                    find coletor where recid(coletor) = recatu1.
                    find prev coletor where coletor.etbcod = vetbcod and
                                            coletor.coldat = vdata no-error.
                end.
                recatu2 = if available coletor
                          then recid(coletor)
                          else ?.
                find coletor where recid(coletor) = recatu1.
                delete coletor.
                recatu1 = recatu2.
                leave.
            end.
            if esqcom1[esqpos1] = "Listagem"
            then do with frame f-Lista overlay row 6 1 column centered.
                message "Confirma Impressao de coletoridades " update sresp.
                if not sresp
                then leave.
                recatu2 = recatu1.
                output to printer.
                for each coletor:
                    display coletor.
                end.
                output close.
                recatu1 = recatu2.
                leave.
            end.
    
          end.
          else do:
            display caps(esqcom2[esqpos2]) @ esqcom2[esqpos2]
                with frame f-com2.
            message esqregua esqpos2 esqcom2[esqpos2].
            pause.
          end.
          view frame frame-a .
        end.
        if keyfunction(lastkey) = "end-error"
        then view frame frame-a.
        find produ where produ.procod = coletor.procod no-lock.
        
        if coletor.coldec > 0
        then assign vest = coletor.coldec + coletor.colqtd
                    vdif = "Sobra " + string(coletor.coldec).
    
        if coletor.colacr > 0
        then assign vest = coletor.colqtd - coletor.colacr
                    vdif = "Falta " + string(coletor.colacr).
    
    
        if coletor.colacr = 0 and
           coletor.coldec = 0
        then assign vest = coletor.colqtd
                    vdif = "".

        
         display vtotest 
                 vtotqtd with frame f-tot. 
     
         display coletor.procod 
                 produ.pronom  
                 vest   
                 coletor.colqtd  
                 coletor.colacr when colacr > 0   
                 coletor.coldec when coldec > 0  
                 vdif 
                    with frame frame-a.

        if esqregua
        then display esqcom1[esqpos1] with frame f-com1.
        else display esqcom2[esqpos2] with frame f-com2.
        recatu1 = recid(coletor).
   end.
end.
end.
