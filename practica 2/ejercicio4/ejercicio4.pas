program Practica2Ejercicio4;

uses
  sysutils;
  
const
	valor_alto = 9999;
	
type
	
	registroMaestro = record
		cod_usuario: integer;
		fecha: string;
		tiempo_total_sesiones_abiertas: real;
	end;
	
	archivoM = file of registroMaestro;
	
	registroDetalle = record
		cod_usuario: integer;
		fecha: string;
		tiempo_sesion: real;
	end;
	
	archivoD = file of registroDetalle;
	
	arrayDetalle = array [1..5] of archivoD;
	
	arrayRegistro = array [1..5] of registroDetalle;
	
// LISTAR ARCHIVOS

procedure imprimirRegistro (r: registroMaestro);
begin
	with r do begin
	writeln('----------------------');
	writeln('Codigo Usuario ', cod_usuario);
	writeln('Fecha ', fecha); 
	writeln('Tiempo total ', tiempo_total_sesiones_abiertas:0:1); 
	end;
end;

procedure listarArchivoMaestro (var archM: archivoM);
var
	reg: registroMaestro;
begin

	reset(archM);
	
	while not eof(archM) do begin
		read(archM, reg);
		imprimirRegistro(reg);
	end;

	close(archM);
end;

procedure imprimirRegistroDetalle (reg: registroDetalle);
begin
	with reg do begin
	writeln('----------------------');
	writeln('Codigo ', cod_usuario, ' - Tiempo Sesion: ', tiempo_sesion:0:1,' - Fecha: ', fecha); 
	end;
end;

procedure listarDetalle (var archD: archivoD);
var
	reg: registroDetalle;
begin

	reset(archD);
	
	while not eof(archD) do begin
		read(archD, reg);
		imprimirRegistroDetalle(reg);
	end;

	close(archD);
end;
	
// IMPORTAR ARCHIVOS

procedure importarDetalle (var archD: archivoD; numero: integer);
var
	txt: Text;
	reg: registroDetalle;
	numString: string;
begin

	rewrite(archD);
	str(numero, numString);
	
	assign(txt, 'detalle' + numString + '.txt');
	reset(txt);
	
	while not eof(txt) do begin
		with reg do begin
			readln(txt, cod_usuario, tiempo_sesion, fecha);
		end;
		write(archD, reg);
	end;

	close(archD);
	close(txt);
end;

// EXPORTAR ARCHIVO TXT

procedure exportarMaestro (var archM: archivoM);
var
	txt: Text;
	r: registroMaestro;
begin

	reset(archM);
	assign(txt, 'var/log/archivoMaestro.txt');
	rewrite(txt);
	
	while not eof(archM) do begin
		read(archM, r);
		with r do begin
			writeln(txt, cod_usuario, ' ', tiempo_total_sesiones_abiertas:0:1, fecha);
		end;
	end;

	close(archM);
	close(txt);
end;

// MERGE DETALLES

procedure leer (var archivo: archivoD; var r: registroDetalle);
begin
	if not eof(archivo) then
		read(archivo, r)
	else
		r.cod_usuario:= valor_alto;
end;

procedure minimo (var arrayD: arrayDetalle; var arrayR: arrayRegistro; var regD: registroDetalle);
var
	i: integer;
	indice: integer;
	regAux: registroDetalle;
	regFecha, regArrayFecha: TDateTime;
begin
	indice:= 1;
	regAux.cod_usuario:= valor_alto;
	regAux.fecha:= '31/12/2100';
	for i:= 1 to 5 do begin
		regFecha:= StrToDate(regAux.fecha);
		regArrayFecha:= StrToDate(arrayR[i].fecha);
		if (arrayR[i].cod_usuario < regAux.cod_usuario) then begin
			indice:= i;
			regAux:= arrayR[i];
		end
																	// Acá si hiciera <= se quedaria siempre con el ultimo registro de fechas iguales, ya que el IGUAL haria que cambie
		else if ((arrayR[i].cod_usuario = regAux.cod_usuario) and (regArrayFecha < regFecha)) then begin
			indice:= i;
			regAux:= arrayR[i];
		end
	end;
	
	
	leer(arrayD[indice], arrayR[indice]);
	regD:= regAux;

end;


procedure mergeDetalles (var archM: archivoM; var arrayD: arrayDetalle);
var
	arrayR: arrayRegistro;
	i: integer;
	regMin, regAux: registroDetalle;
	minTotal: real;
	regM: registroMaestro;
begin
	rewrite(archM);
	
	regMin.cod_usuario:= valor_alto;
	regMin.fecha:= 'ZZZ';
	for i:= 1 to 5 do begin
		reset(arrayD[i]);
		leer(arrayD[i], arrayR[i]);
	end;
	
	minimo(arrayD, arrayR, regMin);
	writeln(regMin.cod_usuario , ' ', regMin.fecha);
	while (regMin.cod_usuario <> valor_alto) do begin
		regAux:= regMin;
		minTotal:= 0;
		while ((regAux.cod_usuario = regMin.cod_usuario) and (regAux.fecha = regMin.fecha)) do begin
			minTotal:= minTotal + regMin.tiempo_sesion;
			minimo(arrayD, arrayR, regMin);
			writeln(regMin.cod_usuario , ' ', regMin.fecha, ' ', minTotal:2:0);
		end;
		regM.cod_usuario:= regAux.cod_usuario;
		regM.fecha:= regAux.fecha;
		regM.tiempo_total_sesiones_abiertas:= minTotal;
		
		write(archM, regM);
	end;
	
	close(archM);
	for i:= 1 to 5 do begin
		close(arrayD[i]);
	end;
end;

var

	arrayD: arrayDetalle;
	archivo: archivoM;
	i:integer;
	numString: string;
begin

	assign(archivo, 'var/log/archivoMaestro.dat');
	rewrite(archivo);
	close(archivo);

	for i:= 1 to 5 do begin
		str(i, numString);
		writeln();
		writeln('Registro ' + numString);
		assign(arrayD[i], 'detalle' + numString + '.dat');
		importarDetalle(arrayD[i], i);
		listarDetalle(arrayD[i]);
	end;
	mergeDetalles(archivo, arrayD);
	listarArchivoMaestro(archivo);
	exportarMaestro(archivo);

end.
