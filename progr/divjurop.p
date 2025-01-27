/* Relatorio  dispensa de juros por operador */
/***************************************************************************
** Programa        : divjur.p
** Objetivo        : Listagem de Conferencia de Juros
** Ultima Alteracao: 04/09/95
**
****************************************************************************/

{admcab.i}
def var ljuros as l.
def buffer btitulo for titulo.
def var vlimite as dec format ">,>>9.99".
def var wvlparcial as dec.
def var vclinom like clien.clinom.
def var    wdti like titulo.titdtven label "Periodo".
def var    wdtf like titulo.titdtven.
def buffer wtitulo for titulo.
def var ndias as int format ">>9".
def var wjuro   like titulo.titjuro.
def var wjuromen like titulo.titjuro.
def var wjuromai like titulo.titjuro.
def var vldev   like titulo.titjuro.
def var vdif    like titulo.titjuro format "->,>>>,>>9.9".
def var vdifmen like titulo.titjuro format "->,>>>,>>9.9".
def var vdifmai like titulo.titjuro format "->,>>>,>>9.9".
def var vljur   like titulo.titjuro format ">>,>>9.9".
def var vlmul   like titulo.titjuro format ">>,>>9.9".
def var jucob   like titulo.titjuro format ">>,>>9.9".
def var jucobmen like titulo.titjuro format ">>,>>9.9".
def var jucobmai like titulo.titjuro format ">>,>>9.9".
def var vlcob   like titulo.titjuro format ">>,>>9.9".
def var wvlpri  like titulo.titvlcob.
def var wvlprimen like titulo.titvlcob.
def var wvlprimai like titulo.titvlcob.
def var vetbcod like estab.etbcod.
def stream stela.
form with down frame fdet.

def var vvlrprest    like titulo.titvlcob format "->,>>>,>>9.99".
def var vvlrprestjur like titulo.titvlcob format "->,>>>,>>9.99".
def var vfunnom      like func.funnom.
def var vvjurosdif   as dec format "->,>>>,>>9.99".

form vetbcod colon 18
     estab.etbnom   no-label colon 30
     wdti           colon 18  " A"
     wdtf           colon 35  no-label
                    with side-labels width 80 frame f1.
                    
def temp-table tt-tit
    field etbcod like estab.etbcod
    field pre01  like plani.platot format "->,>>>,>>9.9"
    field pre02  like plani.platot format "->,>>>,>>9.9"
    field cob01  like plani.platot format "->,>>>,>>9.9"
    field cob02  like plani.platot format "->,>>>,>>9.9"
    field cal01  like plani.platot format "->,>>>,>>9.9"
    field cal02  like plani.platot format "->,>>>,>>9.9"
    field dif01  as dec format "->>>>9.9"
    field dif02  as dec format "->>>>9.9"
    index idx1 etbcod.
    
    
def temp-table tt-clien
    field etbcod like titulo.etbcod
    field clinom like clien.clinom
    field clicod like clien.clicod
    field contnum like contrato.contnum  
    field titvlcob like titulo.titvlcob format "->,>>>,>>9.99"
    field jucob    like titulo.titvlcob format "->,>>>,>>9.99"
    field vdif     as dec format "->,>>>,>>9.99"
    field titdtpag like titulo.titdtpag
    field titdtven like titulo.titdtven
    field funcod   like func.funcod
    index idx1 etbcod.


wdti = today.
wdtf = wdti + 30.
repeat:
 
 wjuro = 0.
 wjuromen = 0.
 wjuromai = 0.
 vldev    = 0.
 vdif     = 0.
 vdifmen   = 0.
 vdifmai   = 0.
 vljur     = 0.
 vlmul     = 0.
 jucob     = 0.
 jucobmen  = 0.
 jucobmai  = 0.
 vlcob     = 0.
 wvlpri    = 0.
 wvlprimen = 0.
 wvlprimai = 0.

