{admcab.i}


def var v-pedido as integer.

update v-pedido label "Num Modulo" format ">>>>>9".
          

/***********  N�mero do Modulo  que ter� a montagem for�ada   **************/

for each ctpromoc where sequencia = v-pedido and linha = 0.
if not avail ctpromoc then next.
ctpromoc.situacao = "M".
disp sequencia dtini dtfim situacao.
end.

message "Acertado Modulo" v-pedido.