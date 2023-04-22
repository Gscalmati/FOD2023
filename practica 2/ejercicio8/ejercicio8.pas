program Practica2Ejercicio8;

const

	valor_alto = 9999;
	
type
	cliente = record
		cod: integer;
		nombreCompleto: string[40];
	end;
	
	registroMaestro = record
		cli: cliente;
		anio: integer;
		mes: 1..12;
		dia: 1..31;
		monto: real;
	end;
	
	archivo = file of registroMaestro;
	
// IMPORTAR ARCHIVOS

procedure importarMaestro(var arch: archivo);
var
	reg: registroMaestro;
	txt: Text;
begin
	assign(txt, 'archivoMaestro.txt');
	reset(txt);
	rewrite(arch);
	
	while not eof(txt) do begin
		readln(txt, reg.cli.cod, reg.cli.nombreCompleto);
		readln(txt, reg.anio, reg.mes, reg.dia, reg.monto);
		write(arch, reg);
	end;
	close(txt);
	close(arch);
end;

// LISTAR ARCHIVOS

procedure imprimirRegistro (reg: registroMaestro);
begin
	writeln('Cliente - Cod. ', reg.cli.cod, ' - ', reg.cli.nombreCompleto);
	writeln('Operacion ', reg.anio, '/', reg.mes, '/', reg.dia, ' $', reg.monto:0:2);
	writeln('--------------');
end;

procedure listarMaestro (var arch: archivo);
var
	reg: registroMaestro;
begin
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, reg);
		imprimirRegistro(reg);
	end;
	close(arch);
end;

// CORTE DE CONTROL

procedure leer (var arch: archivo; var reg: registroMaestro);
begin
	if not eof(arch) then
		read(arch, reg)
	else
		reg.cli.cod:= valor_alto;
end;

procedure realizarInforme (var arch: archivo);
var
	reg, regAux: registroMaestro;
	montoTotal, montoCliente, montoAnual, montoMensual: real;
begin
	reset(arch);
	montoTotal:= 0;
	leer(arch, reg);
	while (reg.cli.cod <> valor_alto) do begin
		regAux:= reg;
		montoCliente:= 0;
		while (regAux.cli.cod = reg.cli.cod) do begin
			montoCliente := montoCliente + reg.monto;
			writeln('Mismo Cliente');
			leer(arch,reg);
		end;
		writeln(regAux.cli.cod, ': ', montoCliente:0:2);
		montoTotal:= montoTotal + montoCliente
	end;
		writeln('Monto Total: ', montoTotal:0:2);
 end;

var
	arch: archivo;

begin
	assign(arch, 'archivoMaestro.dat');
	importarMaestro(arch);
	listarMaestro(arch);
	
	realizarInforme(arch);
	
end.
