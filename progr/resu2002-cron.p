{admcab-batch.i}

def output parameter varquivo as char.
def var /*output parameter*/ varqexc as char.

def var vlinha as int.

def temp-table tt-dados
    field linha as int
    field tipo as char
    field qtdext as int
    field campo as char extent 50
    index i1 linha
    .

def var val_des like plani.platot.

def buffer xclase for clase.
def buffer cclase for clase.
def buffer dclase for clase.
def buffer eclase for clase.
def buffer fclase for clase.
def buffer gclase for clase.

def var vanalitico as log format "Analitico/Sintetico".

def temp-table tt-cla
    field clacod like clase.clacod
    field clanom like clase.clanom
    index iclase is primary unique clacod.

def var vfabcod like fabri.fabcod.
def var vforcod like forne.forcod.
def var vfabnom like fabri.fabnom.
def var vnom as char.
def var vetbcod like estab.etbcod.
def temp-table tt-estab
    field etbcod like estab.etbcod.
def buffer bclase for clase.
def var ii as int.

def var tt-1 like plani.platot.
def var tt-2 like plani.platot.
def var tt-3 like plani.platot.
def var tt-4 like plani.platot.
def var tt-5 like plani.platot.
def var tt-6 like plani.platot.
def var tt-7 like plani.platot.
def var tt-8 like plani.platot.

def var tot1 like plani.platot.
def var tot2 like plani.platot.
def var tot3 like plani.platot.
def var tot4 like plani.platot.
def var tot5 like plani.platot.
def var tot6 like plani.platot.
def var tot7 like plani.platot.
def var tot8 like plani.platot.

def var vmes as i.
def var vano as i.
def buffer estoq for estoq.

def var t-ven  like estoq.estvenda format "->>>,>>9.99".
DEF VAR t-val  like estoq.estvenda format "->>>,>>9.99".

def var t-venda  like estoq.estvenda format "->>>,>>9.99".
DEF VAR t-valest like estoq.estvenda format ">>,>>>,>>9.99".
def var v-giro   like estoq.estvenda format "->>,>>9.99".
def var tot-v    like estoq.estvenda format "->>>,>>9.99".
DEF VAR est-ven  like estoq.estvenda format "->>>,>>9" .
DEF VAR venda    like estoq.estvenda format "->>>,>>9.99".
DEF VAR est-com  like estoq.estvenda format "->>>,>>9"   .
DEF VAR compra   like estoq.estvenda format "->>>,>>9.99".
DEF VAR est-atu  like estoq.estvenda format "->>>,>>9"   .
DEF VAR valest   like estoq.estvenda format "->>,>>>,>>9.9".
DEF VAR valcus   like estoq.estvenda format "->>>,>>9.99".

def var vclacod like clase.clacod.
def var totcusto like estoq.estcusto.
def var totvenda like estoq.estcusto.
def buffer bestoq for estoq.
def var acre like plani.platot.
def var des like plani.platot.
def buffer bcurva for curva.
def buffer bmovim for movim.
def var totc like plani.platot.
def var tot-m like plani.platot.
def var vacum like plani.platot format "->>9.99".
def var wnp as i.
def var vvltotal as dec.
def var vvlcont  as dec.
def var wacr     as dec.
def var wper     as dec.
def var valortot as dec.
def var vval     as dec.
def var vval1    as dec.
def var vsal     as dec.
def var vlfinan  as dec.
def var vdti    as date format "99/99/9999".
def var vdtf    as date format "99/99/9999".
def var vetbi   like estab.etbcod.
def var vetbf   like estab.etbcod.
def var vvlcusto    like plani.platot column-label "Vl.Custo".
def var vvlvenda    like plani.platot column-label "Vl.Venda".
def var vvlmarg     like plani.platot column-label "Margem".
def var vvlperc     as dec format ">>9.99 %" column-label "Perc".
def var vvldesc     like plani.descprod column-label "Desconto".
def var vvlacre     like plani.acfprod column-label "Acrescimo".
def var vacrepre    like plani.acfprod column-label "Acr.Previsto".
def var vcatcod     like produ.catcod.
def stream stela.
def buffer bcontnf for contnf.
def buffer bplani for plani.
def var vclasup like clase.clasup.
def temp-table tt-catcod
    field catcod like produ.catcod.

def temp-table tt-clase
    field clasup     like clase.clasup
    field clacod     like clase.clacod
    field qtd-fisico like est-ven
    field val-venda  like venda
    field qtd-compra like est-com
    field val-compra like compra
    field qtd-atual  like est-atu
    field val-atual  like valest
    field val-custo  like valcus
    field val-giro   like v-giro.

def var val-fre as dec.
def var val-isu as dec.
def temp-table tt-clase-sint
    field clasup     like clase.clasup
    field clacod     like clase.clacod
    field qtd-fisico like est-ven
    field val-venda  like venda
    field qtd-compra like est-com
    field val-compra like compra
    field qtd-atual  like est-atu
    field val-atual  like valest
    field val-custo  like valcus
    field val-giro   like v-giro.
            
            
