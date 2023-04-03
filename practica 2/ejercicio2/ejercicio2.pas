program Practica2Ejercicio2;

type
	
	alumno = record
		cod: integer;
		apellido: string;
		nombre: string;
		cantMatCursadas: integer;
		cantMatAprobadas: integer;
	end;
	
	registroDetalle = record
		cod: integer;
		materia: string;
		cursadaAprobada: integer;
		finalAprobado: integer;
	end;
	
	archivoM = file of alumno;
	
	archivoD = file of registroDetalle;

// IMPORTAR

procedure importarMaestro (var txt: Text; var archM: archivoM);
var
	alum: alumno;
begin
	reset(txt);
	rewrite(archM);
	
	while not eof(txt) do begin
		readln(txt, alum.cod, alum.apellido);
		readln(txt, alum.cantMatCursadas, alum.cantMatAprobadas, alum.nombre);
		write(archM, alum);
	end;
	
	close(txt);
	close(archM);
end;

procedure importarDetalle (var txt: Text; var archD: archivoD);
var
	reg: registroDetalle;
begin
	reset(txt);
	rewrite(archD);
	
	while not eof(txt) do begin
		readln(txt, reg.cod, reg.cursadaAprobada, reg.finalAprobado, reg.materia);
		write(archD, reg);
	end;
	
	close(txt);
	close(archD);
end;

// PROCESOS DEL EJERCICIO 

procedure leer (var archD: archivoD; var r: registroDetalle); 
begin
	if not eof(archD) then 
		read(archD, r)
	else
		r.cod:= 9999;
end;




// LISTAR 

procedure imprimirAlumno (a: alumno);
begin
	with a do begin
		writeln('-------------------------');
		writeln('Codigo ', cod);
		writeln('Nombre Completo ', nombre, ' ', apellido);
		writeln('Cursadas Aprobadas ', cantMatCursadas);
		writeln('Materias Aprobadas ', cantMatAprobadas);
		writeln('-------------------------');
	end;
end;

procedure listarMaestro (var archM: archivoM);
var
	a: alumno;
begin
	reset(archM);
	while not eof(archM) do begin
		read(archM, a);
		imprimirAlumno(a);
	end;
	close(archM);
end;

procedure imprimirRegistro (reg: registroDetalle);
begin
	with reg do begin
		writeln('-------------------------');
		writeln('Codigo ', cod);
		writeln('Materia ', materia);
		writeln('Cursada ', cursadaAprobada);
		writeln('Final ', finalAprobado);
		writeln('-------------------------');
	end;
end;

procedure listarDetalle (var archD: archivoD);
var
	reg: registroDetalle;
begin
	reset(archD);
	while not eof(archD) do begin
		read(archD, reg);
		imprimirRegistro(reg);
	end;
	close(archD);
end;

procedure listarAlumnosMasDeCuatro(var archMaestro: archivoM);
var
	a: alumno;
begin
	reset(archMaestro);
	
	while not eof(archMaestro) do begin
		read(archMaestro, a);
		if (a.cantMatCursadas - a.cantMatAprobadas >= 4) then
			imprimirAlumno(a);
	end;
	
	close(archMaestro);
end;

// ACTUALIZAR MAESTRO

procedure actualizarMaestro (var archM: archivoM; var archD: archivoD);
var
	regDetalle: registroDetalle;
	alum: alumno;
begin
	// Abro Archivos
	reset(archM);
	reset(archD);

	// Leo Detalle
	leer(archD, regDetalle);
	
	// Si no salio valor alto ( o sea, si todavia hay info en el detalle
	while (regDetalle.cod <> 9999) do begin
		// Leo Maestro
		read(archM, alum);
		// Hasta tener registros iguales de M y D
		while (alum.cod <> regDetalle.cod) do
			read(archM, alum);
		/// En este punto tengo el M en el mismo reg que el D
		
		// Si es el mismo codigo, proceso la informacion
		while (regDetalle.cod = alum.cod) do begin
			if (regDetalle.cursadaAprobada = 1) then
				alum.cantMatCursadas := alum.cantMatCursadas +1;
			if (regDetalle.finalAprobado = 1) then
				alum.cantMatAprobadas := alum.cantMatAprobadas +1;
			// Leo Detalle
			leer(archD, regDetalle);
		end;
		
		/// Voy a salir cuando tenga distintos reg en M y D
		/// Pero ya actualice en el "alum" la data nueva
		
		// Actualizo registro Maestro
		seek(archM, filepos(archM)-1);
		write(archM, alum);
	end;

		// Cierro Archivos
	close(archM);
	close(archD);
end;

var
	archMaestro: archivoM;
	archDetalle: archivoD;
	txtMaestro, txtDetalle: Text;
begin 
	assign (txtMaestro, 'archivoMaestro.txt');
	assign (txtDetalle, 'archivoDetalle.txt');
	
	assign (archMaestro, 'archivoMaestro.dat');
	assign (archDetalle, 'archivoDetalle.dat');

	importarMaestro(txtMaestro, archMaestro);
	importarDetalle(txtDetalle, archDetalle);
	
	listarMaestro(archMaestro);
	listarDetalle(archDetalle);
	writeln();
	writeln('-------------------------');
	writeln('-------------------------');
	writeln('-------------------------');
	writeln();
	actualizarMaestro (archMaestro, archDetalle);
	listarAlumnosMasDeCuatro(archMaestro);
	//listarMaestro (archMaestro);
end.

