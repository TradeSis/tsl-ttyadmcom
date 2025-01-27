def var recatu1         as recid.
def var recatu2         as recid.
def var vpedrec         as recid.
def var reccont         as int.
def var esqpos1         as int.
def var esqpos2         as int.
def var esqregua        as log.
def var wdif            like liped.lipent format ">>>9".
def var wsep            like liped.lipent format ">>>9".
def var west            like liped.lipent format "->>>9".
def var vpronom         like produ.pronom.
def var vpednum like pedid.pednum.
def buffer bpedid for pedid.
def buffer cliped for liped.
def buffer xpedid for pedid.
def buffer xliped for liped.
def buffer cplani for plani.
def var vlei            as char format "x(26)".
def var vetb            as i    format ">>9".
def var vcod            as i    format "9999999".
def var vcod2           as i    format "999999".
def var vqtd            as i    format "999999".
def var vnumero         like plani.numero.
def var vserie          like plani.serie.
def var vplacod         like plani.placod.
def var vprotot         like plani.protot.
def var vmovseq         as i.
def var esqcom1         as char format "x(12)" extent 5
    initial ["","","","",""].
def var esqcom2         as char format "x(12)" extent 5
	    initial [" Coletor ",
		     " Romaneio ",
		     " Separacao ",
		     "Separa Geral",
		     " Emissao NF "].
{admcab.i}
def buffer bliped           for  liped.
def buffer vliped           for  liped.
def buffer bplani           for  plani.
def var vok                 as log.
    form
	esqcom2
	    with frame f-com2
		 row screen-lines no-box no-labels side-labels column 1
		 centered.
    assign
	esqregua  = no
	esqpos1  = 1
	esqpos2  = 1.
    view frame f-com2.
