--eje 1
SELECT clie_codigo,clie_razon_social
FROM Cliente
WHERE clie_limite_credito > 1000
ORDER BY 1

--eje 2
SELECT prod_codigo, prod_detalle
FROM Producto
JOIN Item_Factura ON prod_codigo = item_producto
JOIN Factura ON fact_numero = item_numero
AND fact_tipo = item_tipo
AND fact_sucursal = item_sucursal
WHERE YEAR(fact_fecha) = 2012
GROUP BY prod_codigo,prod_detalle
ORDER BY sum(item_cantidad)

--Cantidad de productos: 2190

--eje 3
SELECT prod_codigo, prod_detalle, sum(isnull(stoc_cantidad,0))
FROM Producto
LEFT JOIN STOCK ON stoc_producto = prod_codigo
LEFT JOIN DEPOSITO ON depo_codigo = stoc_deposito
GROUP BY prod_codigo, prod_detalle
ORDER BY 2

--eje 4
SELECT prod_codigo, prod_detalle, COUNT(comp_componente)
FROM Producto
LEFT JOIN Composicion ON comp_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle
HAVING prod_codigo IN 
(
SELECT prod_codigo
FROM Producto p1
LEFT JOIN STOCK ON stoc_producto = p1.prod_codigo
LEFT JOIN DEPOSITO ON depo_codigo = stoc_deposito 
GROUP BY p1.prod_codigo
HAVING AVG(stoc_cantidad) > 100
)
ORDER BY 3 DESC

--eje 5
SELECT p.prod_codigo, p.prod_detalle, sum(isnull(item_cantidad,0)) 
FROM Producto p
JOIN Item_Factura ON p.prod_codigo = item_producto
JOIN Factura ON fact_numero = item_numero 
AND fact_tipo = item_tipo
AND fact_sucursal = item_sucursal
WHERE YEAR(fact_fecha) = 2012
GROUP BY p.prod_codigo, p.prod_detalle
HAVING sum(isnull(item_cantidad,0)) >
(
SELECT sum(isnull(item_cantidad,0)) 
FROM Item_Factura 
JOIN Factura ON fact_numero = item_numero 
AND fact_tipo = item_tipo
AND fact_sucursal = item_sucursal
WHERE YEAR(fact_fecha) = 2011 AND p.prod_codigo = item_producto
)
ORDER BY 1

--eje 6
SELECT rubr_id,rubr_detalle, count(DISTINCT prod_codigo), SUM(ISNULL(stoc_cantidad,0))
FROM Rubro
LEFT JOIN Producto ON prod_rubro = rubr_id
LEFT JOIN STOCK ON stoc_producto = prod_codigo
AND prod_codigo in (select stoc_producto from stock group by stoc_producto having sum(stoc_cantidad) >
(select isnull(stoc_cantidad,0) from stock where stoc_producto = '00000000' and stoc_deposito = '00'))
GROUP BY rubr_id,rubr_detalle
ORDER BY 4
--No puedo poner subconsultas en un sum, asi que la doble subconsulta es la unica forma

--eje7
SELECT prod_codigo, prod_detalle, MAX(item_precio), MIN(item_precio),
((MAX(item_precio)-MIN(item_precio))/MIN(item_precio))*100
FROM Item_Factura 
JOIN Producto ON prod_codigo = item_producto
JOIN STOCK ON stoc_producto = prod_codigo
GROUP BY prod_codigo, prod_detalle
HAVING sum(stoc_cantidad) > 0
ORDER BY 1

--eje 8
SELECT prod_codigo, prod_detalle,
(
	SELECT MAX(stoc_cantidad) FROM STOCK JOIN DEPOSITO ON stoc_deposito = depo_codigo
	WHERE stoc_producto = prod_codigo
)
FROM Producto 
RIGHT JOIN STOCK ON stoc_producto = prod_codigo --Todos prod con stock 
GROUP BY prod_codigo, prod_detalle
HAVING COUNT(DISTINCT stoc_deposito) = (SELECT COUNT(DISTINCT depo_codigo) FROM DEPOSITO)
ORDER BY 3 DESC

SELECT
 p.prod_detalle,
 max(s.stoc_cantidad) max_stock
FROM Producto p
JOIN STOCK s
 ON p.prod_codigo = s.stoc_producto
 AND s.stoc_cantidad > 0
GROUP BY
 p.prod_detalle
HAVING
 count(s.stoc_deposito) = (select count(*) FROM DEPOSITO d)-- sale en todos los campos de la sub

