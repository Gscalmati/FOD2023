program Pract1Ejercicio3;

type

	empleado = record
		num: integer;
		ap: string;
		nom: string;
		edad: integer;
		dni: longint;
		end;

	archivo = file of empleado;

procedure crearArchivo();
var
	arch: archivo;
	emp: empleado;
	nom: string;
begin
	writeln('Ingrese nombre del archivo a crear');
	readln(nom);
	
	assign(arch, Concat(nom, '.dat'));
	rewrite(arch);
	
	
	writeln('Ingrese apellido del empleado');
	readln(emp.ap);
	while (emp.ap <> 'fin') do begin	
		writeln('Ingrese nombre del empleado');
		readln(emp.nom);
		writeln('Ingrese DNI del empleado');
		readln(emp.dni);
		writeln('Ingrese numero del empleado');
		readln(emp.num);
		writeln('Ingrese edad del empleado');
		readln(emp.edad);
		write(arch, emp);
		//
		writeln('Ingrese apellido del empleado');
		readln(emp.ap);
	end;

	close(arch);
end;

procedure imprimirEmpleado(emp: empleado);
begin
		writeln('----------------------------');
		write('Nombre: ');
		writeln(emp.nom);
		write('Apellido: ');
		writeln(emp.ap);
		write('DNI: ');
		writeln(emp.dni);
		write('Numero: ');
		writeln(emp.num);
		write('Edad: ');
		writeln(emp.edad);
		writeln('----------------------------');
end;

procedure imprimirEmpleadoLinea(emp: empleado);
begin
		writeln('----------------------------');
		writeln(emp.nom, ' ', emp.ap, ' - DNI: ', emp.dni, ' - Numero: ', emp.num, ' - Edad: ', emp.edad);
		writeln('----------------------------');
end;

procedure definirParametros (var parametro: integer; var valor: string);
begin
	writeln('Desea buscar por: 1-Nombre / 2-Apellido');
	readln(parametro);
	writeln('Inserte el valor a buscar');
	readln(valor);
	writeln();

end;

procedure verificarParametros (var parametro: integer; var valor: string; var emp: empleado);
begin
	if (parametro = 1) then
		if (emp.nom = valor) then
			imprimirEmpleadoLinea(emp);
	if (parametro = 2) then
		if (emp.ap = valor) then
			imprimirEmpleadoLinea(emp);

end;

procedure listarConParametro(nombre: string);
var
	arch: archivo;
	emp: empleado;
	valor: string;
	parametro: integer;
begin
	Assign(arch, Concat(nombre, '.dat'));
	reset(arch);
	
	definirParametros(parametro, valor);
	while not eof(arch) do begin
		read(arch, emp);
		verificarParametros(parametro, valor, emp);
	end;
	
	close(arch);
end;

procedure listarCompleta(nombre: string);
var
	arch: archivo;
	emp: empleado;
begin
	Assign(arch, Concat(nombre, '.dat'));
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, emp);
		imprimirEmpleadoLinea(emp);
	end;
	
	close(arch);
end;

procedure listarMayoresDe70(nombre: string);
var
	arch: archivo;
	emp: empleado;
begin
	Assign(arch, Concat(nombre, '.dat'));
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, emp);
		if (emp.edad >= 70) then
			imprimirEmpleado(emp);
	end;
	
	close(arch);
end;

procedure gestionarOpcionListar (var opcion: integer; var nombre: string);
begin

	if (opcion = 1) then
		listarConParametro(nombre);
	if (opcion = 2) then
		listarCompleta(nombre);
	if (opcion = 3) then
		listarMayoresDe70(nombre);
end;

procedure mostrarMenuListas();
begin
	writeln();
	writeln('----------------------------');
	writeln('Ingrese la opcion deseada');
	writeln('1-Listar empleados por nombre o apellido');
	writeln('2-Listar Empleados');
	writeln('3-Listar Empleados mayores de 70');
	writeln('----------------------------');
	writeln();
end;

procedure listarArchivo();
var
	opcion: integer;
	nombre: string;
begin
	writeln('Listador de Empleados');
	writeln('Ingrese nombre del archivo a listar');
	readln(nombre);
	
	
	repeat
		mostrarMenuListas();
		readln(opcion);
		gestionarOpcionListar(opcion, nombre);
	until opcion = 0;
	
	
end;

procedure gestionarOpcion (var opcion: integer);
begin

	if (opcion = 1) then
		crearArchivo();
	if (opcion = 2) then
		listarArchivo();
end;

procedure mostrarMenuGeneral();
begin
	writeln();
	writeln('----------------------------');
	writeln('Ingrese la opcion deseada');
	writeln('1-Crear archivo de Empleados');
	writeln('2-Listar Empleados');
	writeln('----------------------------');
	writeln();
end;

	
	
var
	opcion: integer;
begin
	writeln('Gestor de empleados - v1.0');
	repeat
		mostrarMenuGeneral();
		readln(opcion);
		gestionarOpcion(opcion);
	until opcion = 0;

end.
