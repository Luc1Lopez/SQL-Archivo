USE [Clientes] 
GO
/*BEGIN
	
	declare @var1 char(100)
	declare @var2 int 
	
	set @var2 = 1 + 2 
	set @var1 = 'Hola Mundo'
	
	print @var2
	print @var1 
	
END
BEGIN
	
	declare @v_cod char(5)
	declare @v_nombre char(100) 
	
	set @v_cod = '00000'
	
	select 
		 @v_nombre = clie_razon_social 
	from cliente 
	where 
		clie_codigo =  @v_cod
		
	print @v_nombre
	
END

BEGIN
	
	declare @var int 
		
	IF (SELECT COUNT(*) FROM CLIENTE) > 1000 
	begin
		
		print 'hay mas de 1000 clientes'
		
	end
	else
	begin
		
		print 'hay menos de 1000 clientes'
		
	end
	
	
	
	
END
BEGIN
	
	declare @var int 
		
	set @var = 1 
	
	while @var <= 100
	begin
		print @var 
		set @var = @var + 1 
	end 

	
	
	
	
END

CREATE view VIEW_EJEMPLO ( COD , NOMBRE, TOTAL  )
AS

	SELECT 
		c.clie_codigo ,
		c.clie_razon_social,
		sum(fact_total)
	FROM Cliente c JOIN Factura f 
		ON c.clie_codigo = f.fact_cliente 
	group by 
		c.clie_codigo ,
		c.clie_razon_social
create view VIEW_year_clie ( cod_clie , anio, total_anio  )
AS

	SELECT 
		fact_cliente ,
		year(fact_fecha),
		sum(fact_total)
	FROM Factura f 
	group by 
		fact_cliente,
		year(fact_fecha)
select * from VIEW_EJEMPLO 
			right  join cliente on clie_codigo = cod 
				   join VIEW_year_clie 
				   	on cod_clie = cod
order by 
	TOTAL desc
END

alter view VIEW_EJEMPLO ( COD , NOMBRE, TOTAL  )
AS

	SELECT 
		c.clie_codigo ,
		c.clie_razon_social,
		(fact_total)
	FROM Cliente c JOIN Factura f 
		ON c.clie_codigo = f.fact_cliente
update VIEW_EJEMPLO 
	set 
		nombre = 'Modificado por view'
	where 
		COD = '00000'

END

CREATE FUNCTION fnc_cuadrado(  @param1 decimal(12,2)  )
RETURNS decimal(14,4) 
AS
BEGIN
	declare @result decimal(12,2) 
	
	set @result = @param1 * @param1
	return @result 
	
	
END;

select dbo.fnc_cuadrado(12)


select 
	clie_codigo, 
	dbo.fnc_cuadrado(clie_limite_credito),
	clie_limite_credito
from Cliente c
create function fnc_tabla1 (@codigo char(6)) 
RETURNS TABLE 
AS 

	RETURN (SELECT * FROM CLIENTE WHERE clie_codigo != @codigo);
select * from dbo.fnc_tabla1('00000')
order by 
	clie_razon_social desc
END

DECLARE @cod char(5)
	DECLARE @nombre char(100)
	
	DECLARE mi_cursor CURSOR FOR 
		SELECT 
			clie_codigo ,
			clie_razon_social 
		FROM Cliente c 
		ORDER BY
			clie_codigo DESC 
			
	OPEN mi_cursor 
	fetch mi_cursor into @cod, @nombre
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		PRINT @NOMBRE
		fetch mi_cursor into @cod, @nombre
	END 
	CLOSE mi_cursor 
	DEALLOCATE mi_cursor
END

DECLARE @cod char(5)
	DECLARE @nombre char(100)
	
	DECLARE mi_cursor CURSOR  FOR 
		SELECT 
			clie_codigo ,
			clie_razon_social 
		FROM Cliente c 
		ORDER BY
			clie_codigo DESC 
	FOR UPDATE OF 
		clie_razon_social 
			
	OPEN mi_cursor 
	fetch mi_cursor into @cod, @nombre
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF @cod = '00000'
		BEGIN 
			UPDATE CLIENTE 
				SET clie_razon_social = 'CAMBIADO FOR UDPATE CURSOR'
			WHERE 
				CURRENT OF MI_CURSOR 
		END 	
		fetch mi_cursor into @cod, @nombre
	END 
	CLOSE mi_cursor 
	DEALLOCATE mi_cursor
SELECT * FROM Cliente c
*/