-- eje 9 
select J.empl_codigo as codigo_jefe,
	   J.empl_nombre as nombre_jefe,
       J.empl_apellido as apellido_jefe,
	   E.empl_codigo as codigo_empleado,
	   E.empl_nombre as nombre_empleado,
       E.empl_apellido as apellido_empleado
	   --count (D.depo_encargado)as depositos_dirigidos_entre_los_2
From Empleado J
Join Empleado E ON E.empl_jefe = J.empl_codigo
Join DEPOSITO D ON (D.depo_encargado = E.empl_codigo OR D.depo_encargado = E.empl_jefe) 
group by  J.empl_codigo ,
	   J.empl_nombre ,
       J.empl_apellido ,
	   E.empl_codigo ,
	   E.empl_nombre ,
       E.empl_apellido 

--eje 10
SELECT
	prod_codigo,
	(
		SELECT TOP 1 fact_cliente FROM Factura
		JOIN Item_Factura on item_numero = fact_numero and item_sucursal = fact_sucursal and item_tipo = fact_tipo
		WHERE item_producto = prod_codigo
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC
	) clie_mas_compro
FROM Producto
WHERE prod_codigo IN 
	(
		SELECT TOP 10 item_producto FROM Item_Factura
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
	) OR
	prod_codigo IN 
	(
		SELECT TOP 10 item_producto FROM Item_Factura
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) ASC
	)

--eje 11

SELECT fami_detalle,COUNT(DISTINCT prod_codigo), SUM(ISNULL(item_precio * item_cantidad,0))
FROM Familia
JOIN Producto ON prod_familia = fami_id
LEFT JOIN Item_Factura ON item_producto = prod_codigo
GROUP BY fami_detalle,fami_id --como el having lo necesita, lo agrego al group
HAVING fami_id IN(
SELECT a.prod_familia FROM Producto a
JOIN Item_Factura b ON b.item_producto = a.prod_codigo
JOIN Factura ON fact_numero = b.item_numero
AND fact_tipo = b.item_tipo
AND fact_sucursal = b.item_sucursal
WHERE YEAR(fact_fecha) < 2012 
GROUP BY a.prod_familia
HAVING SUM(b.item_cantidad * b.item_precio) > 20000
)
ORDER BY 2 DESC

--eje 12
SELECT p.prod_detalle, COUNT(DISTINCT fact_cliente),
AVG(item_precio * item_cantidad), 
(SELECT COUNT(DISTINCT stoc_deposito) FROM STOCK WHERE stoc_producto = p.prod_codigo),
(SELECT SUM(ISNULL(stoc_cantidad,0)) FROM STOCK WHERE stoc_producto = p.prod_codigo)
FROM Producto p
LEFT JOIN Item_Factura ON p.prod_codigo = item_producto
LEFT JOIN Factura ON fact_numero = item_numero 
AND fact_tipo = item_tipo
AND fact_sucursal = item_sucursal
GROUP BY p.prod_detalle, p.prod_codigo
HAVING p.prod_codigo IN 
(
SELECT prod_codigo FROM Producto
JOIN Item_Factura ON prod_codigo = item_producto
JOIN Factura ON fact_numero = item_numero 
AND fact_tipo = item_tipo
AND fact_sucursal = item_sucursal
WHERE YEAR(fact_fecha) = 2012
GROUP BY prod_codigo
)
ORDER BY SUM(item_cantidad * item_precio) DESC



--1336 prod con stock
--31 rubros
--2190 productos
--95 familias
--6 prod compuestos
--2687 clientes
--9 empleados

--eje 13

SELECT p1.prod_detalle, p1.prod_precio, SUM(p2.prod_precio * comp_cantidad)
FROM Composicion 
LEFT JOIN Producto p1 ON p1.prod_codigo = comp_producto
LEFT JOIN Producto p2 ON p2.prod_codigo = comp_componente
GROUP BY p1.prod_detalle,p1.prod_precio
HAVING COUNT(DISTINCT comp_componente) >= 2
ORDER BY COUNT(DISTINCT comp_componente) DESC

--eje 14

SELECT clie_codigo,COUNT(DISTINCT fact_numero),
ISNULL(AVG(fact_total),0), ISNULL(COUNT(DISTINCT item_producto),0),
MAX(fact_total)
FROM Cliente
LEFT JOIN Factura ON fact_cliente = clie_codigo
LEFT JOIN Item_Factura ON fact_numero = item_numero 
AND fact_tipo = item_tipo
AND fact_sucursal = item_sucursal
AND YEAR(fact_fecha) = 2012
--Deberia ir YEAR(GET_DATE()) - 1 en vez de 2012, pero queria que devolviera algo
GROUP BY clie_codigo
ORDER BY 2 DESC

--eje 15

