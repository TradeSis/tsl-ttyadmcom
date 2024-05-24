/***************************************************************************
** Programa        : divjur.p
** Objetivo        : Listagem de Conferencia de Juros
** Ultima Alteracao: 04/09/95
**
****************************************************************************/

{admcab.i new}
setbcod = 6.

def buffer btitulo for titulo.

def var vclinom like clien.clinom.
def var    wdti like titulo.titdtven label "Periodo".
def var    wdtf like titulo.titdtven.
def buffer wtitulo for titulo.
def var ndias as int format ">>9".
def var wjuro   like titulo.titjuro.
def var wjuromen like titulo.titjuro.
def var wjuromai like titulo.titjuro.
def var vldev   like titulo.titjuro.
def var vdif    like titulo.titjuro format "->>>,>>9.99".
def var vdifmen like titulo.titjuro format "->>>,>>9.99".
def var vdifmai like titulo.titjuro format "->>>,>>9.99".
def var vljur   like titulo.titjuro format ">,>>9.99".
def var vlmul   like titulo.titjuro format ">,>>9.99".
def var jucob   like titulo.titjuro format ">,>>9.99".
def var jucobmen like titulo.titjuro format ">,>>9.99".
def var jucobmai like titulo.titjuro format ">,>>9.99".
def var vlcob   like titulo.titjuro format ">,>>9.99".
def var wvlpri  like titulo.titvlcob.
def var wvlprimen like titulo.titvlcob.
def var wvlprimai like titulo.titvlcob.

form with down frame fdet.

form titulo.etbcobra colon 18
     estab.etbnom   no-label colon 30
     wdti           colon 18  " A"
     wdtf           colon 35  no-label
		    with side-labels width 80 frame f1.

wdti = today.
wdtf = wdti + 30.
repeat:
    prompt-for titulo.etbcobra
	   validate(can-find(estab where estab.etbcod = input titulo.etbcobra),
	   "Estabelecimento nao Cadastrado")  with frame f1.

    if  input titulo.etbcobra <> 0 then do:
	find estab where estab.etbcod = input titulo.etbcobra.
	display etbnom with frame f1.
    end.

    update wdti validate(input wdti <> ?, "Data deve ser Informada")
	   with frame f1.

    update wdtf validate(input wdtf >= input wdti, "Data Invalida")
	   with frame f1.

    {confir.i 1 "Listagem Previsao"}
    {mdadmcab.i
	&Saida     = "printer"
	&Page-Size = "64"
	&Cond-Var  = "140"
	&Page-Line = "66"
	&Nom-Rel   = """DIVJURB4"""
	&Nom-Sis   = """SISTEMA CREDIARIO"""
	&Tit-Rel   = """LISTAGEM DE CONFERENCIA DE JUROS - PERIODO DE "" +
			STRING(WDTI) + "" A "" + STRING(WDTF) +
			"" FILIAL "" + STRING(ESTAB.ETBCOD) + ""  "" +
			ESTAB.ETBNOM "
	&Width     = "140"
	&Form      = "frame f-cab"}

    for each titulo use-index titdtpag where
	     titulo.empcod    =  wempre.empcod       and
	     titulo.titnat    =  no                  and
	     titulo.modcod    =  "CRE"               and
	     titulo.etbcobra  = input titulo.etbcobra and
	     titulo.titdtpag >=  input wdti          and
	     titulo.titdtpag <=  input wdtf break by titulo.titdtpag
	     with frame fdet:

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
	     clien.clicod = titulo.clifor no-error.
	if avail clien
	then vclinom = clien.clinom.
	else vclinom = " ".
	ndias = titulo.titdtpag - titulo.titdtven.

	if  ndias > 0 then do:
	    find tabjur where
		 tabjur.nrdias = ndias no-lock no-error.
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

	end.
	if  ndias > 0 then do:
	    if ndias <= 365
	    then assign wvlprimen = wvlprimen + wvlpri
			wjuromen  = wjuromen  + wjuro
			jucobmen  = jucobmen  + jucob
			vdifmen   = vdifmen   + vdif.

	    else assign wvlprimai = wvlprimai + wvlpri
			wjuromai  = wjuromai  + wjuro
			jucobmai  = jucobmai  + jucob
			vdifmai   = vdifmai   + vdif.
	    disp
	       titulo.etbcod
	       titulo.titnum   column-label  "Contr"
	       titulo.titpar   column-label  "Pr"
	       titulo.clifor    column-label  "Cod"
	       vclinom    column-label  "Cliente" format "x(20)"
	       titulo.titdtven column-label "Venc."    format "99/99/99"
	       titulo.titdtpag column-label "Dt.Pag"   format "99/99/99"
	       ndias           column-label "Dias"     format "->>9"
	       wvlpri column-label "Vlr.Prest."
	       wjuro  /*titulo.titvlpag - wvlpri*/
			       column-label "Juro!Cobrado" format "->>,>>9.99"
	       jucob @ vlcob   column-label "Juro!Calculado" format ">>,>>9.99"
	       vdif            column-label "Dif."     format "->,>>9.99"
	       with frame fdet width 140.
	    down with frame fdet.
	    accumulate wvlpri(total by titulo.titdtpag)
		       (wjuro)(total by titulo.titdtpag)
		       jucob(total by titulo.titdtpag)
		       vdif(total by titulo.titdtpag).
	    accumulate wvlpri(total)
		       (wjuro)(total)
		       jucob(total)
		       vdif(total ).
	end.
	if last-of(titulo.titdtpag) then do:
	    down with fram fdet.
	    disp "--------------" @ wvlpri
		 "---------"          @ wjuro
		 "---------" @ vlcob
		 "---------" @ vdif
		 with frame fdet width 140.
	    down with fram fdet.
	    disp accum total by titulo.titdtpag (wvlpri) @ wvlpri
		 accum total by titulo.titdtpag (wjuro)
			    @ wjuro
		 accum total by titulo.titdtpag (jucob) @ vlcob
		 accum total by titulo.titdtpag (vdif) @ vdif
		 with frame fdet width 140.
	    down 2 with frame fdet.
	end.
	if last(titulo.titdtpag) then do:
	    disp "TOTAL GERAL     " @ vCLINOM
		 "--------------" @ wvlpri
		 "---------"          @ wjuro
		 "---------" @ vlcob
		 "---------" @ vdif
		 with frame fdet width 140.
	    down 1 with fram fdet.
	    disp accum total (wvlpri) @ wvlpri
		 accum total (wjuro)
			    @ wjuro
		 accum total (jucob) @ vlcob
		 accum total (vdif) @ vdif
		 with frame fdet width 140.
	end.
    end.
    disp "TOTAL <= 365 DIAS"
	 with frame f365 width 140. put skip.
    disp wvlprimen column-label "Total Prest."
	 wjuromen  column-label "Total juro cobrado "
	 jucobmen  column-label "Total juro calculado"
	 vdifmen   column-label "Total Diferenca"
	 with frame ff365 width 140.  put skip.

     disp "TOTAL > 365 DIAS"
		 with frame ff-365 width 140.  put skip.
	    disp wvlprimai  column-label "Total Prest."
		 wjuromai   column-label "Total juro cobrado"
		 jucobmai   column-label "Total juro calculado"
		 vdifmai column-label "Total Diferenca"
		    with frame f-365 width 140. put skip.

    output close.
end.
