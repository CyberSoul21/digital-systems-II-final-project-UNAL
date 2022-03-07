//---------------------------------------------------------------------------
//
// Wishbone proyecto
//
//  Description de registro:
//  %Miren que esto debe estar previamente definido en el periférico
//  Trigger  0x00 
//  echoMedida  0x04 
//  LedPrueba  0x08 
//
//---------------------------------------------------------------------------

module wb_ultrasonido (
   input              clk,
   input              reset,
   // Wishbone interface
   //Tipico de cada Wishbone
   input              wb_stb_i,
   input              wb_cyc_i,
   output             wb_ack_o,
   input              wb_we_i,
   input       [31:0] wb_adr_i,  //Este indica la dirección
   input        [3:0] wb_sel_i,  
   input       [31:0] wb_dat_i,  //Este porta los datos de entrada al modulo vienen del lm32 ()
   output reg  [31:0] wb_dat_o,  //Este porta los datos de salida al modulo hacia el lm32 ()


//  echo, triger,motor, contador

output reg triger,
output reg LedPrueba,
input echoMedida
);

//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
 
reg  ack; //Viene con el Wishbone
//Constante para la cuál se prefiere dejar de contar, ya que seria distancia muy grande
parameter superior=135000;
reg trigflag=0; //Bandera para saber si esta mandando el triger
reg   [31:0] count=0; //Contador que almacenará los ciclos que dura el echo
reg   ocupado=0;      //Variable que indicará si esta ocupado 
reg   escribio=1;     //Variable que indicará si se puede reiniciar el contador


assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

wire wb_rd = wb_stb_i & wb_cyc_i & ~wb_we_i;
wire wb_wr = wb_stb_i & wb_cyc_i &  wb_we_i;


always @(posedge clk)


begin
 
 // reset para algunas variables
 if (reset) begin
 wb_dat_o <=0;
 ack <= 0;
 triger<=0;
 count<=0;
 end  

 else begin

ack <= 0;
// bandera que queda prendida cuando el triger se enciende

        if(triger==1)
        begin 
        trigflag<=1;
        end
        

// si echo es 1 empieza a contar
  
       if(echoMedida)
        begin 
        count<=count+1;
       end
     

     // si empezó a contar el echo, entonces se pone ocupado =1
     // trigflag=0 porque ya esta contando
     //escribio=0 porque no ha terminado de contar
       if(count==1)
       begin
       ocupado<=1;      
       escribio<=0;
       trigflag<=0;
       end
 
// para activar ciclo de lectura
// si el echo es 1, entonces deja de estar ocupado y puede tomar el dato wb_data_out       

        if(count==superior || ~echoMedida)
        begin 
        ocupado<=0;
        end
        

  
        if (wb_rd & ~ack)  // ciclo de lectura
        
        begin           
        ack <= 1;
           
          
           case (wb_adr_i[7:0])
           'h04: begin
           if (~ocupado)
           begin
           wb_dat_o<=count;
           count<=32'b0;
           escribio<=1;
           end
           end
    
           default: ack <= 0;
           endcase	
           end
          



      
        if (wb_wr & ~ack ) 
        begin // ciclo de escritura
        ack <= 1;
        case (wb_adr_i[7:0])
        'h00: triger<= wb_dat_i;
        'h08: LedPrueba<= wb_dat_i;
 
        default:
        ack<=0;
       
        endcase
        end
        end


end
endmodule