SELECT p1.prod_codigo, 
p1.prod_detalle, 
p2.prod_codigo, p2.prod_detalle,
COUNT(*)
FROM Item_Factura i1
JOIN Item_Factura i2 ON i1.item_numero = i2.item_numero 
AND i1.item_tipo = i2.item_tipo
AND i1.item_sucursal = i2.item_sucursal
JOIN Producto p1 ON p1.prod_codigo = i1.item_producto
JOIN Producto p2 ON p2.prod_codigo = i2.item_producto
WHERE p1.prod_codigo > p2.prod_codigo
GROUP BY p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle
ORDER BY 5 DESC

--eje 16

SELECT clie_razon_social, SUM(item_cantidad),
(
	SELECT TOP 1 item_producto
	FROM Factura 
	JOIN Item_Factura ON fact_numero = item_numero 
	AND fact_tipo = item_tipo
	AND fact_sucursal = item_sucursal
	WHERE fact_cliente = clie_codigo AND YEAR(fact_fecha) = 2012 
	GROUP BY item_producto
	ORDER BY SUM(item_cantidad) DESC, item_producto ASC

)
FROM Cliente
JOIN Factura ON fact_cliente = clie_codigo 
JOIN Item_Factura ON fact_numero = item_numero 
AND fact_tipo = item_tipo
AND fact_sucursal = item_sucursal
WHERE YEAR(fact_fecha) = 2012
GROUP BY clie_razon_social,clie_codigo
HAVING SUM(fact_total) < 
(	SELECT TOP 1 SUM(item_cantidad * item_precio)
	FROM Factura 
	JOIN Item_Factura ON fact_numero = item_numero 
	AND fact_tipo = item_tipo
	AND fact_sucursal = item_sucursal
	WHERE YEAR(fact_fecha) = 2012
	GROUP BY item_producto
	ORDER BY 1 DESC
)* 0.33
ORDER BY 1

--Podria estar mejor, creo, esa doble sub consulta ta fea

--eje 17
SELECT ISNULL(FORMAT(fact_fecha,'yyyy/MM'),'0000/00')
,prod_codigo, prod_detalle,
SUM(ISNULL(item_cantidad,0)), 
ISNULL((
SELECT SUM(fact_total - fact_total_impuestos)
FROM Factura f 
WHERE YEAR(f.fact_fecha) - 1 = YEAR(fact_fecha)
AND MONTH(f.fact_fecha) = MONTH(fact_fecha)
),0),
ISNULL(COUNT(DISTINCT fact_numero),0)
FROM Producto p
LEFT JOIN Item_Factura ON p.prod_codigo = item_producto
LEFT JOIN Factura ON fact_numero = item_numero 
AND fact_tipo = item_tipo
AND fact_sucursal = item_sucursal
GROUP BY prod_codigo, prod_detalle,FORMAT(fact_fecha,'yyyy/MM')
ORDER BY 1 DESC,2 DESC

--No me jugaria la carrera con esta, PERO deberia de estar bien

--eje 18


--eje 19

SELECT p.prod_codigo, p.prod_detalle, f1.fami_id, f1.fami_detalle,
(
	SELECT TOP 1 f3.fami_id
	FROM Familia f3 
	WHERE LEFT(f3.fami_detalle,5) = LEFT(p.prod_detalle,5) AND f3.fami_detalle <> f1.fami_detalle
	GROUP BY f3.fami_id
	ORDER BY COUNT(*) DESC, f3.fami_id ASC 
),
(
	SELECT TOP 1 f3.fami_detalle
	FROM Familia f3 
	WHERE LEFT(f3.fami_detalle,5) = LEFT(p.prod_detalle,5) AND f3.fami_detalle <> f1.fami_detalle
	GROUP BY f3.fami_detalle
	ORDER BY COUNT(*) DESC, fami_detalle ASC 
) 
FROM Producto p
LEFT JOIN Familia f1 ON f1.fami_id = p.prod_familia
GROUP BY p.prod_codigo, p.prod_detalle, f1.fami_id, f1.fami_detalle
ORDER BY 2 ASC

--Ta mal, pero no entiendo la consigna en si, so...