bl-princ:
repeat:
    vpedrec = ?.
    prompt-for estab.etbcod with frame f-est width 80 side-label color
						    black/cyan row 4.
    find estab where estab.etbcod = input estab.etbcod no-lock no-error.
    if not avail estab
    then do:
	bell.
	message "Estabelecimento nao Cadastrado".
	undo, retry.
    end.
    disp estab.etbnom no-label with frame f-est.
    form
	liped.pednum  column-label "Num"
	liped.procod
	vpronom  format "x(45)"
	west          column-label "Est."
	wdif          column-label "Qtd."
	liped.lipsep column-label "Sep." format ">>>9"
	    with frame frame-a 10 down centered color white/red width 80.
    disp esqcom2 with frame f-com2.
    if recatu1 = ?
    then
	find first liped USE-INDEX LIPED where liped.pedtdc = 2
			   and liped.etbcod = estab.etbcod
			   AND liped.lipsep > 0
			   and liped.lipsit = "A"
			   and liped.protip = (if setbcod = 996
					       then "C"
					       else "M")
			       no-lock no-error.
    else
	find liped where recid(liped) = recatu1 no-lock.
    if not available liped and
	setbcod = 996 then do:
	message "Nenhum Pedido registrado para esta Filial. Ler Coletor ? "
		update sresp.
	if sresp then do:
		input from H:\coletor\coleta99.txt .
		repeat:
		    import vlei.
		    assign vetb = int(substring(string(vlei),4,2))
			   vcod = int(substring(string(vlei),14,7))
			   vcod2 = int(substring(string(vlei),14,6))
			   vqtd = int(substring(string(vlei),21,6)).
		    if vetb <> estab.etbcod or vcod = 0 or vcod = ? or
		       vcod = 1 or vcod = 2 or vcod = 3 or vcod = 4 or vcod = 5
		       then next.
		    find produ where produ.procod = vcod no-lock no-error.
		    if not avail produ
		    then do:
			find produ where produ.procod = vcod2 no-lock.
		    end.
		    find first cliped where cliped.pedtdc = 2             and
					    cliped.etbcod = estab.etbcod  and
					    cliped.lipsit = "A"           and
					    cliped.procod = produ.procod
					    no-error.
		    if not avail cliped
		    then do:
			find bpedid where recid(bpedid) = vpedrec no-error.
			if not avail bpedid
			then do:
			    find last bpedid where bpedid.etbcod = estab.etbcod
					       and bpedid.pedtdc = 2 no-error.
			    if avail bpedid
			    then vpednum = bpedid.pednum + 1.
			    else vpednum = 1.
			    create xpedid.
			    assign xpedid.pedtdc    = 2
				   xpedid.pednum    = vpednum
				   xpedid.regcod    = estab.regcod
				   xpedid.peddat    = today
				   xpedid.pedsit    = yes
				   xpedid.sitped    = "A"
				   xpedid.modcod    = "PED"
				   xpedid.etbcod    = estab.etbcod.
			    vpedrec = recid(xpedid).
			end.
			find clase where clase.clacod = produ.clacod no-lock.
			create xliped.
			assign xliped.pednum = xpedid.pednum
			       xliped.pedtdc = xpedid.pedtdc
			       xliped.predt  = xpedid.peddat
			       xliped.etbcod = xpedid.etbcod
			       xliped.procod = produ.procod
			       xliped.lipcor = ""
			       xliped.lipqtd = vqtd
			       xliped.lipsep = xliped.lipqtd
			       xliped.lipsit = "A"
			       xliped.protip = if clase.claordem = yes
					       then "M"
					       else "C".
			find estoq where estoq.etbcod = xliped.etbcod and
					 estoq.procod = xliped.procod no-lock
								      no-error.
			if avail estoq
			then xliped.lippreco = estoq.estcusto.
			else do:
			   find estoq where estoq.etbcod = 999 and
					    estoq.procod = xliped.procod
							no-lock no-error.
			    xliped.lippreco = estoq.estcusto.
			end.
			disp xliped.procod label "Aguarde... Lendo Produto"
				with frame f-len centered color yellow/red
						side-label overlay row 10.
			pause 0.
		    end.
		    else do:
			cliped.lipsep = vqtd.
			find estoq where estoq.etbcod = cliped.etbcod and
					 estoq.procod = cliped.procod no-lock
								      no-error.
			if avail estoq
			then cliped.lippreco = estoq.estcusto.
			else do:
			   find first estoq where estoq.procod = xliped.procod
							no-lock no-error.
			    cliped.lippreco = estoq.estcusto.
			end.
			disp cliped.procod label "Aguarde... Lendo Produto"
				with frame f-len2 centered color yellow/red
						side-label overlay row 10.
			pause 0.
		    end.
		end.
		input close.
	end.
	else undo.
    end.
    if recatu1 = ?
    then
	find first liped USE-INDEX LIPED where liped.pedtdc = 2
			   and liped.etbcod = estab.etbcod
			   and liped.lipsep > 0
			   and liped.lipsit = "A"
			   and liped.protip = (if setbcod = 996
					       then "C"
					       else "M") no-lock no-error.
    else
	find liped where recid(liped) = recatu1 no-lock.
    clear frame frame-a all no-pause.
    wdif = liped.lipqtd - liped.lipent.
    vpronom = "".
    find produ where produ.procod = liped.procod no-lock no-error.
    if avail produ
    then vpronom = produ.pronom.
    wsep = 0.
    for each bliped where bliped.lipsit = "A" and
			  bliped.procod = liped.procod:
	wsep = wsep + bliped.lipsep.
    end.
    west = 0.
    for each estoq where estoq.etbcod = setbcod and
			 estoq.procod = liped.procod no-lock.
	west = west + estoq.estatual - wsep.
    end.
    display
	liped.pednum  column-label "Num"
	liped.procod
	vpronom
	west
	wdif
	liped.lipsep
	    with frame frame-a 10 down centered color white/red.
    recatu1 = recid(liped).
    color display message
	esqcom2[esqpos2]
	    with frame f-com2.
    repeat:
	find next liped  USE-INDEX LIPED where liped.pedtdc = 2 and
			       liped.etbcod = estab.etbcod and
			       liped.lipsep > 0 and
			       liped.lipsit = "A" and
			       liped.protip = (if setbcod = 996
					       then "C"
					       else "M")
			      no-lock no-error.
	if not available liped
	then leave.
	if frame-line(frame-a) = frame-down(frame-a)
	then leave.
	down with frame frame-a.
	wdif = liped.lipqtd - liped.lipent.
	vpronom = "".
	find produ where produ.procod = liped.procod no-lock no-error.
	if avail produ
	then vpronom = produ.pronom.
	wsep = 0.
	for each bliped where bliped.lipsit = "A" and
			      bliped.procod = liped.procod:
	    wsep = wsep + bliped.lipsep.
	end.
	west = 0.
	for each estoq where estoq.etbcod = setbcod and
			     estoq.procod = liped.procod no-lock.
	    west = west + estoq.estatual - wsep.
	end.
	display
	    liped.pednum  column-label "Num"
	    liped.procod
	    vpronom
	    west
	    wdif
	    liped.lipsep
		with frame frame-a 10 down centered color white/red.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.
    repeat with frame frame-a:
	find liped where recid(liped) = recatu1 no-lock.
	status default.
	choose field liped.pednum help "[C] Consulta Estoque"
	    go-on(cursor-down cursor-up
		  cursor-left cursor-right
		  page-down   page-up
		  tab PF4 F4 ESC return C c).
	status default "".
	color display white/red liped.pednum.
	if keyfunction(lastkey) = "C" or keyfunction(lastkey) = "c"
	then do:
	    pause 0.
	    color disp message liped.procod with frame frame-a.
	    pause 0.
	    for each estoq where estoq.etbcod <= 10 and
				 estoq.procod = liped.procod no-lock.
		 disp estoq.etbcod column-label "FL"
		      estoq.estatual column-label "Estoque"
					format "->>>>,>>9"
				with frame f-estoq1  overlay 10 down column 21
				color white/gray.
	    end.
	    for each estoq where estoq.etbcod > 10 and
				 estoq.etbcod <= 20 and
				 estoq.procod = liped.procod no-lock.
		disp estoq.etbcod column-label "FL"
		     estoq.estatual column-label "Estoque"
					format "->>>>,>>9"
				with frame f-estoq overlay 10 down column 36
				color white/gray.
	    end.
	    for each estoq where estoq.etbcod > 20 and
				 estoq.etbcod <= 30 and
				 estoq.procod = liped.procod no-lock.
		 disp estoq.etbcod column-label "FL"
		      estoq.estatual column-label "Estoque"
					format "->>>>,>>9"
				with frame f-estoq2  overlay 10 down column 51
				color white/gray.
	    end.
	    for each estoq where estoq.etbcod > 30 and
				 estoq.procod = liped.procod no-lock.
		disp estoq.etbcod column-label "FL"
		     estoq.estatual column-label "Estoque"
					format "->>>>,>>9"
				with frame f-estoq3  overlay 10 down column 66
				color white/gray.
	    end.
	color display white/red liped.procod with frame frame-a.
	end.
	if keyfunction(lastkey) = "TAB"
	then do:
	    esqregua = no.
	    if esqregua
	    then do:
		color display normal
		    esqcom1[esqpos1]
		    with frame f-com1.

		color display message
		    esqcom2[esqpos2]
		    with frame f-com2.
	    end.
	    else do:
		color display message
		    esqcom2[esqpos2]
		    with frame f-com2.
	    end.
	    esqregua = not esqregua.
	end.
	if keyfunction(lastkey) = "cursor-right"
	then do:
	    esqregua = no.
	    if esqregua
	    then do:
		color display normal
		    esqcom1[esqpos1]
		    with frame f-com1.
		esqpos1 = if esqpos1 = 5
			  then 5
			  else esqpos1 + 1.
		color display messages
		    esqcom1[esqpos1]
		    with frame f-com1.
	    end.
	    else do:
		color display normal
		    esqcom2[esqpos2]
		    with frame f-com2.
		esqpos2 = if esqpos2 = 5
			  then 5
			  else esqpos2 + 1.
		color display messages
		    esqcom2[esqpos2]
		    with frame f-com2.
	    end.
	    next.
	end.
	if keyfunction(lastkey) = "cursor-left"
	then do:
	    esqregua = no.
	    if esqregua
	    then do:
		color display normal
		    esqcom1[esqpos1]
		    with frame f-com1.
		esqpos1 = if esqpos1 = 1
			  then 1
			  else esqpos1 - 1.
		color display messages
		    esqcom1[esqpos1]
		    with frame f-com1.
	    end.
	    else do:
		color display normal
		    esqcom2[esqpos2]
		    with frame f-com2.
		esqpos2 = if esqpos2 = 1
			  then 1
			  else esqpos2 - 1.
		color display messages
		    esqcom2[esqpos2]
		    with frame f-com2.
	    end.
	    next.
	end.
	if keyfunction(lastkey) = "page-down"
	then do:
	    do reccont = 1 to frame-down(frame-a):
		find next liped  USE-INDEX LIPED where liped.pedtdc = 2 and
				       liped.etbcod = estab.etbcod and
				       liped.lipsep > 0 and
				       liped.lipsit = "A" and
				       liped.protip = (if setbcod = 996
						       then "C"
						       else "M")
					    no-lock no-error.
		if not avail liped
		then leave.
		recatu1 = recid(liped).
	    end.
	    leave.
	end.
	if keyfunction(lastkey) = "page-up"
	then do:
	    do reccont = 1 to frame-down(frame-a):
		find prev liped  USE-INDEX LIPED where liped.pedtdc = 2 and
				       liped.etbcod = estab.etbcod and
				       liped.lipsit = "A" and
				       liped.lipsep > 0 and
				       liped.protip = (if setbcod = 996
						       then "C"
						       else "M")
					    no-lock no-error.
		if not avail liped
		then leave.
		recatu1 = recid(liped).
	    end.
	    leave.
	end.
	if keyfunction(lastkey) = "cursor-down"
	then do:
	    find next liped  USE-INDEX LIPED where liped.pedtdc = 2 and
				   liped.etbcod = estab.etbcod and
				   liped.lipsit = "A" and
				   liped.lipsep > 0 and
				   liped.protip = (if setbcod = 996
						   then "C"
						   else "M")
					    no-lock no-error.
	    if not avail liped
	    then next.
	    color display white/red liped.pednum.
	    if frame-line(frame-a) = frame-down(frame-a)
	    then scroll with frame frame-a.
	    else down with frame frame-a.
	end.
	if keyfunction(lastkey) = "cursor-up"
	then do:
	    find prev liped  USE-INDEX LIPED where liped.pedtdc = 2 and
				   liped.etbcod = estab.etbcod and
				   liped.lipsit = "A" and
				   liped.lipsep > 0   and
				   liped.protip = (if setbcod = 996
						   then "C"
						   else "M")
					    no-lock no-error.
	    if not avail liped
	    then next.
	    color display white/red liped.pednum.
	    if frame-line(frame-a) = 1
	    then scroll down with frame frame-a.
	    else up with frame frame-a.
	end.
	if keyfunction(lastkey) = "end-error"
	then leave bl-princ.
	if keyfunction(lastkey) = "return"
	then do on error undo:
	    find liped where recid(liped) = recatu1.
	  hide frame frame-a no-pause.
	  esqregua = no.
	  if esqregua
	  then do:
	    display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
		with frame f-com1.
	    if esqcom1[esqpos1] = ""
	    then do on error undo, retry on endkey undo, leave
			with frame f-liped.
	    end.
	  end.
	  else do:
	    display caps(esqcom2[esqpos2]) @ esqcom2[esqpos2]
		    with frame f-com2.
	    if esqcom2[esqpos2] = " Coletor " and
		setbcod = 996
	    then do:
		input from H:\coletor\coleta99.txt .
		repeat:
		    import vlei.
		    assign vetb = int(substring(string(vlei),4,2))
			   vcod = int(substring(string(vlei),14,7))
			   vcod2 = int(substring(string(vlei),14,6))
			   vqtd = int(substring(string(vlei),21,6)).
		    if vetb <> estab.etbcod or vcod = 0 or vcod = ? or
		       vcod = 1 or vcod = 2 or vcod = 3 or vcod = 4 or vcod = 5
		       then next.
		    find produ where produ.procod = vcod no-lock no-error.
		    if not avail produ
		    then do:
			find produ where produ.procod = vcod2 no-lock.
		    end.
		    find first cliped where cliped.pedtdc = 2             and
					    cliped.etbcod = estab.etbcod  and
					    cliped.lipsit = "A"           and
					    cliped.procod = produ.procod
					    no-error.
		    if not avail cliped
		    then do:
			find bpedid where recid(bpedid) = vpedrec no-error.
			if not avail bpedid
			then do:
			    find last bpedid where bpedid.etbcod = estab.etbcod
					       and bpedid.pedtdc = 2 no-error.
			    if avail bpedid
			    then vpednum = bpedid.pednum + 1.
			    else vpednum = 1.
			    create xpedid.
			    assign xpedid.pedtdc    = 2
				   xpedid.pednum    = vpednum
				   xpedid.regcod    = estab.regcod
				   xpedid.peddat    = today
				   xpedid.pedsit    = yes
				   xpedid.sitped    = "A"
				   xpedid.modcod    = "PED"
				   xpedid.etbcod    = estab.etbcod.
			    vpedrec = recid(xpedid).
			end.
			find clase where clase.clacod = produ.clacod no-lock.
			create xliped.
			assign xliped.pednum = xpedid.pednum
			       xliped.pedtdc = xpedid.pedtdc
			       xliped.predt  = xpedid.peddat
			       xliped.etbcod = xpedid.etbcod
			       xliped.procod = produ.procod
			       xliped.lipcor = ""
			       xliped.lipqtd = vqtd
			       xliped.lipsep = xliped.lipqtd
			       xliped.lipsit = "A"
			       xliped.protip = if clase.claordem = yes
					       then "M"
					       else "C".
			find estoq where estoq.etbcod = xliped.etbcod and
					 estoq.procod = xliped.procod no-lock
								      no-error.
			if avail estoq
			then xliped.lippreco = estoq.estcusto.
			else do:
			   find first estoq where estoq.procod = xliped.procod
							no-lock no-error.
			    xliped.lippreco = estoq.estcusto.
			end.
			disp xliped.procod label "Aguarde... Lendo Produto"
				with frame f-len3 centered color yellow/red
						side-label overlay row 10.
			pause 0.
		    end.
		    else do:
			cliped.lipsep = vqtd.
			find estoq where estoq.etbcod = cliped.etbcod and
					 estoq.procod = cliped.procod no-lock
								      no-error.
			if avail estoq
			then cliped.lippreco = estoq.estcusto.
			else do:
			   find first estoq where estoq.procod = xliped.procod
							no-lock no-error.
			    cliped.lippreco = estoq.estcusto.
			end.
			disp cliped.procod label "Aguarde... Lendo Produto"
				with frame f-len4 centered color yellow/red
						side-label overlay row 10.
			pause 0.
		    end.
		end.
		input close.
		leave.
	    end.
	    if esqcom2[esqpos2] = " Romaneio "
	    then do:
		run pedrom.p ( input liped.etbcod ).
	    end.
	    if esqcom2[esqpos2] = " Separacao "
	    then do on error undo:
		wdif = liped.lipqtd - liped.lipent.
		update liped.lipsep /*validate(liped.lipsep <= wdif,
				    "Quantidade Invalida")*/
		    with frame frame-a.
		vpronom = "".
		find produ where produ.procod = liped.procod no-lock no-error.
		if avail produ
		then vpronom = produ.pronom.
		wsep = 0.
		for each bliped where bliped.lipsit = "A" and
				      bliped.procod = liped.procod:
		    wsep = wsep + bliped.lipsep.
		end.
		west = 0.
		for each estoq where estoq.etbcod = setbcod and
				     estoq.procod = liped.procod no-lock.
		    west = west + estoq.estatual - wsep.
		    liped.lippreco = estoq.estcusto.
		end.
		disp west with frame frame-a.
		find next liped  USE-INDEX LIPED where liped.pedtdc = 2 and
				       liped.etbcod = estab.etbcod and
				       liped.lipsit = "A" and
				       liped.lipsep > 0 and
				       liped.protip = (if setbcod = 996
						       then "C"
						       else "M") no-error.
		if not avail liped
		then next.
		color display white/red liped.pednum.
		if frame-line(frame-a) = frame-down(frame-a)
		then scroll with frame frame-a.
		else down with frame frame-a.
		update liped.lipsep with frame frame-a.
	    end.
	    if esqcom2[esqpos2] = "Separa Geral"
	    then do on error undo:
		for each bliped where bliped.pedtdc = 2
				  and bliped.etbcod = estab.etbcod
				  and bliped.lipsit = "A":
		    wdif = bliped.lipqtd - bliped.lipent.
		    bliped.lipsep = wdif.
		    disp bliped.lipsep @ liped.lipsep
		    with frame frame-a.
		    vpronom = "".
		    find produ where produ.procod = bliped.procod
		    no-lock no-error.
		    if avail produ
		    then vpronom = produ.pronom.
		    wsep = 0.
		    for each cliped where cliped.lipsit = "A" and
					  cliped.procod = bliped.procod:
			wsep = wsep + cliped.lipsep.
		    end.
		    west = 0.
		    for each estoq where estoq.etbcod = setbcod and
					 estoq.procod = bliped.procod no-lock.
			west = west + estoq.estatual - wsep.
			bliped.lippreco = estoq.estcusto.
		    end.
		    disp west with frame frame-a.
		end.
		recatu1 = ?.
		clear frame frame-a all no-pause.
		leave.
	    end.
	    if esqcom2[esqpos2] = " Emissao NF "
	    then do on error undo:
		find last cplani where cplani.etbcod = setbcod and
				       cplani.placod <= 500000
				       exclusive-lock.
		vplacod = cplani.placod + 1.
		find last bplani where bplani.movtdc = 6 and
				       bplani.etbcod = setbcod
					exclusive-lock no-error.
		if not avail bplani
		then vnumero = 1.
		else vnumero = bplani.numero + 1.
		vserie  = "U".
		find tipmov where tipmov.movtdc = 6 no-lock.
		update vnumero
		       vserie with frame f-num centered row 10 overlay
					    side-label title " Nota Fiscal "
						color blue/cyan.
		do on error undo:
		    create plani.
		    assign plani.etbcod   = setbcod
			   plani.placod   = vplacod
			   plani.emite    = setbcod
			   plani.serie    = vserie
			   plani.numero   = vnumero
			   plani.movtdc   = 6
			   plani.desti    = estab.etbcod
			   plani.pladat   = today
			   plani.datexp   = today
			   plani.modcod   = tipmov.modcod

			   plani.notfat   = estab.etbcod
			   plani.dtinclu  = today
			   plani.horincl  = time
			   plani.notsit   = no.
		    vok = yes.
		    vprotot = 0.
		    for each liped  where liped.pedtdc = 2 and
					  liped.etbcod = estab.etbcod and
					  liped.lipsit = "A" and
					  liped.lipsep > 0 and
					  liped.protip = (if setbcod = 996
							  then "C"
							  else "M").
			vmovseq = vmovseq + 1.
			create movim.
			ASSIGN movim.movtdc = plani.movtdc
			       movim.PlaCod = plani.placod
			       movim.etbcod = plani.etbcod
			       movim.movseq = vmovseq
			       movim.procod = liped.procod
			       movim.movqtm = liped.lipsep
			       movim.movpc  = liped.lippreco
			       movim.movdat = plani.pladat
			       movim.MovHr     = int(time).
			run atuest.p (input recid(movim),
				      input "I",
				      input 0).
			vprotot = vprotot + (liped.lippreco * liped.lipsep).
			liped.lipent = liped.lipent + liped.lipsep.
			liped.lipsep = 0.
			if liped.lipent >= liped.lipqtd
			then liped.lipsit = "F".
			find pedid where pedid.etbcod = liped.etbcod and
					 pedid.pedtdc = liped.pedtdc and
					 pedid.pednum = liped.pednum.
			vok = yes.
			for each bliped of pedid no-lock.
			    if bliped.lipsit = "A"
			    then vok = no.
			end.
			if vok
			then pedid.sitped = "F".
			else pedid.sitped = "A".
		    end.
		    plani.platot = vprotot.
		    plani.protot = vprotot.
		    FIND NFFPED WHERE NFFPED.FORCOD = PLANI.PLACOD AND
				      NFFPED.MOVNDC = PLANI.MOVTDC AND
				      NFFPED.MOVSDC = PLANI.SERIE  AND
				      NFFPED.PEDNUM = PEDID.PEDNUM NO-ERROR.
		    IF NOT AVAIL NFFPED
		    THEN DO:
			create nffped.
			assign nffped.forcod = plani.placod
			       nffped.movndc = plani.movtdc
			       nffped.movsdc = plani.serie
			       nffped.pednum = pedid.pednum.
		    END.
		end.
		bell.
		message "Prepare a Impressora".
		pause.
		run /* impnftra.p */ imptra_l.p (input recid(plani)).
		leave.
	    end.
	  end.
	end.
	display esqcom2[esqpos2] with frame f-com2.
	wdif = liped.lipqtd - liped.lipent.
	vpronom = "".
	find produ where produ.procod = liped.procod no-lock no-error.
	if avail produ
	then vpronom = produ.pronom.
	wsep = 0.
	for each bliped where bliped.lipsit = "A" and
			      bliped.procod = liped.procod:
	    wsep = wsep + bliped.lipsep.
	end.
	west = 0.
	for each estoq where estoq.etbcod = setbcod and
			     estoq.procod = liped.procod no-lock.
	     west = west + estoq.estatual - wsep.
	end.
	display
	    liped.pednum  column-label "Num"
	    liped.procod
	    vpronom
	    west
	    wdif
	    liped.lipsep
		with frame frame-a 10 down centered color white/red.
	recatu1 = recid(liped).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
	view frame fc1.
	view frame fc2.
    end.
end.
