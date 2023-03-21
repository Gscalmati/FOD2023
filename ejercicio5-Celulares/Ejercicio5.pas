program Pract1Ejercicio4;

type

	celular = record
		cod: integer;
		nom: string;
		desc: string;
		marca: string;
		precio: real;
		stockMin: integer;
		stockDisp: integer;
		end;

	archivo = file of celular;

// IMPORTAR ARCHIVO

procedure importarArchivo();
var
	cel: celular;
	arch: archivo;
	txt: Text;
	nombre: string;
begin
	writeln('Ingrese nombre del archivo a crear');
	readln(nombre);
	
	assign(arch, nombre + '.dat');
	assign(txt, 'celulares.txt');
	
	reset(txt);
	rewrite(arch);
	
	while not eof(txt) do begin
		readln(txt, cel.cod, cel.precio, cel.stockMin, cel.stockDisp, cel.nom);
		readln(txt, cel.marca);
		readln(txt, cel.desc);
		
		write(arch, cel);
	end;	
	
	close(arch);
	close(txt);
end;
// LISTAR 

procedure listarArchivoCompleto (nombre: string);
var
	arch: archivo;
	cel: celular;
begin
	assign(arch, nombre + '.dat');
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, cel);
		writeln(cel.cod, cel.precio:0:2, cel.stockMin, cel.stockDisp, cel.nom, cel.desc, cel.marca);
	end;
	
	close(arch);
end;


// EXPORTAR ARCHIVO

//------------- PROGRAMA GENERAL ---------------//
{
procedure gestionarOpcion (var opcion: integer);
begin

	if (opcion = 1) then
		importarArchivo();
	if (opcion = 2) then
		listarBajoStock();
	if (opcion = 3) then
		listarDescripcionCustom();
	if (opcion = 4) then
		exportarArchivo();
end;
}
procedure mostrarMenuGeneral();
begin
	writeln();
	writeln('----------------------------');
	writeln('Ingrese la opcion deseada');
	writeln('1-Importar archivo TXT a DAT');
	writeln('2-Listar Celulares con Bajo Stock');
	writeln('3-Listar Celulares con descripción personalizada');
	writeln('4-Exportar archivo DAT a TXT');
	writeln('0-Salir');
	writeln('----------------------------');
	writeln();
end;

	
	
var
	opcion: integer;
begin

	writeln('Gestor de celulares - v1.0');
	{
	repeat
		mostrarMenuGeneral();
		readln(opcion);
		gestionarOpcion(opcion);
	until opcion = 0;
	}
	importarArchivo();
	listarArchivoCompleto('celularesDat');
end.
