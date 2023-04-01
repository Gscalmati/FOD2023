program Pract2Ejercicio1;

type

	ventas = record
		cod: integer;
		nom: string;
		comi: string;
	end;

	archivo = file of ventas;

procedure compactarArchivo (

	
var
	arch: archivo;
	txt: Text;
begin

writeln('Ingrese nombre de archivo a compactar');
readln(nombre);

assign (txt, nombre + '.txt');
assign (txtNuevo, nombre + 'Export.txt');

compactarArchivo (txt, txtNuevo);

end.
