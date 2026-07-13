const valorAlto = 99999;
type
    aplicacion = record
        codigo: integer;
        nombre: string[20];
        origen: string[15];
        precio_licencia: integer;
        licencias_disponibles: integer;
        licencias_minimas_stock: integer;
    end;

    ventas = record
        codigo: integer;
        cant_vendidas: integer;
    end;

    archivoMaestro = file of aplicacion;
    archivoDetalle = file of ventas;

    vector_Detalle = array [1..20] of archivoDetalle;
    vector_Registro = array [1..20] of ventas;

procedure leer(var archivo: archivoDetalle; var dato: ventas);
begin
    if (not(EOF(archivo))) then
        read(archivo,dato)
    else
        dato.codigo := valorAlto;
end;

procedure leerMaestro(var maestro: archivoMaestro; var dato:aplicacion);
begin
    if (not(EOF(maestro))) then
        read(maestro, dato)
    else
        dato.codigo := valorAlto;
end;

procedure buscarMinimo(regDetalle: vector_Registro; var minimo: integer);
var
    i: integer;
begin
    minimo := regDetalle[1].codigo;
    for i := 2 to 20 do
    begin
        if regDetalle[i].codigo < minimo then
            minimo := regDetalle[i].codigo;
    end;
end;

procedure actualizarDetalle(var maestro: archivoMaestro; var detalle: vector_Detalle; var salida: text);
var
    regDetalle: vector_Registro;
    regMaestro: aplicacion;
    i, minimo, totalVendidas: integer;
    montoTotal: real;
begin
    for i := 1 to 20 do
        leer(detalle[i], regDetalle[i]);

    leerMaestro(maestro, regMaestro);

    buscarMinimo(regDetalle, minimo);
    while (minimo <> valorAlto) do
    begin
        while (regMaestro.codigo < minimo) do
            leerMaestro(maestro, regMaestro);

        totalVendidas := 0;
        for i := 1 to 20 do
        begin
            if regDetalle[i].codigo = minimo then
            begin
                totalVendidas := totalVendidas + regDetalle[i].cant_vendidas;
                leer(detalle[i], regDetalle[i]);
            end;
        end;

        regMaestro.licencias_disponibles := regMaestro.licencias_disponibles - totalVendidas;
        montoTotal := totalVendidas * regMaestro.precio_licencia;

        seek(maestro, FilePos(maestro) - 1);
        write(maestro, regMaestro);

        if montoTotal > 10000 then
            writeln(salida, regMaestro.codigo, ' ', regMaestro.nombre, ' ', regMaestro.origen, ' ', montoTotal:0:2);

        buscarMinimo(regDetalle, minimo);
    end;
end;

var
    maestro: archivoMaestro;
    regVentas: aplicacion;
    detalle: vector_Detalle;
    regDetalle: vector_Registro;
    archivoSalida: text;
    i : integer;
begin
    for i:= 1 to 20 do
    begin
        assign(detalle[i], 'detalle' + IntToStr(i));
        reset(detalle[i]);
    end;
    assign(maestro, 'maestro');
    reset(maestro);
    assign(archivoSalida, 'salida.txt');
    rewrite(archivoSalida);
    actualizarDetalle(maestro, detalle, archivoSalida);
    close(maestro);
    for i := 1 to 20 do
        close(detalle[i]);
    close(archivoSalida);
end.