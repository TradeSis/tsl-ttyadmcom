/*
 *
 * Recebe como Parametro um produto e emite etiquetas para a DREBES
 *
 */

{admcab.i}

/* DREBES */
if opsys = "UNIX"
then do:
         unix silent rm /admcom/relat/etique.bat.
end.
else do:        
         dos silent del c:\temp\etique.bat.
end.

def var westac like estac.etcnom format "x(20)".
def var vano as i format 99.
def var vmes as i format 99.

def var wtaman as char format "x(8)".

def input parameter par-rec as recid. 
def input parameter par-qtd as dec.
def input parameter par-taman as char format "x(3)".

/*
/* USADO PARA TESTE*/
def var par-rec as recid.
def var par-qtd as dec.
def var par-taman as char form "x(03)".

find first produ where produ.procod = 10218 no-lock no-error.
if not avail produ 
then do:
       message "NAO ENCONTRADO" view-as alert-box.
       undo, retry.
end.
  
assign par-rec   = recid(produ)
       par-qtd   = 8
       par-taman = "MED".
*/
       
/*****def input parameter par-data  as char format "x(4)".*****/

def var vproant as char format "x(8)".
def var vlinha  as int.
def var wcopias as int.
def var wvezes  as int.
def var wetique as int.
def var wsobra  as int.
def var vconta  as int.
def var vpos    as int.
def var vnome1  as char.
def var vnome2  as char.
def var vdata   as char format "x(4)".
def var vdtped  as char form   "x(4)".
def var iprocod like produ.procod.

def buffer bf-produ for produ.

def temp-table wfetq
    field linha as int
    field comando as char format "x(70)".

output to "c:\temp\etique.bat" append.
        
     put "c:\windows\command\mode com1:9600,e,7,2,r" skip
         "copy l:\zebra\lebes.grf com1" skip. 

output close.

input from l:\zebra\admcom9.ale no-echo.

vlinha = 0.

repeat:
    create wfetq.
    import
        comando.
    vlinha = vlinha + 1.
    wfetq.linha = vlinha.
