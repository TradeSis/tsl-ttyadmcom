/*----------------------------------------------------------------------------*/
/* finan/pag_gru1.p                                         Agenda - Listagem */
/*                                                                            */
/*----------------------------------------------------------------------------*/
{admcab.i}

def var vtotal as dec.

def var tempusercod like fin.titulo.titobs.
def var tempnomedofunc like fin.titulo.titobs. 
def var vsetcod like setaut.setcod.
def var vval as char.
def var v as char.
def var cc-desc as char.
def var vfornom like forne.fornom.
def var vacumme as dec initial 0.
def input parameter vesc as log.
def var varquivo as char format "x(20)".
def var vv as char.
def var vtot like fin.titulo.titvlcob.
def buffer bmodgru for modgru.
def var vperc as dec.
def temp-table wpag
    field wcod like fin.titulo.clifor
    field wnome like forne.fornom
    field wmodcod like fin.titulo.modcod
    field wmogsup like modgru.mogsup
    field wdes  like fin.titulo.titvlcob
    field wjur  like fin.titulo.titvlcob
    field wcob  like fin.titulo.titvlcob
    field wpag  like fin.titulo.titvlcob
    field wven  like fin.titulo.titvlcob.

def temp-table wgru
    field wcod like fin.titulo.clifor
    field wnome like forne.fornom
    field wmodcod like fin.titulo.modcod
    field wdes  like fin.titulo.titvlcob
    field wjur  like fin.titulo.titvlcob
    field wcob  like fin.titulo.titvlcob
    field wpag  like fin.titulo.titvlcob
    field wven  like fin.titulo.titvlcob.

def temp-table wfor
    field wcod like fin.titulo.clifor
    field wnome like forne.fornom
    field wmodcod like fin.titulo.modcod
    field wdes  like fin.titulo.titvlcob
    field wjur  like fin.titulo.titvlcob
    field wcob  like fin.titulo.titvlcob
    field wpag  like fin.titulo.titvlcob
    field wven  like fin.titulo.titvlcob.

def temp-table tt-exp
    field ano as int format "9999"
    field mes as int format "99"
    field datpag as date format "99/99/9999"
    field ccusto as int format ">>9"
    field desccc as char 
    field etbcod like estab.etbcod
    field cidade as char
    field grucod as int 
    field grumod like fin.modal.modcod
    field grunom as char
    field codmod as int
    field modcod like fin.modal.modcod
    field modnom as char
    field forcod as int  format ">>>>>>>>9"
    field fornom as char
    field titnum like fin.titulo.titnum
    field valor as dec
    field vencod like fin.titulo.vencod
    field UserCod like ger.func.UserCod
    field nomedofunc like ger.func.funnom
    field exptitobs like fin.titulo.titobs
    index i1 etbcod ano mes datpag
    .
    
def var vcob like fin.titulo.titvlpag.
def var vpag like fin.titulo.titvlpag.
def var vdes like fin.titulo.titvlpag.
def var vjur like fin.titulo.titvlpag.
def var vacum like fin.titulo.titvlpag.
def var vlog as log.
def var vdt as date.
def var vmodcod like fin.modal.modcod.
def temp-table wmodal like fin.modal.
def var wtotger like fin.titulo.titvlcob.
def var vnome like clien.clinom.
def var recatu2 as recid.
def var vtitrel     as char format "x(50)".
def var wetbcod like fin.titulo.etbcod initial 0.
def var wmodcod like fin.titulo.modcod initial "".
def var wtitnat like fin.titulo.titnat.
def var wclifor like fin.titulo.clifor initial 0.
def var wclicod like clien.clicod initial 0.
def var wdti    like fin.titulo.titdtven label "Periodo" initial today.
def var wdtf    like fin.titulo.titdtven.
def var wtitvlcob like fin.titulo.titvlcob.
def var wtot      as dec format ">,>>>,>>>,>>9.99" label "Total".
def var wseq as i extent 2.
def var i as i.
def var wbar as c label "/" initial "/" format "x".
def var wclfnom as char format "x(30)" label "clfnom".
def var wforcli as i format "999999" label "For/Cli".

wdtf = today.
wtotger = 0.
def var vven as dec.
form with frame f-pag.
def buffer bestab for estab.
def var vpfor as log format "Sim/Nao".
def var vana as log format "Sim/Nao".
def var valor as char.

