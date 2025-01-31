{admcab.i}
def var vmovqtm   like  movim.movqtm.
def var vciccgc   like  clien.ciccgc.
def var valicota  like  plani.alicms format ">9,99".
def var vpladat   like  plani.pladat.
def var vnumero   like  plani.numero format ">>>>>>>>>>" initial 0.
def var vbicms    like  plani.bicms.
def var vicms     like  plani.icms .
def var vprotot   like  plani.protot.
def var vprotot1  like  plani.protot.
def var vdescpro  like  plani.descpro.
def var vacfprod  like  plani.acfprod.
def var vfrete    like  plani.frete.
def var vseguro   like  plani.seguro.
def var vdesacess like  plani.desacess.
def var vipi      like  plani.ipi.
def var vplatot   like  plani.platot.
def var vetbcod   like  plani.etbcod.
def var vserie    like  plani.serie.
def var vopccod   like  plani.opccod.
def var vprocod   like  produ.procod.
def var vdown as i.
def var vant as l.
def var vi as int.
def var vqtd        like movim.movqtm.
def var v-procod    like produ.procod no-undo.
def var vmovseq     like movim.movseq.
def var vplacod     like plani.placod.
def var vtotal      like plani.platot.
def var vforcod like forn.forcod.


form produ.procod
     produ.pronom format "x(30)"
     movim.movqtm format ">,>>9.99" column-label "Qtd"
     movim.movalicms column-label "ICMS"
     movim.movalipi  column-label "IPI"
     movim.movpc  format ">,>>9.99" column-label "Custo"
		    with frame f-produ1 row 5 7 down overlay
				    centered color message width 80.

form vprocod      label "Codigo"
     produ.pronom  no-label format "x(25)"
     vprotot
	 with frame f-produ centered color message side-label
			row 15 no-box width 81 overlay.

form
    estab.etbcod  label "Filial " colon 15
    estab.etbnom no-label
    vforcod label "Fornecedor" colon 15
    forne.fornom no-label
    vnumero   colon 15
    vserie
    /*
    plani.opfcod  label "Op.Fiscal" colon 15
    opfis.opfnom  no-label */
    plani.pladat       colon 15
      with frame f1 side-label color blue/cyan width 80 row 4.

form
    plani.bicms    colon 10
    plani.icms     colon 30
    plani.protot  colon 65
    plani.frete    colon 10
    plani.ipi      colon 30
    plani.descpro  colon 10
    plani.acfprod  colon 45
    plani.platot  with frame f2 side-label row 11 width 80 overlay.

/*
prompt-for func.funcod
	   func.senha blank with frame f-func side-label centered.
find func where func.funcod = input func.funcod and
		func.senha  = input func.senha no-lock no-error.
if not avail func
then do:
    message "Funcionario Invalido".
    undo, retry.
end.
if func.senha <> "0701" and func.senha <> "100"
then do:
    message "Funcionario Invalido".
    undo, retry.
end.
*/

repeat:
    clear frame f1 no-pause.
    clear frame f-1 no-pause.
    clear frame f-produ1 no-pause.
    hide  frame f2 no-pause.
    prompt-for estab.etbcod with frame f1.
    find estab using estab.etbcod no-lock.
    display
	estab.etbnom with frame f1.
    vserie = "U".
    update vforcod with frame f1.
    find forne where forne.forcod = vforcod no-error.
    if not avail forne
    then do:
	bell.
	message "Fornecedor nao Cadastrado !!".
	undo, retry.
    end.
    display forne.fornom when avail forne with frame f1.
    update vnumero
	   vserie with frame f1.
    find plani where plani.numero = vnumero and
		     plani.emite  = forne.forcod and
		     plani.movtdc = 1   and
		     plani.serie  = vserie and
		     plani.etbcod = estab.etbcod no-error.
    if not avail plani
    then do:
	message "Nota Fiscal nao cadastrada".
	undo, retry.
    end.
    do on error undo, retry:
	/*
	update plani.opfcod with frame f1.
	find opfis where opfis.opfcod = plani.opfcod no-lock no-error.
	if not avail opfis
	then do:
	    message "Operacao Comercial Nao Cadastrada".
	    undo, retry.
	end.
	disp opfis.opfnom with frame f1. */
      /*  find tipmov where tipmov.movtdc = opcom.movtdc no-lock.*/
	update plani.pladat
		with frame f1.
    end.
    /*do on error undo, retry:
	update plani.bicms
	       plani.icms with frame f2.
    end.
    plani.protot = plani.bicms.
    update
	plani.protot
	plani.frete
	plani.ipi
	plani.descpro
	plani.acfprod with frame f2.
	plani.platot = (plani.bicms + plani.frete + plani.ipi) - plani.descpro.
    update plani.platot with frame f2.
    vtotal = vipi + vdesacess + vseguro + vfrete +
	     vprotot - vdescpro.*/
    clear frame f-produ2 all no-pause.

    for each movim where movim.etbcod = plani.etbcod and
			 movim.placod = plani.placod :
	find produ where produ.procod = movim.procod no-lock.
	 disp produ.procod
	      produ.pronom format "x(25)"
	      movim.movqtm format ">,>>9.99" column-label "Qtd"
	      movim.movalicms column-label "ICMS"
	      movim.movalipi  column-label "IPI"
	      movim.movpc  format ">,>>9.99" column-label "Custo"
	      (movim.movpc * movim.movqtm) format ">>,>>9.99"
				    column-label "TOTAL"
			    with frame f-produ2 row 5 9 down  overlay
			      centered color message width 80.
		down with frame f-produ2.
		pause 0.
     end.
     hide frame f1 no-pause.
     hide frame f2 no-pause.
     repeat with on endkey undo, leave on error undo, retry:
	view frame f-produ2.
	vprocod = 0.
	update vprocod with frame f-1 row 18 no-box color message
				    side-label overlay.
	find produ where produ.procod = vprocod no-lock no-error.
	if not avail produ
	then do:
		message "Produto nao Cadastrado".
		undo, retry.
	end.
	disp produ.pronom no-label with frame f-1.
	find movim where movim.etbcod = plani.etbcod and
			 movim.placod = plani.placod and
			 movim.procod = produ.procod  no-error.

	if not avail movim
	then do:
	    message "Produto nao pertence a nota".
	    undo, retry.
	end.
	vmovqtm = movim.movqtm.
	update movim.movqtm
	       /*movim.movalicms
	       movim.movalipi
	       movim.movpc */ with frame f-produ2.
	run atuest.p(recid(movim),
		     input "A",
		     input vmovqtm).
	clear frame f-produ2 all no-pause.

	for each movim where movim.etbcod = plani.etbcod and
			     movim.placod = plani.placod :
	    find produ where produ.procod = movim.procod no-lock.
	    disp produ.procod
		 produ.pronom format "x(25)"
		 movim.movqtm format ">,>>9.99" column-label "Qtd"
		 movim.movalicms column-label "ICMS"
		 movim.movalipi  column-label "IPI"
		 movim.movpc  format ">,>>9.99" column-label "Custo"
			    with frame f-produ2 row 5 9 down  overlay
			      centered color message width 80.
		down with frame f-produ2.
		pause 0.
	end.

     end.
     clear frame f-1 all no-pause.
end.
