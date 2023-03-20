program Pract1Ejercicio4;

type

	empleado = record
		num: integer;
		ap: string;
		nom: string;
		edad: integer;
		dni: string;
		end;

	archivo = file of empleado;


//------------- PROCEDURES ARCHIVO ---------------//

function definirNombre(): string;
var
	nombre: string;
begin
	writeln('Ingrese nombre del archivo para trabajar');
	readln(nombre);
	definirNombre := nombre;
end;

procedure crearArchivo();
var
	arch: archivo;
	emp: empleado;
	nombre: string;
begin
	writeln('Ingrese nombre del archivo a crear');
	readln(nombre);
	
	assign(arch, Concat(nombre, '.dat'));
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
		//
		write(arch, emp);
		//
		writeln('Ingrese apellido del empleado');
		readln(emp.ap);
	end;

	close(arch);
end;

//------------- IMPRIMIR EMPLEADOS ---------------//

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

//------------- DEFINIR PARAMETROS ---------------//

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
	if (parametro = 1) and (emp.nom = valor) then
			imprimirEmpleadoLinea(emp);
	if (parametro = 2) and (emp.ap = valor) then
			imprimirEmpleadoLinea(emp);

end;

//------------- FORMAS DE LISTAR ---------------//

procedure listarConParametro(nombre: string);
var
	arch: archivo;
	emp: empleado;
	valor: string;
	parametro: integer;
begin
	assign(arch, Concat(nombre, '.dat'));
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
	assign(arch, Concat(nombre, '.dat'));
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
	assign(arch, Concat(nombre, '.dat'));
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, emp);
		if (emp.edad >= 70) then
			imprimirEmpleado(emp);
	end;
	
	close(arch);
end;

//------------- LISTAR EMPLEADOS ---------------//

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
	writeln('0-Volver al menu anterior');
	writeln('----------------------------');
	writeln();
end;

procedure listarArchivo();
var
	opcion: integer;
	nombre: string;
begin
	writeln('Listador de Empleados');
	nombre:= definirNombre();
	
	
	repeat
		mostrarMenuListas();
		readln(opcion);
		gestionarOpcionListar(opcion, nombre);
	until opcion = 0;
	
	
end;



//---------------- PROCESOS GESTIONAR -------------//

function verificarNumero(var arch:archivo; numero:integer): boolean;
var
	flag:boolean;
	emp: empleado;
begin
	flag:= true;
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, emp);
		if (emp.num = numero) then
			flag:= false;
	end;

	verificarNumero:= flag;
end;


function registrarEmpleado(var arch: archivo): empleado;
var
	emp: empleado;
	flag: boolean;
begin
	writeln('Ingrese apellido del empleado');
	readln(emp.ap);
	writeln('Ingrese nombre del empleado');
	readln(emp.nom);
	writeln('Ingrese DNI del empleado');
	readln(emp.dni);
	writeln('Ingrese edad del empleado');
	readln(emp.edad);
	
	writeln('Ingrese numero del empleado');
	readln(emp.num);
	
	flag:= verificarNumero(arch, emp.num);
	while not (flag) do begin
		writeln('Ingrese otro numero de empleado, el anterior esta ocupado');
		readln(emp.num);
		flag:= verificarNumero(arch, emp.num);
	end;
	registrarEmpleado:= emp;
	
end;


procedure agregarEmpleado (nombre:string);
var
	arch: archivo;
	emp: empleado;
begin
	assign(arch, Concat(nombre, '.dat'));
	
	emp:= registrarEmpleado(arch);
	
	write(arch,emp);
	
	close(arch);
end;

procedure modificarEdadEmpleado (nombre:string);
begin
	writeln('Modificar edad');
end;

procedure exportarEmpleados (nombre:string);
begin
	writeln('Exportar empleado');
end;

procedure exportarEmpleadosSinDNI (nombre:string);
begin
	writeln('Exportar empleado sin DNI');
end;

//------------- GESTIONAR EMPLEADOS ---------------//

procedure controlarOpcionGestionar (var opcion: integer; var nombre: string);
begin

	if (opcion = 1) then
		agregarEmpleado(nombre);
	if (opcion = 2) then
		modificarEdadEmpleado(nombre);
	if (opcion = 3) then
		exportarEmpleados(nombre);
	if (opcion = 4) then
		exportarEmpleadosSinDNI(nombre);	
end;

procedure mostrarMenuGestion();
begin
	writeln();
	writeln('----------------------------');
	writeln('Ingrese la opcion deseada');
	writeln('1-Agregar empleado a la lista');
	writeln('2-Modificar edad de empleado');
	writeln('3-Exportar empleados en TXT');
	writeln('4-Exportar empleados "00" en TXT');
	writeln('0-Volver al menu anterior');
	writeln('----------------------------');
	writeln();
end;

procedure gestionarArchivo();
var
	opcion: integer;
	nombre: string;
begin
	writeln('Gestor de Empleados');
	nombre:= definirNombre();
	
	repeat
		mostrarMenuGestion();
		readln(opcion);
		controlarOpcionGestionar(opcion, nombre);
	until opcion = 0;
	
	
end;

procedure gestionarOpcion (var opcion: integer);
begin

	if (opcion = 1) then
		crearArchivo();
	if (opcion = 2) then
		listarArchivo();
	if (opcion = 3) then
		gestionarArchivo();
end;

//------------- PROGRAMA GENERAL ---------------//

procedure mostrarMenuGeneral();
begin
	writeln();
	writeln('----------------------------');
	writeln('Ingrese la opcion deseada');
	writeln('1-Crear archivo de Empleados');
	writeln('2-Listar Empleados');
	writeln('3-Gestionar Empleados');
	writeln('0-Salir');
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