/*BEGIN TRANSACTION
	INSERT INTO Clientes.dbo.Envases(enva_codigo,enva_detalle)
		values(5, 'env 5')
		
	INSERT INTO Clientes.dbo.Envases (enva_codigo,enva_detalle)
			values(6, 'env 6')
ROLLBACK--Puede ser commit, lo que lo volveria dato confirmado

SELECT * FROM Clientes.dbo.Envases*/

/*create trigger tr_ejemplo_prod
on producto AFTER update 
as 
begin transaction

	select prod_codigo, prod_detalle, 'TABLA DELETED' from deleted 
	union 
	select prod_codigo, prod_detalle, 'TABLA INSERTED' from Inserted 

commit
SELECT * FROM Producto p
UPDATE Producto set prod_detalle = 'valor nuevo' 
where 
	prod_codigo IN ('00000030','00000031')*/

/*alter trigger tr_ejemplo_prod
on producto AFTER update 
as 
begin transaction


	print 'entro'
	
	select 
		prod_codigo, 
		prod_detalle, 
		'TABLA DELETED' 
	from deleted 
	union 
	select 
		prod_codigo, 
		prod_detalle, 
		'TABLA INSERTED' 
	from Inserted 

rollback
SELECT * FROM Producto p
UPDATE Producto set prod_detalle = 'valor nuevo ' +  prod_codigo
	where 
		prod_codigo IN ('00000030','00000031')*/

/*alter trigger tr_INSTEAD_envases
on ENVASES INSTEAD OF insert  
as 
begin transaction

	select 
		'TABLA INSERTED',
		*
	from Inserted 

	insert into Envases (enva_codigo, enva_detalle)
	select 
		enva_codigo, LTRIM(RTRIM(enva_detalle)) + 'TR INSTEAD'
	from inserted 
	
commit
insert into Envases (enva_codigo, enva_detalle)
	values(17, 'envase,17') */


/*Create trigger trigger_producto 
	ON item_factura 
AFTER insert
AS
BEGIN TRANSACTION
declare @cantidad decimal(12,2)
declare @mes int 
declare @anio int 

		DECLARE mi_cursor CURSOR FOR 
			SELECT 
				SUM(item_cantidad),
				year(fact_fecha),
       			MONTH(fact_fecha)
			FROM INSERTED i JOIN 
				 factura f ON 
							f.fact_numero = i.item_numero and 
        				  	f.fact_tipo = i.item_tipo and 
        				  	f.fact_sucursal = i.item_sucursal 
        	WHERE 
        		i.item_producto = '00000030'
        	group by 
       			item_producto,
       			year(fact_fecha),
       			MONTH(fact_fecha)
		
       	OPEN mi_cursor 
       	fetch mi_cursor INTO 
       		@cantidad,
       		@anio ,
       		@mes
while @@fetch_status = 0 
       	begin
	       	
	       	update vta_30 
	       		set cantidad = cantidad + @cantidad
	       	where 
	       		mes = @mes and 
	       		anio = @anio 
	       		
	       	if @@rowcount = 0 
	       		insert into vta_30 (mes, anio, cantidad )
	       			values(@mes, @anio, @cantidad)
	       	
	    	fetch mi_cursor INTO 
	       		@cantidad,
	       		@anio ,
	       		@mes
       	end
       	close mi_cursor 
       	deallocate mi_cursor 
       			
		
COMMIT;*/

--Cursor: ejecuta las funciones por filas en tiempo real


--Ejercicio 1
/*CREATE FUNCTION ocupado(@articulo as char(45), @stock as char(45), @limite as char(45))
RETURNS char(45)
AS
BEGIN
	declare @result char(45) 
	IF(CAST(@stock AS decimal(12,2)) >= 
	CAST(@limite AS decimal(12,2)))
		set @result = 'Stock Maximo'
	ELSE 
		declare @v1 decimal(12,2)
		declare @v2 decimal(12,2)
		set @v1 = CAST(@stock)
		set @v2 = CAST(@limite)
		set @result = 'Ocupacion: ' + (@v1 * 100)/@v2
	return @result 
END*/

--Ejercicio 2
/*CREATE FUNCTION existencia(@articulo AS char(45),@fecha AS SMALLDATETIME)
RETURNS DECIMAL(14,4)
AS
BEGIN
	declare @result DECIMAL(14,4)
	RETURN (
	SELECT SUM(s.stoc_cantidad)
	FROM STOCK s 
	WHERE s.stoc_producto = @articulo) + 
	( Select Sum(I1.item_cantidad)
	from Factura F  JOIN Item_Factura I1 
	ON I1.item_tipo = F.fact_tipo AND
       I1.item_sucursal = F.fact_sucursal AND
	   I1.item_numero = F.fact_numero 
	WHERE I1.item_producto = @articulo AND F.fact_fecha < @fecha)
	END*/

