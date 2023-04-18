program Practica2Ejercicio3;
const
	valor_alto = 9999;
type

	
	producto = record
		cod: integer;
		nombre: string;
		desc: string;
		stockDisponible: integer;
		stockMinimo: integer;
		precio: real;
	end;
	
	archivoM = file of producto;
	
	registroDetalle = record
		cod: integer;
		cantVendida: integer;
	end;
	
	archivoD = file of registroDetalle;
	
	detalles = array[1..3] of archivoD;
	
	
// LISTAR
procedure imprimirProducto (p: producto);
begin
	with p do begin
	writeln('----------------------');
	writeln('Codigo ', cod, ' - Nombre:', nombre); 
	writeln('Precio ', precio:0:0, ' - Descripcion:', desc); 
	writeln('Stock Disponible ', stockDisponible, ' - Stock Minimo ', stockMinimo); 
	writeln('----------------------');
	end;
end;

procedure listarArchivoMaestro (var archM: archivoM);
var
	p: producto;
begin

	reset(archM);
	
	while not eof(archM) do begin
		read(archM, p);
		imprimirProducto(p);
	end;

	close(archM);
end;

procedure imprimirRegistroDetalle (reg: registroDetalle);
begin
	with reg do begin
	writeln('----------------------');
	writeln('Codigo ', cod, ' - Cant. Vendida:', cantVendida); 
	writeln('----------------------');
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
	
// IMPORTAR ARCHIVO TXT

procedure importarMaestro (var archM: archivoM);
var
	txt: Text;
	p: producto;
begin

	rewrite(archM);
	assign(txt, 'archivoMaestro.txt');
	reset(txt);
	
	while not eof(txt) do begin
		with p do begin
			readln(txt, cod, stockDisponible, stockMinimo, nombre);
			readln(txt, precio, desc);
		end;
		write(archM, p);
	end;

	close(archM);
	close(txt);
end;

procedure importarDetalle (var archD: archivoD; numero: integer);
var
	txt: Text;
	reg: registroDetalle;
	numString: string;
begin

	rewrite(archD);
	str(numero, numString);
	
	assign(txt, 'archivoDetalle' + numString + '.txt');
	reset(txt);
	
	while not eof(txt) do begin
		with reg do begin
			readln(txt, cod, cantVendida);
		end;
		write(archD, reg);
	end;

	close(archD);
	close(txt);
end;

// ACTUALIZAR MAESTRO

procedure leer (var arch: archivoD; var reg: registroDetalle);
begin
	if not eof(arch) then
		read(arch, reg)
	else
		reg.cod:= 9999
end;

procedure actualizarMaestro (var maestro: archivoM; var arrayD: detalles);
var
	reg: registroDetalle;
	i: integer;
	prodAux: producto;
	vendidos: integer;
	codActual: integer;
	txt: Text;
begin
	assign(txt, 'bajoStock.txt');
	rewrite(txt);
	
	reset(maestro);
	for i:= 1 to 3 do begin
		reset(arrayD[i]);
		
		leer(arrayD[i], reg);
		
		while (reg.cod <> valor_alto) do begin
		
			read(maestro, prodAux);
			
			while (prodAux.cod <> reg.cod) do
				read(maestro, prodAux);
				
			vendidos:= 0;
			
			while (prodAux.cod = reg.cod) do begin
				vendidos:= vendidos + reg.cantVendida;
				leer(arrayD[i], reg);
			end;
			
			prodAux.stockDisponible:= prodAux.stockDisponible - vendidos;
			
			seek(maestro, filepos(maestro)-1);
			write(maestro, prodAux);
		end;
		close(arrayD[i]);
		seek(maestro, 0);
	end;
	close(maestro);
	close(txt);
end;

// EXPORTAR ARCHIVO TXT

procedure exportarMaestro (var archM: archivoM);
var
	txt: Text;
	p: producto;
begin

	reset(archM);
	assign(txt, 'archivoMaestro.txt');
	rewrite(txt);
	
	while not eof(archM) do begin
		read(archM, p);
		with p do begin
			writeln(txt, cod, ' ', stockDisponible, ' ', stockMinimo, nombre);
			writeln(txt, precio:0:0, desc);
		end;
	end;

	close(archM);
	close(txt);
end;

procedure exportarBajoStock (var archM: archivoM);
var
	txt: Text;
	p: producto;
begin

	reset(archM);
	assign(txt, 'bajoStock.txt');
	rewrite(txt);
	
	while not eof(archM) do begin
		read(archM, p);
		if(p.stockDisponible < p.stockMinimo) then begin
			with p do begin
				writeln(txt, cod, ' ', stockDisponible, ' ', stockMinimo, nombre);
				writeln(txt, precio:0:0, desc);
				writeln(txt, '');
			end;
			end;

	end;

	close(archM);
	close(txt);
end;



var
	archivoMaestro: archivoM;
	arrayD: detalles;
	nombreArchM: string;
	i: integer;
	numString: string;
begin
	nombreArchM:= 'archivoMaestro.dat';
	assign (archivoMaestro, nombreArchM);
	
	importarMaestro(archivoMaestro);
	listarArchivoMaestro(archivoMaestro);
	
	for i:= 1 to 3 do begin
		str(i, numString);
		writeln();
		writeln('Registro ' + numString);
		assign(arrayD[i], 'archivoDetalle' + numString + '.dat');
		importarDetalle(arrayD[i], i);
		listarDetalle(arrayD[i]);
	end;
	
	actualizarMaestro(archivoMaestro, arrayD);
	exportarBajoStock(archivoMaestro);
	
	listarArchivoMaestro(archivoMaestro);
	exportarMaestro(archivoMaestro);
	
	
end.
