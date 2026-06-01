{Precondiciones:
• Existe un archivo maestro.
• Existe un único archivo detalle que modifica al
maestro.
• Cada registro del detalle modifica a un solo registro
del maestro que seguro existe.
•No todos los registros del maestro son
necesariamente modificados.
• Cada elemento del maestro que se modifica, es
alterado por un solo un elemento del archivo
detalle.
•Ambos archivos están ordenados por igual criterio.}

type
 producto = record
cod: string[4];
 descripcion: string[30];
 pu: real; {precio unitario}
 stock: integer;
end;
venta_prod = record
cod: string[4];
cant_vendida: integer;
end;
maestro = file of producto;
detalle = file of venta_prod;
var
 mae: maestro;
 det: detalle;
regm: producto;
 regd: venta_prod;

begin { Inicio del programa }
 assign(mae, 'maestro.dat');
 assign(det, 'detalle.dat');
 reset(mae);
 reset(det);
{Loop archivo detalle}
while not(EOF(det)) do begin
read(mae, regm); // Lectura archivo maestro
 read(det, regd); // Lectura archivo detalle

{Se busca en el maestro el producto del
detalle}
 while (regm.cod <> regd.cod) do
 read(mae, regm);
{Se modifica el stock del producto con la
cantidad vendida de ese producto}
regm.stock := regm.stock-regd.cant_vendida;
{Se reubica el puntero en el maestro}
 seek(mae, filepos(mae)-1);
{Se actualiza el maestro}
 write(mae, regm);
end; // Fin while archivo detalle
close(det);
close(mae);
end.
