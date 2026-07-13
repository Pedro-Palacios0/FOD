const valorAlto = 9999;
type
    equipo = record
        codigo : integer;
        nombre : string;
        jugados : integer;
        ganados : integer;
        empatados : integer;
        perdidos : integer;
        puntos : integer;
    end;

    partidos = record
        codigo : integer;
        fecha : integer;
        puntos : integer;
        codigoRival : integer;
    end;

    archivoEquipos = file of equipo;
    archivoDetalle = file of partidos;

    vectorPartidos = array [1..12] of archivoDetalle;
    vectorRegistros = array [1..12] of partidos;

procedure leerMaestro(var archivo : archivoEquipos; var dato : equipo);
begin
    if(not(EOF(archivo))) then
        read(archivo,dato)
    else 
        dato.codigo := valorAlto
end;

procedure leerDetalle(var archivo : archivoDetalle; var dato : partidos);
begin
    if(not(EOF(archivo))) then
        read(archivo,dato)
    else 
        dato.codigo := valorAlto
end;

procedure buscarMinimo(regDetalle: vectorRegistros; var minimo: integer);
var
    i: integer;
begin
    minimo := regDetalle[1].codigo;
    for i := 2 to 12 do
    begin
        if regDetalle[i].codigo < minimo then
            minimo := regDetalle[i].codigo;
    end;
end;

procedure actualizarMaestro(var maestro : archivoEquipos; var archivo : vectorPartidos);
var 
    regM : equipo;
    regD : vectorRegistros;
    i, minimo, puntosCampeon : integer;
    equipoCampeon : string;
begin
    puntosCampeon := 0;
    for i := 1 to 12 do
        leerDetalle(archivo[i],regD[i]);

    leerMaestro(maestro,regM);
    buscarMinimo(regD, minimo);
    while(minimo <> valorAlto) do 
    begin
        while(regM.codigo < Minimo) do 
            leerMaestro(maestro,regM);
        for i := 1 to 12 do
        begin
            if regD[i].codigo = minimo then
            begin
                regM.jugados := regM.jugados + 1;
                regM.puntos := regM.puntos + regD[i].puntos;
                if (regD[i].puntos = 3) then
                    regM.ganados := regM.ganados + 1
                else if (regD[i].puntos = 1) then
                    regM.empatados := regM.empatados + 1
                else
                    regM.perdidos := regM.perdidos + 1;
                leerDetalle(archivo[i], regD[i]);
            end;
        end;

        seek(maestro, filePos(maestro) - 1);
        write(maestro, regM);

        if (regM.puntos > puntosCampeon) then
        begin
            puntosCampeon := regM.puntos;
            equipoCampeon := regM.nombre;
        end;
        buscarMinimo(regD, minimo);
    end;
    writeln('El campeon fue ', equipoCampeon, ' con ', puntosCampeon, ' puntos');
end;

var
    maestro: archivoEquipos;
    regM: equipo;
    detalle: vectorPartidos;
    regDetalle: vectorRegistros;
    i : integer;
    detalleArc, maestroArc : string;
begin
    for i:= 1 to 12 do
    begin
        writeln('Escriba el nombre de los archivos detalle: ');
        readln(detalleArc)
        assign(detalle[i], detalleArc);
        reset(detalle[i]);
    end;
    writeln('Escriba el nombre del archivo maestro: ');
    readln(maestroArc)    
    assign(maestro, maestroArc);
    reset(maestro);
    actualizarMaestro(maestro, detalle);
    close(maestro);
    for i := 1 to 12 do
        close(detalle[i]);
end.