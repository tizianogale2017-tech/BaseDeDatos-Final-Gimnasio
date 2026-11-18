-- ============================================================
-- Trabajo integrador - Base de Datos I
-- Caso: gimnasio de barrio (socios, planes y cuotas)
-- Script 04: consultas (11 esenciales y 5 complejas)
-- Ejecutar después de 01, 02 y 03
-- ============================================================

-- ------------------------------------------------------------
-- CONSULTAS ESENCIALES
-- ------------------------------------------------------------

-- E1. ¿Qué socios tienen más de 30 años? Ordenados por apellido.
SELECT nombre, apellido, edad
  FROM SOCIO
 WHERE edad > 30
 ORDER BY apellido;

-- E2. ¿Qué socios se inscribieron durante 2026?
SELECT nombre, apellido, fecha_ingreso
  FROM SOCIO
 WHERE fecha_ingreso BETWEEN '2026-01-01' AND '2026-12-31'
 ORDER BY fecha_ingreso;

-- E3. ¿Qué cuotas se pagaron en efectivo o por transferencia? De la más cara a la más barata.
SELECT id_cuota, metodo_pago, precio, fecha_pago
  FROM CUOTA
 WHERE metodo_pago IN ('Efectivo', 'Transferencia')
 ORDER BY precio DESC;

-- E4. ¿Qué cuotas todavía no se pagaron?
SELECT id_cuota, precio, plazo_pago
  FROM CUOTA
 WHERE fecha_pago IS NULL
 ORDER BY plazo_pago;

-- E5. ¿Qué socios tienen un apellido que empieza con P?
SELECT nombre, apellido
  FROM SOCIO
 WHERE apellido LIKE 'P%';

-- E6. ¿Qué planes tienen algún descuento o se entrenan dos días o más?
SELECT id_plan, cant_dias, descuento
  FROM PLAN
 WHERE descuento > 0 OR cant_dias >= 2
 ORDER BY descuento DESC;

-- E7. ¿Qué cuotas se pagaron tarde y tuvieron recargo?
SELECT id_cuota, plazo_pago, fecha_pago, porcentaje_anadido
  FROM CUOTA
 WHERE porcentaje_anadido > 0 AND fecha_pago > plazo_pago;

-- E8. ¿Qué rutinas se hacen los días miércoles?
SELECT id_plan, rutina
  FROM PLAN_RUTINA
 WHERE dia = 'Miércoles'
 ORDER BY rutina;

-- E9. ¿Qué gimnasios tienen 15 mancuernas o más?
SELECT id_gimnasio, mancuernas, discos
  FROM GIMNASIO
 WHERE mancuernas >= 15
 ORDER BY mancuernas DESC;

-- E10. ¿Qué planes no tienen un objetivo cargado?
SELECT id_plan, cant_dias, horario
  FROM PLAN
 WHERE objetivo IS NULL;

-- E11. ¿Qué socios atiende cada empleado? (relación N:M: se pasa por la tabla ATENCION)
SELECT pe.apellido AS empleado, s.apellido AS socio, s.nombre
  FROM ATENCION a
  JOIN PERSONAL pe ON pe.id_personal = a.id_personal
  JOIN SOCIO s     ON s.id_socio = a.id_socio
 ORDER BY pe.apellido, s.apellido;

-- ------------------------------------------------------------
-- CONSULTAS COMPLEJAS
-- ------------------------------------------------------------

-- C1 (JOIN de cuatro tablas). ¿Qué socios tienen cuotas sin pagar, de qué importe y desde cuándo?
SELECT s.nombre, s.apellido, c.id_cuota, c.precio, c.plazo_pago
  FROM CUOTA c
  JOIN PLAN p  ON p.id_plan = c.id_plan
  JOIN SOCIO s ON s.id_socio = p.id_socio
 WHERE c.fecha_pago IS NULL
 ORDER BY c.plazo_pago;

-- C2 (JOIN de tres tablas). ¿Cuál es el plan y el local de cada socio?
SELECT s.apellido, s.nombre, p.cant_dias, p.horario, g.id_gimnasio
  FROM SOCIO s
  JOIN PLAN p     ON p.id_socio = s.id_socio
  JOIN GIMNASIO g ON g.id_gimnasio = s.id_gimnasio
 ORDER BY s.apellido;

-- C3 (agregación con GROUP BY). ¿Cuánto se cobró en cada mes, contando los recargos?
SELECT substr(fecha_pago, 1, 7) AS mes,
       COUNT(*) AS cuotas_cobradas,
       SUM(precio * (1 + porcentaje_anadido / 100.0)) AS total_cobrado
  FROM CUOTA
 WHERE fecha_pago IS NOT NULL
 GROUP BY substr(fecha_pago, 1, 7)
 ORDER BY mes;

-- C4 (GROUP BY con HAVING). ¿Qué socios tienen más de una cuota cargada y cuánto suman?
SELECT s.apellido, s.nombre, COUNT(c.id_cuota) AS cuotas, SUM(c.precio) AS total
  FROM SOCIO s
  JOIN PLAN p  ON p.id_socio = s.id_socio
  JOIN CUOTA c ON c.id_plan = p.id_plan
 GROUP BY s.id_socio, s.apellido, s.nombre
HAVING COUNT(c.id_cuota) > 1
 ORDER BY total DESC;

-- C5 (subconsulta). ¿Qué cuotas son más caras que el promedio de todas las cuotas?
SELECT s.apellido, s.nombre, c.id_cuota, c.precio
  FROM CUOTA c
  JOIN PLAN p  ON p.id_plan = c.id_plan
  JOIN SOCIO s ON s.id_socio = p.id_socio
 WHERE c.precio > (SELECT AVG(precio) FROM CUOTA)
 ORDER BY c.precio DESC;
