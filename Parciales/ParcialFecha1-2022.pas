const valorAlto = 'ZZZ';
type
    ventas = record
        libreria : string;
        generoliterario : string;
        nombredellibro : string;
        precio : real;
        cantvendida : integer;
    end;

    archivoventas = file of ventas;

procedure leer(var archivo : archivoventas; var dato : ventas);
begin
    if(not(EOF(archivo))) then
        read(archivo,dato)
    else 
        dato.libreria := valorAlto;
end;

procedure Informe(var archivo : archivoventas; var salida : text);
var
    reg : ventas;
    libreria, genero, libro : string;
    montolibreria, montogenero, totallibro, montototal : real;
begin
    montototal := 0;
    leer(archivo,reg);
    while(reg.libreria <> valorAlto) do 
    begin
        libreria := reg.libreria;
        montolibreria := 0;
        writeln(salida, 'Libreria: ', libreria);
        while(libreria = reg.libreria) do 
        begin
            genero := reg.generoliterario;
            montogenero := 0;
            writeln(salida, 'Genero: ', genero);
            while(libreria = reg.libreria) and (genero = reg.generoliterario) do 
            begin
                libro := reg.nombredellibro;
                totallibro := 0;
                writeln(salida, 'Nombre de libro: ', libro);
                while(libreria = reg.libreria) and (genero = reg.generoliterario) and (libro = reg.nombredellibro) do
                begin
                    totallibro := totallibro + (reg.cantvendida * reg.precio);
                    leer(archivo,reg);
                end;
                writeln(salida, 'Total vendido libro ', libro, ' ', totallibro);
                montogenero := montogenero + totallibro;
            end;
            writeln(salida, 'Monto vendido genero ', genero, ' ', montogenero);
            montolibreria := montolibreria + montogenero;
        end;
        writeln(salida, 'Monto vendido libreria ', libreria, ' ', montolibreria);
        montototal := montototal + montolibreria;
    end;
    writeln(salida, 'Monto total librerias ', montototal);
end;

var 
    archivo : archivoventas;
    texto : text;
begin
    assign(archivo, 'ventas');
    assign(texto, 'texto');
    rewrite(texto);
    reset(archivo);
    Informe(archivo,texto);
    close(archivo);
    close(texto);
end.