--Ejercicio 3 LAS FUNCTION NO PUEDEN HACER INNSERT, UPDATE Y OTRAS MODIFICACIONES A TABLAS
/*CREATE PROCEDURE eje3A
AS
BEGIN
	DECLARE @total DECIMAL(18,2) 
	DECLARE @generenteGeneral NUMERIC(6,0)
	SELECT @total = COUNT(DISTINCT e.empl_codigo)
	FROM Empleado e WHERE e.empl_jefe IS NULL
	SELECT TOP 1 @generenteGeneral = e2.empl_codigo 
	FROM Empleado e2 WHERE E2.empl_jefe IS NULL ORDER BY e2.empl_salario ASC

	UPDATE Empleado set empl_jefe = @generenteGeneral 
	WHERE empl_jefe IS NULL AND empl_codigo <> @generenteGeneral
	RETURN @total;
END

CREATE PROCEDURE dbo.sp_ej3ASBEGIN    DECLARE @resultado INT = 0;    DECLARE @cod_gerente_general NUMERIC(6);    DECLARE @max_salario DECIMAL(12, 2)    DECLARE @cod_jefe NUMERIC(6);    SELECT @resultado = COUNT(*)    FROM Empleado    WHERE empl_jefe IS NULL;    IF @resultado > 1    BEGIN        SELECT TOP 1 @cod_gerente_general = empl_codigo        FROM Empleado        WHERE empl_jefe IS NULL        ORDER BY empl_salario DESC, empl_ingreso ASC;        UPDATE Empleado        SET empl_jefe = @cod_gerente_general        WHERE empl_jefe IS NULL        AND empl_codigo != @cod_gerente_general;    END    RETURN @resultado;END;
*/

--Ejercicio 4
/*CREATE FUNCTION eje4()
RETURNS NUMERIC(6,0)
AS
BEGIN
	DECLARE @cod NUMERIC(6,0)
	SELECT TOP 1 @cod = e.empl_codigo 
	FROM Empleado e JOIN Factura f ON
	f.fact_vendedor = e.empl_codigo WHERE YEAR(f.fact_fecha) = YEAR(GETDATE()) - 1
	GROUP BY e.empl_codigo ORDER BY SUM(f.fact_total) DESC

	UPDATE Empleado set empl_comision = (SELECT SUM(f.fact_total) FROM Empleado e JOIN Factura f ON
	f.fact_vendedor = e.empl_codigo AND YEAR(f.fact_fecha) = YEAR(GETDATE()) - 1)
	RETURN @cod
END*/

--Ejercicio 5
/*
Create table Fact_table(		anio char(4) NOT NULL,	mes char(2) NOT NULL,	familia char(3) NOT NULL,	rubro char(4) NOT NULL,	zona char(3) NOT NULL,	cliente char(6) NOT NULL,	producto char(8) NOT NULL,	cantidad decimal(12,2),	monto decimal(12,2))Alter table Fact_tableAdd constraint pk_fact primary key(anio,mes,familia,rubro,zona,cliente,producto)GO

ALTER PROCEDURE eje5ASBEGIN		DELETE Fact_table		INSERT INTO Fact_table 		(anio,mes,familia,rubro,zona,cliente,producto,cantidad,monto)	SELECT  		YEAR(f.fact_fecha),		MONTH(f.fact_fecha), 		p.prod_familia,		p.prod_rubro,		d.depa_zona,		c.clie_codigo,		p.prod_codigo,		SUM(ISNULL(i.item_cantidad,0)),		SUM((ISNULL(i.item_precio,0) * ISNULL(i.item_cantidad,0)))	FROM Factura f 		JOIN Item_Factura i ON			item_numero   =fact_numero and 			item_sucursal =fact_sucursal and 			item_tipo     =fact_tipo 		JOIN Producto p ON 			p.prod_codigo = i.item_producto 		JOIN Cliente c ON			c.clie_codigo = f.fact_cliente 		JOIN EMPLEADO e on			e.empl_codigo = f.fact_vendedor 		JOIN Departamento d ON			d.depa_codigo = e.empl_departamento 	GROUP BY 		YEAR(f.fact_fecha),		MONTH(f.fact_fecha), 		p.prod_familia,		p.prod_rubro,		d.depa_zona,		c.clie_codigo,		p.prod_codigoEND
--DROP procedure eje5
EXEC eje5*/

