def output param vstatus as char.
def output param vmensagem_erro as char.



def var varqlog as char.
varqlog = "/u/bsweb/log/boleto_des" + string(today, "99999999") + ".log".

output to value(varqlog) append.
put unformatted skip
    today " " string(time, "hh:mm:ss")
    " bol/gravacybacordo_v1702.p " .
output close.



def var vetbcod as int.
def var vcontnum as int.
def var vParcelasLista as char.
def var vParcelasValorLista as char.
def var vdtacordo as date.
def var vdtvenc as date.

def shared temp-table GravaAcordoEntrada
    field CNPJ_CPJ as char
    field IDAcordo as char
    field DataAcordo as char
    field QtdContratosOrigem as char
    field VlPrincipal as char
    field VlJuros   as char
    field VlMulta   as char
    field VlHonorarios as char
    field VlEncargos as char
    field VlTotalAcordo as char
    field VlDesconto as char
    field OrigemAcordo as char.


def shared temp-table ContratosOrigem
    field grupo as char
    field contrato as char.


def shared temp-table ParcelasAcordo
    field NumeroParcela as char
    field Vencimento as char 
    field VlPrincipal as char
    field VlJuros as char
    field VlMulta as char
    field VlHonorarios as char
    field VlEncargos as char.


vstatus = "S".

find first GravaAcordoEntrada.

find cybacordo where 
    cybacordo.idacordo = int(gravaacordoentrada.idacordo)
    no-lock no-error.
if avail cybacordo
then do:
    vstatus = "N".
    vmensagem_erro = "Acordo ja gravado".
    return.
end.    

find first clien where clien.ciccgc = GravaAcordoEntrada.cnpj_cpj no-lock.

output to value(varqlog) append.
put unformatted skip
    today " " string(time, "hh:mm:ss")
    " bol/gravacybacordo_v1702.p " 
    gravaacordoentrada.dataacordo.
output close.


            /* 29.08.17 formato YYYY-MM-DD HH24:MI:SS */
vdtacordo = date(int(substr(gravaacordoentrada.dataacordo,6,2)),
                 int(substr(gravaacordoentrada.dataacordo,9,2)),
                 int(substr(gravaacordoentrada.dataacordo,1,4))).

output to value(varqlog) append.
put unformatted skip
    today " " string(time, "hh:mm:ss")
    " bol/gravacybacordo_v1702.p " 
    vdtacordo.
output close.


create cybacordo.
  ASSIGN
    CybAcordo.IDAcordo   = int(GravaAcordoEntrada.IDAcordo)
    CybAcordo.CliFor     = clien.clicod
    CybAcordo.DtAcordo   = vDtAcordo
    CybAcordo.Situacao   = "A"
    CybAcordo.VlAcordo   = dec(GravaAcordoEntrada.VlTotalAcordo)
    CybAcordo.VlOriginal = dec(GravaAcordoEntrada.VlPrincipal)
    CybAcordo.HrAcordo   = time
    CybAcordo.DtEfetiva  = ?
    CybAcordo.HrEfetiva  = ?.
  assign
    cybacordo.etbcod = 0
    cybacordo.modcod = ""
    cybacordo.tpcontrato = "".    

    for each ContratosOrigem.
        vetbcod   = int(substr(contratosOrigem.contrato,1,3)).
        vcontnum  = int(substr(ContratosOrigem.contrato,4)).

        
        find contrato where contrato.contnum = vcontnum no-lock.
 
        if cybacordo.etbcod = 0
        then cybacordo.etbcod = vetbcod.
        if cybacordo.modcod = ""
        then cybacordo.modcod = contrato.modcod.
        if cybacordo.tpcontrato = ""
        then cybacordo.tpcontrato = "N".
        
       
        create cybacorigem.
        ASSIGN
            CybAcOrigem.IDAcordo      = cybacordo.IDAcordo
            CybAcOrigem.contnum       = contrato.contnum.
        
        cybacorigem.vlOriginal = 0.
        
        vparcelasLista = "".
        vparcelasValorLista = "".
        
        for each titulo where 
                titulo.empcod = 19 and 
                titulo.titnat = no and 
                titulo.modcod = contrato.modcod and 
                titulo.etbcod = contrato.etbcod and 
                titulo.clifor = contrato.clicod and 
                titulo.titnum = string(contrato.contnum) 
                no-lock
                    by titulo.titpar.
     
            if titulo.clifor <= 1 or
               titulo.clifor = ? or
               titulo.titpar = 0 or
               titulo.titnum = "" or
               titulo.titvlcob <= 0.01 /*** 02.08.16 ***/
            then next.


            if titulo.titsit <> "LIB" then next.
            
            vparcelasLista = vparcelasLista +
                            if vparcelasLista = ""
                             then string(titulo.titpar)
                             else "," + string(titulo.titpar).
            
            vparcelasValorLista = vparcelasValorLista +
                            if vparcelasValorLista = ""
                             then string(titulo.titvlcob)
                             else "," + string(titulo.titvlcob).
            
            cybacOrigem.vlOriginal = cybAcOrigem.VlOriginal + 
                                        titulo.titvlcob.
        end.
        assign
            CybAcOrigem.ParcelasLista = vParcelasLista
            CybAcOrigem.ParcelasValor = vParcelasValorLista.

    end.

    for each ParcelasAcordo.
            /* 29.08.17 formato YYYY-MM-DD HH24:MI:SS */


            output to value(varqlog) append.
            put unformatted skip
            today " " string(time, "hh:mm:ss")
            " bol/gravacybacordo_v1702.p Parcelas " 
            parcelasAcordo.Vencimento.
        output close.

        
        vdtvenc   = date(int(substr(parcelasAcordo.Vencimento,6,2)),
                         int(substr(parcelasAcordo.Vencimento,9,2)),
                         int(substr(parcelasAcordo.Vencimento,1,4))).

    
        create CybAcParcela.
        ASSIGN
            CybAcParcela.IDAcordo     = cybacordo.IDAcordo
            CybAcParcela.Parcela      = int(parcelasAcordo.NumeroParcela)
            CybAcParcela.DtVencimento = vDtVenc
            CybAcParcela.VlCobrado    = dec(parcelasAcordo.VlPrincipal).

            /* Quando Efetivado */
        ASSIGN
            CybAcParcela.contnum      = ?  .

    end.
