{admcab.i}

def var vsenha as char format "x(10)".

update vsenha blank label "Senha"
       with frame f-senha centered side-labels. 
           
hide frame f-senha no-pause.

if vsenha = "score-drb"
then do:

run cred3.p.
if connected ("d")
then disconnect d.

end.
else leave.


/*
if opsys = "UNIX"
then do:
    /*connect /admcom/Claudir/teste -1 no-error.
      */
        run /admcom/desenv/credscore/cred3.p.
        end.
        else do:
            /*connect l:\Claudir\teste -1 no-error.
              */
                run l:\desenv\credscore\cred3.p.
                end.

                disconnect teste.
*/
