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
