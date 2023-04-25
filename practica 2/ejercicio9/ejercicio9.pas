
program Practica2Ejercicio9;

uses
  SysUtils;
  
const
	valor_alto = 9999;
	
type

	voto = record
		codPro: integer;
		codLoc: integer;
		mesa: integer;
		cantVotos: integer;
	end;
	
	archivo = file of voto;
	
// IMPORTAR ARCHIVOS

procedure importarMaestro(var arch: archivo);
var
	reg: voto;
	txt: Text;
begin
	assign(txt, 'archivoMaestro.txt');
	reset(txt);
	rewrite(arch);
	
	while not eof(txt) do begin
		readln(txt, reg.codPro, reg.codLoc, reg.mesa, reg.cantVotos);
		write(arch, reg);
	end;
	close(txt);
	close(arch);
end;

// LISTAR ARCHIVOS

procedure imprimirRegistro (reg: voto);
begin
	writeln('Cod. Prov. ', reg.codPro, ' - Cod. Loc.', reg.codLoc, ' - Mesa ', reg.mesa, ' - Votos ', reg.cantVotos);
	writeln('--------------');
end;

procedure listarMaestro (var arch: archivo);
var
	reg: voto;
begin
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, reg);
		imprimirRegistro(reg);
	end;
	close(arch);
end;

// CORTE DE CONTROL
procedure leer(var arch: archivo; var reg: voto);
begin
	if not eof(arch) then
		read(arch,reg)
	else
		reg.codPro := valor_alto;
end;

procedure realizarInforme (var arch: archivo);
var
	reg, regAux: voto;
	votosProv, votosLoc, votosTotal: integer;
begin
	reset(arch);
	votosTotal:= 0;
	leer(arch, reg);
	while (reg.codPro <> valor_alto) do begin
		regAux:= reg;
		votosProv:= 0;
		writeln('Codigo de Provincia ' , regAux.codPro);
		while (regAux.codPro = reg.codPro) do begin
			regAux.codLoc:= reg.codLoc;
			votosLoc:= 0;
			writeln(Format('%*s%*s', [10, 'Codigo de Localidad', 20, 'Total de Votos']));
			while ((regAux.codPro = reg.codPro) and (regAux.codLoc = reg.codLoc)) do begin
				votosLoc:= votosLoc + reg.cantVotos;
				leer(arch, reg);
			end;
			
			writeln(Format('%*d%*d', [10, regAux.codLoc, 25, votosLoc]));
			votosProv:= votosProv + votosLoc;
		end;
		writeln('Total de Votos Provincia ', regAux.codPro, ': ', votosProv);
		writeln();
		votosTotal:= votosTotal + votosProv;
	end;
	writeln();
	writeln('Total general de Votos: ', votosTotal);
	close(arch);
 end;

var
	arch: archivo;
	
begin
	assign(arch, 'archivoMaestro.dat');
	importarMaestro(arch);
	//listarMaestro(arch);
	
	realizarInforme(arch);
end.
