program creacion_archivo;
type
persona = record
dni: string[8];
apellidoyNombre: string[30];
direccion: string[40];
sexo : char;
salario : real;
end;
archivo_personas = file of persona;
var
personas: archivo_personas;
nombre_fisico: string[12];
per: persona;
begin
write('Ingrese el nombre del archivo: ');
readln(nombre_fisico);
{enlace entre el nombre lógico y el nombre
 físico}
assign(personas, nombre_fisico);
{apertura del archivo para creación}
 rewrite(personas);
{lectura del DNI una persona}
 write('Ingrese el dni de la persona: ');
readln(per.dni);
while (per.dni <> '') do begin
{lectura del resto de los datos de la persona}
write('Ingrese el apellido y nombre de la persona: ');
readln(per.apellidoyNombre);
write('Ingrese la dirección de la persona: ');
readln(per.direccion);
write('Ingrese el sexo de la persona: ');
readln(per.sexo);
write('Ingrese el salario de la persona: ');
readln(per.salario);
{escritura del registro de la persona en el archivo}
write(personas, per);
{lectura del DNI de una nueva persona}
 write('Ingrese otro dni o blanco para terminar: ');
readln(per.dni);
end;
{cierre del archivo}
 close(personas);
end.
