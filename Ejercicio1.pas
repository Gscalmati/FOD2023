program Pract1Ejercicio1;

type
	archivo = file of integer;
	
var
	arch: archivo;
	int: integer;
	nombre: string;
begin


writeln('Ingrese nombre del archivo a cargar');
readln(nombre);

Assign(arch, nombre + '.dat');

Rewrite(arch);

writeln('Ingrese numero');
readln(int);

while (int <> 30000) do begin
	write(arch, int);
	writeln('Ingrese numero');
	readln(int);
	end;

close(arch);
end.
