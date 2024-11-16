Use [Clientes]
GO
--SELECT * FROM Cliente GO
--SELECT clie_codigo , clie_razon_social FROM Cliente GO

--SELECT clie_codigo CODIGO, clie_domicilio DOMI, 1 + 1 AS SUMA FROM Cliente GO

/*SELECT 
	clie_codigo CODIGO,
	clie_domicilio DOMI,
	1 + 1 AS SUMA,
	GETDATE() AS FECHA_HORA,
	YEAR(GETDATE() ),
	SUBSTRING('EDGARDO', 1 , 3) ,
	SUBSTRING('clie_domicilio', 1 , 5) 
FROM Cliente*/

/*SELECT 
	*
FROM Cliente
WHERE 
	clie_codigo = '00101' OR 
	clie_codigo = '00102'*/

/*SELECT 
	*
FROM Cliente
WHERE 
	clie_codigo BETWEEN '00101' AND '00110'*/

/*SELECT 
	*
FROM Cliente
WHERE 
	clie_codigo >= '00109' AND 
	clie_limite_credito <= 10000*/

/*SELECT 
	*
FROM Cliente
WHERE 
	clie_codigo >= '00109' AND 
	clie_limite_credito <= 10000
ORDER BY 
	clie_domicilio ASC  ,
	clie_codigo DESC*/

/*SELECT 
	YEAR(fact_fecha),
	MONTH(fact_fecha),
	fact_cliente ,
	fact_total 
FROM Factura f 
WHERE 
	YEAR(fact_fecha) between 2010 and 2012 
order by 
	YEAR(fact_fecha) asc, MONTH(fact_fecha) asc*/

/*SELECT 
*
FROM Factura f 
WHERE 
	YEAR(fact_fecha) between 2010 and 2012 
order by 
	YEAR(fact_fecha) asc, MONTH(fact_fecha) asc*/

/*SELECT * 
FROM  Factura f JOIN Cliente c 
	ON F.fact_cliente = C.clie_codigo*/

/*SELECT 
	F.fact_cliente ,
	C.clie_domicilio ,
	F.fact_fecha ,
	F.fact_total 
FROM  Factura f JOIN Cliente c 
	ON F.fact_cliente = C.clie_codigo*/

/*SELECT *
FROM Cliente c JOIN Empleado e 
	on c.clie_vendedor = e.empl_codigo*/

/*select fact_tipo,fact_sucursal,fact_numero,fact_fecha,
	fact_total,item_producto,prod_detalle
from Factura f join Item_Factura i on
	f.fact_tipo = i.item_tipo and 
    f.fact_sucursal = i.item_sucursal and 
	f.fact_numero = i.item_numero
join Producto p on p.prod_codigo = i.item_producto
*/

/*select 	fact_tipo,fact_sucursal,fact_numero,fact_fecha,
	fact_total,fact_cliente, clie_razon_social, item_producto,
	prod_detalle
from Factura f join Item_Factura i on
f.fact_tipo = i.item_tipo and 
f.fact_sucursal = i.item_sucursal and 
f.fact_numero = i.item_numero 
join Producto p on p.prod_codigo = i.item_producto 
join cliente c on c.clie_codigo = f.fact_cliente*/

/*select  
	fact_cliente,
	sum(fact_total)
from Factura f join Cliente c
	on f.fact_cliente = c.clie_codigo 
group by 
	fact_cliente*/

/*select  
	fact_cliente,
	sum(fact_total) as facturado,
	avg(fact_total) as promedio ,
	count(*) as filas,
	count(distinct fact_vendedor) as count_distinct_vendedor
from Factura f join Cliente c
	on f.fact_cliente = c.clie_codigo 
group by 
	fact_cliente*/
/*select  
	fact_cliente,
	sum(fact_total) as facturado,
	avg(fact_total) as promedio ,
	count(*) as filas,
	count(distinct fact_vendedor) as count_distinct_vendedor,
	count(fact_vendedor ) as count_vendedor
from Factura f join Cliente c
	on f.fact_cliente = c.clie_codigo 
where 
	year(fact_fecha) = 2012 
group by 
	fact_cliente
having 
	sum(fact_total)  >= 37000  
order by 
	sum(fact_total) asc*/

/*select c.clie_codigo, c.clie_razon_social,
	count(*),
	sum(fact_total)
from Cliente c join Factura f2 	
			on c.clie_codigo = f2.fact_cliente
group by
	c.clie_codigo ,
	c.clie_razon_social	
having 
	sum(fact_total) > 10000
order by 
	sum(fact_total) desc*/

