{admcab.i}

def buffer btitulo for titulo.

def var varquivo as char.
def var varqexp  as char.
def var vseq as int.
def var vqtoper  as int.
def var vlote as int.

def buffer ctitulo for titulo.
def var vdti     like plani.pladat.
def var vdtf     like plani.pladat.

varqexp = "canc" + string(today,"999999") + ".rem".
def var vexporta as char.

vexporta = "/admcom/import/financeira/" + varqexp.
varquivo = "/admcom/import/financeira/" + "altr" + string(today,"999999") + "."
                + string(time).

FUNCTION f-troca returns character
    (input cpo as char).
    def var v-i as int.
    def var v-lst as char extent 60
       init ["@",":",";",".",",","*","/","-",">","!","'",'"',"[","]"].
         
    if cpo = ?
    then cpo = "".
    else do v-i = 1 to 30:
         cpo = replace(cpo,v-lst[v-i],"").
    end.
    return cpo. 
end FUNCTION.

def temp-table tc-titulo like titulo
use-index cxmdat
use-index datexp
use-index etbcod
use-index exportado
use-index iclicod
use-index titdtpag
use-index titdtven
use-index titnum
use-index titsit
.

def var v-acrescimo like contrato.vltotal.
def var vdata as date.

form tc-titulo.moecod no-label format "x(15)"
        with frame f-disp down width 160.

def var vmoecod like titulo.moecod.

def var vindex as int.
def var v-sit as char extent 3 format "x(15)".
def var v-it as char extent 3.
def var v-i as int.
v-sit[1] = "N�O EXPORTADOS".
v-sit[2] = "JA EXPORTADOS".
v-sit[3] = "TODOS".

form "(" at 1  space(0)
     v-it[1] format "x" no-label
     space(0) ")"
     v-sit[1] no-label
     "(" at 1  space(0)
     v-it[2] format "x" no-label
     space(0) ")"
     v-sit[2]  no-label
     "("  at 1 space(0)
     v-it[3] format "x" no-label
     space(0) ")"
     v-sit[3] no-label
     with frame f-it 1 down centered row 10
     title " processar ".

def buffer cenvfinan for envfinan.

def var vparcelas as int.

