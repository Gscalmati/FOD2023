program Pract2Ejercicio1;

type

	ventas = record
		cod: integer;
		nom: string;
		comi: real;
	end;

	archivo = file of ventas;

procedure imprimirVenta (v: ventas);
begin
	writeln('Ventas de ', v.nom, ' cod. ', v.cod, ' con comisiones de ', v.comi:0:0);
end;

procedure listarArchivo (var txt: Text);
var
	v: ventas;
begin
	reset(txt);
	
	while not eof(txt) do begin
		readln(txt, v.cod, v.comi, v.nom);
		imprimirVenta(v);
	end;
	
	close(txt);
end;

procedure leer(var txt: Text; var v: ventas);
begin
	if not eof(txt) then
		readln(txt, v.cod, v.comi, v.nom)
	else 
		v.cod:= 9999;
end;

procedure compactarArchivo (var txt: Text; var txtNuevo: Text);
var
	v: ventas;
	vAux: ventas;
	codActual: integer;
	comiAct: real;
	nomAct: string;
begin
	reset(txt);
	rewrite(txtNuevo);
	
	leer(txt, v);
	while (v.cod <> 9999) do begin
		codActual:= v.cod;
		comiAct:= 0;
		nomAct:= v.nom;
		while (codActual = v.cod) do begin
			comiAct:= comiAct + v.comi;
			leer(txt,v);
		end;
		writeln(txtNuevo, codActual, ' ', comiAct:0:0, ' ', nomAct);
	end;
	
	close(txt);
	close(txtNuevo);

end;

	
var
	txt, txtNuevo: Text;
	nombre: string;
begin

writeln('Ingrese nombre de archivo a compactar');
readln(nombre);

assign(txt, nombre + '.txt');
assign(txtNuevo, 'export.txt');


writeln('Archivo Completo');
listarArchivo(txt);
writeln('-------------------');
compactarArchivo (txt, txtNuevo);
writeln('Archivo Compactado');
listarArchivo(txtNuevo);
writeln('-------------------');

end.