/*Hacer una consulta SQL que muestre para todos los clientes
la cantidad de facturas que tiene.*/

/*SELECT 
	c.clie_codigo,
	c.clie_razon_social,
	count(f.fact_numero) as count_correcto,
	count(1) count_constante,
	count(*) count_asterisco
from cliente c left join Factura f 
		on c.clie_codigo = f.fact_cliente 
group by 
	c.clie_codigo,
	c.clie_razon_social
order by 
	3 asc*/

/*SELECT 
	CASE 
		WHEN c.clie_codigo = '00000' THEN 'cliente cero'
		WHEN c.clie_codigo = '00001' THEN 'cliente uno'
		ELSE 'RESTO CLIENTES'
	END, 
	COUNT(*)
FROM Cliente c 
GROUP BY 
	CASE 
		WHEN c.clie_codigo = '00000' THEN 'cliente cero'
		WHEN c.clie_codigo = '00001' THEN 'cliente uno'
		ELSE 'RESTO CLIENTES'
	END

SELECT TOP 10 * FROM Cliente c 
ORDER BY clie_codigo DESC
SELECT TOP 10 * FROM Cliente c 
ORDER BY clie_codigo ASC*/

/*SELECT 
	 	count(Distinct fact_vendedor ),
		f.fact_cliente
FROM Factura f 
group by 
	fact_cliente
ORDER BY 
	fact_cliente*/
/*SELECT 
	distinct 
		f.fact_cliente,
		f.fact_fecha   
FROM Factura f 
ORDER BY 
	fact_cliente*/

--Ejercicio 1
/*SELECT c.clie_codigo, c.clie_razon_social
FROM Cliente c
WHERE clie_limite_credito >= 1000
ORDER BY c.clie_codigo ASC*/

--Ejercicio 2
/*select 
	Producto.prod_codigo,
	Producto.prod_detalle,
	sum(Item_factura.item_Cantidad) as cantidad_vendida
from Producto
inner join Item_Factura 
	on Producto.prod_codigo = Item_Factura.item_producto
inner join Factura 
	on Item_Factura.item_tipo = Factura.fact_tipo
	and Item_Factura.item_sucursal = Factura.fact_sucursal 
	and Item_Factura.item_numero = Factura.fact_numero
where YEAR(Factura.fact_fecha) = 2012
group by prod_codigo,prod_detalle
order by cantidad_vendida*/

--Ejercicio 3
/*SELECT p.prod_codigo, p.prod_detalle,
	isnull(sum(s.stoc_cantidad),0) AS cantidad
FROM Producto p LEFT JOIN STOCk s
ON p.prod_codigo = s.stoc_producto
GROUP BY p.prod_codigo,p.prod_detalle
ORDER BY p.prod_detalle ASC*/

----Ejercicio 4
/*SELECT p.prod_codigo, p.prod_detalle, 
ISNULL(sum(c.comp_cantidad),0)/COUNT(DISTINCT s.stoc_deposito)
as cantidad
FROM Producto p 
LEFT JOIN Composicion c
ON comp_producto = p.prod_codigo
JOIN STOCK s  
ON s.stoc_producto = p.prod_codigo
GROUP BY p.prod_codigo,p.prod_detalle
HAVING AVG(s.stoc_cantidad) > 100
ORDER BY cantidad ASC*/

----Ejercicio 6
/*SELECT r.rubr_id,r.rubr_detalle,
ISNULL(COUNT(p.prod_rubro),0) AS Cant
FROM Rubro r
LEFT JOIN Producto p ON
r.rubr_id = p.prod_rubro
GROUP BY r.rubr_id,r.rubr_detalle
ORDER BY r.rubr_id
*/

----Ejercicio 7 PREGUNTA EN CLASE
/*SELECT p.prod_codigo,p.prod_detalle,
MAX(p.prod_precio) AS maxi,
MIN(p.prod_precio) AS mini,
(1-(MAX(p.prod_precio)/NULLIF(MIN(p.prod_precio),0))) AS dif
FROM Producto p
LEFT JOIN STOCK s ON
p.prod_codigo = s.stoc_producto
WHERE s.stoc_cantidad > 0
GROUP BY p.prod_codigo, p.prod_detalle
ORDER BY p.prod_codigo*/


