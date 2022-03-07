
//Se van a manejar todos los modulos por puerto serial, así se les asigna el siguiente orden:
//UART0: Bluetooth (o wifi, se evaluara si cambiarlo para que quede más fácil enviar los datos a un servidor)
//UART1: Pantall LCD
//UART2: RFID

//El programa esta en un bucle revisando algún cambio de estado, principalmente en la pantalla  (esto inicialmente)
//si detecta cambio de estado, es decir hay un valor en el RX del UART1 entra a evalluar que acción realizar.
//se crea una función de lectura para el rfid void lector_rfid(uint8 r);
//Se crea funcion envio de dato por bluetooh

#include "soc-hw.h"

void lector_rfid(char r);
void enviar_bluetooth(char n, char s);

int main()
{

	uint8_t flag=1;
	char data_lcd ='0';


//	uart0_putchar('w');
//	sleep(100);

	while(flag)
	{

		data_lcd = uart1_getchar();
		sleep(10);
		switch(data_lcd){

		case 'e':lector_rfid('e'); //Registrar entrada
		break;
		case 'd':lector_rfid('d'); //Registrar descanso
		break;
		case 's':lector_rfid('s'); //Registrar salida
		break;
		}
//		if(data_rx == 'a')
//                {
//			gpio_write(PIN1, 1);
//			flag = 0;
//		}
	}
	return 0;
}

lector_rfid(char r)
{
	uint8_t flag2 = 1;
	char data_rfid = '0'; 
	int c = 0;
	gpio_write(PIN1,1);
	while(flag2)
	{
		data_rfid = uart2_getchar();
	
		if(data_rfid == 'A' ) //Tarjeta de Javier
		{
			enviar_bluetooth(data_rfid,r);
			gpio_write(PIN2,1);
			flag2 = 0;
		}
		if(data_rfid == 'B') //Tarjeta de Wilson
		{
			enviar_bluetooth(data_rfid,r);
			gpio_write(PIN2,1);
			flag2 = 0;
		}
		if(c==8000000)
		{

			flag2 = 0;
		}
		else
		{
			sleep(10);
			c++;
		}
	}
	c=0;
	return;


}
enviar_bluetooth(char n, char s)
{
	uart0_putchar(n);
	sleep(100);
	uart0_putchar(s);
	sleep(100);
	return;
}
