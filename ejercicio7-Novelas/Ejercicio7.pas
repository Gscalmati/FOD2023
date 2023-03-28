program Pract1Ejercicio7;

type

	novela = record
		cod: integer;
		genero: string;
		nom: string;
		precio: real;
	end;

	archivo = file of novela;
	
// LISTAR

procedure imprimirNovela(nov: novela);
begin
	writeln('------------');
	writeln('Titulo ', nov.nom, ' - Codigo ', nov.cod); 
	writeln('Precio ', nov.precio:2:0, ' - Codigo ', nov.genero); 
	writeln('------------');
end;

procedure listarCompleto (var arch: archivo);
var
	nov: novela;
begin
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, nov);
		imprimirNovela(nov);
	end;
	
	close(arch);
end;

// CREAR ARCHIVO

procedure crearArchivo (var arch: archivo);
var
	txt: Text;
	nov: novela;
begin
	assign (txt, 'novelas.txt');
	
	rewrite(arch);
	reset(txt);
	
	while not eof(txt) do begin
		readln(txt, nov.cod, nov.precio, nov.genero);
		readln(txt, nov.nom);
		write(arch, nov);
	end;
	
	close(txt);
	close(arch);
end;

// AGREGAR NOVELA

function verificarCodLibre(var arch:archivo; cod: integer): boolean;
var
	codLibre: boolean;
	nov: novela;
begin
	reset(arch);
	codLibre:= True;
	while not eof(arch) and codLibre do begin
		read(arch, nov);
		if (nov.cod = cod) then
			codLibre:= False
	end;
	
	close(arch);
	verificarCodLibre:= codLibre;
end;

procedure ingresarNovela (var nov: novela; var arch: archivo);
var
	flag: boolean;
begin
	writeln('Ingrese la informacion de la nueva novela');
	with nov do begin
		write('Nombre: '); readln(nom);
		write('Genero: '); readln(genero);
		write('Precio: '); readln(precio);
		write('Codigo: '); readln(cod);
	
	
		flag:= verificarCodLibre(arch, nov.cod);
		while not flag do begin
			write('Codigo ya en uso, ingrese otro codigo para la novela: ');
			readln(nov.cod);
			flag:= verificarCodLibre(arch, nov.cod);
		end;
	end; 
	
end;

procedure agregarNovela (var arch: archivo);
var
	nov: novela;
begin
	ingresarNovela(nov, arch);
	
	reset (arch);
	seek(arch, filesize(arch));
	write(arch, nov);
end;

// MODIFICAR NOVELA

function buscarNovela (var arch: archivo; var nov: novela; cod: integer): integer;
var
	novelaEncontrada: boolean;
	posNovela: integer;
begin
	reset(arch);
	novelaEncontrada:= False;
	posNovela:= -1;
	
	while not eof(arch) and not novelaEncontrada do begin
		read(arch, nov);
		if (nov.cod = cod) then begin
			novelaEncontrada:= True;
			posNovela:= filepos(arch)-1;
		end;
	end;
	
	close(arch);
	buscarNovela:= posNovela;
end;

procedure modificarInfoNovela(var nov: novela);
var
	opc: integer;
begin
	writeln('Ingrese campo a modificar de la novela: ');
	writeln('1 - Nombre');
	writeln('2 - Genero');
	writeln('3 - Precio');
	readln(opc);
	
	if (opc = 1) then begin
		writeln('Ingrese el nuevo nombre');
		readln(nov.nom);
	end;
	if (opc = 2) then begin
		writeln('Ingrese el nuevo genero');
		readln(nov.genero);
	end;
	if (opc = 3) then begin
		writeln('Ingrese el nuevo precio');
		readln(nov.precio);
	end;
end;

procedure modificarNovela(var arch: archivo);
var
	nov:novela;
	cod, posNov: integer;
	
begin
	write('Ingrese el codigo de la novela a modificar: ');
	readln(cod);
	
	posNov:= buscarNovela(arch, nov, cod);
	while (posNov = -1) do begin
		write('Novela inexistente, ingrese otro codigo: ');
	    readln(cod);
	    posNov:= buscarNovela(arch, nov, cod);
	end;
	
	imprimirNovela(nov);
	modificarInfoNovela(nov);
	
	
	reset(arch);
	seek(arch, posNov);
	write(arch, nov);
	
	close(arch);
end;

// EXPORTAR ARCHIVO

procedure exportarArchivo(var arch: archivo);
var
	nov: novela;
	txt: Text;
begin
	assign(txt, 'novelasExport.txt');
	
	rewrite(txt);
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, nov);
		writeln(txt, nov.cod, ' ', nov.precio:0:0, nov.genero);
		writeln(txt, nov.nom);
	end;	
	
	close(arch);
	close(txt);
end;


// MENU PRINCIPAL

function definirNombre(): string;
var
	nom:string;
begin
	write('Ingrese nombre del archivo ');
	readln(nom);
	definirNombre:= nom;
end;

procedure mostrarMenu();
begin
	writeln('Menu principal');
	writeln('1- Crear archivo de Novelas');
	writeln('2- Agregar Novela');
	writeln('3- Modificar Novela Existente');
	writeln('4- Listar archivo DAT de novelas');
	writeln('5- Exportar archivo TXT de novelas');
end;

procedure gestionarOpcion(opcion: integer; var arch: archivo);
begin
	if (opcion = 1) then begin
		crearArchivo(arch);
		writeln('----------------------');
		writeln();
	end;
	if (opcion = 2) then begin
		agregarNovela(arch);
		writeln('----------------------');
		writeln();
	end;
	if (opcion = 3) then begin
		modificarNovela(arch);
		writeln('----------------------');
		writeln();
	end;
	if (opcion = 4) then begin
		listarCompleto(arch);
		writeln('----------------------');
		writeln();
	end;
	if (opcion = 5) then begin
		exportarArchivo(arch);
		writeln('----------------------');
		writeln();
	end;
end;

var
	opcion: integer;
	nombre: string;
	arch: archivo;
begin
	nombre:= definirNombre();
	assign(arch, nombre + '.dat');
	
	repeat
		mostrarMenu();
		readln(opcion);
		gestionarOpcion(opcion, arch);
	until opcion = 0;
end.
