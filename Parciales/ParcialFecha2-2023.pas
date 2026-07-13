const valorAlto = 9999;
type
    equipo = record
        cod_equipo : integer;
        nom_equipo : string;
        año : integer;
        cod_torneo : integer;
        cod_equipoRival : integer;
        goles_aFavor : integer;
        goles_enContra : integer;
        puntosObtenidos : integer;
    end;

    archivoTorneo = file of equipo;

procedure leer(var archivo : archivoTorneo; var dato : equipo);
begin
    if(not(EOF(archivo))) then
        read(archivo,dato)
    else
        dato.cod_equipo := 9999;
end;

procedure Informe(var archivo : archivoTorneo);
var
    reg : equipo;
    año, cod_torneo, cod_equipo, totalgoles, totalencontra, cantganados, cantperdidos, cantempates, puntostotal :integer;
    nom_equipo, equipocampeon : string;
    equipo_mayorpuntaje : integer;
begin
    leer(archivo,reg);
    writeln('Informe resumen por equipo del futbol Argentino');
    while(reg.cod_equipo <> valorAlto) do 
    begin
        año := reg.año;
        writeln('Año ', año);
        while(año = reg.año) do 
        begin
            cod_torneo := reg.cod_torneo;
            equipo_mayorpuntaje := -1;
            writeln('cod_torneo ', cod_torneo);
            while(año = reg.año) and (cod_torneo = reg.cod_torneo) do 
            begin
                cod_equipo := reg.cod_equipo;
                nom_equipo := reg.nom_equipo;
                writeln('cod_equipo ', reg.cod_equipo, ' nombre equipo ', nom_equipo);
                totalgoles := 0;
                totalencontra := 0;
                cantganados := 0;
                cantperdidos := 0;
                cantempates := 0;
                puntostotal := 0;
                while(año = reg.año) and (cod_torneo = reg.cod_torneo) and (cod_equipo = reg.cod_equipo) do
                begin
                    totalgoles := totalgoles + reg.goles_aFavor;
                    totalencontra := totalencontra + reg.goles_enContra;
                    if (reg.puntosObtenidos = 3) then
                        cantganados := cantganados + 1
                    else if (reg.puntosObtenidos = 1) then
                        cantempates := cantempates + 1
                    else
                        cantperdidos := cantperdidos + 1;
                    puntostotal := puntostotal + reg.puntosObtenidos;
                    leer(archivo,reg);
                end;
                writeln('cantidad total de goles a favor: ', totalgoles);
                writeln('cantidad total de goles en contra: ', totalencontra);
                writeln('diferencia de gol: ', totalgoles - totalencontra);
                writeln('cantidad total de partidos ganados: ', cantganados);
                writeln('cantidad total de partidos empatados: ', cantempates);
                writeln('cantidad total de partidos perdidos: ', cantperdidos);
                writeln('cantidad total de puntos: ', puntostotal);
                if (puntostotal > equipo_mayorpuntaje) then
                begin
                    equipo_mayorpuntaje := puntostotal;
                    equipocampeon := nom_equipo;
                end;
            end;
            writeln('el equipo ', equipocampeon, ' fue campeon del torneo ', cod_torneo, ' del año ', año);
        end;
    end;
end;

var
    archivo : archivoTorneo;
begin
    assign(archivo, 'torneos');
    reset(archivo);
    Informe(archivo);
    close(archivo);
end.