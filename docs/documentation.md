{% docs event_types %}

Tipos de eventos que se pueden producir.
	
Uno de los siguientes valores: 

| tipo           | definición                                       |
|----------------|--------------------------------------------------|
| checkout       | Proceso de pago iniciado por el cliente           |
| package_shipped| Paquete enviado al cliente                       |
| add_to_cart    | Producto añadido al carrito                      |
| page_view      | Vista la página de un determinado producto       |

{% enddocs %}

{% docs order_status %}

Estado de envío del pedido.
	
Uno de los siguientes valores: 

| estado         | definición                                       |
|----------------|--------------------------------------------------|
| preparing      | Pedido en preparación, aún no enviado            |
| shipped        | Pedido enviado, aún no entregado                 |
| delivered      | Pedido recibido por el cliente                   |

{% enddocs %}

