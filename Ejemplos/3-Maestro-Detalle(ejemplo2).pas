type
 producto = record
cod: string[4];
 descripcion: string[30];
 pu: real;
 stock: integer;
end;
venta_prod = record
cod: string[4];
cant_vendida: integer;
end;
detalle = file of venta_prod;
maestro = file of producto;
var
mae: maestro;
det: detalle;
regm: producto;
regd: venta_prod;
cod_actual: string[4];
tot_vendido: integer;
begin {Inicio del programa}
 assign(mae, 'maestro');
 assign(det, 'detalle');
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
{Se totaliza la cantidad vendida del detalle}
cod_actual := regd.cod;
tot_vendido := 0;
while (regd.cod = cod_actual) do begin
tot_vendido:=tot_vendido+regd.cant_vendida; read(det, regd);
end;
{Se actualiza el stock del producto con la
cantidad vendida del mismo}
regm.stock := regm.stock - tot_vendido;
{se reubica el puntero en el maestro}
seek(mae, filepos(mae)-1);
{se actualiza el maestro}
 write(mae, regm);
end;
close(det);
close(mae);
end.