--HAVING filtra en base funciones, todo lo que hiciste antes
----Ejercicio 8
/*SELECT p.prod_detalle, MAX(s.stoc_cantidad) max_stock
FROM Producto p JOIN STOCK s
ON p.prod_codigo = s.stoc_producto AND 
s.stoc_cantidad > 0
GROUP BY p.prod_detalle
HAVING count(s.stoc_deposito) = 
(select count(*) FROM DEPOSITO d)*/

----Ejercicio 9 PREGUNTA
/*SELECT e.empl_jefe,e.empl_codigo,e.empl_nombre,
COUNT(d.depo_encargado) AS depo_cant
FROM Empleado e
INNER JOIN DEPOSITO d ON
d.depo_encargado = e.empl_jefe OR
d.depo_encargado = e.empl_codigo
GROUP BY e.empl_codigo,e.empl_jefe,e.empl_nombre
ORDER BY e.empl_codigo*/

--Sub select
/*SELECT 
   		clie_codigo,
   		isnull(sum(fact_total),0) as Suma 
   FROM Cliente c LEFT JOIN Factura fact
   		ON fact_cliente = c.clie_codigo 
   GROUP BY 
   		clie_codigo*/

--Lo que va dentro del OVER determina a que va a numerar
/*SELECT ROW_NUMBER() OVER(ORDER BY c.clie_codigo) AS orden,
c.clie_codigo, c.clie_razon_social
FROM Cliente c*/

--PARTTITION: Agrupo en base a un elemento, sin unir las filas.
--Ejemplo: Las primeras 5 filase son de juan, las siguentes 2 de tomas, etc.
/*SELECT ROW_NUMBER() OVER 
(PARTITION BY fact_cliente ORDER BY 
fact_fecha asc) AS nro_fila,
fact_cliente,fact_fecha 
FROM Factura f 
ORDER BY fact_cliente asc*/

/*SELECT SUM(fact_total) OVER (PARTITION BY 
fact_cliente) AS SUMA, fact_cliente, fact_fecha 
FROM Factura f ORDER BY fact_cliente asc*/

----Ejercicio 10. IN ese un buscar en lista.
/*SELECT 
	p.prod_codigo,
	(
	SELECT TOP 1 
		fact_cliente 
	FROM Factura f2 join Item_Factura if2 
		on
			f2.fact_numero = if2.item_numero and 
			f2.fact_sucursal = if2.item_sucursal and 
			f2.fact_tipo = if2.item_tipo 
	where 
		item_producto = p.prod_codigo
	group by 
		fact_cliente
	order by 
		sum(if2.item_cantidad) DESC 
	)
FROM Producto p
WHERE 
	p.prod_codigo in   
				(
				SELECT TOP 10 
					item_producto
				FROM Item_Factura it1
				GROUP BY 
					item_producto
				ORDER BY 
					SUM(it1.item_cantidad) DESC
				)
OR	 p.prod_codigo in  (
				SELECT TOP 10 
					item_producto
				FROM Item_Factura it1
				GROUP BY 
					item_producto
				ORDER BY 
					SUM(it1.item_cantidad) ASC
				)
*/
--Ejercicio 11
/*SELECT fam.fami_detalle,
COUNT(DISTINCT p.prod_codigo) AS cant_produc,
SUM(SUM(f.fact_total)-SUM(f.fact_total_impuestos)) AS total
FROM Familia fam JOIN Producto p ON
 fam.fami_id = p.prod_familia 
 JOIN Item_Factura i ON
 p.prod_codigo = i.item_producto
 JOIN Factura f ON
 f.fact_sucursal = i.item_sucursal AND
 f.fact_tipo = i.item_tipo AND
 YEAR(f.fact_fecha) < 2012
GROUP BY fam.fami_detalle
HAVING SUM(f.fact_total_impuestos) > 20000
ORDER BY cant_produc DESC*/

--Ejercicio 12, mal
/*SELECT p.prod_detalle,
COUNT(DISTINCT f.fact_cliente) as clientes,
COUNT(CASE WHEN (d.depo_codigo = s.stoc_deposito AND s.stoc_cantidad > 0) 
then 1 else 0 end) as depos,
s.stoc_cantidad
FROM Producto p 
JOIN STOCK s ON
p.prod_codigo = s.stoc_producto
JOIN DEPOSITO d ON
s.stoc_deposito = d.depo_codigo
JOIN Item_Factura i ON
p.prod_codigo = i.item_producto
JOIN Factura f ON
f.fact_tipo+f.fact_sucursal+f.fact_numero=i.item_tipo+I.item_sucursal+I.item_numero
GROUP BY p.prod_detalle,f.fact_fecha,s.stoc_cantidad
HAVING YEAR(f.fact_fecha) = 2012
ORDER BY SUM(i.item_cantidad) DESC*/

