{admcab.i}


def var v-pedido as integer.

update v-pedido label "Num Pedido" format ">>>>>>>>>9".
          

/***********  N�mero do Pedido que ter� a libera��o for�ada   **************/

/* assign v-pedido = 9999.*/

 
find last pedid where pedid.etbcod = 200
                  and pedid.pedtdc = 3
                  and pedid.pednum = v-pedido exclusive-lock no-error.

if avail pedid
then do:
    assign pedid.sitped = "A".
    message "Situa��o alterada com sucesso!!" view-as alert-box.
    release pedid.
end.
else message "Pedido N�o encontrado!!" view-as alert-box.









