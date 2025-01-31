
{admcab.i}

def input parameter p-etbcod like estab.etbcod.
def input parameter p-dti as date.
def input parameter p-dtf as date.
def input parameter p-index as int.

def var recatu1         as recid.
def var recatu2         as recid.
def var reccont         as int.
def var esqpos1         as int.
def var esqpos2         as int.
def var esqregua        as log.
def var esqvazio        as log.
def var esqascend     as log initial yes.
def var esqcom1         as char format "x(12)" extent 5
    initial [" Consulta "," ","  "," "," "].
def var esqcom2         as char format "x(12)" extent 5
            initial [" "," ","","",""].
def var esqhel1         as char format "x(80)" extent 5
    initial ["  ",
             "  ",
             "  ",
             "  ",
             "  "].
def var esqhel2         as char format "x(12)" extent 5
   initial ["  ",
            "  ",
            "  ",
            "  ",
            "  "].

def buffer btbprice  for tbprice.

form
    esqcom1
    with frame f-com1
                 row 6 no-box no-labels side-labels column 1 centered.
form
    esqcom2
    with frame f-com2
                 row screen-lines no-box no-labels side-labels column 1
                 centered.
assign
    esqregua = yes
    esqpos1  = 1
    esqpos2  = 1.

def var vetbcod like estab.etbcod.
def var vdti as date.
def var vdtf as date.
def var v as char.
def var c as char.
def shared var vtipo as char extent 3 format "x(10)"
    init["  VIVO  ","  CLARO  ","  TIM"]
    .

def var vindex as int.

hide frame f3 no-pause.

def var vcto_o as dec.
def var vcto_v as dec.
def var vcto_e as dec.
def var vprice as dec.

def temp-table tt-price
    field etbcod like estab.etbcod
    field serial like tbprice.serial
    field custo_o as dec
    field custo_v as dec
    field venda_s as dec
    field venda_e as dec
    field price as dec
    index i1 etbcod serial
    .
    
do:
    for each estab where  estab.etbcod = p-etbcod no-lock.
        for each tbprice where
                 tbprice.etb_venda = estab.etbcod and
                 tbprice.data_venda >= p-dti and
                 tbprice.data_venda <= p-dtf
                 no-lock:
            
            if (p-index = 1 and
                tbprice.tipo <> "VIVO") or
               (p-index = 2 and
                tbprice.tipo <> "CLARO") or
               (p-index = 3 and
                tbprice.tipo <> "TIM")
            then next. 
            
            find first tt-price where
                       tt-price.serial = tbprice.serial
                       no-error.
            if not avail tt-price
            then do:
                create tt-price.
                tt-price.serial = tbprice.serial.
                tt-price.etbcod = tbprice.etb_venda.
            end.
            assign
                tt-price.custo_o = tt-price.custo_o + tbprice.custo_original
                tt-price.custo_v = tt-price.custo_v + 
                       (tbprice.venda_efetiva * .7)
                tt-price.venda_s = tt-price.venda_s + tbprice.venda_sugerido
                tt-price.venda_e = tt-price.venda_e + tbprice.venda_efetiva
                .
            if tbprice.custo_original > 0
            then tt-price.price   = tt-price.price +
                        (tbprice.custo_original - 
                                       (tbprice.venda_efetiva * .7)).
        end. 
    end.
end.
for each tt-price:
    assign
        vcto_o = vcto_o + tt-price.custo_o
        vcto_v = vcto_v + tt-price.custo_v
        vcto_e = vcto_e + tt-price.venda_e
        vprice = vprice + tt-price.price.
end.

