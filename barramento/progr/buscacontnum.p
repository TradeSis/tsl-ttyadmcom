def  input parameter p-etbcod as int.
def output parameter vcontnum as int.
def output parameter vstatus  as int.
 
        /* Numeracao Contratos **/
    do for geranum on error undo on endkey undo:
        find geranum where geranum.etbcod = 999
            exclusive-lock
            no-wait
            no-error.
        if not avail geranum
        then do:
            if not locked geranum
            then do:
                create geranum.
                assign
                    geranum.etbcod  = 999
                    geranum.clicod  = 300000000
                    geranum.contnum = 300000000.
                vstatus = 200.
            end.
            else do: /** LOCADO **/
                vcontnum = 0. 
                vstatus = 423.
            end.
        end.
        else do:
            geranum.contnum = geranum.contnum + 1.
            vstatus = 200.
        end.
        
        if vstatus = 200
        then do:
            vcontnum = geranum.contnum.
            find current geranum no-lock.
        end.
        
    end.  
