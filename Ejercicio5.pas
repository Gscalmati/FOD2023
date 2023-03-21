program Pract1Ejercicio5;

type

	celular = record
		codCel: integer;
		precio: real;
		stockMin: integer;
		stockDisp: integer;
		nom: string;
		marca: string;
		desc: string;
	end;

	archivo = file of celular;

// PROCESOS IMPORTAR ARCHIVO

procedure importarArchivo ();
var
	arch: archivo;
	txt: Text;
	nombre: string;
	cel: celular;
begin
	writeln('Inserte nombre del archivo a crear');
	readln(nombre);
	
	assign(arch, nombre + '.dat');
	assign (txt, 'celulares.txt');
	
	reset(txt);
	rewrite(arch);
	
	while not eof(txt) do begin
		readln(txt, cel.codCel, cel.precio, cel.stockMin, cel.stockDisp, cel.nom);
		readln(txt, cel.marca);
		readln(txt, cel.desc);
		write(arch, cel);
	end;
	
	close(arch);
	close(txt);
end;

// PROCESOS LISTAR

procedure listarBajoStock();
begin
	writeln('Bajo stock');
end;

procedure listarDescripcionCustom();
begin
	writeln('Bajo stock');
end;

// PROCESO EXPORTAR

procedure exportarArchivo();
begin
	writeln('Exportar archivo');
end;

// PROCESOS MENU GENERAL

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


// PROGRAMA PRINCIPAL


var
	opcion: integer;
begin
{
	repeat
		writeln('Lector de Celulares 3000');
		writeln('Ingrese la opcion deseada');
		writeln('1- Importar archivo de TXT a DAT');
		writeln('2- Listar celulares con poco stock');
		writeln('3- Listar celulares con descripcion personalizada');
		writeln('4- Exportar archivo de DAT a TXT');
		gestionarOpcion(opcion);
	until opcion = 0;
}
	importarArchivo();

end.
