/*1. Sabiendo que un producto recurrente es aquel producto que al menos
se compró durante 6 meses en el último año.
Realizar una consulta SQL que muestre los clientes que tengan
productos recurrentes y de estos clientes mostrar:

i. El código de cliente.
ii. El nombre del producto más comprado del cliente.
iii. La cantidad comprada total del cliente en el último año.

Ordenar el resultado por el nombre del cliente alfabéticamente.*/

--Lo hice yo, esta bastante bien
/*
SELECT 
c.clie_codigo AS Cli,
(SELECT TOP 1 p1.prod_detalle AS Producto 
FROM Producto p1 JOIN Item_Factura i1 ON
i1.item_producto = p1.prod_codigo JOIN Factura f1 ON
i1.item_tipo = f1.fact_tipo AND
i1.item_numero = f1.fact_numero AND
i1.item_sucursal = f1.fact_sucursal
WHERE f1.fact_cliente = c.clie_codigo
GROUP BY p1.prod_detalle,i1.item_producto
ORDER BY sum(i1.item_cantidad) DESC
) AS Producto,
SUM(i.item_cantidad) AS Total
--(SELECT TOP 1 SUM(i2.item_cantidad)FROM Item_Factura i2) AS Cant_Total
FROM Factura f 
JOIN Item_Factura i ON
i.item_tipo = f.fact_tipo AND
i.item_numero = f.fact_numero AND
i.item_sucursal = f.fact_sucursal  
JOIN Cliente c ON
c.clie_codigo = f.fact_cliente
WHERE YEAR(f.fact_fecha) = 2011 
--(YEAR(GETDATE()) - 1) VA ASI,PERO NECESITO ALGO CON LO QUE TESTEAR
GROUP BY c.clie_codigo,c.clie_razon_social
HAVING COUNT(DISTINCT MONTH(f.fact_fecha)) >= 6
ORDER BY c.clie_razon_social ASC*/

/*SELECT 
    c.clie_codigo AS codigo_del_cliente,
    c.clie_razon_social AS nombre,
    (SELECT TOP 1 
      p.prod_detalle 
     FROM Factura f2
  JOIN item_factura ifact2 ON f2.fact_tipo = ifact2.item_tipo 
      AND f2.fact_sucursal = ifact2.item_sucursal 
      AND f2.fact_numero = ifact2.item_numero
  JOIN producto p ON p.prod_codigo = ifact2.item_producto 
   WHERE  
    f2.fact_cliente = c.clie_codigo
   GROUP BY 
    ifact2.item_producto , p.prod_detalle 
   ORDER BY  
    sum(ifact2.item_cantidad) desc
    ),
    SUM(ifact.item_cantidad) AS cantidad
FROM Factura f
JOIN cliente c ON f.fact_cliente = c.clie_codigo
JOIN item_factura ifact ON f.fact_tipo = ifact.item_tipo 
    AND f.fact_sucursal = ifact.item_sucursal 
    AND f.fact_numero = ifact.item_numero
JOIN producto p ON ifact.item_producto = p.prod_codigo
WHERE 
 YEAR(f.fact_fecha) = 2012  
  GROUP BY 
   c.clie_codigo,
   c.clie_razon_social 
HAVING 
 COUNT(DISTINCT MONTH(f.fact_fecha)) >= 6
ORDER BY 
 c.clie_razon_social ASC*/

/*1. Implementar una restricción que no deje realizar operaciones masivas
sobre la tabla cliente. En caso de que esto se intente se deberá
registrar que operación se intentó realizar , en que fecha y hora y sobre
que datos se trató de realizar.*/

