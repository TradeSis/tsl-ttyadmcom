
def var vdtini as date format "99/99/9999" initial today.
def var vdtfin as date format "99/99/9999" initial today.

def var varq as char.
def var codigo-conta  as char format "x(15)".
def var nome-conta    as char format "x(30)".
def var data-diario   as date format "99/99/9999".
def var saldo-inicial as dec format ">>>,>>>,>>9.99".
def var saldo-final   as dec format ">>>,>>>,>>9.99".
def var valor-debito  as dec format ">>>,>>>,>>9.99".
def var valor-credito as dec format ">>>,>>>,>>9.99".
def var vsaldo        as dec format ">>>,>>>,>>9.99".
def var vnumero       as char.
def var ii as int.

def var vdia          as int.
def var vmes          as int.
def var vano          as int.

 

    pause.
    unix silent 
    /usr/dlc/bin/quoter -d % /admcom/relato/drebes/CONT2001/FONR2001.TXT > 
                    /ctb-dados/forn.arq.

 
    pause.
   
    
    input from /ctb-dados/forn.arq.
    repeat:

        import varq.
    
        codigo-conta = substring(varq,1,15).
        vdia = int(substring(varq,43,2)).
        vmes = int(substring(varq,45,2)).
        vano = int(substring(varq,47,4)).
        nome-conta   = substring(varq,63,38).
        valor-credito = dec(substring(varq,101,17)) / 100.

        
        

        ii = 0.
        vnumero = "".
        do ii = 1 to 15:

           if substring(nome-conta,ii,1) = "0" or
              substring(nome-conta,ii,1) = "1" or
              substring(nome-conta,ii,1) = "2" or 
              substring(nome-conta,ii,1) = "3" or 
              substring(nome-conta,ii,1) = "4" or 
              substring(nome-conta,ii,1) = "5" or 
              substring(nome-conta,ii,1) = "6" or 
              substring(nome-conta,ii,1) = "7" or 
              substring(nome-conta,ii,1) = "8" or 
              substring(nome-conta,ii,1) = "9"  
           then vnumero = vnumero + substring(nome-conta,ii,1).
           else leave.
              
        
        end.
        
        data-diario   = date(vmes,vdia,vano).
        
       
      
    
        display codigo-conta
                data-diario
                vnumero    
                nome-conta    
                valor-credito
                    with frame f2 1 down width 80.
        pause 0.            


               
        find first fin.titulo 
                        where fin.titulo.empcod = 19 and
                              fin.titulo.titnat   = yes and
                              fin.titulo.titdtpag = data-diario and
                              fin.titulo.titvlpag = valor-credito and
                              fin.titulo.titnum   = vnumero 
                                                no-lock no-error.
        if not avail fin.titulo 
        then do:     
            find first fin.titulo 
                        where fin.titulo.empcod = 19 and
                              fin.titulo.titnat = yes and   
                              fin.titulo.titdtpag = data-diario   and
                              fin.titulo.titvlpag = valor-credito 
                                                no-lock no-error.
            if avail fin.titulo 
            then do:
                
                find first lanfor where 
                           lanfor.conta  = codigo-conta    and
                           lanfor.datope = data-diario     and
                           lanfor.histo  = nome-conta      and
                           lanfor.valope = valor-credito   and
                           lanfor.tipope = "P"             and
                           lanfor.tipdoc = "DUP"           and
                           lanfor.numdoc = fin.titulo.titnum and
                           lanfor.datemi = fin.titulo.titdtemi and
                           lanfor.datven = fin.titulo.titdtven and 
                           lanfor.valtit = valor-credito no-error.
                if avail lanfor
                then assign lanfor.clifor = string(fin.titulo.clifor).
            end.

        end.               
        else do:
        
            
            find first lanfor where 
                           lanfor.conta  = codigo-conta    and
                           lanfor.datope = data-diario     and
                           lanfor.histo  = nome-conta      and
                           lanfor.valope = valor-credito   and
                           lanfor.tipope = "P"             and
                           lanfor.tipdoc = "DUP"           and
                           lanfor.numdoc = fin.titulo.titnum and
                           lanfor.datemi = fin.titulo.titdtemi and
                           lanfor.datven = fin.titulo.titdtven and 
                           lanfor.valtit = valor-credito no-error.
            if avail lanfor
            then assign lanfor.clifor = string(fin.titulo.clifor).
            
        end.
        
        
        
    end.
    input close.

    