def buffer bestab for estab.
find bestab where bestab.etbcod = setbcod no-lock.
def var stbjur as log format "Sim/Nao".
def var varquivo as char.
    for each tt-tit:
        delete tt-tit.
    end.

    update vetbcod with frame f1.

    if  vetbcod <> 0 then do:
        find estab where estab.etbcod = vetbcod no-lock.
        display estab.etbnom with frame f1.
    end.
    else disp "Geral" @ estab.etbnom with frame f1.

    update wdti validate(input wdti <> ?, "Data deve ser Informada")
           with frame f1.

    update wdtf validate(input wdtf >= input wdti, "Data Invalida")
           skip with frame f1.
    update vlimite colon 18 label "Dif.Limite" with frame f1.
    
    stbjur = no.
    message "Usar tabela de juros GERAL ? " UPDATE stbjur.
    
    output stream stela to terminal.
    
    {confir.i 1 "Listagem Previsao"}

    if opsys = "UNIX"
    then varquivo = "../relat/divjurb5l." + string(time).
    else varquivo = "..\relat\divjurb5w." + string(time). 
    {mdadmcab.i
        &Saida     = "value(varquivo)"
        &Page-Size = "64"
        &Cond-Var  = "150"
        &Page-Line = "66"
        &Nom-Rel   = """DIVJURB5"""
        &Nom-Sis   = """SISTEMA CREDIARIO"""
        &Tit-Rel   = """LISTAGEM DE CONFERENCIA DE JUROS - PERIODO DE "" +
                        STRING(WDTI) + "" A "" + STRING(WDTF) +
                        "" FILIAL "" + STRING(vetbcod)"
        &Width     = "158"
        &Form      = "frame f-cab"}
    for each estab where if vetbcod = 0
                         then true
                         else estab.etbcod = vetbcod no-lock:
                         
           
            wjuro = 0. 
            wjuromen = 0. 
            wjuromai = 0. 
            vldev    = 0. 
            vdif     = 0. 
            vdifmen   = 0. 
            vdifmai   = 0. 
            vljur     = 0. 
            vlmul     = 0. 
            jucob     = 0. 
            jucobmen  = 0. 
            jucobmai  = 0. 
            vlcob     = 0. 
            wvlpri    = 0. 
            wvlprimen = 0. 
            wvlprimai = 0. 

 
    for each titulo use-index etbcod  where
             titulo.etbcobra  = estab.etbcod    and 
             titulo.titdtpag >=  input wdti     and
             titulo.titdtpag <=  input wdtf     and
             titulo.modcod    =  "CRE"          and
             titulo.titdtpag > titulo.titdtven  no-lock.
       
        if titulo.etbcobra = ? or
           titulo.moecod   = "NOV"
        then next.

        if  titulo.titdtpag > titulo.titdtven
        then do:
            ljuros = yes.
            if titulo.titdtpag - titulo.titdtven = 2
            then do:
                find dtextra where exdata = titulo.titdtpag - 2 
                        no-lock no-error.
                if weekday(titulo.titdtpag - 2) = 1 or avail dtextra
                then do:
                    find dtextra where exdata = titulo.titdtpag - 1 
                            no-lock no-error.
                    if weekday(titulo.titdtpag - 1) = 1 or avail dtextra
                    then ljuros = no.
                end.
            end.
            else do:
                if titulo.titdtpag - titulo.titdtven = 1
                then do:
                    find dtextra where exdata = titulo.titdtpag - 1 
                                no-lock no-error.
                    if weekday(titulo.titdtpag - 1) = 1 or avail dtextra
                    then ljuros = no.
                end.
            end.
            ndias = if not ljuros
                    then 0
                    else titulo.titdtpag - titulo.titdtven.
        end.
        else ndias = 0.
                                                        
        if ndias = 0 then next.                                              

        display stream stela titulo.etbcobra
                             titulo.titdtpag
                             titulo.titnum with 1 down centered. pause 0.
        find first btitulo where
             btitulo.empcod    =  wempre.empcod       and
             btitulo.titnat    =  no                  and
             btitulo.modcod    =  "CRE"               and
             btitulo.etbcod    = titulo.etbcod        and
             btitulo.clifor    =  titulo.clifor       and
             btitulo.titnum    =  titulo.titnum       and
             btitulo.titnumger = titulo.titnum and
             btitulo.titparger = titulo.titpar
             no-lock no-error.

        if available btitulo
        then
            if btitulo.titnumger = titulo.titnum
            then wvlpri = if titulo.titvlcob > btitulo.titvlcob
                          then titulo.titvlcob - btitulo.titvlcob
                          else btitulo.titvlcob - titulo.titvlcob.

            else wvlpri = titulo.titvlcob.
        else
            wvlpri = titulo.titvlcob.
        find clien where
             clien.clicod = titulo.clifor no-lock no-error.
        if avail clien
        then vclinom = clien.clinom.
        else vclinom = " ".
        
       
        ndias = titulo.titdtpag - titulo.titdtven.
        /*********************  ************************/

        if  ndias > 0 then do:
            if stbjur
            then do:
                {sel-tabjur.i 0 ndias}. 
            end.
            else do:
                {sel-tabjur.i estab.etbcod ndias}.
            end.
            /**
            find tabjur where
                 tabjur.etbcod = 0 and
                 tabjur.nrdias = ndias no-lock no-error.
            **/
            if  avail tabjur then do:
                assign
                 jucob = (wvlpri * tabjur.fator) - wvlpri.
            end.
        end.
        wjuro = titulo.titvlpag - titulo.titvlcob.

        if ndias >= 0
        then do:
            assign
                vldev = wvlpri + (titulo.titdtpag - titulo.titdtven)
                        * wjuro
                vdif  = (titulo.titvlpag - (wvlpri + jucob)).
        vdif = wjuro - JUCOB.

        if ndias > 0 and ndias <= 180
        then assign wvlprimen = wvlprimen + wvlpri
                    wjuromen  = wjuromen  + wjuro
                    jucobmen  = jucobmen  + jucob
                    vdifmen   = vdifmen   + vdif.

        if ndias > 180
        then assign wvlprimai = wvlprimai + wvlpri
                    wjuromai  = wjuromai  + wjuro
                    jucobmai  = jucobmai  + jucob
                    vdifmai   = vdifmai   + vdif.
        end.
        
        
        find first tt-tit where tt-tit.etbcod = titulo.etbcobra no-error.
        if not avail tt-tit
        then do:
            create tt-tit.
            assign tt-tit.etbcod = titulo.etbcobra.
        end.
        
        assign tt-tit.pre01  = wvlprimen 
               tt-tit.cob01  = wjuromen 
               tt-tit.cal01  = jucobmen 
               tt-tit.dif01  = vdifmen   
               tt-tit.pre02  = wvlprimai  
               tt-tit.cob02  = wjuromai    
               tt-tit.cal02  = jucobmai    
               tt-tit.dif02  = vdifmai.    
               
        /* find tt-clien where tt-clien.contnum = contrato.contnum no-lock no-e~rror.
        if not avail tt-clien then do:*/
        
        find first contrato where contrato.contnum = int(titulo.titnum) no-lock~ no-error.
        if not avail contrato then next.
        
            create tt-clien.
            assign tt-clien.etbcod   = titulo.etbcod
                   tt-clien.clinom   = clien.clinom
                   tt-clien.clicod   = clien.clicod
                   tt-clien.contnum  = contrato.contnum                        ~               tt-clien.titvlcob = titulo.titvlcob
                   tt-clien.jucob    = tt-clien.titvlcob + jucob
                   tt-clien.vdif     = vdif
                   tt-clien.titdtpag = titulo.titdtpag
                   tt-clien.titdtven = titulo.titdtven.
       /* end.*/
       
       find first autoriz where autoriz.etbcod = tt-clien.etbcod   and
                          autoriz.data   = tt-clien.titdtpag and
                          autoriz.clicod = tt-clien.clicod   and
                          autoriz.motivo = "Dispensa de juros"
                          no-lock no-error.
                          
       if avail autoriz then assign tt-clien.funcod = autoriz.funcod.
               
    end.
    end.      
    for each tt-tit no-lock break by tt-tit.etbcod.
        /***
        display tt-tit.etbcod column-label "Fl."  
                tt-tit.pre01(total)  column-label "Vlr.Prest!<= 180"
                tt-tit.cob01(total)  column-label "Jur.Cob.!<= 180"
                tt-tit.cal01(total)  column-label "Jur.Cal.!<= 180"
                tt-tit.dif01(total)  column-label "Dif.!<= 180" format "->>>>>>~>9.9"
                tt-tit.pre02(total)  column-label "Vlr.Prest!> 180"
                tt-tit.cob02(total)  column-label "Jur.Cob!> 180"
                tt-tit.cal02(total)  column-label "Jur.Cal!> 180"
                tt-tit.dif02(total)  column-label "Dif.!> 180" format "->>>>>>>~9.9"
                (pre01 + pre02)(total) column-label "Total!Prest." format "->,>~>>,>>9.99"
                (cob01 + cob02)(total) column-label "Total!Cob." 
                (cal01 + cal02)(total) column-label "Total!Cal." format "->,>>>~,>>9.99" 
                (dif01 + dif02)(total) column-label "Total!Dif." format "->>>,>~>9.99"
                    with frame f3 down width 170.  
                    
        ***/

        if last-of(tt-tit.etbcod) then do:

            for each tt-clien where tt-clien.etbcod = tt-tit.etbcod no-lock
            break by tt-clien.etbcod by tt-clien.funcod.
            
                vvlrprest    = vvlrprest    + tt-clien.titvlcob.
                vvlrprestjur = vvlrprestjur + tt-clien.jucob.
                vvjurosdif   = vvjurosdif   + tt-clien.vdif.
                
                if last-of(tt-clien.funcod)
                then do:

                    vfunnom = "".
                    find func where func.funcod = tt-clien.funcod and
                                    func.etbcod = tt-clien.etbcod
                    no-lock no-error.
                    
                    if avail func 
                    then vfunnom = func.funnom.
                    else vfunnom = "".
                    
                    disp tt-clien.etbcod  column-label "Estab."
                         tt-clien.funcod  column-label "Cod !Func."
                         vfunnom          column-label "Nome Func."  
                         vvlrprest        column-label "Tot.Valor !Prest"
                         vvlrprestjur     column-label "Tot.Valor !Prest Juros"
                         vvjurosdif       column-label "Tot.Juros !Disp"
                         with frame f-operadores 
                         down
                         width 155.
                
                    if last-of(tt-clien.etbcod)
                    then down 2
                    with frame f-operadores.


                    vvlrprest    = 0.
                    vvlrprestjur = 0.
                    vvjurosdif   = 0.   
                end.
             end.
            
            
            /**
            for each tt-clien where 
                     tt-clien.etbcod = tt-tit.etbcod
                     no-lock:

                disp tt-clien.clinom   column-label "Nome" 
                     tt-clien.clicod   column-label "Cod.Clien" format "9999999~999"
                     tt-clien.contnum  column-label "Contrato" format "99999999~999"
                     tt-clien.titvlcob column-label "Valor !Prest" format "->>>~,>>9.99"
                     tt-clien.jucob    column-label "Valor Prest ! Com Juros" f~ormat "->>>,>>9.99"
                     tt-clien.vdif     column-label "Juros Disp." format "->>>,~>>9.99"
                     tt-clien.titdtpag column-label "Data Pagto"
                     tt-clien.titdtven column-label "Data Venc. ! Prest"
                     tt-clien.funcod   column-label "Func." format "99999999"
                     with frame f4 down width 155.  

            end.
            **/
        end.            

    end.
    output close.
    output stream stela close.
    if opsys = "UNIX"
    then do:
        run visurel.p(varquivo,"").
    end.
    else do:
        {mrod.i}.
    end.
end.


