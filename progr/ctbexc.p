{admcab.i}

def var vetbcod like estab.etbcod.
def var vmes    as int format "99".
def var vano    as int format "9999".
return.
repeat:
    /*
    vmes = 12.
    vano = year(today) - 1.
    */
    
    update vetbcod label "Filial" with frame f1 side-label width 80.
    if vetbcod = 0
    then display "GERAL" @ estab.etbnom with frame f1.
    else do:
        find estab where estab.etbcod = vetbcod no-lock.
        display estab.etbnom no-label with frame f1.
    end.
    update vmes label "MES"
           vano label "ANO" with frame f1.
    
    find first ctbhie where
               ctbhie.etbcod = vetbcod and
               ctbhie.ctbmes = vmes and
               ctbhie.ctbano = vano
               no-lock no-error.
    if not avail ctbhie
    then do:
        bell.
        message color red/with
         "Inventario n�o encontrado." 
         view-as alert-box
         .
        undo. 
    end. 
    
    message "Confirma Exclusao ?" update sresp.
    if not sresp
    then next.
    
    for each estab where if vetbcod = 0
                         then estab.etbcod > 0
                         else estab.etbcod = vetbcod no-lock:
    
        for each ctbhie where ctbhie.etbcod = estab.etbcod and
                              ctbhie.ctbmes = vmes         and
                              ctbhie.ctbano = vano:
            disp estab.etbcod
                 ctbhie.procod with frame f2 side-label centered.
            pause 0.
            delete ctbhie.
        end.            
    end.
end.         
   
