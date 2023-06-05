program Practica2Ejercicio10;

const
	valor_alto = 9999;
	
type

	empleado = record
		depto: integer;
		div: integer;
		num: integer;
		cat: 1..15;
		cantHoras: integer;
	end;
	
