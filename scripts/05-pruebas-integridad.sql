-- ============================================================
-- Trabajo integrador - Base de Datos I
-- Caso: gimnasio de barrio (socios, planes y cuotas)
-- Script 05: pruebas de integridad
-- Cada sentencia viola una restricción A PROPÓSITO y debe fallar.
-- Ejecutar al final y de a una sentencia por vez: si se ejecutan todas
-- juntas, algunos programas se detienen en el primer error.
-- ============================================================

PRAGMA foreign_keys = ON;

-- P1. Clave foránea inexistente: el gimnasio 99 no existe.
-- Error esperado: FOREIGN KEY constraint failed
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio)
VALUES (50, 'Prueba', 'Uno', 30, '2026-11-14', 12345678, 99);

-- P2. Valor repetido en una columna UNIQUE: el DNI 33100201 ya es de otro socio.
-- Error esperado: UNIQUE constraint failed: SOCIO.dni
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio)
VALUES (51, 'Prueba', 'Dos', 30, '2026-11-14', 33100201, 1);

-- P3. Violación de un CHECK: la edad debe estar entre 12 y 99.
-- Error esperado: CHECK constraint failed: edad BETWEEN 12 AND 99
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio)
VALUES (52, 'Prueba', 'Tres', 5, '2026-11-14', 12345679, 1);

-- P4. Violación de NOT NULL: el apellido es obligatorio.
-- Error esperado: NOT NULL constraint failed: SOCIO.apellido
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio)
VALUES (53, 'Prueba', NULL, 30, '2026-11-14', 12345680, 1);

-- P5. Clave primaria repetida: ya existe el socio 1.
-- Error esperado: UNIQUE constraint failed: SOCIO.id_socio
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio)
VALUES (1, 'Prueba', 'Cinco', 30, '2026-11-14', 12345681, 1);

-- P6. Borrado restringido: el plan 1 tiene cuotas cargadas.
-- Error esperado: FOREIGN KEY constraint failed
DELETE FROM PLAN WHERE id_plan = 1;

-- P7. CHECK entre columnas: una cuota pagada debe tener método y fecha de pago.
-- Error esperado: CHECK constraint failed: (metodo_pago IS NULL) = (fecha_pago IS NULL)
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan)
VALUES (60, 'Efectivo', 30000, '2026-12-10', 0, NULL, 1);

-- P8. Un rol repetido para el mismo empleado.
-- Error esperado: UNIQUE constraint failed: PERSONAL_ROL.id_personal, PERSONAL_ROL.rol
INSERT INTO PERSONAL_ROL (id_personal_rol, rol, id_personal)
VALUES (60, 'Recepcionista', 3);

-- P9. Un par empleado-socio repetido en la relación N:M.
-- Error esperado: UNIQUE constraint failed: ATENCION.id_personal, ATENCION.id_socio
INSERT INTO ATENCION (id_atencion, id_personal, id_socio)
VALUES (60, 1, 1);
