-- ============================================================
-- Trabajo integrador - Base de Datos I
-- Caso: gimnasio de barrio (socios, planes y cuotas)
-- Script 01: creación de la base de datos
-- SGBD: SQLite (probado con la versión 3.46.1)
-- ============================================================

-- En SQLite las claves foráneas se controlan solo si se activa esta opción
PRAGMA foreign_keys = ON;

-- Se borran las tablas en orden inverso a sus dependencias,
-- para poder volver a ejecutar el script desde cero.
DROP TABLE IF EXISTS CUOTA;
DROP TABLE IF EXISTS ATENCION;
DROP TABLE IF EXISTS PLAN_RUTINA;
DROP TABLE IF EXISTS PLAN;
DROP TABLE IF EXISTS PERSONAL_ROL;
DROP TABLE IF EXISTS PERSONAL;
DROP TABLE IF EXISTS SOCIO;
DROP TABLE IF EXISTS GIMNASIO;

-- ------------------------------------------------------------
-- GIMNASIO: local donde se brinda el servicio y su equipamiento.
-- Las cantidades no pueden ser negativas.
-- ------------------------------------------------------------
CREATE TABLE GIMNASIO (
    id_gimnasio               INTEGER PRIMARY KEY,
    mancuernas                INTEGER NOT NULL DEFAULT 0 CHECK (mancuernas >= 0),
    discos                    INTEGER NOT NULL DEFAULT 0 CHECK (discos >= 0),
    maquinas                  INTEGER NOT NULL DEFAULT 0 CHECK (maquinas >= 0),
    dispositivos_electronicos INTEGER NOT NULL DEFAULT 0 CHECK (dispositivos_electronicos >= 0),
    bano                      INTEGER NOT NULL DEFAULT 0 CHECK (bano >= 0)
);