end.
input close.

    find produ where recid(produ) = par-rec no-lock. 
    find estac where estac.etccod = produ.etccod no-lock.
    find estoq where estoq.etbcod = estab.etbcod and
                     estoq.procod = produ.procod no-lock.

    assign iprocod = produ.procod.

    run pi-dataped.

    vdtped = string(month(today),"99") + string(day(today),"99").

    wcopias = par-qtd.
    wvezes  = truncate(wcopias / 2,0).
    wvezes  = wvezes * 2.
    wetique = wvezes / 2.
    wsobra  = wcopias - wvezes.
    westac  = trim(
              string(estac.etcnom,"x(10)")   + " " +
              substring(string(year(today)),3,2) + 
              vdtped /*+
              string(month(today),"99")*/) /***** + par-data*****/.
    
    wtaman =  "TAM.:" + string(par-taman,"x(3)").

    if wetique > 0
    then do:
      for each wfetq break by linha:
        if wfetq.linha = 11 or
           wfetq.linha = 12 or
           wfetq.linha = 25 or
           wfetq.linha = 26
        then vpos = 18.
        else if wfetq.linha = 13 or
                wfetq.linha = 27
             then vpos = 39.
             else if wfetq.linha = 15 or
                     wfetq.linha = 29
                  then vpos = 18.
                  else if wfetq.linha = 17 or
                          wfetq.linha = 31
                       then vpos = 25.
                       else if wfetq.linha = 4
                             then vpos = 4.
                       else vpos = 1.

        if wfetq.linha = 7 or wfetq.linha = 9
        then vpos = 18.
        if wfetq.linha = 21 or wfetq.linha = 20
        then vpos = 18.

        assign
            substring(wfetq.comando,vpos) = if wfetq.linha = 4
                                            then string(wetique,"9999")
                                            else 
                                            
                                            if wfetq.linha = 9 or
                                               wfetq.linha = 20
                                            then string(wtaman,"x(8)")
                                            
                                            else
                                            if wfetq.linha = 11 or
                                               wfetq.linha = 12 or
                                               wfetq.linha = 25 or
                                               wfetq.linha = 26
                                            then 
                                             string(produ.procod,"999999")
                                                   
                                            else if wfetq.linha = 13 or
                                                    wfetq.linha = 27
                                            then string(produ.pronom,"x(44)")
                                            else if wfetq.linha = 15 or
                                                    wfetq.linha = 29
                                            then string(estoq.estvenda,">>9.99")
                                            else if wfetq.linha = 7  or
                                                    wfetq.linha = 21
                                            then string(westac,"x(15)")
                                            else if wfetq.linha = 17 or
                                                    wfetq.linha = 31
                                            then /*****""*****/
                                                string(produ.procod,"999999")
                                                
                                            else substring(wfetq.comando,vpos).
        end.
        output to value("c:\temp\cris" + string(produ.procod)).
        for each wfetq break by linha.
            put unformatted wfetq.comando skip.
        end.
        output close.

        output to "c:\temp\etique.bat" append.
            put trim(" type c:\temp\cris" + 
                      string(produ.procod) + " > com1") format "x(40)" skip.
        output close.

    end.
    if wsobra > 0
    then do:
      for each wfetq break by linha:
        if wfetq.linha = 11 or
           wfetq.linha = 12 or
           wfetq.linha = 25 or
           wfetq.linha = 26
        then vpos = 18.
        else if wfetq.linha = 13 or
                wfetq.linha = 27
             then vpos = 39.
             else if wfetq.linha = 15 or
                     wfetq.linha = 29
                  then vpos = 18.
                  else if wfetq.linha = 17 or
                          wfetq.linha = 31
                       then vpos = 25.
                        else if wfetq.linha = 4
                             then vpos = 4.
                       else vpos = 1.

        if wfetq.linha = 7 or wfetq.linha = 9
        then vpos = 18.
        if wfetq.linha = 21 or wfetq.linha = 20
        then vpos = 18.

        assign
            substring(wfetq.comando,vpos) = if wfetq.linha = 4
                                            then string(wsobra,"9999")
                                            else 
                                            if wfetq.linha = 9 or
                                               wfetq.linha = 20
                                            then string(wtaman,"x(8)")
                                            
                                            else
                                            if wfetq.linha = 11 or
                                               wfetq.linha = 12
                                            then /*****""*****/
                                                string(produ.procod,"999999")
                                                
                                            else if wfetq.linha = 25 or
                                               wfetq.linha = 26
                                            then string(0,">>>>>>")
                                            else if wfetq.linha = 13
                                            then string(produ.pronom,"x(44)")
                                            else if wfetq.linha = 27
                                            then string("","x(44)")
                                            else if wfetq.linha = 15
                                            then string(estoq.estvenda,">>9.99")
                                            else if wfetq.linha = 29
                                            then string(0,">>>,>>")
                                            else if wfetq.linha = 17
                                            then /*****""*****/
                                                string(produ.procod,"999999")
                                                
                                            else if wfetq.linha = 7  or
                                                    wfetq.linha = 21
                                            then string(westac,"x(15)")
                                            else if wfetq.linha = 31
                                            then string(0,">>>>>>")
                                            else substring(wfetq.comando,vpos).
        end.

        output to value("c:\temp\crissob" + string(produ.procod)).
        for each wfetq break by linha.
            put unformatted wfetq.comando skip.
        end.
        output close.
        
        output to "c:\temp\etique.bat" append.
            put trim(" type c:\temp\crissob" + 
                      string(produ.procod) + " > com1") format "x(40)" skip.
        output close.

    end.
    
    /*dos silent c:\temp\etique.bat.*/
    
/* unix silent rm cris*. */

/* ------------------------------------------------------------------------- */
procedure pi-dataped:
        
def var vdtfliped  as date form "99/99/9999".
def var vdtfpedid  as date form "99/99/9999".
def var vprocod    like produ.procod.
        
find first bf-produ where
           bf-produ.procod = iprocod no-lock no-error.
if avail bf-produ
then do:
        for each liped   of   bf-produ:
    
            if liped.predtf <> ? 
            then assign vdtfliped = liped.predtf.
            else assign vdtfliped = liped.predt.
             
            for each pedid where
                     pedid.etbcod = liped.etbcod and
                     pedid.pedtdc = liped.pedtdc and
                     pedid.pednum = liped.pednum no-lock:
                
                if pedid.peddtf <> ?
                then assign vdtfpedid = pedid.peddtf.
                 
            end.          
    
        end.
        if vdtfpedid <> ?
        then do:
                assign vdtped = substring(string(year(vdtfpedid)),3,2)
                                + string(month(vdtfpedid),"99").      
        end.
        if vdtped = ""
        then do:        
                if vdtfliped <> ?
                then do:
                        assign vdtped = substring(string(year(vdtfliped)),3,2)
                                      + string(month(vdtfliped),"99").
                end.
        end. 
        if vdtfpedid = ? and
           vdtfliped = ?
        then do:
                assign vdtped = substring(string(year(today)),3,2) 
                                + string(month(today),"99").   
        end.            
end.

end procedure.                 
/* ------------------------------------------------------------------------- */ 
