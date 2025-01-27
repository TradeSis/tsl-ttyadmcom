/* Programa de selecao Lote GLOBAL */
{admcab.i}

def input-output parameter par-lotcre as recid.
def input parameter par-lotcretp as recid.
def input parameter par-tipo     as char.

def temp-table tt-estab
       field etbcod as int.

def var vdtini      as date format "99/99/9999".
def var vdtfim      as date format "99/99/9999".
def var vdata       as date.
def var vselecao    as char.
def var vetbcod     like estab.etbcod.
def var vvlrtitulo as dec.
def var varquivo as char.
def buffer bestab for estab.
form vetbcod label "Filial" colon 25 with frame f1 side-label width 80.
find lotcretp where recid(lotcretp) = par-lotcretp no-lock.

for each tt-estab.

    delete tt-estab.

end.

if par-tipo = " Selecao "
then do.

    {selestab.i vetbcod f1}.

    
    do on error undo, retry:
          update vdtini to 34  label "Data Inicial"
                 vdtfim label "Data Final" with frame f1.
          if  vdtini > vdtfim
          then do:
                message color red/with 
                "Data inv�lida" view-as alert-box.
                undo.
          end.
    end.
    
    update vvlrtitulo label "Valor Titulo acima de " colon 25 with frame f1. 
     
    
    vselecao = string(vdtini) + " a " + string(vdtfim) 
    + " valor acima de " + string(vvlrtitulo).

    
    if vetbcod > 0
    then do:
        for each bestab where bestab.etbcod = vetbcod no-lock:
            create tt-estab.
            buffer-copy bestab to tt-estab.
        end.    
    end.
    else do:
        find first tt-lj where tt-lj.etbcod > 0 no-error.
        if not avail tt-lj
        then  for each bestab no-lock:
                create tt-estab.
                buffer-copy bestab to tt-estab.
        end. 
        else for each tt-lj where tt-lj.etbcod > 0 no-lock:
                create tt-estab.
                buffer-copy tt-lj to tt-estab.
        end.
    end.

    for each tt-estab no-lock.
    
        disp "Estabelecimento :" estab.etbcod no-label
        with frame f4 row 11 centered.
        pause 0.

        for each    titulo where 
                    titulo.empcod = 19
                    and titulo.titnat = no
                    and titulo.modcod = "CRE"
                    and titulo.titdtven >= vdtini
                    and titulo.titdtven <= vdtfim
                    and titulo.titvlcob >= vvlrtitulo 
                    and titulo.etbcod = tt-estab.etbcod 
                    and titulo.titsit = "LIB"
                    and titulo.titvlpag = 0
                    and titulo.cobcod = 2
                    /*
                    and titulo.cobcod <> 12 /* descarta titulos da global */
                    and titulo.cobcod <> 11 /* descarta titulos que ja estao 
                                            na access*/
                    */
                    no-lock break by titulo.titnum by titulo.titpar.


            find first contnf where contnf.etbcod = titulo.etbcod and          
            contnf.contnum = int(titulo.titnum) no-lock no-error.
            
            /* mandar as novacoes com parcela acima de 31 */
            if not avail contnf and
                titulo.titpar < 31
            then next.                                                 
            
            if par-lotcre = ?
            then do.
                run lotcria.p (input recid(lotcretp),
                           output par-lotcre).
                do on error undo.
                    find lotcre where recid(lotcre) = par-lotcre exclusive.
                    lotcre.ltselecao = vselecao.
                end.
                find current lotcre no-lock.
            end.

            run lotagcria.p (input par-lotcre,
                         input recid(titulo)).
            run lottitc.p   (input par-lotcre,
                         input recid(titulo),
                         ?,
                         "" /* por cliente, sitcli.titnum = "" */).
        end. /*titulo*/
        
        if connected ("d") then disconnect d.

        run conecta_d.p.
        if connected ("d")
        then do:
                             
            run ltglobalsellp.p (input-output par-lotcre,
                             input tt-estab.etbcod,
                             input vdtini,
                             input vdtfim,
                             vvlrtitulo). 

                             
            disconnect d.
        end.                     
    
    end. /*estab*/
    
    if par-lotcre <> ?
    then run value(lotcretp.valida + ".p") (input par-lotcre).
end.
if par-tipo = " Por Cliente "
then do.
    find lotcre where recid(lotcre) = par-lotcre no-lock.
    do on error undo with frame f-cli centered row 4 width 80 side-label.
    end.
end.


