/*--------------------------------------------Etiquetas Butique peao----------*/
/* admcom/cp/peaoetiq.p                                                       */
/*----------------------------------------------------------------------------*/

{admcab.i}
def var t-lib like titulo.titvlcob.
def var t-inf like titulo.titvlcob.
def var vini as date format "99/99/9999" label "Data Inicial".
def var vi as int.
def var vfim as date format "99/99/9999" label  "Data Final".
def var diaini as int format ">>9" label "Dias Inicial".
def var diafim as int format ">>9" label "Dias Final".
def var vtotal      as char  extent 8 format "x(10)".
def var vcontrato like titulo.titnum.
def var vcli    like clien.clicod.
def var vclicod like clien.clicod  extent 2 format "999999999".
def var vclinom like clien.clinom format "x(25)"  extent 2.
def var vtitpar like titulo.titpar extent 2.
def var vtitnum like titulo.titnum format "x(8)" extent 2.
def var vnumero like clien.numero  extent 2 .
def var vendereco like clien.endereco format "x(32)" extent 2 .
def var vcep      like clien.cep extent 2 .
def var vcompl  like clien.compl extent 2.
def var vetbcod like titulo.etbcod extent 2 format ">>9".
def var vcidade like clien.cidade format "x(12)" extent 2.
def var vbairro like clien.bairro format "x(10)" extent 2.
def var vtitvlpag like titulo.titvlpag extent 2 .
def var vtitdtven like titulo.titdtven extent 2 format "99/99/9999".
def var vetique   as log format "Sim/Nao".

def var n-etiq  as int.
def var wetbcod like estab.etbcod.

def var vlmax like plani.platot.
def var wetbcod2 like estab.etbcod.

def buffer btitulo for titulo.

def var t as i.
def var i as int.
def var v as i.


do with width 80 title " Emissao de Etiquetas de Aviso " frame f1 side-label
                row 4:
    update wetbcod colon 20
           wetbcod2.

    if wetbcod <> 0
    then do:
        /*
        find estab where estab.etbcod = wetbcod.
        disp estab.etbnom no-label. */
    end.
    else disp " GERAL " @ estab.etbnom colon 20.
    update diaini colon 20
           diafim colon 45.
        vfim = today - diaini.
        vini = today - diafim.
    update vini colon 20
           vfim colon 45.
    update vlmax label "Maior Parcela" colon 20.
    vetique = no.
    update vetique label "Imprimir Etiqueta" colon 20.
    output to printer page-size 0.
    vcontrato = "".
    vcli = 0.
    vi = 0.
    for each estab where
            if wetbcod = 0
            then true
            else estab.etbcod >= wetbcod and
                 estab.etbcod <= wetbcod2 :

        for each titulo use-index titdtven where
                        titulo.empcod = 19      and
                        titulo.titnat = no      and
                        titulo.modcod = "CRE"   and
                        titulo.titdtven >= vini and
                        titulo.titdtven <= vfim and
                        titulo.etbcod = estab.etbcod and
                        titulo.titsit = "LIB"   and
                        titulo.titvlcob > vlmax
                        no-lock break by titulo.clifor:
            if last-of(titulo.clifor)
            then do:
                find clipar where clipar.clicod = titulo.clifor no-error.
                if avail clipar
                then next.

                find clien where clien.clicod = titulo.clifor no-lock no-error.
                if not avail clien
                then next.
                if vetique
                then vi = vi + 1.
                else vi = 1.
                assign vetbcod[vi] = titulo.etbcod
                       vtitdtven[vi] = titulo.titdtven
                       vclicod[vi] = titulo.clifor
                       vtitnum[vi] = titulo.titnum
                       vclinom[vi] = clien.clinom
                       vendereco[vi] = trim(endereco[1] + "," +
                                            string(clien.numero[1])
                                            + " - " +
                                       (if clien.compl[1] = ?
                                        then ""
                                        else string(clien.compl[1])))
                       vcep[vi] = cep[1]
                       vcidade[vi] = cidade[1]
                       vbairro[vi] = bairro[1].

                if vi = 2 and vetique
                then do:
                    put
                     "C: " at 1  vclicod[1] "Ctr: " at 15 vtitnum[1]
                     "C: " at 37 vclicod[2] "Ctr: " at 50 vtitnum[2] skip

                      vclinom[1] at 1
                      vclinom[2] at 37 skip
                      vendereco[1] at 1
                      vendereco[2] at 37 skip

                    "Bair: " at 1 vbairro[1]  vtitdtven[1] at 20
                    "bair: " at 37 vbairro[2] vtitdtven[2] at 56 skip

                    "CEP: " at 1 vcep[1]  vcidade[1]   at 20
                    "CEP: " at 37 vcep[2] vcidade[2]   at 56 skip(1).
                    assign vetbcod[vi] = 0
                           vtitdtven[vi] = ?
                           vclicod[vi] = 0
                           vtitnum[vi] = ""
                           vclinom[vi] = ""
                           vendereco[vi] = ""
                           vcep[vi] = ""
                           vcidade[vi] = "".
                    vi = 0.
                end.
                do transaction:
                    create clipar.
                    assign clipar.clicod = titulo.clifor.
                end.
                vcli = titulo.clifor.
            end.
        end.
    end.
    if vetique
    then 
    put "Fil: " at 1  vetbcod[1] vtitdtven[1] at 20
        "Fil: " at 37 vetbcod[2] vtitdtven[2] at 56 skip 
        "Cta: " at 1  vclicod[1] "Ctr: " at 20 vtitnum[1] 
        "Cta: " at 37 vclicod[2] "Ctr: " at 56 vtitnum[2] skip 
        vclinom[1] at 1 
        vclinom[2] at 37 skip 
        "End: " at 1 vendereco[1] 
        "End: " at 37 vendereco[2] skip 
        "CEP: " at 1 vcep[1]  vcidade[1]   at 20 
        "CEP: " at 37 vcep[2] vcidade[2]   at 56 skip(1).
    output  close.
    message "Emissao de Etiquetas p/ Cobranca encerrada.".
    
    message "deseja limpar arquivo" update sresp.
    if sresp
    then do:
    
        for each clipar:
            
            disp "Limpando Arquivos.....".
            disp clipar with 1 down. pause 0.
            delete clipar.
            
        end.
        
    end.

end.
