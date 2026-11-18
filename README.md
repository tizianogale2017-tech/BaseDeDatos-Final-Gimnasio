# Base de Datos I - Trabajo final: gimnasio de barrio

Universidad Champagnat · Analista Programador Universitario · Base de Datos I · Prof. Lic. Ignacio G. Fontaine Digier

Autores: Tiziano Galetto y Teo Contreras

Base de datos de un gimnasio de barrio (caso real): socios, planes, cuotas, personal y las atenciones que da cada empleado. Gestor: SQLite 3.46.1.

## Contenido

| Carpeta o archivo | Qué es |
|---|---|
| `Trabajo final - Gimnasio.pdf` / `.docx` | Documento completo, con las 15 secciones de la consigna |
| `Diagramas/` | DER (notación de Chen) y esquema relacional, en `.png` y `.drawio` (editable) |
| `Normalizacion - Gimnasio.xlsx` | Normalización paso a paso: Forma 0, 1FN, 2FN, 3FN y dependencias |
| `scripts/` y `scripts.zip` | Scripts SQL numerados y la base `gimnasio.db` |

## Modelo

5 entidades (GIMNASIO, SOCIO, PLAN, CUOTA, PERSONAL), 5 relaciones (una N:M, PERSONAL–SOCIO) y 8 tablas en 3FN: GIMNASIO, SOCIO, PLAN, CUOTA, PERSONAL, PERSONAL_ROL, PLAN_RUTINA y ATENCION.

## Cómo ejecutar los scripts

Desde la carpeta `scripts/`, sobre una base vacía y en este orden:

```
sqlite3 gimnasio.db < 01-creacion.sql
sqlite3 gimnasio.db < 02-datos.sql
sqlite3 gimnasio.db < 03-manipulacion.sql
sqlite3 gimnasio.db < 04-consultas.sql
sqlite3 gimnasio.db < 05-pruebas-integridad.sql
```

Los scripts 01 a 04 corren sin errores. El 05 falla a propósito: son 9 pruebas de integridad y cada una muestra el error esperado.
