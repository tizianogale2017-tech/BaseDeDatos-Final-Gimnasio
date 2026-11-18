-- ============================================================
-- Trabajo integrador - Base de Datos I
-- Caso: gimnasio de barrio (socios, planes y cuotas)
-- Script 03: manipulación de datos (INSERT, UPDATE y DELETE)
-- Ejecutar después de 01-creacion.sql y 02-datos.sql
-- ============================================================

PRAGMA foreign_keys = ON;

-- ------------------------------------------------------------
-- INSERT: generación de las cuotas de diciembre del plan 4.
-- La segunda se cargó por error (duplicada) y se borra más abajo.
-- ------------------------------------------------------------
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan)
VALUES (9, NULL, 25500, '2026-12-10', 0, NULL, 4);
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan)
VALUES (10, NULL, 25500, '2026-12-10', 0, NULL, 4);

-- ------------------------------------------------------------
-- UPDATE 1 (dentro de una transacción): registrar el pago de la cuota 4.
-- Se completan juntos el método y la fecha, porque la tabla lo exige.
-- Si algo falla, ROLLBACK deja la cuota como estaba.
-- ------------------------------------------------------------
BEGIN TRANSACTION;
UPDATE CUOTA
   SET metodo_pago = 'Efectivo',
       fecha_pago  = '2026-11-12'
 WHERE id_cuota = 4;
COMMIT;

-- ------------------------------------------------------------
-- UPDATE 2: el socio del plan 3 pidió cambiar el horario de entrenamiento.
-- ------------------------------------------------------------
UPDATE PLAN
   SET horario = '19:00 a 20:00'
 WHERE id_plan = 3;

-- ------------------------------------------------------------
-- UPDATE 3: se compraron 10 mancuernas para el gimnasio 1.
-- ------------------------------------------------------------
UPDATE GIMNASIO
   SET mancuernas = mancuernas + 10
 WHERE id_gimnasio = 1;

-- ------------------------------------------------------------
-- DELETE 1: se borra la cuota de diciembre duplicada por error.
-- ------------------------------------------------------------
DELETE FROM CUOTA
 WHERE id_cuota = 10;

-- ------------------------------------------------------------
-- DELETE 2 (dentro de una transacción): el socio del plan 5 dejó de ir
-- los sábados. Se borra esa rutina y se corrige la cantidad de días,
-- para que el plan siga siendo coherente. Las dos cosas se hacen juntas.
-- ------------------------------------------------------------
BEGIN TRANSACTION;
DELETE FROM PLAN_RUTINA
 WHERE id_plan = 5 AND dia = 'Sábado';
UPDATE PLAN
   SET cant_dias = 1
 WHERE id_plan = 5;
COMMIT;

-- ------------------------------------------------------------
-- DELETE 3: se cierra el gimnasio 5, que no tenía socios ni personal.
-- Se puede borrar porque ninguna tabla lo referencia (ON DELETE RESTRICT).
-- ------------------------------------------------------------
DELETE FROM GIMNASIO
 WHERE id_gimnasio = 5;
