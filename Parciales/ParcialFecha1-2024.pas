const valorAlto = 9999;
type
    prestamos = record
        numero_sucursal: integer;
        DNI_empleado: integer;
        numero_prestamo: integer;
        fecha_prestamo: string[10];
        monto_prestamo: real;
    end;

    archivoPrestamos = file of prestamos;

procedure Leer(var archivo: archivoPrestamos; var dato: prestamos);
begin
    if (not(EOF(archivo))) then
        read(archivo, dato)
    else
        dato.numero_sucursal := valorAlto;
end;

procedure Informe(var archivo: archivoPrestamos; var salida: text);
var
    reg: prestamos;
    sucursal_actual, DNI_empleado, año_actual: integer;
    cantVentasAño, cantVentasEmpleado, cantVentasSucursal, cantVentasEmpresa: integer;
    montoVentasAño, montoVentasEmpleado, montoVentasSucursal, montoVentasEmpresa: real;
begin
    Leer(archivo, reg);
    montoVentasEmpresa := 0;
    cantVentasEmpresa := 0;

    while (reg.numero_sucursal <> valorAlto) do
    begin
        sucursal_actual := reg.numero_sucursal;
        writeln(salida, 'Sucursal ', sucursal_actual);
        montoVentasSucursal := 0;
        cantVentasSucursal := 0;

        while (reg.numero_sucursal = sucursal_actual) do
        begin
            DNI_empleado := reg.DNI_empleado;
            writeln(salida, 'Empleado: DNI ', DNI_empleado);
            montoVentasEmpleado := 0;
            cantVentasEmpleado := 0;

            while (reg.numero_sucursal = sucursal_actual) and
                  (reg.DNI_empleado = DNI_empleado) do
            begin
                año_actual := extraerAño(reg.fecha_prestamo);
                montoVentasAño := 0;
                cantVentasAño := 0;

                while (reg.numero_sucursal = sucursal_actual) and
                      (reg.DNI_empleado = DNI_empleado) and
                      (extraerAño(reg.fecha_prestamo) = año_actual) do
                begin
                    montoVentasAño := montoVentasAño + reg.monto_prestamo;
                    cantVentasAño := cantVentasAño + 1;
                    Leer(archivo, reg);
                end;

                writeln(salida, año_actual, ' ', cantVentasAño, ' ', montoVentasAño);
                montoVentasEmpleado := montoVentasEmpleado + montoVentasAño;
                cantVentasEmpleado := cantVentasEmpleado + cantVentasAño;
            end;

            writeln(salida, 'Totales ', cantVentasEmpleado, ' ', montoVentasEmpleado);
            montoVentasSucursal := montoVentasSucursal + montoVentasEmpleado;
            cantVentasSucursal := cantVentasSucursal + cantVentasEmpleado;
        end;

        writeln(salida, 'Cantidad total de ventas sucursal: ', cantVentasSucursal);
        writeln(salida, 'Monto total vendido por sucursal: ', montoVentasSucursal);
        montoVentasEmpresa := montoVentasEmpresa + montoVentasSucursal;
        cantVentasEmpresa := cantVentasEmpresa + cantVentasSucursal;
    end;

    writeln(salida, 'Cantidad de ventas de la empresa: ', cantVentasEmpresa);
    writeln(salida, 'Monto total vendido por la empresa: ', montoVentasEmpresa);
end;

var
    archivoP: archivoPrestamos;
    archivoT: text;
begin
    assign(archivoP, 'archivoPrestamos');
    assign(archivoT, 'Informe');
    reset(archivoP);
    rewrite(archivoT);
    Informe(archivoP, archivoT);
    close(archivoP);
    close(archivoT);
end.