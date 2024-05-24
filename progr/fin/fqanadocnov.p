/*
*
*
*/
{admcab.i}

def input param vtitle     as char.
def input param poldfiltro as char.
def input param pfiltro    as char.
def input param poldctmcod  as char.
def input param poldmodcod   as char.
def input param poldtpcontrato as char.
def input param poldetbcod as int. 
def input param poldcobcod  as int.
def input param ppdvmovrec  as recid.

def shared var vetbcod like estab.etbcod.
def shared var vdtini as date format "99/99/9999" label "De".
def shared var vdtfin as date format "99/99/9999" label "Ate".              

def var pctmcod  as char.
def var pmodcod   as char.
def var ptpcontrato as char.
def var petbcod as int. 
def var pcobcod  as int.


def var vvlrorigem  as dec.
def var vvlrnovacao as dec.


def var recatu1         as recid.
def var recatu2         as recid.
def var reccont         as int.
def var esqpos1         as int.
def var esqvazio        as log.
def var esqcom1         as char format "x(12)" extent 5.

esqcom1 = "".

assign  esqcom1[1] = " Consulta "
        esqcom1[2] = " Operacao" .


        
def var vfiltro as char.
    find pdvtmov where pdvtmov.ctmcod = poldctmcod no-lock no-error.
    if avail pdvtmov
    then vfiltro = pdvtmov.ctmnom.
    else vfiltro = "".
    vfiltro = vfiltro + 
            if poldmodcod <> ?
            then "/" + poldmodcod
            else "".
    vfiltro = vfiltro + 
            if poldtpcontrato <> ?
            then "/" + if poldtpcontrato = "F"
                 then "FEI"
                 else if poldtpcontrato = "N"
                      then "NOV"
                      else if poldtpcontrato = "L"
                           then "LP "
                           else "   "
            else "".

    find cobra where cobra.cobcod = poldcobcod no-lock no-error.
    vfiltro = vfiltro + 
            (if poldcobcod <> ?
             then "/" + string(poldcobcod) + if avail cobra 
                                       then ("-" + cobra.cobnom)
                                       else ""
             else "").


disp
    vfiltro no-label format "x(50)"
        poldetbcod when poldetbcod <> ?
            label "Fil" format ">>>>"

    with frame fcab
    row 4 no-box
        side-labels
        width 80
        color underline.
def var par-dtini as date.
        
def new shared frame f-cmon.
    form cmon.etbcod    label "Etb" format ">>9"
         CMon.cxacod    label "PDV" format ">>9"
         CMon.cxanom    no-label
         par-dtini          label "Dt Ini"
         CMon.cxadt         colon 65 format "99/99/9999" label "Data"
         with frame f-CMon row 3 width 81
                         side-labels no-box.
def new shared frame f-banco.
    form
        CMon.bancod    colon 12    label "Bco/Age/Cta"
        CMon.agecod             no-label
        CMon.ccornum            no-label format "x(15)"
        CMon.cxanom              format "x(16)" no-label
        func.funape             format "x(10)" no-label
        CMon.cxadt          format "99/99/9999" no-label
         with frame f-banco row 3 width 81 /*color messages*/
                         side-labels no-box.



form
    esqcom1
    with frame f-com1 width 81
                 row screen-lines no-box no-labels column 1 centered overlay.

assign
    esqpos1  = 1.




def new shared temp-table ttnovacao no-undo
    field tipo      as char
    field contnum   like contrato.contnum format ">>>>>>>>>>9"
    field valor     like contrato.vltotal
    field saldoabe  like titulo.titvlcob  
    index idx is unique primary tipo desc contnum asc.

def temp-table ttpdvmov no-undo
    field rec    as recid
    field tipo      like ttnovacao.tipo
    field contnum   like ttnovacao.contnum
    field valor     like ttnovacao.valor
    field primeiro  as log
        index idx is unique primary rec asc tipo desc contnum asc.



run gravatt.

disp 
    space(32)
    vvlrorigem no-label          format   "-zzzzzzz9.99"
    vvlrnovacao     no-label          format   "-zzzzzzz9.99"
        with frame ftot
            side-labels
            row screen-lines - 1
            width 80
            no-box.



