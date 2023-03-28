program Pract1Ejercicio7;

type

	novela = record
		cod: integer;
		genero: string;
		nom: string;
		precio: real;
	end;

	archivo = file of novela;
	
// MENU PRINCIPAL

procedure mostrarMenu();
begin
	writeln('Menu principal');
	writeln('1- Crear archivo de Novelas');
	writeln('2- Agregar Novela');
	writeln('3- Modificar Novela Existente');
end;

procedure gestionarOpcion(opcion: integer);
var
	nombreArch: string;
	
begin
	if (opcion = 1) then begin
		//nombreArch:= definirNombre();
		//crearArchivo(nombreArch);
	end;
	if (opcion = 2) then begin
		//nombreArch:= definirNombre();
		//modificarArchivo(nombreArch);
	end;
end;

var
	opcion: integer;
begin
	
	repeat
		mostrarMenu();
		readln(opcion);
		gestionarOpcion(opcion);
	until opcion = 0;
end.
