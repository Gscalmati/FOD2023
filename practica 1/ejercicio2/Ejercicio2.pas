program Pract1Ejercicio2;

type

	archivo = file of integer;
	
var

	arch: archivo;
	int, cantNumTot, cantNumMenores: integer;
	nombre: string;
	prom: real;
	
begin
writeln('Ingrese nombre del archivo a cargar');
readln(nombre);
writeln();
Assign(arch, nombre + '.dat');

reset(arch);

cantNumTot:= 0;
cantNumMenores:= 0;
prom:= 0;
while not eof(arch) do begin
	read(arch, int);
	if (int <= 1500) then
		cantNumMenores:= cantNumMenores +1;
	cantNumTot:= cantNumTot +1;
	prom:= prom + int;
	writeln(int);
end;
prom:= prom / cantNumTot;
writeln('Cantidad de numeros menos a 1500: ', cantNumMenores);
writeln('Promedio entre los numeros ', prom:0:3);

end.
