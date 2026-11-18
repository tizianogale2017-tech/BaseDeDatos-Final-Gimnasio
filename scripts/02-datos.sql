-- ============================================================
-- Trabajo integrador - Base de Datos I
-- Caso: gimnasio de barrio (socios, planes y cuotas)
-- Script 02: carga de datos de ejemplo (todos los datos son inventados)
-- Ejecutar después de 01-creacion.sql
-- ============================================================

PRAGMA foreign_keys = ON;

-- GIMNASIO
INSERT INTO GIMNASIO (id_gimnasio, mancuernas, discos, maquinas, dispositivos_electronicos, bano) VALUES (1, 20, 30, 8, 3, 2);
INSERT INTO GIMNASIO (id_gimnasio, mancuernas, discos, maquinas, dispositivos_electronicos, bano) VALUES (2, 12, 18, 5, 2, 2);
INSERT INTO GIMNASIO (id_gimnasio, mancuernas, discos, maquinas, dispositivos_electronicos, bano) VALUES (3, 30, 40, 12, 4, 3);
INSERT INTO GIMNASIO (id_gimnasio, mancuernas, discos, maquinas, dispositivos_electronicos, bano) VALUES (4, 10, 14, 4, 1, 1);
INSERT INTO GIMNASIO (id_gimnasio, mancuernas, discos, maquinas, dispositivos_electronicos, bano) VALUES (5, 16, 24, 7, 2, 2);

-- SOCIO
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio) VALUES (1, 'Lucas', 'Herrera', 28, '2025-03-10', 33100201, 1);
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio) VALUES (2, 'Valentina', 'Ortiz', 34, '2024-08-05', 29800302, 1);
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio) VALUES (3, 'Tomás', 'Aguirre', 19, '2026-02-14', 46200403, 2);
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio) VALUES (4, 'Marina', 'Sosa', 45, '2023-11-20', 21500504, 1);
INSERT INTO SOCIO (id_socio, nombre, apellido, edad, fecha_ingreso, dni, id_gimnasio) VALUES (5, 'Joaquín', 'Pereyra', 23, '2026-05-02', 42300605, 3);

-- PERSONAL
INSERT INTO PERSONAL (id_personal, nombre, apellido, dni, certificado, id_gimnasio) VALUES (1, 'Rodrigo', 'Vega', 31200101, 'Profesorado de Educación Física', 1);
INSERT INTO PERSONAL (id_personal, nombre, apellido, dni, certificado, id_gimnasio) VALUES (2, 'Natalia', 'Cruz', 32300202, 'Instructora de musculación', 1);
INSERT INTO PERSONAL (id_personal, nombre, apellido, dni, certificado, id_gimnasio) VALUES (3, 'Sergio', 'Ledesma', 28400303, NULL, 2);
INSERT INTO PERSONAL (id_personal, nombre, apellido, dni, certificado, id_gimnasio) VALUES (4, 'Julieta', 'Ramos', 35500404, 'Técnica en entrenamiento funcional', 3);
INSERT INTO PERSONAL (id_personal, nombre, apellido, dni, certificado, id_gimnasio) VALUES (5, 'Hernán', 'Paz', 27600505, NULL, 4);

-- PERSONAL_ROL
INSERT INTO PERSONAL_ROL (id_personal_rol, rol, id_personal) VALUES (1, 'Entrenador personal', 1);
INSERT INTO PERSONAL_ROL (id_personal_rol, rol, id_personal) VALUES (2, 'Entrenadora personal', 2);
INSERT INTO PERSONAL_ROL (id_personal_rol, rol, id_personal) VALUES (3, 'Recepcionista', 3);
INSERT INTO PERSONAL_ROL (id_personal_rol, rol, id_personal) VALUES (4, 'Entrenadora personal', 4);
INSERT INTO PERSONAL_ROL (id_personal_rol, rol, id_personal) VALUES (5, 'Mantenimiento', 5);
INSERT INTO PERSONAL_ROL (id_personal_rol, rol, id_personal) VALUES (6, 'Entrenador personal', 3);

