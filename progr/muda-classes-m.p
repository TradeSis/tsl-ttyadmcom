{admcab.i new}
def var vcarcod like caract.carcod.
def var vsubcod like subcaract.subcod.
def var v-ok as log.
def var vclacod like clase.clacod.
def var vetccod like estac.etccod.
def var vdesc as char format "x(50)".

update vetccod at 3 with frame f1.
            if vetccod <> 0
            then do:
                find first estac where estac.etccod = vetccod no-lock no-error.
                if not avail estac 
                then do:
                    message "Estacao Inexistente"   view-as alert-box.
                    undo, retry.
                end.
                else disp estac.etcnom no-label with frame f1.
end.  
else disp "Todas" @ estac.etcnom with frame f1.  
 
if vetccod = 0
then return.

update vcarcod label "Caracteristica" at 3
                    with frame f1 side-label.
if vcarcod <> 0
then do:
                find first caract 
                            where caract.carcod = vcarcod no-lock no-error.
                if not avail caract
                then do:
                     message "Caracteristica Inexistente" VIEW-AS ALERT-BOX.
                     undo, retry.
                end.
                disp cardes no-label with frame f1.
end.
update vsubcod label "Sub-Caracteristica" at 1
                   with frame f1.
if vsubcod <> 0
then do:
                    find first subcarac where subcarac.subcod = vsubcod
                    no-lock no-error.
                    if not avail subcaract
                    then do:
                            message "Sub-Caracteristica Inexistente"
                                VIEW-AS ALERT-BOX.
                            undo, retry.
                    end.
                    disp subcaract.subdes no-label with frame f1.
end.  
else disp "Todas" @ subcaract.subdes with frame f1.  
update vdesc label "Descri��o" with frame f1.
 
update vclacod at 1 label "Nova Sub-Classe"
    with frame f1.
find clase where clase.clacod = vclacod and
                 clase.clagrau = 4
                 no-lock no-error.
if not avail clase then return.
disp clase.clanom no-label with frame f1.                 
    
if vcarcod = 0 or vsubcod = 0
then return.

sresp = no.
message "Confirma altera��o?" update sresp.

if vdesc <> ""
then vdesc = "*" + vdesc + "*".

def buffer bprodu for produ.

for each produ where catcod = 41 no-lock.
    
    if vdesc <> "" and
        produ.pronom matches vdesc
    then.
    else next.
        
    if vetccod  <> 0
    then
    if produ.etccod <> vetccod then next.

    v-ok = no.
    run valprocaract.p(input produ.procod, vcarcod, vsubcod, output v-ok).
    if v-ok
    then do:
        disp produ.procod produ.pronom produ.clacod.
        pause 0.
        if sresp
        then do transaction:
            find bprodu where bprodu.procod = produ.procod exclusive.
            bprodu.clacod = vclacod.
        end.
        find current bprodu no-lock.
    end.
end.    

