program Pract1Ejercicio6;

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
		//writeln(cel.cod, cel.precio:0:2, cel.stockMin, cel.stockDisp, cel.nom, cel.desc, cel.marca);
		imprimirCelular(cel);
		writeln('---------------------------------------------------');
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

// AGREGAR AL ARCHIVO

function verificarCod (nombre: string; cod: integer): boolean;
var
	arch: archivo;
	flag: boolean;
	celAct: celular;
begin
	assign(arch, nombre + '.dat');
	reset(arch);
	flag:= True;
	
	
	while (not eof(arch) and flag) do begin
		read(arch, celAct);
		if (celAct.cod = cod) then
			flag:= False;
	end;
	
	close(arch);
	verificarCod:= flag;
end;

procedure ingresarCelular (var cel:celular; nombre:string);
var
	codValido: boolean;
begin
	writeln('Ingrese la informacion del nuevo celular');
	with (cel) do begin
	write('Ingrese marca ');
	readln(marca);
	write('Ingrese nombre del modelo ');
	readln(nom);
	write('Ingrese codigo del modelo ');
	readln(cod);
	codValido := verificarCod(nombre, cod);
	while not codValido do begin
		write('Codigo ya utlizado, ingrese otro ');
		readln(cod);
		codValido := verificarCod(nombre, cod);
	end;
	write('Ingrese percio ');
	readln(precio);
	write('Ingrese Stock MINIMO ');
	readln(stockMin);
	write('Ingrese Stock DISPONIBLE ');
	readln(stockDisp);
	write('Ingrese descripcion del modelo ');
	readln(desc);
	end;
end;

procedure agregarCelular(nombre: string);
var
	arch: archivo;
	cel: celular;
begin
	assign(arch, nombre + '.dat');
	
	ingresarCelular(cel, nombre);
	
	reset(arch);
	seek(arch, filesize(arch));
	
	write(arch, cel);
	
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
	assign(txt, 'celulares.txt');
	
	rewrite(txt);
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, cel);
		writeln(txt, cel.cod, ' ', cel.precio:0:2, ' ', cel.marca);
		writeln(txt, cel.stockDisp, ' ', cel.stockMin,' ', cel.desc);
		writeln(txt, cel.nom);
	end;	
	
	close(arch);
	close(txt);
end;

procedure exportarSinStock (nombre: string);
var
	arch: archivo;
	txt: Text;
	cel: celular;
begin
	assign(arch, nombre + '.dat');
	assign(txt, 'SinStock.txt');
	
	reset(arch);
	rewrite(txt);
	
	while not eof(arch) do begin
		read(arch, cel);
		if (cel.stockDisp = 0) then
			writeln(txt, cel.cod, ' ', cel.nom, ' ', cel.marca);
	end;
	
	close(arch);
	close(txt);
end;

// MODIFICAR EL ARCHIVO

function buscarCelular(nombreArch:string; var cel:celular; nombreCel:string): integer;
var
	arch:archivo;
	flag: boolean;
	celPos: integer;
begin
	assign(arch, nombreArch + '.dat');
	reset(arch);
	
	celPos:= -1;
	flag:= False;
	
	while not eof(arch) and not flag do begin
		read(arch, cel);
		if (cel.nom = nombreCel) then begin
			celPos:= filepos(arch)-1;
			flag:= True;
		end;
	end;
	close(arch);
	buscarCelular:= celPos;
end;

procedure modificarStockArticulo(nombre: string);
var
	arch: archivo;
	cel: celular;
	nombreCel:string;
	posCel, nuevoStock: integer;
begin
	assign(arch, nombre + '.dat');
	
	// BUSCAR CELULAR COMPLETO O REFERENCIAR LA POS
	writeln('Ingrese nombre del modelo a buscar');
	readln(nombreCel);
	posCel:= buscarCelular(nombre, cel, nombreCel);
	
	while (posCel = -1) do begin
		writeln('Nombre inexistente, ingrese otro');
		readln(nombreCel);
		posCel:= buscarCelular(nombre, cel, nombreCel);
	end;
	
	reset(arch);
	seek(arch, posCel);
	
	writeln('Stock actual ', cel.stockDisp);
	write('Ingrese nuevo stock '); 
	readln(nuevoStock);
	cel.stockDisp:= nuevoStock;
	
	write(arch, cel);
	
	close(arch);
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
	if (opcion = 5) then begin
		writeln('ANIADIR ARTICULO');
		nombre:= nombreDeArchivo();
		agregarCelular(nombre);
		end;
	if (opcion = 6) then begin
		writeln('MODIFICAR STOCK ARTICULO');
		nombre:= nombreDeArchivo();
		modificarStockArticulo(nombre);
		end;
	if (opcion = 7) then begin
		writeln('EXPORTAR SIN STOCK');
		nombre:= nombreDeArchivo();
		exportarSinStock(nombre);
		end;
	if (opcion = 8) then begin
		writeln('LISTAR TODO');
		writeln();
		nombre:= nombreDeArchivo();
		writeln();
		listarArchivoCompleto(nombre);
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
	writeln('5-Aniadir celulares a la BDD');
	writeln('6-Modificar Stock de Articulo');
	writeln('7-Exportar sin Stock a TXT');
	writeln('8-Listar todos los articulos');
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
