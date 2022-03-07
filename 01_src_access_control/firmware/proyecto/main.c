#include "soc-hw.h"


//Se van a manejar todos los modulos por puerto serial, así se les asigna el siguiente orden:
//UART0: Bluetooth (o wifi, se evaluara si cambiarlo para que quede más fácil enviar los datos a un servidor)
//UART1: Pantall LCD
//UART2: RFID

//El programa esta en un bucle revisando algún cambio de estado, principalmente en la pantalla  (esto inicialmente)
//si detecta cambio de estado, es decir hay un valor en el RX del UART1 entra a evalluar que acción realizar.
//se crea una función de lectura para el rfid void lector_rfid(uint8 r);
//Se crea funcion envio de dato por bluetooh


void lector_rfid(char r);
void enviar_bluetooth(char n, char s);

int main(){

	char data_blue;
	uint8_t flag=1;
	char data_lcd ='0';
    
	while(flag){  
 
		writeGpio(1); 
		sleep(1000);
		uart0_putstr("\r\n ||Control Acceso Empleados||\r\n");
		sleep(1000);

		data_lcd = uart1_getchar();
		sleep(100);

		switch(data_lcd){

			case 'e':
				writeGpio(2); 
				sleep(1000);
				lector_rfid('e'); //Registrar entrada

			break;
			case 'd':
				writeGpio(3); 
				sleep(1000);
				lector_rfid('d'); //Registrar descanso

			break;
			case 's':
		           	writeGpio(4); 
				sleep(1000);
				lector_rfid('s'); //Registrar salida
 
			break;
		}

	}
	return 0;
}


lector_rfid(char r)
{
	uint8_t flag2 = 1;
	char data_rfid = '0'; 
	int c = 0;
	writeGpio(5);
	sleep(1000);

	while(flag2)
	{
		data_rfid = uart2_getchar();
	
		if(data_rfid == 'A' ) //Tarjeta de Javier
		{
			writeGpio(6);
			flag2 = 0;
			data_rfid = '0';
			enviar_bluetooth(data_rfid,r);
			uart1_putstr("page 0");
			uart1_putchar(0xff);
			uart1_putchar(0xff);
			uart1_putchar(0xff);
			sleep(100);

		}
		if(data_rfid == 'B') //Tarjeta de Camilo
		{
			writeGpio(7);
			flag2 = 0;
			data_rfid = '0';
			enviar_bluetooth(data_rfid,r);
			uart1_putstr("page 0");
			uart1_putchar(0xff);
			uart1_putchar(0xff);
			uart1_putchar(0xff);
			sleep(100);

		}
		if(c==3)
		{
			flag2 = 0;
			data_rfid = '0';			
			uart1_putstr("page 0");
			uart1_putchar(0xff);
			uart1_putchar(0xff);
			uart1_putchar(0xff);
			sleep(100);
			
		}
		else
		{
			sleep(1000);
			c++;
		}
	}
	c=0;
	return;
}

enviar_bluetooth(char n, char s)
{
	
	switch(s){
		case 'e':
		if(n == 'A')
		{
			uart0_putstr("\r\n ||Entrada de A||\r\n");
		}
		if(n == 'B')
		{
			uart0_putstr("\r\n ||Entrada de B||\r\n");
		} 
		break;
		case 'd':
		if(n == 'A')
		{
			uart0_putstr("\r\n ||Desacanso de A||\r\n");
		}
		if(n == 'B')
		{
			uart0_putstr("\r\n ||Desacanso de B||\r\n");
		} 
		break;
		case 's': 
		if(n == 'A')
		{
			uart0_putstr("\r\n ||Salida de A||\r\n");
		}
		if(n == 'B')
		{
			uart0_putstr("\r\n ||Salida de B||\r\n");
		} 
		break;


	}
	//writeGpio(8);
	//uart0_putchar(n);
	//sleep(1000);
	//uart0_putchar(s);
	//sleep(1000);
	return;
}







