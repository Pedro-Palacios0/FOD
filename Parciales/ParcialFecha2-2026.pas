const valorAlto = 99999;
type
  vuelo = record
    aerolinea: string[20];
    ciudad_origen: string[15];
    ciudad_destino: string[15];
    fecha_y_hora_salida: string[16];  // 'YYYY-MM-DD HH:MM' = 16 caracteres
    numero: integer;
    asientos_disponibles: integer;
    estado: string[10];               // 'programado'/'demorado'/'cancelado'
  end;
  archivoVuelos = file of vuelo;

procedure existeVuelo(numero: integer; var archivo: archivoVuelos; var pos: integer);
var
    reg : vuelo;
begin
    pos := -1;
    seek(archivo, 1);
    leer(archivo, reg);
    while( reg.numero < numero)  do
    begin
        leer(archivo, reg);
    end;
    if (reg.numero = numero) then
        pos := filePos(archivo) - 1;
end;

procedure AgregarVuelo(var archivo: archivoVuelos);
var
    pos, numero, sig : integer;
    reg, cabecera, aux : vuelo;
begin
    reset(archivo);
    write('Ingrese el numero de vuelo: ');
    readln(numero);
    existeVuelo(numero, archivo, pos);
    if (pos <> - 1) then
        writeln('El vuelo ya existe.')
    else
        begin
            reg.numero := numero;
            write('Ingrese la aerolinea: ');
            readln(reg.aerolinea);
            write('Ingrese la ciudad de origen: ');
            readln(reg.ciudad_origen);
            write('Ingrese la ciudad de destino: ');
            readln(reg.ciudad_destino);
            write('Ingrese la fecha y hora de salida (YYYY-MM-DD HH:MM): ');
            readln(reg.fecha_y_hora_salida);
            write('Ingrese la cantidad de asientos disponibles: ');
            readln(reg.asientos_disponibles);
            write('Ingrese el estado del vuelo');
            readln(reg.estado);
            seek(archivo, 0);
            read(archivo, cabecera);
            sig := - cabecera.numero;
            if (sig = 0) then
                begin
                    seek(archivo, fileSize(archivo));
                    write(archivo, reg);
                end
            else
                begin
                    seek(archivo, sig);
                    read(archivo, aux);
                    cabecera.numero := aux.numero;
                    seek(archivo, 0);
                    write(archivo, cabecera);
                    seek(archivo, sig);
                    write(archivo, reg);
                end;
        end;
    close(archivo);
end;


procedure QuitarVuelo(var archivo: archivoVuelos);
var
    pos, numero, sig : integer;
    reg, cabecera, aux : vuelo;
begin
    reset(archivo);
    write('Ingrese el numero de vuelo: ');
    readln(numero);
    existeVuelo(numero, archivo, pos);
    if (pos = -1) then
        writeln('El vuelo a eliminar no existe.')
    else
        begin
            seek(archivo, pos);
            read(archivo, reg);
            if (reg.estado <> 'cancelado') then
                writeln('El vuelo no esta cancelado.')
            else
                begin
                    seek(archivo, 0);
                    read(archivo, cabecera);
                    seek(archivo, pos);
                    reg.numero := cabecera.numero;
                    write(archivo, reg);
                    cabecera.numero := - pos;
                    seek(archivo, 0);
                    write(archivo, cabecera);
                end;
        end;
    close(archivo);
end;

procedure leer(var archivo: archivoVuelos; var dato: vuelo);
begin
    if(not(EOF(archivo))) then
        read(archivo, dato)
    else dato.numero := valorAlto;
end;

var
    archivos: archivoVuelos;
    cabecera: vuelo;
    reg: vuelo;
begin
    assign(archivos, 'maestro');
end.