--Ejercicio 7
/*
CREATE TABLE Ventas (
	cod_producto CHAR(8) NOT NULL,
	detalle CHAR(50) NOT NULL,
	movimientos DECIMAL(18,2) NOT NULL,
	precio_Venta DECIMAL(12,2) NOT NULL,
	renglon INT PRIMARY KEY IDENTITY(1,1),
	ganancia DECIMAL(18,2) NOT NULL
)

CREATE PROCEDURE eje7(@f1 AS DATETIME, @f2 AS DATETIME)
AS 
BEGIN 
	INSERT INTO Ventas(cod_producto,detalle,movimientos,precio_Venta,ganancia)
	SELECT i.item_producto,p.prod_detalle,
	COUNT(i.item_numero),
	AVG(i.item_precio), ((prod_precio*i.item_cantidad)-(i.item_cantidad * i.item_precio)) FROM Factura f JOIN Item_Factura i ON
	CONCAT(i.item_numero, i.item_sucursal, i.item_tipo) = 
    CONCAT(f.fact_numero, f.fact_sucursal, f.fact_tipo) JOIN Producto p ON
	p.prod_codigo = i.item_producto WHERE 
	YEAR(f.fact_fecha) BETWEEN YEAR(@f1) AND YEAR(@f2)
	GROUP BY i.item_producto,p.prod_detalle
END*/




--Ejercio 10
/*CREATE TRIGGER eliminar ON Producto
AFTER DELETE -- Como hago rollback, va un after
AS
BEGIN TRANSACTION
	DECLARE @cantidad int
	SELECT @cantidad = SUM(s.stoc_cantidad) FROM deleted p JOIN STOCK s ON
		p.prod_codigo = s.stoc_producto
	IF(@cantidad > 0)
	BEGIN
        RAISERROR('ERROR, AUN HAY STOCK', 16, 1);
        ROLLBACK TRANSACTION;  -- Deshacer la operación de eliminación
		RETURN
	END
	DELETE Producto WHERE prod_codigo IN (SELECT prod_codigo FROM deleted)
COMMIT

--Otra alternativa
ALTER trigger ej10
on producto instead of DELETE 
as 
begin transaction
    IF EXISTS (
        select 1 
        from DELETED s
        where s.prod_codigo IN (
	        				SELECT stoc_producto 
	        					FROM stock 
	        				where 
	        					stoc_cantidad > 0)
   
    )
	BEGIN
		RAISERROR('Todavia hay stock no se puede eliminar', 16, 1);
	    ROLLBACK;
	   	RETURN;
	END;

	DELETE STOCK 
	WHERE 
		STOC_PRODUCTO IN ( SELECT prod_codigo FROM DELETED )
	
	DELETE Producto 
 	WHERE 
 		prod_codigo IN (  SELECT prod_codigo FROM DELETED  )

commit;*/
--Ejercicio 14/*CREATE PROCEDURE eje14 ASBEGIN	DECLARE @fecha SMALLDATETIME, @cliente NVARCHAR(6),	@producto NVARCHAR(8), @precio INT	SELECT @fecha, @cliente,@producto,@precio = f.fact_fecha,	f.fact_cliente, i.item_producto, i.item_precio	FROM Factura f JOIN Item_Factura i ON 	i.item_sucursal = f.fact_sucursal AND 	i.item_tipo = f.fact_tipo AND	i.item_numero = f.fact_numero	JOIN Composicion c ON	c.comp_producto = i.item_producto	GROUP BY c.comp_producto	HAVING SUM(i.) > SUM(CASE WHEN c.comp_componente = p.pro THEN cELSE 0 END)ENDGOCOMMIT*/--Ejercicio 16CREATE TRIGGER eje15ON Factura INSTEAD OF INSERT ASBEGIN	DECLARE @cantidad INT, @prod NVARCHAR(10)	SELECT @cantidad = i.item_cantidad FROM inserted f JOIN Item_Factura i ON	i.item_numero = f.fact_numero AND	i.item_sucursal = f.fact_sucursal AND	i.item_tipo = f.fact_tipo	SELECT @prod = i.item_producto FROM inserted f JOIN Item_Factura i ON	i.item_numero = f.fact_numero AND	i.item_sucursal = f.fact_sucursal AND	i.item_tipo = f.fact_tipo	UPDATE STOCK	SET stoc_cantidad = stoc_cantidad - @cantidad WHERE @prod = stoc_producto AND	AEND