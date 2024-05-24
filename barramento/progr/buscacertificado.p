def input parameter p-etbcod       as int.
def input parameter p-codigoSeguro as char.
def output parameter vcertifi      as char.
def output parameter vstatus       as int.

def var vtpseguro  as int.
if p-codigoSeguro = "559910" or 
   p-codigoSeguro = "559911" or 
   p-codigoSeguro = "578790" or 
   p-codigoSeguro = "579359" 
then vtpseguro = 2.
else do:
    if p-codigoSeguro = "569131" 
    then vtpseguro = 3.
    else do:
        vstatus = 500.
        vcertifi = "0".
        return. 
    end.
end.    

do for geraseguro on error undo. 
    /* Gerar Numero do Certificado */ 
    
    find geraseguro where geraseguro.tpseguro = vtpseguro  
                      and geraseguro.etbcod = p-etbcod 
        exclusive-lock 
        no-wait 
        no-error. 
    if not avail geraseguro 
    then do: 
        if not locked geraseguro 
        then do. 
            create geraseguro. 
            assign 
                geraseguro.tpseguro = vtpseguro 
                geraseguro.etbcod   = p-etbcod 
                geraseguro.sequencia = 1.   
            vstatus = 200.  
        end. 
        else do: /** LOCADO **/ 
            vcertifi = "0". 
            vstatus = 423. 
        end. 
    end. 
    else do: 
        vstatus = 200. 
        assign 
            geraseguro.sequencia = geraseguro.sequencia + 1. 
    end. 

    if vstatus = 200
    then do:
        vcertifi = string(p-etbcod, "999") + 
                       string(vtpseguro) +
                       string(geraseguro.sequencia, "9999999"). 
        find current geraseguro no-lock. 
    end.
end.
         
