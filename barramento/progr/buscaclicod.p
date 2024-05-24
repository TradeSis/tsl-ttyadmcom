/*Programa para gerar codigo de cliente */
def input  parameter p-etbcod as int.
def output parameter p-gera as int.

        do for geranum on error undo on endkey undo:
            /*** Numeracao para CLIENTES criados na matriz ***/
            find geranum where geranum.etbcod = p-etbcod exclusive no-error.
            if not avail geranum
            then do:
                create geranum.
                assign
                    geranum.etbcod  = p-etbcod
                    geranum.clicod  = 300000000
                    geranum.contnum = 300000000.
            end.
            p-gera = geranum.clicod. 
            geranum.clicod = geranum.clicod + 1.
            release geranum.
        end.
             