/*
CREATE TABLE RegistroOperaciones (
    id INT IDENTITY PRIMARY KEY (1,1),
    operacion NVARCHAR(10), -- INSERT, UPDATE, DELETE
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    detalles TEXT -- Información sobre la operación (puede incluir identificadores o condiciones)
);


create trigger tr_parcial24
on Cliente instead of insert, delete, update
as
begin
begin transaction

	declare @operacion VARCHAR(50)
	declare @campos INT

	if (select count(*) from inserted) > 1 and (select count(*) from deleted) > 1
	begin 
		set @operacion = 'UPDATE'
		set @campos =  (select count(*) from inserted)
	end
	else if (select count(*) from inserted) > 1
	begin 
		set @operacion = 'INSERT'
		set @campos =  (select count(*) from inserted)
	end
	else if (select count(*) from deleted) > 1
	begin
		set @operacion = 'DELETE'
		set @campos =  (select count(*) from deleted)
	end
	else if  (select count(*) from inserted) = 1
	begin
		insert into Cliente
		select * from inserted
		commit transaction
	end
else if  (select count(*) from deleted) = 1
	begin 
		delete from Cliente
		where clie_codigo in (select clie_codigo from deleted)
		commit transaction
	end
	else
	begin
	update 
		commit transaction
	
	insert into RegistroOperacion (operacion, fecha, campos)
		select @operacion, 
				CURRENT_TIMESTAMP,
				@campos
	commit transaction
end
*/

/*Realizar una consulta SQL que muestre aquellos productos que tengan
entre 2 y 4 componentes distintos a nivel producto y cuyos
componentes no fueron todos vendidos (todos) en 2012 pero si en el
2011.
De estos productos mostrar:
i. El código de producto.
ii. El nombre del producto.
iii. El precio máximo al que se vendió en 2011 el producto.
El resultado deberá ser ordenado por cantidad de unidades vendidas
del producto en el 2011.*/

/*
SELECT p.prod_codigo AS PRODUCTO,
p.prod_detalle AS DETALLE,
(SELECT TOP 1 i1.item_precio FROM Factura f1 JOIN Item_Factura i1 ON
i1.item_tipo = f1.fact_tipo AND
i1.item_numero = f1.fact_numero AND
i1.item_sucursal = f1.fact_sucursal 
AND i1.item_producto = p.prod_codigo
WHERE YEAR(f1.fact_fecha) = 2011
GROUP BY p.prod_codigo
ORDER BY i1.item_precio DESC
) as Precio_Max 
FROM Producto p 
LEFT JOIN Composicion c ON
c.comp_producto = p.prod_codigo 
JOIN Item_Factura i ON
i.item_producto = p.prod_codigo 
JOIN Factura f ON
i.item_tipo = f.fact_tipo AND
i.item_numero = f.fact_numero AND
i.item_sucursal = f.fact_sucursal 
WHERE YEAR(f.fact_fecha) = 2011 AND YEAR(f.fact_fecha) != 2012
GROUP BY p.prod_codigo,p.prod_detalle
HAVING COUNT(DISTINCT c.comp_componente) BETWEEN 2 AND 4
ORDER BY SUM(CASE WHEN YEAR(f.fact_fecha) = 2011 THEN i.item_cantidad ELSE 0 END) ASC

SELECT
	p.prod_codigo,
	p.prod_detalle,
	(
		SELECT MAX(i2.item_precio)
		FROM Item_Factura i2 INNER JOIN Factura f2 ON
			f2.fact_tipo = i2.item_tipo
			AND f2.fact_sucursal = i2.item_sucursal
			AND f2.fact_numero = i2.item_numero
		WHERE
			i2.item_producto = p.prod_codigo
			AND YEAR(f2.fact_fecha) = 2011
	)
FROM Composicion c left JOIN Producto p ON
	p.prod_codigo = c.comp_producto
INNER JOIN Producto pc ON
	pc.prod_codigo = c.comp_componente
INNER JOIN Item_Factura i ON
	i.item_producto = pc.prod_codigo
INNER JOIN Factura f ON
	f.fact_tipo = i.item_tipo
	AND f.fact_sucursal = i.item_sucursal
	AND f.fact_numero = i.item_numero
WHERE
  YEAR(f.fact_fecha) != 2012 AND YEAR(f.fact_fecha) = 2011
GROUP BY
	p.prod_codigo,
	p.prod_detalle
HAVING
	COUNT(DISTINCT c.comp_componente) BETWEEN 2 AND 4
	*/