--Ejercicio 13
/*SELECT p.prod_detalle, p.prod_precio,
SUM(c.comp_cantidad * p.prod_precio) AS mult
FROM Producto p 
RIGHT JOIN Composicion c ON
p.prod_codigo = c.comp_producto
GROUP BY p.prod_detalle,p.prod_precio,c.comp_cantidad
HAVING c.comp_cantidad > 2
ORDER BY COUNT(c.comp_cantidad) DESC*/

--Ejercicio 14
/*SELECT c.clie_codigo,
ISNULL(COUNT(f.fact_cliente),0) AS veces,
ISNULL(AVG(f.fact_total),0) AS promedio,
ISNULL(COUNT(DISTINCT i.item_producto),0) AS cant_producto,
ISNULL(MAX(f.fact_total),0) AS maximo
FROM Cliente c 
JOIN Factura f ON
f.fact_cliente = c.clie_codigo AND
YEAR(f.fact_fecha) = YEAR(GETDATE())-1
JOIN Item_Factura i ON
f.fact_tipo+f.fact_sucursal+f.fact_numero=i.item_tipo+I.item_sucursal+I.item_numero
GROUP BY c.clie_codigo
ORDER BY c.clie_codigo ASC*/

--Ejercicio 15 DEBATIBLE
SELECT i1.item_producto AS P1,
p1.prod_detalle,i2.item_producto AS P2,
p2.prod_detalle,
COUNT(*) AS veces
FROM Item_Factura i1 
JOIN Item_Factura i2 ON
i1.item_tipo = i2.item_tipo AND
i1.item_numero = i2.item_numero AND
i1.item_sucursal = i2.item_sucursal AND
i1.item_producto > i2.item_producto
JOIN Producto p1 ON
i1.item_producto = p1.prod_codigo 
JOIN  Producto p2 ON 
i2.item_producto = p2.prod_codigo
GROUP BY i1.item_producto,i2.item_producto,p2.prod_detalle,p1.prod_detalle
HAVING COUNT(*) > 500
ORDER BY veces DESC

--Ejercico 16
/*SELECT f.fact_cliente,
SUM(CASE WHEN (YEAR(f.fact_fecha)=2012)
then i.item_cantidad else 0 end) AS cantidad
FROM Factura f 
JOIN Item_Factura i ON
f.fact_tipo+f.fact_sucursal+f.fact_numero=i.item_tipo+i.item_sucursal+i.item_numero
JOIN Cliente c ON

GROUP BY*/

--Ejercicio 17
/*SELECT p.prod_codigo, 
FORMAT(f.fact_fecha, 'yyyy/MM') AS Periodo,
p.prod_detalle,
SUM(ISNULL(i.item_cantidad,0)) AS Ventas,
COUNT(*) AS Cant_Facturas,
(SELECT ISNULL(SUM(ISNULL(I2.item_cantidad,0)),0) 
FROM Item_Factura I2 
JOIN Factura F2 ON F2.fact_tipo=I2.item_tipo AND F2.fact_sucursal = I2.item_sucursal AND F2.fact_numero = I2.item_numero
WHERE I2.item_producto = P.prod_codigo
	AND YEAR(F2.fact_fecha) = YEAR(F.fact_fecha) - 1
	AND MONTH(F2.fact_fecha) = MONTH(F.fact_fecha)
) as VENTAS_ANIO_ANT
FROM Factura f 
JOIN Item_Factura i ON 
f.fact_tipo+f.fact_sucursal+f.fact_numero=i.item_tipo+i.item_sucursal+i.item_numero
JOIN Producto p ON
p.prod_codigo = i.item_producto
GROUP BY p.prod_codigo, p.prod_detalle,f.fact_fecha
ORDER BY p.prod_codigo, Periodo*/