repeat:

    for each tt-clase-sint:
        delete tt-clase-sint.
    end.
    for each tt-estab:
        delete tt-estab.
    end.
    for each tt-catcod:
        delete tt-catcod.
    end.
    for each tt-cla:
        delete tt-cla.
    end.        
    for each tt-clase:
        delete tt-clase.
    end.
    
    
    assign t-ven  =   0
           t-val   =  0
           t-venda  = 0
           t-valest = 0 
           v-giro   = 0
           tot-v    = 0
           est-ven  = 0
           venda    = 0
           est-com  = 0
           compra   = 0
           est-atu  = 0
           valest   = 0
           valcus   = 0.

    
    
    
    vnom = "".
    vcatcod = 41.
    /*
    update vcatcod label "Departamento"
                with frame f-dep centered side-label color blue/cyan row 4.
    */
    find categoria where categoria.catcod = vcatcod no-lock.
    /*
    disp categoria.catnom no-label with frame f-dep.
    */
    sresp = no  .
    /*
    if categoria.catcod = 31 or
       categoria.catcod = 35
    then message "Deseja agrupar departamentos [31 - 35]" update sresp.
    else message "Deseja agrupar departamentos [41 - 45]" update sresp.
    */
    if sresp
    then do:
        if vcatcod = 31 or
           vcatcod = 35
        then do:
            create tt-catcod.
            assign tt-catcod.catcod = 31.
            create tt-catcod.
            assign tt-catcod.catcod = 35.
            create tt-catcod.
            assign tt-catcod.catcod = 50.
        end.
        if vcatcod = 41 /* or    antonio - Somente confec��o  
           vcatcod = 445 */
        then do:
            create tt-catcod.
            assign tt-catcod.catcod = 41.
        end.
    end.
    else do:
        create tt-catcod.
        assign tt-catcod.catcod = categoria.catcod.
    end.

    assign tot1 = 0 tot2 = 0 tot3 = 0 tot4 = 0 tot5 = 0 
           tot6 = 0 tot7 = 0 tot8 = 0 t-valest = 0 t-venda  = 0.


    assign  tt-1 = 0 tt-2 = 0 tt-3 = 0 tt-4 = 0 tt-5 = 0 tt-6 = 0
            tt-7 = 0 tt-8 = 0.
    
    vdti = date(month(today),01,year(today)).
    vdtf = today - 1.
    /** 
    update vdti label "Periodo"
           "a"
           vdtf no-label with frame f-dat centered color blue/cyan row 8
                                    title " Periodo ".
    **/

    /**
    update skip vanalitico label "Tipo"
        help "[A] Analitico [S] Sintetico"
        with frame f-dat.

    update vclacod at 01 label "Classe" with frame f-dat side-label.

    if vclacod <> 0
    then do:
        find xclase where xclase.clacod = vclacod no-lock no-error.
        display xclase.clanom no-label with frame f-dat.
    end.
    else disp "Todas" @ xclase.clanom with frame f-dat.
    **/
    
        find first clase where clase.clasup = vclacod no-lock no-error. 
        if avail clase 
        then do:
            run cria-tt-cla. 
            hide message no-pause.
        end. 
        else do:
            find clase where clase.clacod = vclacod no-lock no-error.
            if not avail clase
            then do:
                message "Classe nao Cadastrada".
                undo.
            end.

            create tt-cla.
            assign tt-cla.clacod = clase.clacod
                   tt-cla.clanom = clase.clanom.

        end.

        
    
    
    repeat:
        /*
        for each tt-estab:
            disp tt-estab.etbcod column-label "Filiais"
                    with frame f-down row 05 down color blue/cyan.
        end.
        */
        /*
        update vetbcod
            with frame f-etb centered side-label color blue/cyan row 15.
        */

        if vetbcod <> 0
        then do:
            find estab where estab.etbcod = vetbcod no-lock.
            create tt-estab.
            assign tt-estab.etbcod = estab.etbcod.
        end.
        else do:
            /*
            display "GERAL" with frame f-etb.
                */
            vnom = "GERAL".
            for each estab where estab.etbcod <> 0 no-lock:
                create tt-estab.
                assign tt-estab.etbcod = estab.etbcod.
            end.
            leave.
        end.
    end.
    
    if vnom = ""
    then do:
        for each tt-estab:
            vnom = vnom + string(tt-estab.etbcod,">>9") + " ".
        end.
    end.
    /*
    update /*vfabcod*/ vforcod label "Fornecedor"
                with frame f-depf centered side-label color blue/cyan.
    vfabcod = vforcod.
    */
    if vfabcod = 0
    then do:
        /*
        display "GERAL" @ fabri.fabnom with frame f-depf.
        */ 
        vfabnom = "GERAL".
    end.
    else do:             
        find fabri where fabri.fabcod = vfabcod no-lock.
        disp fabri.fabnom no-label with frame f-depf.
        vfabnom = fabri.fabfant.
    end.
    /*
    message "Confirma Resumo ? " update sresp.
    if not sresp
    then next.
    */
    assign est-ven = 0
           venda   = 0
           est-com = 0
           compra  = 0
           est-atu = 0
           valest  = 0
           valcus  = 0.
    
    if opsys = "UNIX"
    then varquivo = "/admcom/relat-auto/" + string(day(today),"99") + "-" + 
                                   string(month(today),"99") + "-" + 
                                   string(year(today),"9999") +
                        "/RCVEG-" + string(day(today),"99") +  
                                   string(month(today),"99") + 
                                   string(year(today),"9999") +
                           "." + string(time).

    {/admcom/progr/mdad.i
        &Saida     = "value(varquivo)"
        &Page-Size = "0"
        &Cond-Var  = "147"
        &Page-Line = "0"
        &Nom-Rel   = ""RESU2002-CRON""
        &Nom-Sis   = """SISTEMA DE ESTOQUE"""
        &Tit-Rel   = """FILIAL "" + string(vetbcod,"">>9"")
                        + "" "" + vfabnom + "" ""
                        + string(vfabcod,"">>>>>9"") + 
                        "" PERIODO DE "" +
                         string(vdti,""99/99/9999"") + "" A "" +
                         string(vdtf,""99/99/9999"") "
       &Width     = "147"
       &Form      = "frame f-cabcab"}
    
    tot-v = 0.

    
    for each tt-cla no-lock:

        find clase where clase.clacod = tt-cla.clacod no-lock no-error.

        find cclase where cclase.clacod = clase.clasup no-lock no-error.
        find dclase where dclase.clacod = cclase.clasup no-lock no-error.
                              
        for each tt-catcod,         
            
            each produ where produ.catcod = tt-catcod.catcod and
                             produ.clacod = tt-cla.clacod no-lock:
            
            if vfabcod = 0
            then.
            else do:
                if vfabcod = produ.fabcod
                then.
                else next.
            end.
            
            find first movim where movim.procod = produ.procod and
                                   movim.movdat >= vdti        and
                                   movim.movdat <= vdtf no-lock no-error.
            if not avail movim
            then do:
                find first estoq where estoq.procod = produ.procod and
                                       estoq.estatual <> 0 no-lock no-error.
                if not avail estoq
                then next.
            end.
            
            for each tt-estab,
                each movim where movim.procod = produ.procod    and
                                 movim.etbcod = tt-estab.etbcod and
                                 movim.movtdc = 5               and
                                 movim.movdat >= vdti           and
                                 movim.movdat <= vdtf        no-lock:
                
                if movim.movqtm = 0 or
                   movim.movpc  = 0
                then next.

                assign totc = 0 des = 0 acre = 0.
                
                find first plani where plani.etbcod = movim.etbcod and
                                       plani.placod = movim.placod and
                                       plani.pladat = movim.movdat and
                                       plani.movtdc = movim.movtdc
                                                        no-lock no-error.
                if not available plani
                then next.

 
                
                if plani.crecod = 2
                then do:
                    if plani.biss > ( plani.platot - plani.vlserv) and
                       (plani.platot - plani.vlserv) >= 1
                    then acre = plani.biss / (plani.platot - plani.vlserv).
                    
                    if acre = ? then acre = 0.
                    
                    if plani.biss < ( plani.platot - plani.vlserv) 
                    then des = (plani.platot - plani.vlserv) / plani.biss.
                    
                    if des = ? then des = 0.
                end. 
                else do: 
                    if plani.acfprod > 0
                    then acre = (plani.platot + plani.acfprod) / plani.platot.
                    
                    if acre = ? then acre = 0.
                    
                    if plani.descprod > 0
                    then des = plani.platot / (plani.platot - plani.descprod).
                    
                    if des = ? then des = 0.
                end.
                if plani.platot < 1
                then assign des = 0
                            acre = 0.

                
                find estoq where estoq.etbcod = movim.etbcod and
                                 estoq.procod = produ.procod 
                                                no-lock no-error.
                if not avail estoq
                then next.

                if acre > 0
                then do:
                    if ( movim.movqtm * movim.movpc * acre ) - 
                       ( ( ( movim.movqtm * movim.movpc ) / 
                             plani.platot ) * plani.vlserv ) <> ?
                    then venda = venda + 
                        ( movim.movqtm * movim.movpc * acre ) - 
                        ( ( ( movim.movqtm * movim.movpc ) / 
                              plani.platot ) * plani.vlserv ).
                
                    if venda = ? then venda = 0.
                    
                end.
                
                if des > 0
                then do:
                    if ( movim.movqtm * movim.movpc / des ) - 
                          ( ( ( movim.movqtm * movim.movpc ) / 
                                plani.platot ) * plani.vlserv ) <> ?
                    
                    then venda = venda +
                             ( movim.movqtm * movim.movpc / des ) - 
                             ( ( ( movim.movqtm * movim.movpc ) / 
                                   plani.platot ) * plani.vlserv ).
                                   
                    if venda = ? then venda = 0.               
                end.

                if acre = 0 and des = 0
                then do:
                       
                    if ( ( movim.movqtm * movim.movpc ) - 
                       ( ( ( movim.movqtm * movim.movpc ) / 
                             plani.platot ) * plani.vlserv ) ) <> ?
                   
                    then venda = venda +
                              ( ( movim.movqtm * movim.movpc ) - 
                              ( ( ( movim.movqtm * movim.movpc ) / 
                                    plani.platot ) * plani.vlserv ) ).
                    
                    if venda = ? then venda = 0.
                    
                end.
                est-ven = est-ven + movim.movqtm.
                
                if est-ven = ? then est-ven = 0.
            end.

            for each tt-estab,                  
                each movim where movim.procod = produ.procod    and
                                 movim.etbcod = tt-estab.etbcod and
                                 movim.movtdc = 4               and
                                 movim.datexp >= vdti           and
                                 movim.datexp <= vdtf        no-lock:
                                 
                find first plani where plani.etbcod = movim.etbcod and
                                      plani.placod = movim.placod and
                                      plani.pladat = movim.movdat and
                                      plani.movtdc = movim.movtdc 
                                      no-lock no-error.
               if not available plani
               then next.

               find estoq where estoq.etbcod = movim.etbcod and
                                estoq.procod = movim.procod no-lock no-error.
                                
               if not avail estoq
               then next.                 
               
               val_des = 0. 
               val_des = ((movim.movpc * movim.movqtm) / 
                            (plani.platot + plani.descprod)) 
                       * plani.descprod.
                       
               /*val-fre = plani.frete *
                         ((movim.movpc * movim.movqtm) /  plani.protot).
                         */
               val-isu = plani.icmssubst *
                        ((movim.movpc * movim.movqtm) /  plani.protot). 

                if val_des = ? then val_des = 0.      
               if val-fre = ? then val-fre = 0.
               if val-isu = ? then val-isu = 0.  
               compra = compra + 
                      (
                      ((movim.movpc * movim.movqtm) + 
                      ((movim.movpc * movim.movqtm) * (movim.movalipi / 100)))
                      - val_des ) + val-fre + val-isu.
               

               /*(movim.movqtm * estoq.estcusto).
               */
               /***( (movim.movpc * movim.movqtm) +
                  ((movim.movpc * movim.movqtm) * (movim.movalipi / 100)) ).
               ***/
               
               est-com = est-com + movim.movqtm.
               
               if compra = ? then compra = 0.
               if est-com = ? then est-com = 0.
               
            end.
            
            for each tt-estab,
                each movim where movim.procod = produ.procod    and
                                 movim.etbcod = tt-estab.etbcod and
                                 movim.movtdc = 1            and
                                 movim.datexp >= vdti        and
                                 movim.datexp <= vdtf    no-lock.
                
                                  
                compra  = compra + ( (movim.movpc * movim.movqtm) +
                                    
                  ((movim.movpc * movim.movqtm) * (movim.movalipi / 100)) ).
                
                est-com = est-com + movim.movqtm.
            
                if compra = ? then compra = 0.
                if est-com = ? then est-com = 0.
            end.

            /***** compras newfree *******/
            for each movim where movim.etbcod = 22 and
                                 movim.movtdc = 06 and
                                 movim.procod = produ.procod and
                                 movim.movdat >= vdti and
                                 movim.movdat <= vdtf and 
                                 (movim.desti  = 995 or
                                  movim.desti  = 996 or
                                  movim.desti  = 900) no-lock:
                                  
                compra  = compra + ( (movim.movpc * movim.movqtm) +
                  ((movim.movpc * movim.movqtm) * (movim.movalipi / 100)) ).
                
                est-com = est-com + movim.movqtm.

                if compra = ? then compra = 0.
                if est-com = ? then est-com = 0.                
            end.

            for each tt-estab:
                find estoq where estoq.etbcod = tt-estab.etbcod and
                                 estoq.procod = produ.procod no-lock no-error.
                if avail estoq
                then do:
                    valest  = valest  + 
                              (estoq.estatual * estoq.estvenda).
                    valcus  = valcus  + 
                              (estoq.estatual * estoq.estcusto).
                    est-atu = est-atu + estoq.estatual.
                
                    if valest = ? then valest = 0.
                    if valcus = ? then valcus = 0.
                    if est-atu = ? then est-atu = 0.
                end.
            end.
            /*
            output stream stela to terminal.
                disp stream stela produ.procod format ">>>>>>>9" produ.clacod
                        with frame ffff centered color white/red 1 down.
                pause 0.
            output stream stela close.
            */
        end.

        
        v-giro = (valest / venda).
        if v-giro = ? then v-giro = 0.
        
        
        tt-1 = tt-1 + est-ven.
                       
        tt-2 = tt-2 + venda.
        
        /* tt-3 = tt-3 + ((venda / tot-v) * 100). */

        tt-4 = tt-4 + est-com.
        
        tt-5 = tt-5 + compra.
        
        tt-6 = tt-6 + est-atu.
        
        tt-7 = tt-7 + valest.
        
        tt-8 = tt-8 + valcus.

        if venda > 0 or
           est-atu <> 0
        then do:
            create tt-clase.
            assign tt-clase.clasup     = clase.clasup
                   tt-clase.clacod     = clase.clacod
                   tt-clase.qtd-fisico = est-ven
                   tt-clase.val-venda  = venda
                   tt-clase.qtd-compra = est-com
                   tt-clase.val-compra = compra
                   tt-clase.qtd-atual  = est-atu
                   tt-clase.val-atual  = valest
                   tt-clase.val-custo  = valcus
                   tt-clase.val-giro   = v-giro.

          /*** teste ***/
          
            find cclase where cclase.clacod = tt-clase.clasup no-lock no-error.
            find dclase where dclase.clacod = cclase.clasup no-lock no-error.

            find first tt-clase-sint where
                 tt-clase-sint.clacod = dclase.clacod no-lock no-error.
            if not avail tt-clase-sint
            then do:
                create tt-clase-sint.
                assign tt-clase-sint.clasup     = dclase.clasup
                       tt-clase-sint.clacod     = dclase.clacod.
            end.
                   
            assign tt-clase-sint.qtd-fisico = 
                       tt-clase-sint.qtd-fisico + est-ven
                   
                   tt-clase-sint.val-venda  =
                       tt-clase-sint.val-venda + venda

                   tt-clase-sint.qtd-compra =
                       tt-clase-sint.qtd-compra + est-com
                       
                   tt-clase-sint.val-compra =
                       tt-clase-sint.val-compra + compra
                       
                   tt-clase-sint.qtd-atual  =
                       tt-clase-sint.qtd-atual + est-atu
                       
                   tt-clase-sint.val-atual  = 
                       tt-clase-sint.val-atual + valest
                       
                   tt-clase-sint.val-custo  = 
                       tt-clase-sint.val-custo + valcus.
                   
          
          /***       ***/
            assign est-ven = 0
                   venda   = 0
                   est-com = 0
                   compra = 0
                   est-atu = 0
                   valest  = 0
                   valcus  = 0.
        end.
    end.    

    for each tt-clase-sint:
    
        tt-clase-sint.val-giro = 
            (tt-clase-sint.val-atual / tt-clase-sint.val-venda).

        if tt-clase-sint.val-giro = ?
        then tt-clase-sint.val-giro = 0.
        
    end.

            assign tot1 = 0
                   tot2 = 0
                   tot3 = 0
                   tot4 = 0
                   tot5 = 0
                   tot6 = 0
                   tot7 = 0
                   tot8 = 0
                   t-valest = 0
                   t-venda  = 0.

vlinha =  1.
    create tt-dados.
    assign
        tt-dados.linha = vlinha
        tt-dados.tipo  = "C"
        tt-dados.qtdext = 11
        tt-dados.campo[2] = "PERIODO DE"
        tt-dados.campo[3] = STRING(VDTI,"99/99/99")
        tt-dados.campo[4] = "  ATE "
        tt-dados.campo[5] = string(vdtf,"99/99/99")        
        .
 
if vanalitico
then do:
    vlinha = vlinha + 1.
    create tt-dados.
    assign
        tt-dados.linha = vlinha
        tt-dados.tipo  = "C"
        tt-dados.qtdext = 11
        tt-dados.campo[3] = "VENDA"
        tt-dados.campo[6] = "COMPRA"
        tt-dados.campo[8] = "ESTOQUE"
        .
    vlinha = vlinha + 1.
    create tt-dados.
    assign
        tt-dados.linha = vlinha
        tt-dados.tipo  = "L"
        tt-dados.qtdext = 11
        tt-dados.campo[1] = "Classe"
        tt-dados.campo[2] = "Descricao"
        tt-dados.campo[3] = "Qtd.Ven"
        tt-dados.campo[4] = "Financeiro(1)"
        tt-dados.campo[5] = "%/Par"
        tt-dados.campo[6] = "Qtd.Com"
        tt-dados.campo[7] = "Financeiro(2)"
        tt-dados.campo[8] = "Qtd.Est"
        tt-dados.campo[9] = "Est.Ven"
        tt-dados.campo[10] = "Est.Cus"
        tt-dados.campo[11] = "Giro(3)"
                .
  
    for each tt-clase no-lock break by tt-clase.clasup
                                    by tt-clase.clacod:
                  
            
        if line-counter = 6
        then put "        V E N D A S                 C O M P R A S  " at 35
                 "               E S T O Q U E S        "
                                  skip fill("-",135) format "x(135)".
        if line-counter = 6
        then put "        V E N D A S                 C O M P R A S   " at 35
                 "               E S T O Q U E S "
                          skip fill("-",135) format "x(135)".

            
        find clase where clase.clacod = tt-clase.clacod no-lock.

        tot1 = tot1 + tt-clase.qtd-fisico.
        tot2 = tot2 + tt-clase.val-venda.
        tot3 = tot3 + (if (tt-clase.val-venda / tt-2) /* * 100*/ <> ?
                       then (tt-clase.val-venda / tt-2)
                       else 0).
        
        
        tot4 = tot4 + tt-clase.qtd-compra.
        tot5 = tot5 + tt-clase.val-compra.
        tot6 = tot6 + tt-clase.qtd-atual.
        tot7 = tot7 + tt-clase.val-atual.
        tot8 = tot8 + tt-clase.val-custo.
          
        tt-3 = tt-3 + ( if ((tt-clase.val-venda / tt-2) * 100) <> ?
                        then ((tt-clase.val-venda / tt-2) * 100)
                        else 0). 
     
        vlinha = vlinha + 1.
        create tt-dados.
        assign
            tt-dados.linha = vlinha
            tt-dados.tipo  = "D"
            tt-dados.qtdext = 11
            tt-dados.campo[1] = string(tt-clase.clacod)
            tt-dados.campo[2] = clase.clanom
            tt-dados.campo[3] = string(tt-clase.qtd-fisico)
            tt-dados.campo[4] = string(tt-clase.val-venda,"->>,>>>,>>9.99")
            tt-dados.campo[5] = string((tt-clase.val-venda /                                                 tt-2),"->>>,>>9.99")
            tt-dados.campo[6] = string(tt-clase.qtd-compra)
            tt-dados.campo[7] = string(tt-clase.val-compra,"->>,>>>,>>9.99")
            tt-dados.campo[8] = string(tt-clase.qtd-atual)
            tt-dados.campo[9] = string(tt-clase.val-atual,"->>,>>>,>>9.99")
            tt-dados.campo[10] = string(tt-clase.val-custo,"->>,>>>,>>9.99")
            tt-dados.campo[11] = string(tt-clase.val-giro)
                .
        
        display tt-clase.clacod
                clase.clanom when avail clase   format "x(20)"
                tt-clase.qtd-fisico column-label "Qtd.Ven"
                tt-clase.val-venda  column-label "FINANCEIRO(1)"
                                format "->>>>>,>>9.99"
                ((tt-clase.val-venda / tt-2) /** 100*/)
                                   column-label "%/Par." format "->,>>9.99"
                tt-clase.qtd-compra column-label "Qtd.Com"
                tt-clase.val-compra column-label "FINANCEIRO(2)"
                                format "->>>>>,>>9.99"
                tt-clase.qtd-atual  column-label "Qtd.Est"
                tt-clase.val-atual  column-label "Est.Ven"
                                format "->>>>>,>>9.99"
                tt-clase.val-custo  column-label "Est.Cus"
                                format "->>>>>,>>9.99"
                tt-clase.val-giro  column-label "Giro(3)"
                        with frame f-1 width 195 down no-box.
        t-venda  = t-venda  + tt-clase.val-venda.
        t-valest = t-valest + tt-clase.val-atual.
        t-ven    = t-venda  + tt-clase.val-venda.
        t-val    = t-valest + tt-clase.val-atual.
      
      
        if last-of(tt-clase.clasup) and
           (tot2 > 0 or tot6 > 0)
        then do:
            vlinha = vlinha + 1.
            create tt-dados.
            assign
                tt-dados.linha = vlinha
                tt-dados.tipo  = "D"
                tt-dados.qtdext = 11.
                
            vlinha = vlinha + 1.
            create tt-dados.
            assign
                tt-dados.linha = vlinha
                tt-dados.tipo  = "D"
                tt-dados.qtdext = 11
                tt-dados.campo[1] = string(tt-clase.clacod)
                tt-dados.campo[2] = "T O T A I S"
                tt-dados.campo[3] = string(tot1)
                tt-dados.campo[4] = string(tot2,"->>,>>>,>>9.99")
                tt-dados.campo[5] = string(tot3,"->,>>9.99")
                tt-dados.campo[6] = string(tot4)
                tt-dados.campo[7] = string(tot5,"->>,>>>,>>9.99")
                tt-dados.campo[8] = string(tot6)
                tt-dados.campo[9] = string(tot7,"->>,>>>,>>9.99")
                tt-dados.campo[10] = string(tot8,"->>,>>>,>>9.99")
                tt-dados.campo[11] = string((t-valest / t-venda))
                .
             
             put skip.
            put fill("-",135) format "x(135)" skip.
            put "T O T A I S ..............."
                 tot1  to 41  format "->>>,>>9" 
                 tot2  to 55  format ">>>>>,>>9.99"
                 tot3  to 65  format "->,>>9.99"
                 tot4  to 74  format "->>>,>>9"
                 tot5  to 88  format ">>>>>,>>9.99"
                 tot6  to 97  format "->>>,>>9"
                 tot7  to 111 format "->>>>>,>>9.99"
                 tot8  to 125 format "->>>>>,>>9.99" 
                 (t-valest / t-venda) to 135 skip
                     fill("-",135) format "x(135)" skip(1).

            assign tot1 = 0
                   tot2 = 0
                   tot3 = 0
                   tot4 = 0
                   tot5 = 0
                   tot6 = 0
                   tot7 = 0
                   tot8 = 0
                   t-valest = 0
                   t-venda  = 0.
            vlinha = vlinha + 1.
            create tt-dados.
            assign
                tt-dados.linha = vlinha
                tt-dados.tipo  = "D"
                tt-dados.qtdext = 11     .
 
        end.
    end.
end.
else do: /* sintetico */
    vlinha = vlinha + 1.
    create tt-dados.
    assign
        tt-dados.linha = 1
        tt-dados.tipo  = "C"
        tt-dados.qtdext = 11
        tt-dados.campo[3] = "VENDA"
        tt-dados.campo[6] = "COMPRA"
        tt-dados.campo[8] = "ESTOQUE"
        .
    vlinha = vlinha + 1.
    create tt-dados.
    assign
        tt-dados.linha = vlinha
        tt-dados.tipo  = "L"
        tt-dados.qtdext = 11
        tt-dados.campo[1] = "Classe"
        tt-dados.campo[2] = "Descricao"
        tt-dados.campo[3] = "Qtd.Ven"
        tt-dados.campo[4] = "Financeiro(1)"
        tt-dados.campo[5] = "%/Par"
        tt-dados.campo[6] = "Qtd.Com"
        tt-dados.campo[7] = "Financeiro(2)"
        tt-dados.campo[8] = "Qtd.Est"
        tt-dados.campo[9] = "Est.Ven"
        tt-dados.campo[10] = "Est.Cus"
        tt-dados.campo[11] = "Giro(3)"
                .
     for each tt-clase-sint no-lock break by tt-clase-sint.clasup
                                         by tt-clase-sint.clacod:
                  
            
        if line-counter = 6
        then put "        V E N D A S                 C O M P R A S  " at 35
                 "               E S T O Q U E S        "
                                  skip fill("-",135) format "x(135)".
        if line-counter = 6
        then put "        V E N D A S                 C O M P R A S   " at 35
                 "               E S T O Q U E S "
                          skip fill("-",135) format "x(135)".

            
        find clase where clase.clacod = tt-clase-sint.clacod no-lock.

        tot1 = tot1 + tt-clase-sint.qtd-fisico.
        tot2 = tot2 + tt-clase-sint.val-venda.
        
        
        tot3 = tot3 + (if ((tt-clase-sint.val-venda / tt-2) * 100) <> ?
                      then ((tt-clase-sint.val-venda / tt-2) * 100)
                      else 0).
        
        
        tot4 = tot4 + tt-clase-sint.qtd-compra.
        tot5 = tot5 + tt-clase-sint.val-compra.
        tot6 = tot6 + tt-clase-sint.qtd-atual.
        tot7 = tot7 + tt-clase-sint.val-atual.
        tot8 = tot8 + tt-clase-sint.val-custo.
          
        tt-3 = tt-3 + (if ((tt-clase-sint.val-venda / tt-2) * 100) <> ?
                       then ((tt-clase-sint.val-venda / tt-2) * 100)
                       else 0). 
     
        vlinha = vlinha + 1.
        create tt-dados.
        assign
            tt-dados.linha = vlinha
            tt-dados.tipo  = "D"
            tt-dados.qtdext = 11
            tt-dados.campo[1] = string(tt-clase-sint.clacod)
            tt-dados.campo[2] = clase.clanom
            tt-dados.campo[3] = string(tt-clase-sint.qtd-fisico)
            tt-dados.campo[4] = string(tt-clase-sint.val-venda,"->>,>>>,>>9.99")
            tt-dados.campo[5] = string((tt-clase-sint.val-venda / tt-2))
            tt-dados.campo[6] = string(tt-clase-sint.qtd-compra)
            tt-dados.campo[7] =                         string(tt-clase-sint.val-compra,"->>,>>>,>>9.99") 
            tt-dados.campo[8] = string(tt-clase-sint.qtd-atual)
            tt-dados.campo[9] = string(tt-clase-sint.val-atual,"->>,>>>,>>9.99")
            tt-dados.campo[10] =                         string(tt-clase-sint.val-custo,"->>,>>>,>>9.99")
            tt-dados.campo[11] = string(tt-clase-sint.val-giro)
                .
 
        display tt-clase-sint.clacod
                clase.clanom when avail clase
                tt-clase-sint.qtd-fisico column-label "Qtd.Ven"
                tt-clase-sint.val-venda  column-label "FINANCEIRO(1)"
                                format "->>>>>,>>9.99"
                
                (if ((tt-clase-sint.val-venda / tt-2) * 100) <> ?
                 then ((tt-clase-sint.val-venda / tt-2) * 100)
                 else 0)
               
                column-label "%/Par." format "->,>>9.99"
                tt-clase-sint.qtd-compra column-label "Qtd.Com"
                tt-clase-sint.val-compra column-label "FINANCEIRO(2)"
                                format "->>>>>,>>9.99"
                tt-clase-sint.qtd-atual  column-label "Qtd.Est"
                tt-clase-sint.val-atual  column-label "Est.Ven"
                                format "->>>>>,>>9.99"
                tt-clase-sint.val-custo  column-label "Est.Cus"
                                format "->>>>>,>>9.99"
                tt-clase-sint.val-giro  column-label "Giro(3)"
                        with frame f-1sint width 200 down no-box.
        t-venda  = t-venda  + tt-clase-sint.val-venda.
        t-valest = t-valest + tt-clase-sint.val-atual.
        t-ven    = t-venda  + tt-clase-sint.val-venda.
        t-val    = t-valest + tt-clase-sint.val-atual.
      
      
        if last-of(tt-clase-sint.clasup) and
           (tot2 > 0 or tot6 > 0)
        then do:
            vlinha = vlinha + 1.
            create tt-dados.
            assign
                tt-dados.linha = vlinha
                tt-dados.tipo  = "D"
                tt-dados.qtdext = 11.
                
            vlinha = vlinha + 1.
            create tt-dados.
            assign
                tt-dados.linha = vlinha
                tt-dados.tipo  = "D"
                tt-dados.qtdext = 11
                tt-dados.campo[2] = "T O T A I S"
                tt-dados.campo[3] = string(tot1)
                tt-dados.campo[4] = string(tot2,"->>,>>>,>>9.99")
                tt-dados.campo[5] = string(tot3)
                tt-dados.campo[6] = string(tot4)
                tt-dados.campo[7] = string(tot5,"->>,>>>,>>9.99")
                tt-dados.campo[8] = string(tot6)
                tt-dados.campo[9] = string(tot7,"->>,>>>,>>9.99")
                tt-dados.campo[10] = string(tot8,"->>,>>>,>>9.99")
                tt-dados.campo[11] = string((t-valest / t-venda))
                .

            put skip.
            put fill("-",135) format "x(135)" skip.
            put "T O T A I S ..............."
                 tot1  to 41  format "->>>,>>9" 
                 tot2  to 55  format ">>>>>,>>9.99"
                 tot3  to 65  format "->,>>9.99"
                 tot4  to 74  format "->>>,>>9"
                 tot5  to 88  format ">>>>>,>>9.99"
                 tot6  to 97  format "->>>,>>9"
                 tot7  to 111 format "->>>>>,>>9.99"
                 tot8  to 125 format "->>>>>,>>9.99" 
                 if (t-valest / t-venda) <> ?
                 then (t-valest / t-venda)
                 else 0 to 135 skip
                     fill("-",135) format "x(135)" skip(1).

            assign tot1 = 0
                   tot2 = 0
                   tot3 = 0
                   tot4 = 0
                   tot5 = 0
                   tot6 = 0
                   tot7 = 0
                   tot8 = 0
                   t-valest = 0
                   t-venda  = 0.
            vlinha = vlinha + 1.
            create tt-dados.
            assign
                tt-dados.linha = vlinha
                tt-dados.tipo  = "D"
                tt-dados.qtdext = 11.
                
        end.
    end.
end.    
    
    if tt-2 > 0 or
       tt-6 > 0
    then do:
        vlinha = vlinha + 1.
            create tt-dados.
            assign
                tt-dados.linha = vlinha
                tt-dados.tipo  = "D"
                tt-dados.qtdext = 11.
                
            vlinha = vlinha + 1.
            create tt-dados.
            assign
                tt-dados.linha = vlinha
                tt-dados.tipo  = "D"
                tt-dados.qtdext = 11
                tt-dados.campo[2] = "T O T A L  G E R A L"
                tt-dados.campo[3] = string(tt-1)
                tt-dados.campo[4] = string(tt-2,"->>,>>>,>>9.99")
                tt-dados.campo[5] = string(tt-3)
                tt-dados.campo[6] = string(tt-4)
                tt-dados.campo[7] = string(tt-5,"->>,>>>,>>9.99")
                tt-dados.campo[8] = string(tt-6)
                tt-dados.campo[9] = string(tt-7,"->>,>>>,>>9.99")
                tt-dados.campo[10] = string(tt-8,"->>,>>>,>>9.99")
                tt-dados.campo[11] = string((tt-7 / tt-2))
                .

        put skip
            fill("-",135) format "x(135)" skip
            "T O T A L  G E R A L ......"
             tt-1 to 41 format "->>>,>>9"
             tt-2 to 55 format  ">>>>>>,>>9.99"
             tt-3 to 65 format  "->,>>9.99"
             tt-4 to 74 format  "->>>,>>9"
             tt-5 to 88 format  ">>>>>>,>>9.99"
             tt-6 to 97 format  "->>>,>>9"
             tt-7 to 111 format ">>>>>>,>>9.99" 
             tt-8 to 125 format ">>>>>>,>>9.99"
             
             if (tt-7 / tt-2) <> ?
             then (tt-7 / tt-2)
             else 0  to 135 skip
             fill("-",135) format "x(135)" skip.
        
    end.
    output close.
    /*
    if opsys = "UNIX"
    then do:
        message "Arquivo gerado: " varquivo. pause.
                                            /*
        run visurel.p (input varquivo, input "").*/
        
    end.    
    else do:
        {mrod.i}
    end.
    */    
    leave. 
end.
/***********************************/
varqexc = "/admcom/relat-auto/" + string(day(today),"99") + "-" + 
                                   string(month(today),"99") + "-" + 
                                   string(year(today),"9999") +
                        "/RCVEG-" + string(day(vdtf),"99") +  
                                   string(month(vdtf),"99") + 
                                   string(year(vdtf),"9999") +
                            string(time) + ".csv".
 
def var varqexc1 as char.
varqexc1 = "/admcom/relat-auto/" + string(day(today),"99") + "-" + 
                                   string(month(today),"99") + "-" + 
                                   string(year(today),"9999") +
                        "/RCVEG-" + string(day(vdtf),"99") +  
                                   string(month(vdtf),"99") + 
                                   string(year(vdtf),"9999") +
                            string(time) + ".log".
 
def var vi as int.
output to value(varqexc) page-size 0.
    for each tt-dados use-index i1 no-lock:
        put unformatted 
            tt-dados.campo[1] format "x(8)"  ";"
            tt-dados.campo[2] format "x(15)" ";"
            tt-dados.campo[3] format "x(8)" ";"
            tt-dados.campo[4] format "x(8)" ";"
            tt-dados.campo[5] format "x(8)" ";"
            tt-dados.campo[6] format "x(8)" ";"
            tt-dados.campo[7] format "x(8)" ";"
            tt-dados.campo[8] format "x(8)" ";"
            tt-dados.campo[9] format "x(8)"  ";"
            tt-dados.campo[10] format "x(8)" ";"
            tt-dados.campo[11] format "x(8)" ";"
            tt-dados.campo[16] format "x(8)" 
            skip.
    end.    
output close.
def var vassunto as char.
vassunto = "teste".
def var v-mail as char.
v-mail = "claudir@custombs.com.br".
unix silent value("/admcom/progr/mail.sh "
                             + "~"" + vassunto + "~" "
                             + varqexc
                             + " "
                             + v-mail
                             + " "
                             + "informativo@lebes.com.br"
                             + " "
                             + "~"zip~""
                             + " > "
                             + varqexc1
                             + " 2>&1 ").      
 
/*******************************/

 procedure cria-tt-cla.
 for each clase where clase.clasup = vclacod no-lock:
   find first bclase where bclase.clasup = clase.clacod no-lock no-error.
   if not avail bclase
   then do: 
     find tt-cla where tt-cla.clacod = clase.clacod no-error. 
     if not avail tt-cla 
     then do: 
       create tt-cla. 
       assign tt-cla.clacod = clase.clacod 
              tt-cla.clanom = clase.clanom.
     end.
   end.
   else do: 
     for each bclase where bclase.clasup = clase.clacod no-lock: 
         find first cclase where cclase.clasup = bclase.clacod no-lock no-error.
         if not avail cclase
         then do: 
           find tt-cla where tt-cla.clacod = bclase.clacod no-error. 
           if not avail tt-cla 
           then do: 
             create tt-cla. 
             assign tt-cla.clacod = bclase.clacod 
                    tt-cla.clanom = bclase.clanom.
           end.
         end.
         else do: 
           for each cclase where cclase.clasup = bclase.clacod no-lock: 
             find first dclase where dclase.clasup = cclase.clacod 
                                                     no-lock no-error. 
             if not avail dclase 
             then do: 
               find tt-cla where tt-cla.clacod = cclase.clacod no-error. 
               if not avail tt-cla 
               then do: 
                 create tt-cla. 
                 assign tt-cla.clacod = cclase.clacod 
                        tt-cla.clanom = cclase.clanom.
               end.                          
             end.
             else do: 
               for each dclase where dclase.clasup = cclase.clacod no-lock: 
                 find first eclase where eclase.clasup = dclase.clacod 
                                                         no-lock no-error. 
                 if not avail eclase 
                 then do: 
                   find tt-cla where tt-cla.clacod = dclase.clacod no-error.
                   if not avail tt-cla 
                   then do: 
                     create tt-cla. 
                     assign tt-cla.clacod = dclase.clacod 
                            tt-cla.clanom = dclase.clanom. 
                   end.       
                 end. 
                 else do:  
                   for each eclase where eclase.clasup = dclase.clacod no-lock:
                     find first fclase where fclase.clasup = eclase.clacod 
                                                             no-lock no-error.
                     if not avail fclase 
                     then do: 
                       find tt-cla where tt-cla.clacod = eclase.clacod
                                                             no-error.
                       if not avail tt-cla 
                       then do: 
                         create tt-cla. 
                         assign tt-cla.clacod = eclase.clacod 
                                tt-cla.clanom = eclase.clanom.
                       end.
                     end.
                     else do:
                     
                       for each fclase where fclase.clasup = eclase.clacod
                                    no-lock:
                         find first gclase where gclase.clasup = fclase.clacod 
                                                             no-lock no-error.
                         if not avail gclase 
                         then do: 
                           find tt-cla where tt-cla.clacod = fclase.clacod
                                                                 no-error.
                           if not avail tt-cla 
                           then do: 
                             create tt-cla. 
                             assign tt-cla.clacod = fclase.clacod 
                                    tt-cla.clanom = fclase.clanom.
                           end.
                         end.
                         else do:
                             find tt-cla where tt-cla.clacod = gclase.clacod 
                                                        no-error.
                             if not avail tt-cla
                             then do:
                             
                                 create tt-cla. 
                                 assign tt-cla.clacod = gclase.clacod 
                                        tt-cla.clanom = gclase.clanom.
                                        
                             end.  
                         end.
                       end.
                     end.
                   end.
                 end.
               end.
             end.
           end.                                  
         end.
     end.
   end.
 end.
end procedure.