program Practica2Ejercicio5;

uses sysutils;

const 
	distritos = 3;
	valor_alto = 9999;
	string_valor_nulo = 'ZZZ';
	
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
		nombre: string[40];
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
// 			NACIMIENTOS
procedure leerNac (var archivoN: archivoNacimiento; var reg: registroNacimiento);
begin
	if not eof(archivoN) then
		read(archivoN, reg)
	else
		reg.nro := valor_alto;
end;

procedure minimoNac(var arrayN: arrayNac; var arrayReg: arrayRegistrosNac; var reg: registroNacimiento);
var
	i,j: integer;
	regAux: registroNacimiento;
begin
	regAux.nro:= valor_alto;
	j:= 1;
	for i:= 1 to distritos do begin
		//writeln('Aux ', regAux.nro, ' - ArrayReg[',i,'] ', arrayReg[i].nro);
		if (arrayReg[i].nro < regAux.nro) then begin
			j:= i;
			regAux:= arrayReg[i];
		end;
	end;
	//writeln('Indice menor ', j);
	leerNac(arrayN[j], arrayReg[j]);
	//writeln('Agregaria ', regAux.nro);
	reg:= regAux;
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
	writeln(registroMin.nro);
	while (registroMin.nro <> valor_alto) do begin
		write(archivoNuevo, registroMin);
		minimoNac(arrayN, arrayReg, registroMin);
		writeln('Afuera del min ', registroMin.nro);
	end;
	close(archivoNuevo);
	for i:= 1 to distritos do
		close(arrayN[i]);
end;

// 			FALLECIMIENTOS
procedure leerFall (var archivoF: archivoFallecimiento; var reg: registroFallecimiento);
begin
	if not eof(archivoF) then
		read(archivoF, reg)
	else
		reg.nro := valor_alto;
end;

procedure minimoFall(var arrayF: arrayFall; var arrayReg: arrayRegistrosFall; var reg: registroFallecimiento);
var
	i,j: integer;
	regAux: registroFallecimiento;
begin
	regAux.nro:= valor_alto;
	j:= 1;
	for i:= 1 to distritos do begin
		//writeln('Aux ', regAux.nro, ' - ArrayReg[',i,'] ', arrayReg[i].nro);
		if (arrayReg[i].nro < regAux.nro) then begin
			j:= i;
			regAux:= arrayReg[i];
		end;
	end;
	//writeln('Indice menor ', j);
	leerFall(arrayF[j], arrayReg[j]);
	//writeln('Agregaria ', regAux.nro);
	reg:= regAux;
end;

procedure mergeProcedureFallecimiento (var arrayF: arrayFall; var archivoNuevo: archivoFallecimiento);
var
	registroMin: registroFallecimiento;
	arrayReg: arrayRegistrosFall;
	i: integer;
begin
	rewrite(archivoNuevo);
	for i:= 1 to distritos do begin
		reset(arrayF[i]);
		leerFall(arrayF[i], arrayReg[i]);
	end;
	minimoFall(arrayF, arrayReg, registroMin);
	//writeln(registroMin.nro);
	while (registroMin.nro <> valor_alto) do begin
		write(archivoNuevo, registroMin);
		minimoFall(arrayF, arrayReg, registroMin);
		//writeln('Afuera del min ', registroMin.nro);
	end;
	close(archivoNuevo);
	for i:= 1 to distritos do
		close(arrayF[i]);
end;

// CREAR/ACTUALIZAR ARCHIVO MAESTRO
procedure escribirMaestro (var txt: Text; var reg: registroMaestro);
begin
	writeln(txt, 'Numero ', reg.nro, ' - Nombre Completo ', reg.nombre);
	writeln(txt, 'Matricula del Dr. - Nacimiento ' , reg.matricula);
	writeln(txt, 'Datos Madre: ', reg.madre.dni, ' - ', reg.madre.nombreCompleto);
	writeln(txt, 'Datos Madre: ', reg.padre.dni, ' - ', reg.padre.nombreCompleto);
	writeln(txt, 'Matricula del Dr. - Fallecimiento ' , reg.matriculaFallecimiento);
	writeln(txt, 'Fecha ' , reg.fecha);
	writeln(txt, 'Fecha ' , reg.hora);
	writeln(txt, 'Fecha ' , reg.lugar);
	writeln(txt, '-------------------');