/*
select p.prod_codigo, p.prod_detalle, 
isnull((select max(if2.item_precio) from Item_Factura if2
inner join Factura f
on if2.item_tipo = f.fact_tipo and if2.item_sucursal = f.fact_sucursal and if2.item_numero = f.fact_numero 
where if2.item_producto = p.prod_codigo
AND YEAR(f.fact_fecha) = 2011
),0) as precio_maximo_en_2011
from Producto p 
inner join Composicion c 
on c.comp_producto = p.prod_codigo 
group by p.prod_codigo, p.prod_detalle
having 
(select count (distinct comp_componente)) between 2 and 4 AND
(select count(distinct c2.comp_componente) from Composicion c2
inner join Item_Factura if2 
on if2.item_producto = c2.comp_componente 
inner join Factura f 
on if2.item_tipo = f.fact_tipo and if2.item_sucursal = f.fact_sucursal and if2.item_numero = f.fact_numero 
where YEAR(f.fact_fecha) = 2012 AND c2.comp_producto = p.prod_codigo) <> (select count (distinct comp_componente))
AND
(select count(distinct c2.comp_componente) from Composicion c2
inner join Item_Factura if2 
on if2.item_producto = c2.comp_componente 
inner join Factura f 
on if2.item_tipo = f.fact_tipo and if2.item_sucursal = f.fact_sucursal and if2.item_numero = f.fact_numero 
where YEAR(f.fact_fecha) = 2011
AND c2.comp_producto = p.prod_codigo) = (select count (distinct comp_componente))
order by (select sum(if2.item_cantidad)
from Item_Factura if2
inner join Factura f 
on if2.item_tipo = f.fact_tipo and if2.item_sucursal = f.fact_sucursal and if2.item_numero = f.fact_numero 
where if2.item_producto = p.prod_codigo and YEAR(f.fact_fecha) = 2011) DESC*/


/* PARCIAL 18/12/2023 TOMO 25 MIN APROX

--Voy a asumir que Fabricante = Familia


SELECT fam.fami_id AS ID, 
fami_detalle AS DETALLE,
ISNULL((SELECT SUM(i.item_cantidad * i.item_precio) FROM Factura f1
INNER JOIN Item_Factura i1 ON
f1.fact_sucursal = i1.item_sucursal AND
f1.fact_numero = i1.item_numero AND
f1.fact_tipo = i1.item_tipo
JOIN Producto p1 ON 
P1.prod_codigo = i1.item_producto
WHERE f1.fact_fecha >= '2015-07-01' AND
fam.fami_id = p1.prod_familia
GROUP BY p1.prod_familia),0) AS TOTAL_FAM,
AVG(i.item_cantidad * i.item_precio) AS PROMEDIO
FROM Factura f
INNER JOIN Item_Factura i ON
f.fact_sucursal = i.item_sucursal AND
f.fact_numero = i.item_numero AND
f.fact_tipo = i.item_tipo
JOIN Producto p ON 
p.prod_codigo = i.item_producto
JOIN Familia fam ON
fam.fami_id = p.prod_familia
GROUP BY fam.fami_id, fami_detalle
HAVING COUNT(DISTINCT f.fact_numero) > 0
ORDER BY fam.fami_id DESC
*/

--25/06/2024


/*PASABLE,LEE BIEN EL ENUNCIADO
SELECT p.prod_codigo,p.prod_detalle,
d.depo_domicilio,
COUNT(CASE WHEN s.stoc_cantidad>s.stoc_punto_reposicion THEN 1 ELSE 0 END) AS depos
FROM Factura f 
JOIN Item_Factura i ON
f.fact_sucursal = i.item_sucursal AND
f.fact_numero = i.item_numero AND
f.fact_numero = i.item_numero
JOIN Producto p ON
p.prod_codigo = i.item_producto 
JOIN STOCK s ON
s.stoc_producto = p.prod_codigo
LEFT JOIN DEPOSITO d ON
d.depo_codigo = s.stoc_deposito
WHERE (s.stoc_cantidad = 0 OR s.stoc_cantidad = NULL)
GROUP BY p.prod_codigo,p.prod_detalle,d.depo_domicilio
ORDER BY p.prod_codigo ASC*/


