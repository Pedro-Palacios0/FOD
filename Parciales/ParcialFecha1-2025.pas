const valorAlto = 9999;
type
    presentacion = record
        cod_artista : integer;
        nom_artista : string [20];
        año : integer;
        cod_evento : integer;
        nom_evento : string [20];
        likes : integer;
        dislikes : integer;
        puntaje : real;
        end;
    
    archivoEventos = file of presentacion;

procedure leer(var archivo : archivoEventos; var dato : presentacion);
begin
    if(not(EOF(archivo)))  then
        read(archivo, dato)
    else
        dato.año := valorAlto;
end;

procedure ActualizarMenosInfluyente(
  codArtista: integer; nombreArtista: string;
  puntajeTotal : real; dislikesTotal: integer;
  var codMenosInfluyente: integer; var nombreMenosInfluyente: string;
  var menorPuntaje : real; var dislikesDelMenor: integer);
begin
    if (puntajeTotal < menorPuntaje) or
        ((puntajeTotal = menorPuntaje) and (dislikesTotal > dislikesDelMenor)) then
    begin
        codMenosInfluyente := codArtista;
        nombreMenosInfluyente := nombreArtista;
        menorPuntaje := puntajeTotal;
        dislikesDelMenor := dislikesTotal;
    end;
end;

procedure Informe_Pantalla(var archivo : archivoEventos);
var
    codArtista_menosInfluyente : integer;
    nomArtista_menosInfluyente : string;
    nro_presentaciones, cant_años, año, totalPresentaciones : integer;
    promedio_presentaciones : real;
    nombre_evento, nombre_artista : string;
    codigo_evento, codigo_artista : integer;
    likesTotales, dislikesTotales, dislikesDelMenor : integer;
    puntajeTotal, menorPuntaje : real;
    reg : presentacion;
begin
    leer(archivo, reg);
    cant_años := 0;
    totalPresentaciones := 0;
    writeln('Resumen de menor influencia por evento');
    while(reg.año <> valorAlto) do 
    begin
        año := reg.año;
        nro_presentaciones := 0;
        writeln('Año: ', año);
        while(año = reg.año) do 
        begin
            nombre_evento := reg.nom_evento;
            codigo_evento := reg.cod_evento;
            menorPuntaje := 9999;
            dislikesDelMenor := -1;
            writeln('Evento: ', nombre_evento, ' (Codigo: ', codigo_evento, ')');
            while(año = reg.año) and (codigo_evento = reg.cod_evento) do 
            begin
                codigo_artista := reg.cod_artista;
                nombre_artista := reg.nom_artista;
                writeln('Artista: ', nombre_artista, ' (Codigo: ', codigo_artista, ')');
                likesTotales := 0;
                dislikesTotales := 0;
                puntajeTotal := 0;
                while(año = reg.año) and (codigo_evento = reg.cod_evento)
                and (codigo_artista = reg.cod_artista) do
                begin
                    likesTotales := likesTotales + reg.likes;
                    dislikesTotales := dislikesTotales + reg.dislikes;
                    puntajeTotal := puntajeTotal + reg.puntaje;
                    nro_presentaciones := nro_presentaciones + 1;
                    leer(archivo, reg);
                end;
                ActualizarMenosInfluyente(codigo_artista, nombre_artista, puntajeTotal,
                dislikesTotales, codArtista_menosInfluyente, nomArtista_menosInfluyente, menorPuntaje, dislikesDelMenor);
                writeln('Likes totales: ', likesTotales);
                writeln('Dislikes totales: ', dislikesTotales);
                writeln('Diferencia: ', likesTotales - dislikesTotales);
                writeln('Puntaje total del jugarado: ', puntajeTotal);
            end;
            writeln('El artista ', nomArtista_menosInfluyente, ' fue el menos influyente de ', nombre_evento, ' del año ', año);
        end;
        cant_años := cant_años + 1;
        totalPresentaciones := totalPresentaciones + nro_presentaciones;
        writeln('Durante el año ', año, ' se registraron ', nro_presentaciones, ' de presentaciones de artistas');
    end;
    promedio_presentaciones := totalPresentaciones / cant_años;
    writeln('El promedio total de presentaciones por año es de: ', promedio_presentaciones, ' presentaciones');
end;

var
    archivo : archivoEventos;
begin
    assign(archivo, 'eventos');
    reset(archivo);
    Informe_Pantalla(archivo);
    close(archivo);
end.