--Ejercicio 18
/*select 
	R.rubr_detalle as DetalleRubro,
	(
		Select Sum(I2.item_cantidad * I2.item_precio) from Item_Factura I2 
			JOIN Producto P2 ON I2.item_producto = P2.prod_codigo
				where I2.item_tipo+I2.item_sucursal+I2.item_numero = F.fact_tipo+F.fact_sucursal+F.fact_numero AND
					  P2.prod_rubro = R.rubr_id			
	) AS VENTAS_EN_PESOS_RUBRO,
	(SELECT TOP 1 COUNT(F3.fact_cliente) FROM Factura F3 
		JOIN Item_Factura I3 ON
	GROUP BY F3.fact_cliente )
		FROM Rubro R 
		LEFT JOIN Producto P ON P.prod_rubro = R.rubr_id
		RIGHT JOIN Item_Factura I ON I.item_producto = P.prod_codigo
		JOIN Factura F ON F.fact_tipo+F.fact_sucursal+F.fact_numero=I.item_tipo+I.item_sucursal+I.item_numero
		GROUP BY R.rubr_id,R.rubr_detalle , F.fact_tipo,F.fact_sucursal,F.fact_numero*/

--Ejercicio 19
/*SELECT p.prod_codigo,p.prod_detalle,
fam.fami_id, fam.fami_detalle,
(SELECT TOP 1 f.fami_id 
FROM Familia f JOIN Producto p1 ON p1.prod_familia = f.fami_id 
WHERE f.fami_id != p.prod_familia AND 
LEFT(p.prod_detalle,5) = LEFT(p1.prod_codigo,5)
ORDER BY p1.prod_codigo ASC) AS Cod_Sugerido,
(SELECT TOP 1 f.fami_detalle 
FROM Familia f JOIN Producto p2 ON p2.prod_familia = f.fami_id 
WHERE f.fami_id != p.prod_familia AND 
LEFT(p.prod_detalle,5) = LEFT(p2.prod_codigo,5)
ORDER BY p2.prod_codigo DESC) AS Det_Sugerido
FROM Producto p
JOIN Familia fam ON
fam.fami_id = p.prod_familia
GROUP BY p.prod_codigo,p.prod_detalle,p.prod_familia,fami_id,fam.fami_detalle
ORDER BY p.prod_detalle ASC*/

--Ejercicio 21
/*
WITH FacturasMal AS (
SELECT fac.fact_cliente, fac.fact_numero, YEAR(fac.fact_fecha) AS fecha
FROM Factura fac JOIN Item_Factura i ON
fac.fact_numero+fact_sucursal+fact_tipo=i.item_numero+i.item_sucursal+i.item_tipo
WHERE fac.fact_total - fac.fact_total_impuestos - 1 > SUM(i.item_precio)
), ClientesMal AS
(
	SELECT fecha,fact_cliente FROM FacturasMal GROUP BY fecha,fact_cliente 
)

SELECT YEAR(c.fecha) AS Anio,
COUNT(DISTINCT c.fact_cliente) AS clientes,
COUNT(DISTINCT f.fact_numero) AS facturas
FROM ClientesMal c JOIN FacturasMal f ON
	f.fecha = c.fecha 
GROUP BY c.fecha
ORDER BY Anio*/

--Ejercicio 23


--Ejercicio 24
/*
WITH top2 AS(
	SELECT TOP 2 f.fact_vendedor FROM Factura f
	GROUP BY f.fact_vendedor
	ORDER BY COUNT(f.fact_numero) ASC
), facturas AS(
SELECT f.fact_numero,f.fact_sucursal,f.fact_tipo FROM Factura f
	JOIN top2 t ON f.fact_vendedor = t.fact_vendedor
)
SELECT p.prod_codigo AS cod,
p.prod_detalle AS nom,
SUM(i.item_cantidad) AS unidades
FROM facturas f1 JOIN Item_Factura i ON
i.item_numero = f1.fact_numero AND
i.item_sucursal = f1.fact_sucursal AND
i.item_tipo = i.item_tipo JOIN Producto p ON
P.prod_codigo = i.item_producto JOIN Composicion c ON
c.comp_producto = p.prod_codigo
GROUP BY prod_codigo, prod_detalle
HAVING COUNT(DISTINCT f1.fact_numero) > 5
ORDER BY unidades DESC
*/

--Ejercicio 25
		--Cantidad de facturas