end;

procedure crearArchivoMaestro (var maestro: archivoMaestro; var archivoN: archivoNacimiento; var archivoF: archivoFallecimiento);
var
	regNac: registroNacimiento;
	regFall: registroFallecimiento;
	regM: registroMaestro;
	txt: Text;
begin
	assign(txt, 'archivoMaestroTxt.txt');
	rewrite(txt);
	
	reset(archivoN);
	reset(archivoF);
	
	leerNac(archivoN, regNac);
	leerFall(archivoF, regFall);
	while ((regNac.nro <> valor_alto) or (regFall.nro <> valor_alto)) do begin
		if (regNac.nro = regFall.nro) then begin
			with regM do begin
				nro:= regNac.nro;
				nombre:= regNac.nombreCompleto;
				matricula:= regNac.matricula;
				madre:= regNac.madre;
				padre:= regNac.padre;
				matriculaFallecimiento:= regFall.matricula;
				fecha:= regFall.fecha;
				hora:= regFall.hora;
				lugar:= regFall.lugar;
			end;
			leerNac(archivoN, regNac);
			leerFall(archivoF, regFall);
		end
		else if (regNac.nro < regFall.nro) then begin
			with regM do begin
				nro:= regNac.nro;
				nombre:= regNac.nombreCompleto;
				matricula:= regNac.matricula;
				madre:= regNac.madre;
				padre:= regNac.padre;
				matriculaFallecimiento:= -1;
				fecha:= string_valor_nulo;
				hora:= string_valor_nulo;
				lugar:= string_valor_nulo;
			end;
			leerNac(archivoN, regNac);
		end
		else if(regNac.nro > regFall.nro) then begin
			with regM do begin
				nro:= regFall.nro;
				nombre:= regFall.persona.nombreCompleto;
				matricula:= -1;;
				madre.dni:= valor_alto;
				madre.nombreCompleto:= string_valor_nulo;
				padre.dni:= valor_alto;
				padre.nombreCompleto:= string_valor_nulo;
				matriculaFallecimiento:= regFall.matricula;
				fecha:= regFall.fecha;
				hora:= regFall.hora;
				lugar:= regFall.lugar;
			end;
			leerFall(archivoF, regFall);
		end;
		escribirMaestro(txt, regM);
	end;
	
	close(txt);
	
	close(archivoN);
	close(archivoF);
end;

var 
	arrayN: arrayNac;
	arrayF: arrayFall;
	mergeNacimiento: archivoNacimiento;
	mergeFallecimiento: archivoFallecimiento;
	archivoM: archivoMaestro;
	i: integer;
begin
	assign(archivoM, 'archivoMaestro.dat');
	assign(mergeNacimiento, 'mergeNacimiento.dat');
	assign(mergeFallecimiento, 'mergeFallecimiento.dat');
	
	for i:=1 to distritos do begin
		assign(arrayN[i], 'archivoNacimiento'+IntToStr(i)+'.dat');
		importarNacimiento(arrayN[i], i);
		
		//writeln('----------NACIMIENTOS ' + IntToStr(i) +'----------');
		//listarNacimiento(arrayN[i]);
		//writeln('----------FIN NACIMIENTOS '+ IntToStr(i) +'----------');
		 
		assign(arrayF[i], 'archivoFallecimiento'+IntToStr(i)+'.dat');
		importarFallecimiento(arrayF[i], i);
		
		//writeln('----------FALLECIMIENTOS ' + IntToStr(i) +'----------');
		//listarFallecimiento(arrayF[i]);
		//writeln('----------FIN FALLECIMIENTOS '+ IntToStr(i) +'----------');
	end;
	
	
	mergeProcedureNacimiento(arrayN, mergeNacimiento);
	
	writeln();
	writeln();
	writeln('----------MERGE NACIMIENTOS----------');
	listarNacimiento(mergeNacimiento);
	
	
	mergeProcedureFallecimiento(arrayF, mergeFallecimiento);
	writeln();
	writeln();
	writeln('----------MERGE FALLECIMIENTOS----------');
	listarFallecimiento(mergeFallecimiento);
	
	writeln('----------CREAR MAESTRO----------');
	crearArchivoMaestro(archivoM, mergeNacimiento, mergeFallecimiento);

end.
