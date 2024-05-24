{admcab.i}
def input param ptitulos as char.
def var pfiltraperiodo as log format "Sim/Nao". 
def var pfiltraplanos as log format "Sim/Nao".

def var pdtini as date format "99/99/9999".
def var pdtfim as date format "99/99/9999".

def var petbcod as int.
def var pfincod as int. /* pfincod = 0 todos ´fincod = ? nenhum */
def var vfincod as int.
def var vfinnom as char.
        hide message no-pause.
        message "informe filial ou zero para todas".
        update petbcod label "informe filial ou zero para todas" colon 40
            with frame ffilial
            row 9 centered side-labels overlay
            title ptitulos.
         hide message no-pause.
          
        find estab where estab.etbcod = petbcod no-lock no-error.
        if not avail estab and petbcod > 0
        then do:
            message "filial invalida".
            undo.
        end.     
        pfiltraperiodo  = no. 
        pfiltraplanos  = no. 
        pfincod = ?.        
        pdtini = ?.
        pdtfim = ?.
        
        update pfiltraperiodo label "filtrar periodo?"  colon 40
         with frame ffilial.
        disp pdtini colon 40 label "de" pdtfim label "ate"
                        with frame ffilial.
                        
        if pfiltraperiodo
        then do:            
            update pdtini colon 40 label "de" pdtfim label "ate"
                with frame ffilial.
        end.        
        update pfiltraplanos label "por plano?" colon 40
            with frame ffilial.
        if pfiltraplanos
        then do:
            hide message no-pause.
            message "informe o codigo do plano oou zero para todos".  
            pfincod = 0.
            update pfincod label "plano " with frame ffilial.
        end.    
 
def temp-table ttcotas no-undo
    field fcccod    like fincotacluster.fcccod
    field etbcod    like fincotacllib.etbcod 
    field fincod    like fincotaclplan.fincod
    field dtivig like fincotaetb.dtivig
    field dtfvig    like fincotaetb.dtivig
    field cotaslib    like fincotacllib.CotasLib
    field cotasuso  like fincotaetb.cotasuso
    index x is unique primary fcccod asc etbcod asc fincod asc dtivig asc dtfvig asc .
    
def var pordem as int.
 
def var varqcsv as char format "x(65)".

    varqcsv = "/admcom/relat/cotascluster_" + 
                string(today,"99999999") + "_" + replace(string(time,"HH:MM:SS"),":","") + ".csv".

    update varqcsv no-label colon 12
                            with side-labels width 80 frame f1
                            row 15 title "csv"
                            overlay.


message "Aguarde...". 


for each fincotacluster no-lock,
    each fincotacllib  of fincotacluster where
            no-lock,
    each fincotaclplan of fincotacluster no-lock.
    if petbcod <> 0 then if fincotacllib.etbcod <> petbcod then next.
    if pfincod <> ? 
    then if pfincod <> 0 
         then if fincotaclplan.fincod <> pfincod 
              then next.
    if pdtini <> ?  then if fincotacllib.dtivig < pdtini then next.
    if pdtfim <> ?  then if fincotacllib.dtfvig > pdtfim then next.
    
    vfincod = if pfincod = ? then 0 else fincotaclplan.fincod.
    
    find first ttcotas where  
            ttcotas.fcccod = fincotacluster.fcccod and
            ttcotas.etbcod = fincotacllib.etbcod   and
            ttcotas.fincod = vfincod and
            ttcotas.dtivig  = fincotacllib.dtivig and
            ttcotas.dtfvig  = fincotacllib.dtfvig
        no-error.
    if not avail ttcotas
    then do:
        create ttcotas. 
        ttcotas.fcccod = fincotacluster.fcccod.
        ttcotas.etbcod = fincotacllib.etbcod.
        ttcotas.fincod = vfincod.
        ttcotas.dtivig  = fincotacllib.dtivig.
        ttcotas.dtfvig  = fincotacllib.dtfvig .
    end.
    ttcotas.cotaslib = ttcotas.cotaslib + fincotacllib.cotaslib.   
    
    for each fincotaetb where 
                    fincotaetb.etbcod = fincotacllib.etbcod and
                    fincotaetb.fincod = fincotaclplan.fincod and
                    fincotaetb.dtivig = fincotacllib.dtivig and
                    fincotaetb.dtfvig = fincotacllib.dtfvig 
                    no-lock.
        ttcotas.cotasuso = ttcotas.cotasuso + fincotaetb.cotasuso.   
    end.

end.



output to value(varqcsv).
put unformatted  "filial;muncipio;CLS;Cluster;plano;nomePlano;" 
                 "dataInicio;dataFinal;"
                 "cotas Liberadas;cotas Usadas;"
                 skip.

for each ttcotas.

        find fincotacluster of ttcotas no-lock.
        find estab of ttcotas no-lock.
        vfinnom = "-".
        if ttcotas.fincod <> 0
        then do: 
            find finan of ttcotas no-lock no-error.
            if avail finan
            then vfinnom = finan.finnom.
        end.    
    
        put unformatted
            ttcotas.etbcod ";"
            estab.munic ";"
            ttcotas.fcccod ";"
            fincotacluster.fccnom ";"
            ttcotas.fincod ";"
            vfinnom ";"
            ttcotas.dtivig format "99/99/9999" ";"
            ttcotas.dtfvig format "99/99/9999" ";"
            ttcotas.cotaslib ";"
            ttcotas.cotasuso ";"
            skip.

    end.  


output close.

        hide message no-pause.
        message "Arquivo csv gerado " varqcsv.
        hide frame f1 no-pause.
        pause.    