--El ultimo else tiene algo raro
/*CREATE TRIGGER parcial 
ON Producto INSTEAD OF INSERT 
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @precioViejo INT,@precioActual INT
		DECLARE @precioNuevo INT
		DECLARE @cantFacturas INT
		SELECT @cantFacturas = 
			COUNT(DISTINCT f.fact_numero)
			FROM Factura f 
			JOIN Item_Factura i ON
				f.fact_sucursal = i.item_sucursal AND
				f.fact_numero = i.item_numero AND
				f.fact_numero = i.item_numero
			JOIN Producto p ON
			p.prod_codigo = i.item_producto
			JOIN inserted nueva ON
				nueva.prod_codigo = p.prod_codigo
			WHERE f.fact_fecha < DATEADD(YEAR, -1, GETDATE()) 
			GROUP BY f.fact_numero
		SELECT @precioViejo = p.prod_precio
			FROM Factura f 
			JOIN Item_Factura i ON
				f.fact_sucursal = i.item_sucursal AND
				f.fact_numero = i.item_numero AND
				f.fact_numero = i.item_numero
			JOIN Producto p ON
			p.prod_codigo = i.item_producto
			JOIN inserted nueva ON
				nueva.prod_codigo = p.prod_codigo
			WHERE f.fact_fecha < DATEADD(YEAR, -1, GETDATE()) 
			GROUP BY f.fact_numero

			SELECT @precioActual = p.prod_precio
			FROM Factura f 
			JOIN Item_Factura i ON
				f.fact_sucursal = i.item_sucursal AND
				f.fact_numero = i.item_numero AND
				f.fact_numero = i.item_numero
			JOIN Producto p ON
			p.prod_codigo = i.item_producto
			JOIN inserted nueva ON
				nueva.prod_codigo = p.prod_codigo
			WHERE f.fact_fecha < DATEADD(MONTH, -1, GETDATE()) 
			GROUP BY f.fact_numero
		IF(@cantFacturas > 0 OR @cantFacturas IS NOT NULL)
			SELECT @precioNuevo = = inserted.prod_precio FROM inserted
			 IF(NOT (@precioNuevo BETWEEN @precioActual AND (@precioActual * 1.05))  AND  (@precioNuevo <= @precioViejo * 1.5))
			   BEGIN
				INSERT INTO Producto
				SELECT * FROM inserted
				COMMIT TRANSACTION
			   END
			ELSE
				 SET MESSAGE_TEXT = 'Gano la inflacion';
		ELSE
			BEGIN
			INSERT INTO Producto
			SELECT * FROM inserted
	COMMIT TRANSACTION
END*/

--25/06/2024

-- ESTA INCREIBLE
/*SELECT p.prod_detalle AS DETELLE,
CASE
WHEN (COUNT(CASE WHEN YEAR(f.fact_fecha) = 2012 THEN 1 ELSE 0 END)) > 100 THEN 'Popular'
ELSE 'SIN INTERES'
END AS LEYENDA, 
COUNT(DISTINCT f.fact_numero) AS FACTURAS,
(SELECT TOP 1 c1.clie_codigo FROM Factura f1
JOIN Item_Factura i1 ON
f1.fact_sucursal = i1.item_sucursal AND
f1.fact_numero = i1.item_numero AND
f1.fact_numero = i1.item_numero
JOIN Cliente c1 ON
c1.clie_codigo = f1.fact_cliente
WHERE p.prod_codigo = i1.item_producto
GROUP BY c1.clie_codigo
ORDER BY SUM(i1.item_cantidad),c1.clie_codigo) AS CLIENTESUPERIOR

FROM Factura f 
JOIN Item_Factura i ON
f.fact_sucursal = i.item_sucursal AND
f.fact_numero = i.item_numero AND
f.fact_numero = i.item_numero
JOIN Producto p ON
p.prod_codigo = i.item_producto
GROUP BY p.prod_codigo,p.prod_detalle
HAVING SUM(CASE WHEN (YEAR(f.fact_fecha) = 2012) THEN i.item_cantidad ELSE 0 END) > 0.15 *
SUM(CASE WHEN (YEAR(f.fact_fecha) BETWEEN 2010 AND 2011) THEN i.item_cantidad ELSE 0 END)
ORDER BY p.prod_codigo*/