repeat :
    do on error undo, retry:
          update vdti label "Periodo alteracao" 
                 vdtf label ""  with frame f1.
          if  vdti > vdtf
          then do:
                message "Data inv�lida".
                undo.
            end.

       disp varquivo    label "Arquivo"   colon 18 format "x(50)"
        with frame f1 side-label.
       update varquivo with frame f1.
    end.
    
    disp v-it v-sit with frame f-it.

    choose field v-it with frame f-it.
    vindex = frame-index.
    v-it[vindex] = "*".
    disp v-it with frame f-it.
 
    sresp = no.
    message "Confirma processamento?" update sresp. 
    if sresp = no
    then next.

    assign vqtoper = 0.

    do vdata = vdti to vdtf:
        disp "PROCESSANDO.... AGUARDE!   "
            vdata
            with frame f-dd 1 down no-box color message
            no-label row 10 centered.
        pause 0.    
            
        for each titulo where
             titulo.datexp = vdata and
             titulo.modcod = "CRE" and
             titulo.titdtemi < vdata - 30 
             no-lock:

            find first cenvfinan where 
                            cenvfinan.empcod = titulo.empcod
                        and cenvfinan.titnat = titulo.titnat
                        and cenvfinan.modcod = titulo.modcod
                        and cenvfinan.etbcod = titulo.etbcod
                        and cenvfinan.clifor = titulo.clifor
                        and cenvfinan.titnum = titulo.titnum
                        /*and cenvfinan.titpar = titulo.titpar
                        */
                        no-lock no-error.
            if not avail cenvfinan then next.
            
            find first titexporta where
                           titexporta.empcod = 27 and
                           titexporta.titnat = titulo.titnat and
                           titexporta.modcod = titulo.modcod and
                           titexporta.etbcod = titulo.etbcod and
                           titexporta.clifor = titulo.clifor and
                           titexporta.titnum = titulo.titnum and
                           titexporta.titpar = titulo.titpar
                           no-lock no-error.
                if avail titexporta and
                   (titexporta.titdtven <> titulo.titdtven or
                    titexporta.titvlcob <> titulo.titvlcob or
                    (titexporta.titsit  <> titulo.titsit and
                     titulo.titsit <> "LIB" and
                     titulo.titsit <> "PAG"))
                then do:
                    if titexporta.titdtven <> titulo.titdtven
                    then vmoecod = "VENCIMENTO".
                    else if titexporta.titvlcob <> titulo.titvlcob
                    then vmoecod = "VALOR".
                    else vmoecod = "SITUACAO".
                    find first tc-titulo where 
                        tc-titulo.empcod = titulo.empcod and
                        tc-titulo.titnat = titulo.titnat and
                        tc-titulo.modcod = titulo.modcod and
                        tc-titulo.etbcod = titulo.etbcod and
                        tc-titulo.clifor = titulo.clifor and
                        tc-titulo.titnum = titulo.titnum 
                            no-error.        
                    if not avail tc-titulo
                    then do:
                        create tc-titulo.
                        buffer-copy titulo to tc-titulo.
                        tc-titulo.moecod = vmoecod.
                    end.
                end.
             
            disp titulo.titnum with frame f-dd.
            pause 0.
            
            if titulo.moecod = "REA" or
               titulo.moecod = "CAR" or
               titulo.moecod = "PRE" or
               titulo.moecod = "CHV" or
               titulo.moecod = "PDM" or
               titulo.moecod = "NOV" or
               (titulo.moecod = ""   and
                titulo.tpcontrato = "" /*titpar < 30*/ and
                titulo.etbcobra < 900)
            then next.
               
            if titulo.titsit <> "PAG" and
               titulo.tpcontrato = "" /*titpar < 30*/
            then next.
            
            find first envfinan where envfinan.empcod = titulo.empcod
                        and envfinan.titnat = titulo.titnat
                        and envfinan.modcod = titulo.modcod
                        and envfinan.etbcod = titulo.etbcod
                        and envfinan.clifor = titulo.clifor
                        and envfinan.titnum = titulo.titnum
                        and envfinan.titpar = titulo.titpar
                        no-lock no-error.
            if not avail envfinan
            then next.  
        
            if vindex = 3
            then.
            else if vindex = 2 and envfinan.envsit = "CAN" 
            then.
            else if vindex = 1 and envfinan.envsit <> "CAN"
            then.
            else next.
            
            if titulo.moecod = ""
            then vmoecod = string(titulo.etbcobra).
            else vmoecod = titulo.moecod.
            
            find first tc-titulo where 
                   tc-titulo.empcod = titulo.empcod and
                   tc-titulo.titnat = titulo.titnat and
                   tc-titulo.modcod = titulo.modcod and
                   tc-titulo.etbcod = titulo.etbcod and
                   tc-titulo.clifor = titulo.clifor and
                   tc-titulo.titnum = titulo.titnum 
                    no-error.
        
            if not avail tc-titulo
            then do:
                create tc-titulo.
                buffer-copy titulo to tc-titulo.
                tc-titulo.moecod = vmoecod.
            end.
        end.
    end.    
   
    sresp = no.
    message "Gerar arquivo de CANCELAMENTOS ? " update sresp.
    if sresp
    then do:
        run gera-arquivo-sicred.
        message "Arquivo gerado: " vexporta.
    end.
    sresp = no.
    message "Gerar relatorio? " update sresp.
    if not sresp then leave.

    {mdadmcab.i
        &Saida     = value(varquivo)
        &Page-Size = "64"
        &Cond-Var  = "80"
        &Page-Line = "66"
        &Nom-Rel   = ""altfinan""
        &Nom-Sis   = """ """
        &Tit-Rel   = """CONTRATOS ALTERADOS"""
        &Width     = "80"
        &Form      = "frame f-cabcab"}

    disp with frame f-1.
    
    for each tc-titulo no-lock, 
        first contrato where contrato.contnum = int(tc-titulo.titnum)
                        no-lock break by tc-titulo.moecod
                                      by contrato.contnum
                                      /*with frame f-disp*/.

        find clien where clien.clicod = contrato.clicod no-lock no-error.
        
        find first finan where finan.fincod = contrato.crecod no-lock
                no-error.
        
        vparcelas = finan.finnpc.
        
        if first-of(tc-titulo.moecod)
        then do:
            if tc-titulo.moecod = "DEV"
            then disp "DEVOLUCAO" @ tc-titulo.moecod with frame f-disp.
            ELSE IF tc-titulo.moecod = "NOV" 
                THEN DISP "NOVACAO" @ tc-titulo.moecod with frame f-disp.
                ELSE IF tc-titulo.moecod = "" and
                        tc-titulo.tpcontrato <> "" /*titpar >= 30*/
                    THEN DISP "RENOVACAO" @ tc-titulo.moecod with frame f-disp.
                    ELSE DISP tc-titulo.moecod with frame f-disp.
            
        END.        
        
        v-acrescimo = 0.
        find first contnf where contnf.etbcod = contrato.etbcod and
                                contnf.contnum = contrato.contnum
                                no-lock no-error.
        if avail contnf
        then do:
            find plani where plani.etbcod = contnf.etbcod and
                             plani.placod = contnf.placod
                             no-lock no-error.
            if avail plani
            then v-acrescimo = plani.biss - 
                (plani.platot - plani.vlserv - plani.descprod).                 
        end.                        
        /******
        disp tc-titulo.etbcobra column-label "Loc.Baixa"
             tc-titulo.titnum  column-label "Contrato"
             tc-titulo.titsit
             contrato.dtinicial
             v-acrescimo(total by tc-titulo.moecod) column-label "Acrescimo"
             contrato.vltotal(total by tc-titulo.moecod)
             with frame f-disp.
        down with frame f-disp.   
        ******/
        
        disp contrato.etbcod    column-label "Loc.!Emis"
             tc-titulo.etbcobra column-label "Loc.!Baixa"
             clien.clicod format ">>>>>>>>>9" column-label "Codigo!Cliente"
             clien.clinom format "x(30)" column-label "Nome Cliente"
             contrato.contnum  format ">>>>>>>>>9" 
                                column-label "Numero!Contrato"
             contrato.dtinicial column-label "Data!Emissao"
             contrato.vltotal(total by tc-titulo.moecod) 
                        column-label "Vlr.!Principal"
             v-acrescimo(total by tc-titulo.moecod) column-label "Acrescimo"
             vparcelas column-label "Nro.!Parc"
             with frame f-disp.
        down with frame f-disp.                     
    end.
    output close.
        
    run visurel.p(varquivo,"").
    leave.