-- ATENCION (cada empleado atiende socios de su mismo local)
INSERT INTO ATENCION (id_atencion, id_personal, id_socio) VALUES (1, 1, 1);
INSERT INTO ATENCION (id_atencion, id_personal, id_socio) VALUES (2, 1, 2);
INSERT INTO ATENCION (id_atencion, id_personal, id_socio) VALUES (3, 1, 4);
INSERT INTO ATENCION (id_atencion, id_personal, id_socio) VALUES (4, 2, 2);
INSERT INTO ATENCION (id_atencion, id_personal, id_socio) VALUES (5, 2, 4);
INSERT INTO ATENCION (id_atencion, id_personal, id_socio) VALUES (6, 3, 3);
INSERT INTO ATENCION (id_atencion, id_personal, id_socio) VALUES (7, 4, 5);

-- PLAN
INSERT INTO PLAN (id_plan, cant_dias, descuento, horario, objetivo, id_socio) VALUES (1, 2, 0, '18:00 a 19:00', 'Ganar masa muscular', 1);
INSERT INTO PLAN (id_plan, cant_dias, descuento, horario, objetivo, id_socio) VALUES (2, 1, 10, '07:00 a 08:00', 'Bajar de peso', 2);
INSERT INTO PLAN (id_plan, cant_dias, descuento, horario, objetivo, id_socio) VALUES (3, 1, 0, '20:00 a 21:00', NULL, 3);
INSERT INTO PLAN (id_plan, cant_dias, descuento, horario, objetivo, id_socio) VALUES (4, 1, 15, '10:00 a 11:00', 'Mejorar movilidad', 4);
INSERT INTO PLAN (id_plan, cant_dias, descuento, horario, objetivo, id_socio) VALUES (5, 2, 5, '19:00 a 20:00', 'Ganar masa muscular', 5);

-- PLAN_RUTINA
INSERT INTO PLAN_RUTINA (id_plan_rutina, dia, rutina, id_plan) VALUES (1, 'Lunes', 'Fuerza tren superior', 1);
INSERT INTO PLAN_RUTINA (id_plan_rutina, dia, rutina, id_plan) VALUES (2, 'Miércoles', 'Piernas y glúteos', 1);
INSERT INTO PLAN_RUTINA (id_plan_rutina, dia, rutina, id_plan) VALUES (3, 'Martes', 'Cardio y funcional', 2);
INSERT INTO PLAN_RUTINA (id_plan_rutina, dia, rutina, id_plan) VALUES (4, 'Miércoles', 'Rutina general', 3);
INSERT INTO PLAN_RUTINA (id_plan_rutina, dia, rutina, id_plan) VALUES (5, 'Viernes', 'Movilidad y fuerza', 4);
INSERT INTO PLAN_RUTINA (id_plan_rutina, dia, rutina, id_plan) VALUES (6, 'Jueves', 'Hipertrofia pecho y espalda', 5);
INSERT INTO PLAN_RUTINA (id_plan_rutina, dia, rutina, id_plan) VALUES (7, 'Sábado', 'Hipertrofia piernas', 5);

-- CUOTA
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan) VALUES (1, 'Efectivo', 30000, '2026-10-10', 0, '2026-10-08', 1);
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan) VALUES (2, 'Transferencia', 30000, '2026-11-10', 0, '2026-11-09', 1);
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan) VALUES (3, 'Transferencia', 40500, '2026-10-10', 10, '2026-10-14', 2);
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan) VALUES (4, NULL, 40500, '2026-11-10', 0, NULL, 2);
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan) VALUES (5, 'Efectivo', 20000, '2026-11-10', 0, '2026-11-05', 3);
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan) VALUES (6, NULL, 20000, '2026-10-10', 10, NULL, 3);
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan) VALUES (7, 'Transferencia', 25500, '2026-11-10', 0, '2026-11-08', 4);
INSERT INTO CUOTA (id_cuota, metodo_pago, precio, plazo_pago, porcentaje_anadido, fecha_pago, id_plan) VALUES (8, 'Efectivo', 36000, '2026-11-10', 0, '2026-11-03', 5);