/* Este parece estar bien, usalo tranqui
CREATE FUNCTION parcial(@cod AS NVARCHAR(8),@fecha AS SMALLDATETIME)
RETURNS DECIMAL(12,2)
AS
BEGIN
	DECLARE @prod NVARCHAR(8)
	DECLARE @aux SMALLDATETIME
	DECLARE @incremental INT = 0
	DECLARE @cant DECIMAL(12,2) = 0
	DECLARE mi_cursor CURSOR FOR
		SELECT p.prod_codigo,f.fact_fecha
		FROM Factura f 
		JOIN Item_Factura i ON
		f.fact_sucursal = i.item_sucursal AND
		f.fact_numero = i.item_numero AND
		f.fact_numero = i.item_numero
		JOIN Producto p ON
		p.prod_codigo = i.item_producto
		WHERE p.prod_codigo = @cod
		GROUP BY p.prod_codigo,f.fact_fecha
		ORDER BY f.fact_fecha DESC
	OPEN mi_cursor
	FETCH NEXT FROM mi_cursor INTO
	@prod,@aux
	while @@fetch_status = 0
	BEGIN
		IF (@aux = DATEADD(DAY, @incremental, @fecha))
		BEGIN
			SET @cant =  @cant + 1
			SET @incremental = @incremental + 1
		END
			FETCH NEXT FROM mi_cursor INTO
			@prod,@aux
	END
	CLOSE mi_cursor
	DEALLOCATE mi_cursor 		
RETURN @cant
END*/


--8/11/2022
--Se ve bien, pero no devuelve nada por las condiciones
/*SELECT c.clie_codigo AS CLIENTE,
c.clie_razon_social AS RAZON,
p.prod_codigo AS PRODUCTO,
p.prod_detalle AS NOMBRE_PRODUCTO,
COUNT(DISTINCT p.prod_codigo) AS PRODUCTOS,
COUNT(CASE WHEN com.comp_producto IS NOT NULL THEN 1 ELSE 0 END) AS COMPOSICION
FROM Factura f 
JOIN Item_Factura i ON
f.fact_numero = i.item_numero AND
f.fact_tipo = i.item_tipo AND
f.fact_sucursal = i.item_sucursal
JOIN Producto p ON
p.prod_codigo = i.item_producto
JOIN Cliente c ON
c.clie_codigo = f.fact_cliente
RIGHT JOIN Composicion com ON
com.comp_producto = p.prod_codigo
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY c.clie_codigo,p.prod_detalle,c.clie_razon_social, p.prod_codigo 
HAVING (COUNT(DISTINCT MONTH(f.fact_fecha)) = 12)
ORDER BY 
	CASE WHEN (COUNT(DISTINCT p.prod_codigo) > 10) THEN 1 ELSE 2 END, c.clie_codigo
	--En teoria, esto ordena PRIMERO los que tengan 10 productos

CREATE TABLE dbo.ListaRubros(
	rubro NVARCHAR(25) NOT NULL
)
GO

CREATE TRIGGER parcial
ON Producto AFTER UPDATE
AS
BEGIN
	DECLARE @rubro NVARCHAR(50)
	SET @rubro = UPDATE(pro)
		IF(@rubro IN (SELECT l.rubro FROM dbo.ListaRubros l))
		
ROLLBACK TRANSACTION
END
*/