repeat with column 50 side-labels 1 down width 31 row 4 frame f1:

    disp "" @ wetbcod colon 12.
    update wetbcod label "Estabelec." .
    if  wetbcod <> 0
    then do: 
        find estab where estab.etbcod =  wetbcod no-lock.
        display etbnom no-label format "x(10)".
    end. 
    
    else disp "TODOS" @ etbnom.
    update wmodcod validate(wmodcod = "" or
                            can-find(fin.modal where 
                                     fin.modal.modcod = wmodcod),
                            "Modalidade nao cadastrada")
                            label "Modal/Natur" colon 12.
    display " - ".
    if wmodcod = "CRE"
       then wtitnat = no.
    wtitnat = yes.
    update wtitnat no-label.
    repeat:
        
       for each wpag:
            delete wpag.
       end.
       for each wfor:
        delete wfor.
       end. 
         clear frame ff.
        clear frame fc.
        if wtitnat
           then do with column 1 side-labels 1 down width 48 row 4 frame ff:
             disp "" @ wclifor.
             update wclifor label "Fornecedor"
                help "Informe o codigo do Fornecedor ou <ENTER> para todos".
             if input wclifor <> "" and wclifor <> 0
                then do:
                        find forne where forne.forcod = input wclifor.
                        display fornom format "x(32)" no-label at 10.
                end.
                else disp "RELATORIO DE TODOS OS FORNECEDORES" @ fornom.
           end.
           else do with column 1 side-labels 1 down width 48 row 4 frame fc:
             disp "" @ wclicod.
             prompt-for wclicod label "Cliente"
                help "Informe o codigo do Cliente ou <ENTER> para todos".
             if input wclicod <> ""
                then do:
                        find clien where clien.clicod = input wclicod.
                        display clinom format "x(32)" no-label at 10.
                end.
                else disp "RELATORIO DE TODOS OS CLIENTES" @ clinom.
           end.
        if not wtitnat
        then wclifor = wclicod.
        else wclifor = wclifor.
        form wdti colon 12
             " A"
             wdtf colon 29 no-label with frame fdat width 80 side-label.

        update wdti
               wdtf with frame fdat.
               
        for each wmodal:
            delete wmodal.
        end.
        if wmodcod = ""
        then do:
            for each fin.modal where fin.modal.modcod <> "DEV"
                                 and fin.modal.modcod <> "BON"
                                 and fin.modal.modcod <> "CHP" no-lock:
                create wmodal.
                assign wmodal.modcod = fin.modal.modcod
                       wmodal.modnom = fin.modal.modnom.
            end.
            vlog = no.
            repeat:
                vmodcod = "DUP".
                find first wmodal where wmodal.modcod = vmodcod
                                                            no-lock no-error.
                if avail wmodal
                then delete wmodal.
                vlog = yes.
                leave.
            end.
        end.
        else do:
            find first modgru where modgru.mogsup = 0 and
                              modgru.modcod = wmodcod
                              no-lock no-error.
            if avail modgru
            then do:
                for each bmodgru where 
                         bmodgru.mogsup = modgru.mogcod
                         no-lock:
                    find fin.modal where
                        fin.modal.modcod = bmodgru.modcod no-lock.
                    
                    create wmodal.
                    assign wmodal.modcod = fin.modal.modcod
                           wmodal.modnom = fin.modal.modnom.
                end.             
            end.
            else do:
                find fin.modal where fin.modal.modcod = wmodcod no-lock.
                create wmodal.
                assign wmodal.modcod = wmodcod
                   wmodal.modnom = fin.modal.modnom.
            end.
            vlog = yes.
        end.
        
        wtot = 0.
        vtitrel = if wtitnat
                  then "PAGAR"
                  else "RECEBER" .
        if wclifor = 0
        then vv = "GERAL".
        else vv = forne.fornom.
        
        vacum = 0.
        vcob  =  0.
        vjur  =  0.
        vdes  =  0.
        vpag  =  0.

        if opsys = "UNIX"
        then varquivo = "/admcom/relat/exp_pag1.csv".
        else varquivo = "l:\admcom\relat\exp_pag1.csv".

        update varquivo label "Arquivo"  format "x(60)"
                with frame f-arq 1 down side-label width 80.
        
        do vdt = wdti to wdtf:
            disp vdt with frame f-dt 1 down
                centered no-label no-box color message.
            pause 0.    
            for each wmodal:
                find modgru where modgru.modcod = wmodal.modcod and
                                  modgru.mogsup <> 0
                                no-lock no-error.
                find bmodgru where bmodgru.mogcod = modgru.mogsup and
                                   bmodgru.mogsup = 0
                                no-lock no-error.
                for each fin.titulo where fin.titulo.empcod = wempre.empcod and
                                      fin.titulo.titnat =   wtitnat   and
                                      fin.titulo.modcod = wmodal.modcod and
                                      fin.titulo.titdtpag =  vdt        and
                                ( if wetbcod = 0
                                     then true
                                     else fin.titulo.etbcod = wetbcod ) and
                                ( if wclifor = 0
                                     then true
                                     else fin.titulo.clifor = wclifor ) and
                                  fin.titulo.titsit   =   "PAG" no-lock:


                    if fin.titulo.titvlpag <= 0
                    then next.
                    
                    cc-desc = "".
                    find bestab where bestab.etbcod = fin.titulo.etbcod
                            no-lock.
                    find forne where forne.forcod = fin.titulo.clifor no-lock
                                no-error.
                    
                    vsetcod = 0.
                    if  fin.titulo.titbanpag > 0 
                    then vsetcod = fin.titulo.titbanpag.

                    if avail forne
                    then
                    find foraut where foraut.forcod = forne.forcod
                                no-lock no-error.
                    if avail foraut and
                       vsetcod = 0
                    then vsetcod = foraut.setcod.
                       
                    find first setaut where setaut.setcod = vsetcod
                            no-lock no-error.
                    if avail setaut
                    then cc-desc = setaut.setnom.

    /*
    
   find first func where func.funcod = fin.titulo.vencod                  
                     and func.etbcod = 999 no-lock no-error.                
                     
                                           
                      if avail func then
                          assign    
         tempusercod =  string(acha("FUNFOLHA",fin.titulo.titobs[2]))
         tempnomedofunc = string(acha("NOME",fin.titulo.titobs[2])).
    
     */
                                        

                    create tt-exp.
                    assign 
                        tt-exp.ano = year(fin.titulo.titdtpag)
                        tt-exp.mes = month(fin.titulo.titdtpag)
                        tt-exp.datpag = fin.titulo.titdtpag
                        tt-exp.ccusto = vsetcod
                        tt-exp.desccc = cc-desc
                        tt-exp.etbcod = fin.titulo.etbcobra
                        tt-exp.cidade = bestab.munic
                        tt-exp.grucod = bmodgru.mogcod
                        tt-exp.grumod = bmodgru.modcod
                        tt-exp.grunom = bmodgru.mognom
                        tt-exp.codmod = modgru.mogcod
                        tt-exp.modcod = fin.titulo.modcod
                        tt-exp.modnom = wmodal.modnom
                        tt-exp.forcod = fin.titulo.clifor
                        tt-exp.fornom = if avail forne
                                then forne.fornom else ""
                        tt-exp.titnum = fin.titulo.titnum 
                        tt-exp.valor  = fin.titulo.titvlpag
                        tt-exp.vencod = fin.titulo.vencod
                       /*  tt-exp.UserCod = tempusercod
                        tt-exp.nomedofunc = tempnomedofunc */
                        tt-exp.exptitobs = fin.titulo.titobs                  .
                        .
                        
                    if fin.titulo.etbcobra = ? or
                       fin.titulo.etbcobra = 0
                    then tt-exp.etbcod = fin.titulo.etbcod.
                       
                end.
                if vesc
                then do:
                    for each banfin.titulo where 
                             banfin.titulo.empcod = wempre.empcod and
                             banfin.titulo.titnat = wtitnat   and
                             banfin.titulo.modcod = wmodal.modcod and
                             banfin.titulo.titdtpag =  vdt        and
                                ( if wetbcod = 0
                                  then true
                                  else banfin.titulo.etbcod = wetbcod ) and
                                ( if wclifor = 0
                                  then true
                                  else banfin.titulo.clifor = wclifor ) and
                                       banfin.titulo.titsit =   "PAG" no-lock:
                        
                        if banfin.titulo.titvlpag <= 0
                        then next.
                        
                        find bestab where bestab.etbcod = banfin.titulo.etbcod
                            no-lock.
                        find forne where 
                            forne.forcod = banfin.titulo.clifor no-lock
                            no-error.
                    
                        vsetcod = 0.
                        if banfin.titulo.titbanpag > 0 
                        then vsetcod = banfin.titulo.titbanpag.

                        if avail forne
                        then
                        find foraut where foraut.forcod = forne.forcod
                                no-lock no-error.
                        if avail foraut and
                        vsetcod = 0
                        then vsetcod = foraut.setcod.
                       
                        find first setaut where setaut.setcod = vsetcod
                            no-lock no-error.
                        if avail setaut
                        then cc-desc = setaut.setnom.
 /*

            find first func where func.funcod = fin.titulo.vencod                                    and func.etbcod = 999 no-lock no-error. 
                               
                    if avail func then
                    assign
         tempusercod =  string(acha("FUNFOLHA",fin.titulo.titobs[2])) 
         tempnomedofunc =  string(acha("NOME",fin.titulo.titobs[2])). 

*/
 
                                   
                                   /*                                   
                                   if not avail func then     
                                   tempusercod = "".      
                                   */





                        create tt-exp.
                        assign 
                            tt-exp.ano = year(banfin.titulo.titdtpag)
                            tt-exp.mes = month(banfin.titulo.titdtpag)
                            tt-exp.datpag = banfin.titulo.titdtpag
                            tt-exp.ccusto = vsetcod
                            tt-exp.desccc = cc-desc
                            tt-exp.etbcod = banfin.titulo.etbcobra
                            tt-exp.cidade = bestab.munic
                            tt-exp.grucod = bmodgru.mogcod
                            tt-exp.grumod = bmodgru.modcod
                            tt-exp.grunom = bmodgru.mognom
                            tt-exp.codmod = modgru.mogcod
                            tt-exp.modcod = banfin.titulo.modcod
                            tt-exp.modnom = wmodal.modnom
                            tt-exp.forcod = banfin.titulo.clifor
                            tt-exp.fornom = if avail forne
                                    then forne.fornom else ""
                            tt-exp.titnum = banfin.titulo.titnum 
                            tt-exp.valor  = banfin.titulo.titvlpag
                            tt-exp.vencod = banfin.titulo.vencod
                         /*   tt-exp.UserCod = tempusercod
                            tt-exp.nomedofunc = tempnomedofunc  */
                            tt-exp.exptitobs = banfin.titulo.titobs
                            .
                        if banfin.titulo.etbcobra = ? or
                           banfin.titulo.etbcobra = 0
                        then tt-exp.etbcod = banfin.titulo.etbcod.

                    end.
                
                end.
            end.
        end.        
        output to value(varquivo) page-size 0.
        
        put "ANO;MES;DATA PAGAMENTO;COD. CENTRO DE CUSTO;CENTRO DE CUSTO;" +
         "COD. ESTABELECIMENTO;CIDADE;" +
    "COD.GRUPO;GRUPO;COD.MODALIDADE;MODALIDADE;COD.FORNECEDOR;FORNECEDOR;" +
           "CODIGO DESPESA;VA LOR DESPESA; FUNCOD; CODFOLHA; NOME ; TITOBS"  format "x(240)"
           SKIP.
        
        for each tt-exp:
            vval = string(tt-exp.valor).
            if num-entries(vval,".") = 1
            then vval = vval + ".00".
            else if length(entry(2,vval,".")) = 1
            then vval = vval + "0".

            vval = replace(vval,".",";").
            vval = replace(vval,",",".").
            vval = replace(vval,";",",").

            if length(trim(vval)) < 15
            then vval = substr(string(v,"x(20)"),1,15 - length(trim(vval)))
                + trim(vval).
                
            put tt-exp.ano ";"
                tt-exp.mes ";"
                tt-exp.datpag ";"
                tt-exp.ccusto ";"
                tt-exp.desccc format "x(25)" ";"
                tt-exp.etbcod format ">>>" ";"
                tt-exp.cidade format "x(25)" ";"
                tt-exp.grumod ";"
                tt-exp.grunom format "x(30)" ";"
                tt-exp.modcod ";"
                tt-exp.modnom format "x(30)" ";"
                tt-exp.forcod format ">>>>>>>>9" ";"
                tt-exp.fornom format "x(40)" ";"
                tt-exp.titnum format "x(15)" ";"
                vval format "x(15)"  ";"
                tt-exp.vencod ";"
            /*    tt-exp.UserCod ";"
                tt-exp.nomedofunc ";" */
                tt-exp.exptitobs ";"
                skip .
            
            vtotal = vtotal + tt-exp.valor.
            
        end.
        output close.
        /*
        message vtotal. pause.
        */
        message color red/with
          varquivo view-as alert-box title " Arquivo gerado "
          .
        
        /*
        run visurel.p(varquivo,"").  
        leave.
        */
    end.
    leave.
end.