--eje 20
SELECT empl_codigo, empl_nombre, empl_apellido, empl_ingreso,
COUNT(CASE WHEN YEAR(fact_fecha) = 2011 AND fact_total > 100 THEN 1 END),
COUNT(CASE WHEN YEAR(fact_fecha) = 2012 AND fact_total > 100 THEN 1 END)
FROM Empleado
LEFT JOIN Factura ON fact_vendedor = empl_codigo
GROUP BY empl_codigo, empl_nombre, empl_apellido, empl_ingreso
HAVING COUNT(fact_numero) >=50
UNION
SELECT j.empl_codigo, j.empl_nombre, j.empl_apellido, j.empl_ingreso,
COUNT(CASE WHEN YEAR(fact_fecha) = 2011 THEN 1 END)/2,
COUNT(CASE WHEN YEAR(fact_fecha) = 2012 THEN 1 END)/2
FROM Empleado j
LEFT JOIN Empleado e ON e.empl_jefe = j.empl_codigo
LEFT JOIN Factura ON fact_vendedor = e.empl_codigo 
GROUP BY j.empl_codigo, j.empl_nombre, j.empl_apellido, j.empl_ingreso
HAVING (
	SELECT COUNT(*) FROM Factura WHERE fact_vendedor = j.empl_codigo
) <= 49
ORDER BY 6 DESC 
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY
--Es buena, pregunta igual por otra resolucion




--eje 21

SELECT YEAR(fact_fecha),COUNT(DISTINCT fact_cliente),COUNT(DISTINCT fact_numero)
FROM Factura 
WHERE fact_numero IN (
SELECT f.fact_numero 
FROM Factura f
LEFT JOIN Item_Factura ON f.fact_numero = item_numero 
AND f.fact_tipo = item_tipo
AND f.fact_sucursal = item_sucursal
GROUP BY f.fact_numero,f.fact_total,f.fact_total_impuestos
HAVING (f.fact_total - f.fact_total_impuestos - SUM(item_precio*item_cantidad)) < 1)
GROUP BY YEAR(fact_fecha)
ORDER BY 1 DESC
--Perfecta	


--eje 22

SELECT rubr_detalle,DATEPART(QUARTER,fact_fecha),ISNULL(COUNT(DISTINCT fact_numero),0),
ISNULL(COUNT(DISTINCT item_producto),0)
FROM Factura 
LEFT JOIN Item_Factura ON fact_numero = item_numero 
AND fact_tipo = item_tipo
AND fact_sucursal = item_sucursal
LEFT JOIN Producto ON prod_codigo = item_producto
RIGHT JOIN Rubro ON rubr_id = prod_rubro
WHERE prod_codigo NOT IN (
SELECT comp_producto FROM Composicion
)
GROUP BY rubr_detalle,DATEPART(QUARTER,fact_fecha)
HAVING ISNULL(COUNT(DISTINCT fact_numero),0) > 100
ORDER BY 1 ASC, 3 DESC 
--parece bueno


--eje 24

SELECT p.prod_codigo,p.prod_detalle, 
SUM(i.item_cantidad)
FROM Factura f
LEFT JOIN Item_Factura i ON
f.fact_numero = i.item_numero AND
f.fact_tipo = i.item_tipo AND
f.fact_sucursal = i.item_sucursal 
JOIN Producto p ON p.prod_codigo = i.item_producto
WHERE f.fact_vendedor IN (
SELECT TOP 2 e1.empl_codigo FROM Empleado e1 ORDER BY e1.empl_comision DESC
) AND
p.prod_codigo IN (SELECT DISTINCT comp_producto FROM Composicion )
GROUP BY p.prod_codigo,p.prod_detalle
HAVING COUNT(DISTINCT f.fact_numero) >= 5 
ORDER BY 3 DESC

--eje 25 este y el 23 es con un sub select en el where, pero nose porque tarda tanto
SELECT YEAR(f1.fact_fecha),
(SELECT TOP 1 r.rubr_id
FROM Factura f
LEFT JOIN Item_Factura i ON
f.fact_numero = i.item_numero AND
f.fact_tipo = i.item_tipo AND
f.fact_sucursal = i.item_sucursal AND
YEAR(f1.fact_fecha) = YEAR(f.fact_fecha)
JOIN Producto p ON p.prod_codigo = i.item_producto
RIGHT JOIN Rubro r ON r.rubr_id = p.prod_rubro
GROUP BY r.rubr_id
ORDER BY SUM(i.item_cantidad) DESC) 
FROM Factura f1 
LEFT JOIN Item_Factura i1 ON 
i1.item_numero = f1.fact_numero AND
i1.item_sucursal = f1.fact_sucursal AND
i1.item_tipo = f1.fact_tipo
GROUP BY  YEAR(f1.fact_fecha)
/*
Realizar una consulta SQL que para cada año y familia muestre : 
a. Año 
b. El código de la familia más vendida en ese año. 
c. Cantidad de Rubros que componen esa familia. 
d. Cantidad de productos que componen directamente al producto más vendido de 
esa familia. 
e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa 
familia. 
f. 
El código de cliente que más compro productos de esa familia. 
g. El porcentaje que representa la venta de esa familia respecto al total de venta 
del año. 
El resultado deberá ser ordenado por el total vendido por año y familia en forma 
descendente. 
*/



