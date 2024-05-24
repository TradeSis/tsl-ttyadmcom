{/u/bsweb/progr/acha.i}

def var par-ok  as log.
def var vstatus as char.
def var vmensagem_erro as char.
def var vrecebe-email-promo as char.
def var vcod as int64.

def shared temp-table ClienteEntrada
    field codigo_cpfcnpj as char.

{/u/bsweb/progr/bsxml-iso.i}

find first ClienteEntrada no-lock no-error.
if avail ClienteEntrada
then do.
    vstatus = "S".

    vcod = int(ClienteEntrada.codigo_cpfcnpj) no-error.
    if vcod <> 0 and vcod <> ?
    then do.

        find first clien where 
                    clien.clicod = int(ClienteEntrada.codigo_cpfcnpj)
                    no-lock no-error.
    end.
        
    if not avail clien
    then find first clien where 
                clien.ciccgc = ClienteEntrada.codigo_cpfcnpj
                no-lock no-error.
    

    if not avail clien
    then assign
            vstatus = "E"
            vmensagem_erro = "Cliente " + ClienteEntrada.codigo_cpfcnpj + 
            " nao encontrado.".
end.
else assign
        vstatus = "E"
        vmensagem_erro = "Parametros de Entrada nao recebidos".
    
BSXml("ABREXML","").
bsxml("abretabela","ClienteRetorno").
bsxml("status",vstatus).
bsxml("mensagem_erro",vmensagem_erro).
    
if avail clien
then do:
    find cpclien where cpclien.clicod =  clien.clicod no-lock no-error.
        
    bsxml("codigo_cliente",string(clien.clicod)).
    bsxml("cpf_cnpj",clien.ciccgc).
    bsxml("nome",Texto(clien.clinom)).
    bsxml("celular",Texto(clien.fax)).
    bsxml("telefone_profissional",Texto(clien.protel[1])).

    /**
    bsxml("data_nascimento", EnviaData(clien.dtnasc)).
    bsxml("codigo_senha","").

    bsxml("cep",Texto(clien.cep[1])).
    bsxml("endereco",Texto(clien.endereco[1])).

    if clien.numero[1] <> ?
    then bsxml("numero",string(clien.numero[1])).
    else bsxml("numero","").

    bsxml("complemento",Texto(clien.compl[1])).
    bsxml("bairro",Texto(clien.bairro[1])).
    bsxml("cidade",Texto(clien.cidade[1])).
    bsxml("uf",Texto(clien.ufecod[1])).
    bsxml("pais","BRA").
    bsxml("email",lc(Texto(clien.zona))).
        
    if avail cpclien and cpclien.emailpromocional = true
    then assign vrecebe-email-promo = "Sim".
    else assign vrecebe-email-promo = "Nao".    
    if vrecebe-email-promo = ?
    then vrecebe-email-promo = "".
    bsxml("deseja_receber_email",vrecebe-email-promo).
        
    bsxml("ddd","").
    bsxml("telefone",Texto(clien.fone)).

    **/            

end.

bsxml("fechatabela","ClienteRetorno").
BSXml("FECHAXML","").