end.

procedure gera-arquivo-sicred.
    output to value(vexporta) page-size 0.
    run p-registro-00.
    for each tc-titulo where tc-titulo.titnum <> "" no-lock,
        first contrato where contrato.contnum = int(tc-titulo.titnum)
                        no-lock break by tc-titulo.moecod
                                      by contrato.contnum:
        run p-registro-20.
    end.         
    run p-registro-99.
    output close.

        output to ./vexporta.txt.
        unix silent unix2dos value(vexporta). 
        unix silent chmod 777 value(vexporta).
        output close.
        unix silent value("rm ./vexporta.txt -f").
end procedure.

/* header */
procedure p-registro-00.

     def buffer blotefin for lotefin.
     vseq = 1.
     put unformat skip
         "00"                      /* 001-002 */
         varqexp format "x(08)"    /* 003-010 */
          string(today,"99999999") /* 011-018 */
          " " format "x(776)"      /* 019-794  */
          vseq format "999999" /* NUMERICO  Sequencia  */
          .
   find last Blotefin use-index lote exclusive-lock no-error.
   create lotefin.
   assign lotefin.lotnum = (if avail Blotefin 
                             then Blotefin.lotnum + 1
                             else 1)
          lotefin.lottip = "CAN"
          lotefin.aux-ch = "CONTRATOS ALTERADOS + 30 DIAS".
   assign vlote = lotefin.lotnum.                         
   
end procedure.

/* OPERACAO */
procedure p-registro-20.
    def buffer benvfinan for envfinan.

    vseq = vseq + 1.
    put unformat skip 
      "20"                          /* 001-002  TIPO  FIXO �1 */
      "0001"                        /* 003-006 AG�NCIA        */
      contrato.contnum format "9999999999"       /* 007-016 Contrato */
      " " format "x(778)"
      vseq format    "999999"                    /* 795-800 */.
  
    assign vqtoper = vqtoper + 1.

    /***2014***/
    for each titulo where 
           titulo.empcod = 19 and
           titulo.titnat = no and
           titulo.modcod = "CRE" and
           titulo.etbcod = contrato.etbcod and
           titulo.clifor = contrato.clicod and
           titulo.titnum = string(contrato.contnum):
           
        find first benvfinan where benvfinan.empcod = titulo.empcod
                        and benvfinan.titnat = titulo.titnat
                        and benvfinan.modcod = titulo.modcod
                        and benvfinan.etbcod = titulo.etbcod
                        and benvfinan.clifor = titulo.clifor
                        and benvfinan.titnum = titulo.titnum
                        and benvfinan.titpar = titulo.titpar
                        no-error.
        if avail benvfinan and benvfinan.envsit <> "CAN"
        then do on error undo:
            assign benvfinan.lotcan = vlote
                    benvfinan.envsit = "CAN".  
            if titulo.cobcod = 10
            then do:
                titulo.cobcod = 2.
                create titulolog.
                assign
                    titulolog.empcod = titulo.empcod
                    titulolog.titnat = titulo.titnat
                    titulolog.modcod = titulo.modcod
                    titulolog.etbcod = titulo.etbcod
                    titulolog.clifor = titulo.clifor
                    titulolog.titnum = titulo.titnum
                    titulolog.titpar = titulo.titpar
                    titulolog.data    = today
                    titulolog.hora    = time
                    titulolog.funcod  = sfuncod
                    titulolog.campo   = "CobCod"
                    titulolog.valor   = string(titulo.cobcod)
                    titulolog.obs     = "LOTE=" + string(vlote).
            end.
        end.
    end.
end procedure.

/* Trailer */
procedure p-registro-99.
  vseq = vseq + 1.

  put unformat skip
     "99"                                 /* 01-02 fixo "99" */
     varqexp format "x(6)"                /* 03-08 Nome do arquivo */
     string(today,"99999999")             /* 09-16 data movimento */
     vqtoper format "9999999999"          /* 17-26 QTD DE OPERA��ES */
     " " format "x(768)"                  /* 27-794 FILLER */
     vseq format    "999999" skip.

   find lotefin where lotefin.lotnum = vlote exclusive-lock no-error.
   if not avail lotefin
   then do:
        create lotefin.
        assign lotefin.lotnum = vlote
               lotefin.lottip = "CAN".
   end.
   assign lotefin.datexp = today
          lotefin.hora = time
          lotefin.lotqtd = vqtoper.

end procedure.

