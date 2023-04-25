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
	assign(txt, 'archivoChatGPT.txt');
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
		writeln('Cliente ' , regAux.cli.cod);
		while (regAux.cli.cod = reg.cli.cod) do begin
			//montoCliente := montoCliente + reg.monto;
			regAux.anio:= reg.anio;
			montoAnual:= 0;
			writeln('----Anio ' , regAux.anio);
			while ((regAux.cli.cod = reg.cli.cod) and (regAux.anio = reg.anio)) do begin
				montoMensual:=0;
				regAux.mes:= reg.mes;
				while ((regAux.cli.cod = reg.cli.cod) and (regAux.anio = reg.anio) and (regAux.mes = reg.mes)) do begin
					montoMensual:= montoMensual + reg.monto;
					leer(arch,reg);
				end;
				writeln('--------Monto Mensual en ', regAux.mes, ' $', montoMensual:2:0);
				montoAnual:= montoAnual + montoMensual;
			end;
			writeln('----Monto anual en ', regAux.anio, ' $', montoAnual:2:0);
			montoCliente:= montoCliente + montoAnual;
		end;
		writeln('Monto total del cliente ', regAux.cli.cod, ' $', montoCliente:2:0);
		writeln();
		montoTotal:= montoTotal + montoCliente;
	end;
	writeln();
	writeln('El Monto Total vendido por la empresa a la fecha es: ', montoTotal:0:2);
	close(arch);
 end;



var
	arch: archivo;

begin
	assign(arch, 'archivoMaestro.dat');
	importarMaestro(arch);
	listarMaestro(arch);
	
	realizarInforme(arch);
	
end.