bl-princ:
repeat:
    display 
        vcto_o at 28 format ">>>>>,>>9.99"
        vcto_v format ">>>>>,>>9.99"
        vcto_e format ">>>>>,>>9.99"
        vprice format "->>>,>>9.99"
        with frame frame-t width 80 1 down color white/black
        overlay no-label no-box row 22.
    pause 0.
    
    disp esqcom1 with frame f-com1.
    disp esqcom2 with frame f-com2.
    if recatu1 = ?
    then
        run leitura (input "pri").
    else
        find tt-price where recid(tt-price) = recatu1 no-lock.
    if not available tt-price
    then esqvazio = yes.
    else esqvazio = no.
    if esqvazio
    then do:
        message color red/with
        "Nenhum registro encontrado."
        view-as alert-box.
        return.
    end.
    clear frame frame-a all no-pause.
    if not esqvazio
    then do:
        run frame-a.
    end.

    recatu1 = recid(tt-price).
    if esqregua
    then color display message esqcom1[esqpos1] with frame f-com1.
    else color display message esqcom2[esqpos2] with frame f-com2.
    if not esqvazio
    then repeat:
        run leitura (input "seg").
        if not available tt-price
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down
            with frame frame-a.
        run frame-a.
    end.
    if not esqvazio
    then up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        if not esqvazio
        then do:
            find tt-price where recid(tt-price) = recatu1 no-lock.

            status default
                if esqregua
                then esqhel1[esqpos1] + if esqpos1 > 1 and
                                           esqhel1[esqpos1] <> ""
                                        then  string(tt-price.serial)
                                        else ""
                else esqhel2[esqpos2] + if esqhel2[esqpos2] <> ""
                                        then string(tt-price.serial)
                                        else "".
            run color-message.
            choose field tt-price.serial 
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      tab PF4 F4 ESC return) color message.
            run color-normal.
            status default "".

        end.
            if keyfunction(lastkey) = "TAB"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    color display message esqcom2[esqpos2] with frame f-com2.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    color display message esqcom1[esqpos1] with frame f-com1.
                end.
                esqregua = not esqregua.
            end.
            if keyfunction(lastkey) = "cursor-right"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 5 then 5 else esqpos1 + 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    esqpos2 = if esqpos2 = 5 then 5 else esqpos2 + 1.
                    color display messages esqcom2[esqpos2] with frame f-com2.
                end.
                next.
            end.
            if keyfunction(lastkey) = "cursor-left"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 1 then 1 else esqpos1 - 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    esqpos2 = if esqpos2 = 1 then 1 else esqpos2 - 1.
                    color display messages esqcom2[esqpos2] with frame f-com2.
                end.
                next.
            end.
            if keyfunction(lastkey) = "page-down"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "down").
                    if not avail tt-price
                    then leave.
                    recatu1 = recid(tt-price).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail tt-price
                    then leave.
                    recatu1 = recid(tt-price).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail tt-price
                then next.
                color display white/red tt-price.serial with frame frame-a.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail tt-price
                then next.
                color display white/red tt-price.serial with frame frame-a.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return" or esqvazio
        then do:
            form tt-price
                 with frame f-tt-price color black/cyan
                      centered side-label row 5 .
            hide frame frame-a no-pause.
            if esqregua
            then do:
                display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                        with frame f-com1.

                if esqcom1[esqpos1] = " Inclusao " or esqvazio
                then do with frame f-tt-price on error undo.
                    create tt-price.
                    update tt-price.
                    recatu1 = recid(tt-price).
                    leave.
                end.
                if esqcom1[esqpos1] = " Consulta " or
                   esqcom1[esqpos1] = " Exclusao " or
                   esqcom1[esqpos1] = " Alteracao "
                then do with frame f-tt-price.
                    hide frame frame-t no-pause.
                    display 
        tt-price.serial format "x(20)"
        tt-price.etbcod column-label "Fil"
        tt-price.custo_o column-label "Custo Orig"   format ">>>>>,>>9.99"
        tt-price.custo_v column-label "Custo Venda"  format ">>>>>,>>9.99"
        /*tt-price.venda_s column-label "Venda Sug"    format ">>>,>>9.99"*/
        tt-price.venda_e column-label "Venda Efe"    format ">>>>>,>>9.99"
        tt-price.price   column-label "Price"        format "->>>,>>9.99"
        with frame frame-c width 80 10 down centered color white/red 
        row 7 title "  " + vtipo[p-index] + 
        " Filial " + string(p-etbcod,">>9") + "  "
        overlay.
        pause 0.
                    find first tbprice where
                               tbprice.tipo   = trim(vtipo[p-index]) and 
                               tbprice.serial = tt-price.serial
                               no-lock.
                    disp tbprice.nota_compra    label "Nota Compra" 
                         tbprice.data_compra
                         tbprice.nota_venda
                         tbprice.data_venda
                         with frame f-consulta 1 down
                         side-label 1 column row 12
                         centered no-box
                         overlay color message.
                    pause.
                    view frame frame-t.
                end.
                if esqcom1[esqpos1] = " Alteracao "
                then do with frame f-tt-price on error undo.
                    find tt-price where
                            recid(tt-price) = recatu1 
                        exclusive.
                    update tt-price.
                end.
                if esqcom1[esqpos1] = " Exclusao "
                then do with frame f-exclui  row 5 1 column centered
                        on error undo.
                    message "Confirma Exclusao de" tt-price.serial                                update sresp.
                    if not sresp
                    then undo, leave.
                    find next tt-price where true no-error.
                    if not available tt-price
                    then do:
                        find tt-price where recid(tt-price) = recatu1.
                        find prev tt-price where true no-error.
                    end.
                    recatu2 = if available tt-price
                              then recid(tt-price)
                              else ?.
                    find tt-price where recid(tt-price) = recatu1
                            exclusive.
                    delete tt-price.
                    recatu1 = recatu2.
                    leave.
                end.
                if esqcom1[esqpos1] = " Listagem "
                then do with frame f-Lista:
                    update "Deseja Imprimir todas ou a selecionada "
                           sresp format "Todas/Selecionada"
                                 help "Todas/Selecionadas"
                           with frame f-lista row 15 centered color black/cyan
                                 no-label.
                    if sresp
                    then run ltt-price.p (input 0).
                    else run ltt-price.p (input tt-price.serial).
                    leave.
                end.
            end.
            else do:
                display caps(esqcom2[esqpos2]) @ esqcom2[esqpos2]
                        with frame f-com2.
                if esqcom2[esqpos2] = "  "
                then do:
                    hide frame f-com1  no-pause.
                    hide frame f-com2  no-pause.
                    /* run programa de relacionamento.p (input ). */
                    view frame f-com1.
                    view frame f-com2.
                end.
                leave.
            end.
        end.
        if not esqvazio
        then do:
            run frame-a.
        end.
        if esqregua
        then display esqcom1[esqpos1] with frame f-com1.
        else display esqcom2[esqpos2] with frame f-com2.
        recatu1 = recid(tt-price).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame f-com2  no-pause.
