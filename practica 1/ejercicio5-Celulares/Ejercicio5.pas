program Pract1Ejercicio5;

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
		readln(txt, cel.cod, cel.precio, cel.marca);
		readln(txt, cel.stockDisp, cel.stockMin, cel.desc);
		readln(txt, cel.nom);
		
		write(arch, cel);
	end;	
	
	close(arch);
	close(txt);
end;

// LISTAR 

procedure imprimirCelular(cel: celular);
begin
	writeln('Codigo ', cel.cod, ' - Precio ', cel.precio:0:2, ' - Stock Minimo ', cel.stockMin, ' - Stock Disponible ', cel.stockDisp);
	writeln('Marca ', cel.marca, ' - Nombre ', cel.nom, ' - Descripcion ', cel.desc);
end;

function nombreDeArchivo (): string;
var
	nombre:string;
begin
	writeln('Ingrese nombre del archivo');
	readln(nombre);
	nombreDeArchivo:= nombre;
end;

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

procedure listarArchivoBajoStock (nombre: string);
var
	arch: archivo;
	cel: celular;
begin
	assign(arch, nombre + '.dat');
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, cel);
		if (cel.stockDisp < cel.stockMin) then
			writeln(cel.cod, cel.precio:0:2, cel.stockMin, cel.stockDisp, cel.nom, cel.desc, cel.marca);
	end;
	
	close(arch);
end;

procedure listarDescripcionCustom (nombre: string);
var
	arch: archivo;
	cel: celular;
	descripcion: string;
	flag: integer;
begin
	writeln('Elija una descripcion para realizar la busqueda de la informacion');
	readln(descripcion);
	
	assign(arch, nombre + '.dat');
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, cel);
		flag:= pos(descripcion, cel.desc);
		if (flag <> 0) then
			writeln(cel.cod, cel.precio:0:0, cel.stockMin, cel.stockDisp, cel.nom, cel.desc, cel.marca);
	end;
	
	close(arch);
end;


// EXPORTAR ARCHIVO

procedure exportarArchivo(nombre: string);
var
	cel: celular;
	arch: archivo;
	txt: Text;
begin
	//writeln('Ingrese nombre del archivo a crear');
	//readln(nombre);
	
	assign(arch, nombre + '.dat');
	assign(txt, 'celularesExport.txt');
	
	rewrite(txt);
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, cel);
		writeln(txt, cel.cod, ' ', cel.precio:0:2, cel.marca);
		writeln(txt, cel.stockDisp, ' ', cel.stockMin, ' ',cel.desc);
		writeln(txt, cel.nom);
	end;	
	
	close(arch);
	close(txt);
end;

//------------- PROGRAMA GENERAL ---------------//

procedure gestionarOpcion (var opcion: integer);
var
	nombre:string;
begin

	if (opcion = 1) then
		importarArchivo();
	if (opcion = 2) then begin
		writeln('LISTAR CELULARES BAJOS DE STOCK');
		nombre:= nombreDeArchivo();
		listarArchivoBajoStock(nombre);
		end;
	if (opcion = 3) then begin
		writeln('LISTAR CELULARES POR DESCRIPCION');
		nombre:= nombreDeArchivo();
		listarDescripcionCustom(nombre);
		end;
	if (opcion = 4) then begin
		writeln('EXPORTAR ARCHIVO');
		nombre:= nombreDeArchivo();
		exportarArchivo(nombre);
		end;
end;

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
	
	repeat
		mostrarMenuGeneral();
		readln(opcion);
		gestionarOpcion(opcion);
	until opcion = 0;
	

end.
