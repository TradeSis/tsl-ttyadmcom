/* Gestao de Boletos   - rotinas
   bol/baixaparcela_v1701.p
    Baixa Parcela vinculada a Boleto de Acordo ou Central de Pagamentos
*/
def input parameter par-pdvmov as recid.
def input parameter par-seqreg  as int.

def input parameter par-bolorigem as recid.
def input parameter par-titdtpag  as date.
def input parameter par-titvlpag  as dec.
def input parameter par-titjuro   as dec.  
def output param    par-ok as log.

def buffer bcybacparcela for cybacparcela.

par-ok = no.

find banbolorigem where recid(banbolorigem) = par-bolorigem no-lock.
find banboleto of banbolorigem no-lock.

find pdvmov where recid(pdvmov) = par-pdvmov no-lock.


if banbolorigem.tabelaOrigem = "cybacparcela"
then do:
    find cybacparcela where 
            cybacparcela.idacordo = int(entry(1,banbolorigem.dadosOrigem)) and
            cybacparcela.parcela  = int(entry(2,banbolorigem.dadosOrigem))
        no-lock no-error.
    if not avail cybacparcela
    then return.
    find cybacordo of cybacparcela no-lock no-error.
    if not avail cybacordo
    then return.

    if cybacordo.dtefetiva <> ? 
    then do on error undo:
        find first titulo where
            titulo.empcod = 19 and
            titulo.titnat = no and
            titulo.modcod = cybacordo.modcod and
            titulo.etbcod = cybacordo.etbcod and
            titulo.clifor = cybacordo.clifor and
            titulo.titnum = string(cybacparcela.contnum) and
            titulo.titpar = cybacparcela.parcela
        exclusive no-error.
        if avail titulo
        then do:
            /**
            assign
                titulo.titdtpag = par-titdtpag
                titulo.titvlpag = par-titvlpag
                titulo.titjuro  = if titulo.titvlpag > titulo.titvlcob
                                  then titulo.titvlpag - titulo.titvlcob
                                  else 0
                titulo.titsit   = "PAG"
                titulo.etbcobra = 999
                titulo.moecod   = "BCO".
            **/
            
            find current cybacparcela exclusive.
            assign
                cybacparcela.dtbaixa  = today
                cybacparcela.situacao = "B". /* Baixado */ 
        
            find first bcybacparcela of cybacordo where
                bcybacparcela.parcela > cybacparcela.parcela
                exclusive no-error.
            if avail bcybacparcela
            then do:
                bcybacparcela.situacao = "ENVIARBOLETO". /* Next */
            end.                                
            
            par-ok = yes.
            
    
            create pdvdoc.
          ASSIGN
            pdvdoc.etbcod            = pdvmov.etbcod
            pdvdoc.cmocod            = pdvmov.cmocod
            pdvdoc.DataMov           = pdvmov.DataMov
            pdvdoc.Sequencia         = pdvmov.Sequencia
            pdvdoc.ctmcod            = pdvmov.ctmcod
            pdvdoc.COO               = pdvmov.COO
            pdvdoc.seqreg            = par-seqreg
            pdvdoc.CliFor            = titulo.CliFor
            pdvdoc.ContNum           = string(titulo.titnum)
            pdvdoc.titpar            = titulo.titpar
            pdvdoc.titdtven          = titulo.titdtven.
          ASSIGN
            pdvdoc.pago_parcial      = "N"
            pdvdoc.modcod            = titulo.modcod
            pdvdoc.Desconto_Tarifa   = 0
            pdvdoc.Valor_Encargo     = 0
            pdvdoc.hispaddesc        = "BAIXA DE BOLETO ACORDO CYB " + string(cybacordo.idacordo).
            pdvdoc.valor             = par-titvlpag.
            pdvdoc.titvlcob          = titulo.titvlcob.
            pdvdoc.valor_encargo    = par-titvlpag - titulo.titvlcob.
            if pdvdoc.valor_encargo < 0
            then do:
                pdvdoc.desconto = pdvdoc.valor_encargo * -1.
                pdvdoc.valor_encargo = 0.
            end.
        
            run /admcom/progr/fin/baixatitulo.p (recid(pdvdoc),
                                                recid(titulo)).

            
            
        end.
    end.
end.

message banbolorigem.nossonumero "bol/baixaparcela_v2001.p" banbolOrigem.tabelaOrigem banBolOrigem.ChaveOrigem banbolorigem.dadosorigem.

if (banbolOrigem.tabelaOrigem = "titulo" or banbolOrigem.tabelaOrigem = ?) and
   banBolOrigem.ChaveOrigem = "contnum,titpar"
then do:  
    find contrato where
            contrato.contnum = int(entry(1,banbolorigem.dadosorigem)) 
         no-lock no-error.    
    if avail contrato
    then do:  
        find first  titulo where   
                titulo.empcod = 19 and 
                titulo.titnat = no and 
                titulo.modcod = contrato.modcod and 
                titulo.etbcod = contrato.etbcod and 
                titulo.clifor = contrato.clicod and 
                titulo.titnum = string(contrato.contnum) and 
                titulo.titpar = int(entry(2,banbolorigem.dadosorigem)) 
                exclusive no-error.
        if avail titulo
        then do:
            if titulo.titsit = "LIB"
            then do:
                par-ok = yes.
                /**
                assign            
                    titulo.titdtpag = par-titdtpag
                    titulo.titvlpag = par-titvlpag
                    titulo.titjuro  = if titulo.titvlpag > titulo.titvlcob
                                      then titulo.titvlpag - titulo.titvlcob
                                      else 0
                    titulo.titsit   = "PAG"
                    /* 12.12.17 */
                    titulo.etbcobra = 999
                    titulo.moecod   = "BCO".
                    
                **/
                
               create pdvdoc.
              ASSIGN
                pdvdoc.etbcod            = pdvmov.etbcod
                pdvdoc.cmocod            = pdvmov.cmocod
                pdvdoc.DataMov           = pdvmov.DataMov
                pdvdoc.Sequencia         = pdvmov.Sequencia
                pdvdoc.ctmcod            = pdvmov.ctmcod
                pdvdoc.COO               = pdvmov.COO
                pdvdoc.seqreg            = par-seqreg
                pdvdoc.CliFor            = titulo.CliFor
                pdvdoc.ContNum           = string(titulo.titnum)
                pdvdoc.titpar            = titulo.titpar
                pdvdoc.titdtven          = titulo.titdtven.
              ASSIGN
                pdvdoc.pago_parcial      = "N"
                pdvdoc.modcod            = titulo.modcod
                pdvdoc.Desconto_Tarifa   = 0
                pdvdoc.Valor_Encargo     = 0
                pdvdoc.hispaddesc        = "BAIXA DE BOLETO " + string(banboleto.nossonumero).
                pdvdoc.valor             = par-titvlpag.
                pdvdoc.titvlcob          = titulo.titvlcob.
                pdvdoc.valor_encargo    = par-titvlpag - titulo.titvlcob.
                if pdvdoc.valor_encargo < 0
                then do:
                    pdvdoc.desconto = pdvdoc.valor_encargo * -1.
                    pdvdoc.valor_encargo = 0.
                end.
        
                run /admcom/progr/fin/baixatitulo.p (recid(pdvdoc),
                                                    recid(titulo)).

                     
                    
            end.
        end.      
    end.
end.