hide frame frame-a no-pause.

procedure frame-a.
display tt-price.serial format "x(20)"
        tt-price.etbcod column-label "Fil"
        tt-price.custo_o column-label "Custo Orig"   format ">>>>>,>>9.99"
        tt-price.custo_v column-label "Custo Venda"  format ">>>>>,>>9.99"
        /*tt-price.venda_s column-label "Venda Sug"    format ">>>,>>9.99"*/
        tt-price.venda_e column-label "Venda Efe"    format ">>>>>,>>9.99"
        tt-price.price   column-label "Price"        format "->>>,>>9.99"
        with frame frame-a width 80 10 down centered color white/red 
        row 7 title "  " + vtipo[p-index] + 
        " Filial " + string(p-etbcod,">>9") + "  "
        overlay.
end procedure.
procedure color-message.
color display message
        tt-price.serial
        with frame frame-a.
end procedure.
procedure color-normal.
color display normal
        tt-price.serial
        with frame frame-a.
end procedure.




procedure leitura . 
def input parameter par-tipo as char.
        
if par-tipo = "pri" 
then  
    if esqascend  
    then  
        find first tt-price where true
                                                no-lock no-error.
    else  
        find last tt-price  where true
                                                 no-lock no-error.
                                             
if par-tipo = "seg" or par-tipo = "down" 
then  
    if esqascend  
    then  
        find next tt-price  where true
                                                no-lock no-error.
    else  
        find prev tt-price   where true
                                                no-lock no-error.
             
if par-tipo = "up" 
then                  
    if esqascend   
    then   
        find prev tt-price where true  
                                        no-lock no-error.
    else   
        find next tt-price where true 
                                        no-lock no-error.
        
end procedure.