bl-princ:
repeat:
    disp esqcom1 with frame f-com1.
    if recatu1 = ?
    then run leitura (input "pri").
    else find  ttpdvmov where recid(ttpdvmov) = recatu1 no-lock.
    if not available ttpdvmov
    then esqvazio = yes.
    else esqvazio = no.
    clear frame frame-a all no-pause.
    if not esqvazio
    then do:
        run frame-a.
    end.
    else do on endkey undo.
        pause 1 no-message.
        leave.
    end.

    recatu1 = recid(ttpdvmov).
    color display message esqcom1[esqpos1] with frame f-com1.
    if not esqvazio
    then repeat:
        run leitura (input "seg").
        if not available ttpdvmov
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down with frame frame-a.

        run frame-a.
    end.
    if not esqvazio
    then up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        if not esqvazio
        then do:
            find ttpdvmov where recid(ttpdvmov) = recatu1 no-lock.
            find pdvmov where recid(pdvmov) = ttpdvmov.rec no-lock.

            status default "".
            color disp message  pdvmov.datamov
        pdvmov.etbcod
        cmon.cxacod 
        pdvmov.datamov 
        pdvtmov.ctmnom 
        pdvmov.sequencia 
        ttpdvmov.tipo
        ttpdvmov.contnum
        ttpdvmov.valor .
            
            choose field pdvmov.etbcod  help ""
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      PF4 F4 ESC return).
            color disp normal pdvmov.etbcod pdvmov.datamov
                    pdvmov.etbcod
        cmon.cxacod 
        pdvmov.datamov 
        pdvtmov.ctmnom 
        pdvmov.sequencia 
        ttpdvmov.tipo
        ttpdvmov.contnum
        ttpdvmov.valor .
            

            status default "".

        end.

            if keyfunction(lastkey) = "cursor-right"
            then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 5 then 5 else esqpos1 + 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                next.
            end.
            if keyfunction(lastkey) = "cursor-left"
            then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 1 then 1 else esqpos1 - 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                next.
            end.
            if keyfunction(lastkey) = "page-down"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "down").
                    if not avail ttpdvmov
                    then leave.
                    recatu1 = recid(ttpdvmov).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail ttpdvmov
                    then leave.
                    recatu1 = recid(ttpdvmov).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail ttpdvmov
                then next.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail ttpdvmov
                then next.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return" or esqvazio
        then do on error undo, retry on endkey undo, leave:
                display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                        with frame f-com1.

                    if esqcom1[esqpos1] = " Consulta "
                    then do:
                        hide frame f-com2   no-pause.
                        hide frame f-com1   no-pause.
                        hide frame frame-a  no-pause.
                        hide frame fcab     no-pause.
                        hide frame f1       no-pause.

                        run conco_v1701.p (string(ttpdvmov.contnum)).
                        pause 0.
                        view frame f-com2   . pause 0.
                        view frame f-com1   . pause 0.
                        view frame frame-a  . pause 0.
                        view frame fcab     . pause 0.
                        view frame f1       . pause 0.
                    end.


                    if esqcom1[esqpos1] = " Operacao "
                    then do:
                        hide frame f-com2   no-pause.
                        hide frame f-com1   no-pause.
                        hide frame frame-a  no-pause.
                        hide frame fcab     no-pause.
                        hide frame f1       no-pause.
                        run dpdv/pdvcope.p ( input recid(pdvmov)).
                        pause 0.
                        view frame f-com2   . pause 0.
                        view frame f-com1   . pause 0.
                        view frame frame-a  . pause 0.
                        view frame fcab     . pause 0.
                        view frame f1       . pause 0.
                    end.
                    
                    
        end.
        if not esqvazio
        then do:
            run frame-a.
        end.
        display esqcom1[esqpos1] with frame f-com1.
        recatu1 = recid(ttpdvmov).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1 no-pause.
hide frame frame-a no-pause.
hide frame fcab    no-pause.
hide frame f1 no-pause.
hide frame f-sub no-pause.


procedure leitura . 
def input parameter par-tipo as char.
        
if par-tipo = "pri" 
then  
        find first ttpdvmov where 
                    true
                                                no-lock no-error.
                                             
if par-tipo = "seg" or par-tipo = "down" 
then  
        find next ttpdvmov  where
                true
                                       no-lock no-error.
             
if par-tipo = "up" 
then                  
        find prev ttpdvmov where 
                true
        
                                 no-lock no-error.
        
end procedure.

procedure frame-a.  

    find pdvmov where recid(pdvmov) = ttpdvmov.rec no-lock.
    find cmon   of pdvmov no-lock.
    find pdvtmov of pdvmov no-lock.

    if ttpdvmov.primeiro
    then display
        pdvmov.etbcod   column-label "Etb" format ">>9"
        cmon.cxacod   column-label "Cx" format ">>"
        pdvmov.datamov  column-label "Data" format "999999"
        pdvtmov.ctmnom format "x(10)"
        pdvmov.sequencia 
            with frame frame-a.
     disp       
        ttpdvmov.tipo
        ttpdvmov.contnum
        ttpdvmov.valor column-label "Valor"     format "->>>>>9.99"      
                with frame frame-a 8 down centered row 7 
                width 80 overlay no-box.

end procedure.




procedure gravatt.
def var vprimeiro as log.
hide message no-pause.
message "fazendo calculos... aguarde...".
for each ttpdvmov.
    delete ttpdvmov.
