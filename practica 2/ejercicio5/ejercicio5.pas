program Practica2Ejercicio5;

uses sysutils;

const 
	distritos = 3;
	valor_alto = 9999;
	
type

	persona = record
		nombreCompleto: string[40];
		dni: integer;
	end;
	
	registroNacimiento = record
		nro: integer;
		nombreCompleto: string[40];
		direccion: string[40];
		matricula: integer;
		madre: persona;
		padre: persona;
	end;
	
	archivoNacimiento = file of registroNacimiento;
	
	registroFallecimiento = record
		nro: integer;
		persona: persona;
		matricula: integer;
		fecha: string;
		hora: string;
		lugar: string;
	end;
	
	archivoFallecimiento = file of registroFallecimiento;
	
	registroMaestro = record
		nro: integer;
		nombre: string;
		apellido: string;
		direccion: string[40];
		matricula: integer;
		madre: persona;
		padre: persona;
		matriculaFallecimiento: integer;
		fecha: string;
		hora: string;
		lugar: string;
	end;
	
	archivoMaestro = file of registroMaestro;
	
	arrayNac = array [1..distritos] of archivoNacimiento;
	arrayRegistrosNac = array [1..distritos] of registroNacimiento;
	
	arrayFall = array [1..distritos] of archivoFallecimiento;
	arrayRegistrosFall = array [1..distritos] of registroFallecimiento;

// IMPORTAR ARCHIVOS

procedure importarNacimiento(var archN: archivoNacimiento; i: integer);
var
	reg: registroNacimiento;
	txt: Text;
begin
	assign(txt, 'archivoNacimiento'+IntToStr(i)+'.txt');
	reset(txt);
	rewrite(archN);
	
	while not eof(txt) do begin
		readln(txt, reg.nro, reg.nombreCompleto);
		readln(txt, reg.matricula, reg.direccion);
		readln(txt, reg.madre.dni, reg.madre.nombreCompleto);
		readln(txt, reg.padre.dni, reg.padre.nombreCompleto);
		write(archN, reg);
	end;
	close(txt);
	close(archN);
end;

procedure importarFallecimiento(var archF: archivoFallecimiento; i: integer);
var
	reg: registroFallecimiento;
	txt: Text;
begin
	assign(txt, 'archivoFallecimiento'+IntToStr(i)+'.txt');
	reset(txt);
	rewrite(archF);
	
	while not eof(txt) do begin
		readln(txt, reg.nro, reg.persona.dni, reg.persona.nombreCompleto);
		readln(txt, reg.matricula, reg.fecha);
		readln(txt, reg.hora);
		readln(txt, reg.lugar);
		write(archF, reg);
	end;
	close(txt);
	close(archF);
end;

// LISTAR ARCHIVOS


procedure imprimirNacimiento(reg: registroNacimiento);
begin
	writeln(reg.nro, ' ', reg.nombreCompleto);
 	writeln(reg.direccion);
 	writeln('Matricula del Dr. ', reg.matricula);
	writeln('Datos Madre ', reg.madre.dni, ' ', reg.madre.nombreCompleto);
	writeln('Datos Padre ', reg.padre.dni, ' ', reg.padre.nombreCompleto);
	writeln('-------------------------------------------------------');
end;

procedure imprimirFallecimiento(reg: registroFallecimiento);
begin
	writeln(reg.nro, ' ', reg.persona.dni, ' ' ,reg.persona.nombreCompleto);
	writeln('Matricula del Dr. ', reg.matricula);
	writeln('Datos Deceso ', reg.fecha, ' - Hora  ', reg.hora, ' - Lugar ', reg.lugar);
	writeln('-------------------------------------------------------');
end;

procedure listarFallecimiento(var archF: archivoFallecimiento);
var
	reg: registroFallecimiento;
begin
	reset(archF);
	
	while not eof(archF) do begin
		read(archF, reg);
		imprimirFallecimiento(reg);
	end;
	close(archF);
end;

procedure listarNacimiento(var archN: archivoNacimiento);
var
	reg: registroNacimiento;
begin
	reset(archN);
	while not eof(archN) do begin
		read(archN, reg);
		imprimirNacimiento(reg);
	end;
	close(archN);
end;

// MERGE ARCHIVOS
procedure leerNac (var archivoN: archivoNacimiento; var reg: registroNacimiento);
begin
	if not eof(archivoN) then
		read(archivoN, reg)
	else
		reg.nro := valor_alto;
end;

procedure minimoNac(var arrayN: arrayNac; var arrayReg: arrayRegistrosNac; var reg: registroNacimiento);
begin

end;

procedure mergeProcedureNacimiento (var arrayN: arrayNac; var archivoNuevo: archivoNacimiento);
var
	registroMin: registroNacimiento;
	arrayReg: arrayRegistrosNac;
	i: integer;
begin
	rewrite(archivoNuevo);
	for i:= 1 to distritos do begin
		reset(arrayN[i]);
		leerNac(arrayN[i], arrayReg[i]);
	end;
	minimoNac(arrayN, arrayReg, registroMin);
	while (registroMin.nro <> valor_alto) do begin
		write(archivoNuevo, registroMin);
		minimoNac(arrayN, arrayReg, registroMin);
	end;
	
	close(archivoNuevo);
	for i:= 1 to distritos do
		close(arrayN[i]);
end;


var 
	arrayN: arrayNac;
	arrayF: arrayFall;
	mergeNacimiento: archivoNacimiento;
//	mergeFallecimiento: archivoFallecimiento;
	archivoM: archivoMaestro;
	i: integer;
begin
	assign(archivoM, 'archivoMaestro.dat');
	for i:=1 to distritos do begin
		assign(arrayN[i], 'archivoNacimiento'+IntToStr(i)+'.dat');
		importarNacimiento(arrayN[i], i);
		
		writeln('----------NACIMIENTOS ' + IntToStr(i) +'----------');
		listarNacimiento(arrayN[i]);
		writeln('----------FIN NACIMIENTOS '+ IntToStr(i) +'----------');
		
		assign(arrayF[i], 'archivoFallecimiento'+IntToStr(i)+'.dat');
		importarFallecimiento(arrayF[i], i);
		
		writeln('----------FALLECIMIENTOS ' + IntToStr(i) +'----------');
		listarFallecimiento(arrayF[i]);
		writeln('----------FIN FALLECIMIENTOS '+ IntToStr(i) +'----------');
	end;
	mergeProcedureNacimiento(arrayN, mergeNacimiento);

end.