--Cliente que mas compro
--AVG
/*WITH aux AS(
SELECT TOP 1 p.prod_familia AS cod, 
COUNT(DISTINCT p.prod_rubro) AS rubroCant
FROM Producto p JOIN Item_Factura i ON
i.item_producto = p.prod_codigo
GROUP BY p.prod_familia
ORDER BY SUM(i.item_cantidad) DESC
), productoMas AS(
	SELECT TOP 1 p.prod_codigo
	FROM Producto p JOIN aux ON
	p.prod_familia = cod JOIN Item_Factura i1 ON
	i1.item_producto = p.prod_codigo
	GROUP BY p.prod_codigo
	ORDER BY SUM(i1.item_cantidad) DESC
)
SELECT YEAR(f.fact_fecha) AS Ano,
p.prod_familia AS familia,
COUNT(DISTINCT p.prod_rubro) AS rubros,
(SELECT COUNT(DISTINCT c.comp_componente) FROM Composicion c JOIN productoMas m ON
c.comp_producto = m.prod_codigo) AS compo,
COUNT(DISTINCT f.fact_numero) AS facturas,
(
	SELECT TOP 1 f.fact_cliente FROM Factura f JOIN Item_Factura i ON
	i.item_numero = f.fact_numero AND
	i.item_sucursal = f.fact_sucursal AND
	i.item_tipo = f.fact_tipo JOIN Producto p ON
	p.prod_codigo = i.item_producto
	JOIN aux ON p.prod_familia = aux.cod
	GROUP BY f.fact_cliente
	ORDER BY SUM(i.item_cantidad)
) AS cliente,
AVG(f.fact_total) AS prom
FROM Factura f JOIN Item_Factura i ON
	i.item_numero = f.fact_numero AND
	i.item_sucursal = f.fact_sucursal AND
	i.item_tipo = f.fact_tipo JOIN Producto p ON
	p.prod_codigo = i.item_producto JOIN aux ON 
	p.prod_familia = aux.cod
GROUP BY p.prod_familia, YEAR(f.fact_fecha)
ORDER BY SUM(f.fact_total) DESC*/

--Ejercicio 26. REPITE CODGIO DE EMPLEADO, PROBABLEMENTE POR LA EXISTENCIA DE MAS DE UN DEPOSITO A CARGO
/*
SELECT DISTINCT e.empl_codigo, COUNT(DISTINCT d.depo_codigo) AS depo,
SUM(f.fact_total) AS total,
(SELECT TOP 1 f1.fact_cliente FROM Factura f1 WHERE f1.fact_vendedor = e.empl_codigo 
GROUP BY fact_cliente
ORDER BY COUNT(fact_cliente) DESC) AS cliente,
(SELECT TOP 1 p.prod_codigo FROM Producto p JOIN Item_Factura i ON
i.item_producto = p.prod_codigo GROUP BY p.prod_codigo ORDER BY SUM(i.item_cantidad) DESC) AS prod,
(SUM(CASE WHEN f.fact_vendedor = e.empl_codigo THEN f.fact_total ELSE 0 END)/SUM(fact_total)) AS prom
FROM Empleado e JOIN DEPOSITO d ON
d.depo_encargado = e.empl_codigo JOIN Factura f ON
YEAR(f.fact_fecha) = 2012
GROUP BY e.empl_codigo, d.depo_codigo
ORDER BY total DESC*/

--Ejercicio 27
WITH datos_Envase AS(
 SELECT YEAR(f1.fact_fecha) AS anio,
		en1.enva_codigo,en1.enva_detalle,
		COUNT(DISTINCT i1.item_producto) AS cant_prod,
		COUNT(DISTINCT f1.fact_numero) AS cant_fact,
		ROW_NUMBER() OVER(
			PARTITION BY YEAR(f1.fact_fecha), en1.enva_codigo
			ORDER BY SUM(i.item_cant) DESC
		) AS prod_rank,
		p1.prod_codigo
  FROM Factura f1 JOIN Item_Factura i1 ON
  i1.item_numero = f1.fact_numero AND
  i1.item_sucursal = f1.fact_sucursal AND
  i1.item_tipo = f1.fact_tipo 
  JOIN Producto p1 ON p1.prod_codigo = i1.item_producto JOIN
  Envases en1 ON en1.enva_codigo = p1.prod_envase
  GROUP BY  YEAR(f1.fact_fecha),en1.enva_codigo,p1.prod_codigo
), producto_mas AS(
	SELECT TOP 1 p2.prod_codigo FROM Producto p2 JOIN datos_Envase d ON
	p2.prod_codigo = d.prod_codigo 
	GROUP BY p2.prod_codigo
	ORDER BY SUM(d.cant_prod)
) SELECT dat.anio, dat.enva_codigo, dat.enva_detalle,
dat.cant_prod, dat.cant_prod, pr.prod_codigo 
FROM datos_Envase dat JOIN Envases en ON
en.enva_codigo = dat.enva_codigo JOIN producto_mas pr ON
pr.prod_codigo = 