end.

if ppdvmovrec = ?
then 
for each cmon 
    where if vetbcod = 0
          then true
          else cmon.etbcod = vetbcod
    no-lock.
        if not poldfiltro = "geral"
        then if poldetbcod <> ?
             then if cmon.etbcod <> poldetbcod
                  then next.
        for each pdvdoc where pdvdoc.etbcod = cmon.etbcod and pdvdoc.cmocod = cmon.cmocod and 
                pdvdoc.datamov >= vdtini and
                pdvdoc.datamov <= vdtfin no-lock.
            if pdvdoc.pstatus = yes
            then.
            else next.    
            if pdvdoc.valor <> 0 and pdvdoc.placod = 0
            then.
            else next.
            
            release titulo.
            
            find titulo where titulo.contnum = int(pdvdoc.contnum) and
                                  titulo.titpar  = pdvdoc.titpar
                                  no-lock no-error.
            if not avail titulo
            then do:                           
                find contrato where contrato.contnum = int(pdvdoc.contnum) no-lock no-error.
                if avail contrato
                then do: 
                    find titulo where
                            titulo.empcod = 19 and
                            titulo.titnat = no and
                            titulo.etbcod = contrato.etbcod and
                            titulo.clifor = contrato.clicod and
                            titulo.modcod = contrato.modcod and
                            titulo.titnum = pdvdoc.contnum and
                            titulo.titpar = pdvdoc.titpar and
                            titulo.titdtemi = contrato.dtinicial
                        no-lock no-error.
                end.
            end.                                                   
            if pfiltro = "geral"
            then do:
                
            end.                 
            else do:
                ptpcontrato = if avail titulo then titulo.tpcontrato else "".
                pmodcod = if avail titulo then titulo.modcod else "".
                pcobcod = if avail titulo then titulo.cobcod else 0.
                pctmcod = pdvdoc.ctmcod.
                if poldtpcontrato <> ? and poldtpcontrato <> ptpcontrato then next. 
                if poldmodcod     <> ? and poldmodcod     <> pmodcod     then next.
                if poldcobcod     <> ? and poldcobcod     <> pcobcod     then next.
                if poldctmcod     <> ? and poldctmcod     <> pctmcod     then next.                        
            end.
                  
               
                find pdvmov of pdvdoc no-lock no-error.
                if not avail pdvmov then next.
                find first ttpdvmov where ttpdvmov.rec = recid(pdvmov) no-error.
                if avail ttpdvmov
                then next.
                

                run fin/montattnov.p (recid(pdvmov),NO).
                vprimeiro = yes.
                for each ttnovacao.
                    find first ttpdvmov where
                        ttpdvmov.rec        = recid(pdvmov) and
                        ttpdvmov.tipo       = ttnovacao.tipo and
                        ttpdvmov.contnum    = ttnovacao.contnum
                        no-error.
                    if not avail ttpdvmov
                    then do:
                        create ttpdvmov.
                        ttpdvmov.rec        = recid(pdvmov).
                        ttpdvmov.tipo       = ttnovacao.tipo.
                        ttpdvmov.contnum    = ttnovacao.contnum.
                        ttpdvmov.valor      = ttnovacao.valor.
                        ttpdvmov.primeiro   = vprimeiro.
                        vprimeiro = no.
                        if ttnovacao.tipo = "ORIGINAL"
                        then vvlrorigem   = vvlrorigem  + ttnovacao.valor.
                        else vvlrnovacao  = vvlrnovacao + ttnovacao.valor.
                    end.
            end.
        end.
end.            
else do:
            find pdvmov where recid(pdvmov) = ppdvmovrec no-lock no-error.
                if not avail pdvmov then next.
           

                run fin/montattnov.p (recid(pdvmov),NO).
                vprimeiro = yes.
                for each ttnovacao.
                    find first ttpdvmov where
                        ttpdvmov.rec        = recid(pdvmov) and
                        ttpdvmov.tipo       = ttnovacao.tipo and
                        ttpdvmov.contnum    = ttnovacao.contnum
                        no-error.
                    if not avail ttpdvmov
                    then do:
                        create ttpdvmov.
                        ttpdvmov.rec        = recid(pdvmov).
                        ttpdvmov.tipo       = ttnovacao.tipo.
                        ttpdvmov.contnum    = ttnovacao.contnum.
                        ttpdvmov.valor      = ttnovacao.valor.
                        ttpdvmov.primeiro   = vprimeiro.
                        vprimeiro = no.
                        if ttnovacao.tipo = "ORIGINAL"
                        then vvlrorigem   = vvlrorigem  + ttnovacao.valor.
                        else vvlrnovacao  = vvlrnovacao + ttnovacao.valor.
                    end.
            end.


end.
    
hide message no-pause.
end procedure.