-- ------------------------------------------------------------
-- SOCIO: persona inscripta. El DNI no se puede repetir.
-- ON DELETE RESTRICT: no se puede borrar un gimnasio que tenga socios.
-- ON UPDATE CASCADE: si cambia el id del gimnasio, se actualiza en sus socios.
-- ------------------------------------------------------------
CREATE TABLE SOCIO (
    id_socio      INTEGER PRIMARY KEY,
    nombre        VARCHAR(50) NOT NULL,
    apellido      VARCHAR(50) NOT NULL,
    edad          INTEGER NOT NULL CHECK (edad BETWEEN 12 AND 99),
    fecha_ingreso DATE NOT NULL,
    dni           INTEGER NOT NULL UNIQUE CHECK (dni BETWEEN 1000000 AND 99999999),
    id_gimnasio   INTEGER NOT NULL,
    FOREIGN KEY (id_gimnasio) REFERENCES GIMNASIO (id_gimnasio)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- PERSONAL: empleados del gimnasio. El certificado es opcional.
-- ------------------------------------------------------------
CREATE TABLE PERSONAL (
    id_personal INTEGER PRIMARY KEY,
    nombre      VARCHAR(50) NOT NULL,
    apellido    VARCHAR(50) NOT NULL,
    dni         INTEGER NOT NULL UNIQUE CHECK (dni BETWEEN 1000000 AND 99999999),
    certificado VARCHAR(100),
    id_gimnasio INTEGER NOT NULL,
    FOREIGN KEY (id_gimnasio) REFERENCES GIMNASIO (id_gimnasio)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- PERSONAL_ROL: nace del atributo multivaluado "rol".
-- Un empleado puede tener varios roles, y no puede repetir el mismo rol.
-- ON DELETE CASCADE: los roles no tienen sentido sin el empleado.
-- ------------------------------------------------------------
CREATE TABLE PERSONAL_ROL (
    id_personal_rol INTEGER PRIMARY KEY,
    rol             VARCHAR(30) NOT NULL,
    id_personal     INTEGER NOT NULL,
    FOREIGN KEY (id_personal) REFERENCES PERSONAL (id_personal)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (id_personal, rol)
);

-- ------------------------------------------------------------
-- ATENCION: tabla intermedia que resuelve la relación N:M ATIENDE
-- entre PERSONAL y SOCIO. Cada fila es un par empleado-socio.
-- Un empleado atiende a varios socios y un socio puede ser atendido por varios empleados.
-- UNIQUE evita repetir el mismo par.
-- ON DELETE CASCADE: la atención no tiene sentido sin el empleado o sin el socio.
-- ------------------------------------------------------------
CREATE TABLE ATENCION (
    id_atencion INTEGER PRIMARY KEY,
    id_personal INTEGER NOT NULL,
    id_socio    INTEGER NOT NULL,
    FOREIGN KEY (id_personal) REFERENCES PERSONAL (id_personal)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_socio) REFERENCES SOCIO (id_socio)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (id_personal, id_socio)
);

-- ------------------------------------------------------------
-- PLAN: plan exclusivo de cada socio (relación 1:1, por eso id_socio es UNIQUE).
-- ON DELETE RESTRICT: no se puede borrar un socio que tenga plan.
-- ------------------------------------------------------------
CREATE TABLE PLAN (
    id_plan   INTEGER PRIMARY KEY,
    cant_dias INTEGER NOT NULL CHECK (cant_dias BETWEEN 1 AND 7),
    descuento DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (descuento BETWEEN 0 AND 100),
    horario   VARCHAR(50) NOT NULL,
    objetivo  VARCHAR(100),
    id_socio  INTEGER NOT NULL UNIQUE,
    FOREIGN KEY (id_socio) REFERENCES SOCIO (id_socio)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- PLAN_RUTINA: nace del atributo multivaluado "rutina".
-- Una rutina por cada día de entrenamiento del plan.
-- ------------------------------------------------------------
CREATE TABLE PLAN_RUTINA (
    id_plan_rutina INTEGER PRIMARY KEY,
    dia            VARCHAR(10) NOT NULL
                   CHECK (dia IN ('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo')),
    rutina         VARCHAR(100) NOT NULL,
    id_plan        INTEGER NOT NULL,
    FOREIGN KEY (id_plan) REFERENCES PLAN (id_plan)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (id_plan, dia)
);

-- ------------------------------------------------------------
-- CUOTA: cuota mensual de un plan.
-- precio es el importe cobrado ese mes (queda guardado aunque el plan cambie).
-- Hasta que la cuota se paga, metodo_pago y fecha_pago están vacíos;
-- cuando se paga, se completan los dos juntos (por eso el último CHECK).
-- ON DELETE RESTRICT: no se puede borrar un plan con cuotas (se conserva el historial).
-- ------------------------------------------------------------
CREATE TABLE CUOTA (
    id_cuota           INTEGER PRIMARY KEY,
    metodo_pago        VARCHAR(20) CHECK (metodo_pago IN ('Efectivo','Transferencia','Tarjeta')),
    precio             DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    plazo_pago         DATE NOT NULL,
    porcentaje_anadido DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (porcentaje_anadido BETWEEN 0 AND 100),
    fecha_pago         DATE,
    id_plan            INTEGER NOT NULL,
    FOREIGN KEY (id_plan) REFERENCES PLAN (id_plan)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK ((metodo_pago IS NULL) = (fecha_pago IS NULL))
);

-- ------------------------------------------------------------
-- Índices (además de los que SQLite crea solo para PRIMARY KEY y UNIQUE)
-- ------------------------------------------------------------
-- Acelera: cuotas de un plan ordenadas por vencimiento (historial de un socio).
CREATE INDEX idx_cuota_plan_plazo ON CUOTA (id_plan, plazo_pago);

-- Acelera: ingresos por mes y búsqueda de cuotas sin pagar (fecha_pago IS NULL).
CREATE INDEX idx_cuota_fecha_pago ON CUOTA (fecha_pago);

-- Acelera: listar los socios de un local y los JOIN entre SOCIO y GIMNASIO.
CREATE INDEX idx_socio_gimnasio ON SOCIO (id_gimnasio);

-- Acelera: buscar un socio por apellido y nombre.
CREATE INDEX idx_socio_apellido_nombre ON SOCIO (apellido, nombre);
