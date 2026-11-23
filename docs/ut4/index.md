# UT4. Persistencia con ORM (Hibernate)

**Módulo:** Acceso a Datos · 2.º DAM · **2.ª evaluación** · 

En las unidades anteriores hemos trabajado con ficheros, JDBC y componentes de acceso a datos. Ahora aprenderemos a **guardar y recuperar objetos Java en una base de datos relacional** mediante Hibernate. En vez de escribir manualmente cada `INSERT`, `UPDATE` o `DELETE`, describiremos cómo se corresponde una clase Java con una tabla y dejaremos que el ORM gestione muchas operaciones.

!!! info "Resultados de aprendizaje"
    - **RA3 completo (20 % del módulo):** gestiona la persistencia identificando herramientas ORM y desarrollando aplicaciones que las utilizan. Se trabajan los **CE a), b), c), d), e), f) y g)**.
    - **RA6, CE e):** programa componentes que gestionan información usando mapeo objeto-relacional.

## Contenidos de la programación

| Bloque | Qué aprenderemos | 
|---|---|---|
| [4.1. Concepto de ORM](01-introduccion.md) | Persistencia, ventajas y limitaciones frente a JDBC |
| [4.2. Mapeo](02-mapeo.md) | Configuración de Hibernate, XML y anotaciones | 
| [4.3. Clases y estados](03-estados.md) | Entidades, sesiones y estados de persistencia | 
| [4.4. Relaciones](04-relaciones.md) | Asociaciones entre entidades y carga diferida |
| [4.5. CRUD](05-crud.md) | Crear, recuperar, modificar, eliminar y transacciones | 
| [4.6. Consultas HQL](06-consultas.md) | HQL/JPQL, parámetros y consultas SQL nativas | 
| [4.7. Desarrollo con ORM](07-desarrollo.md) | Integración con DAO y pruebas | 
| [4.8. Actividades y descargas](08-actividades.md) | Prácticas guiadas y proyecto integrador |

## Evaluación

La UT4 se evalúa con **prueba objetiva (40 %)** y **práctica o prácticas (60 %)**, según la programación. El RA3 representa el **20 % de la calificación del módulo**. Los siete CE del RA3 tienen el mismo peso dentro de ese RA (aproximadamente 14,28 % cada uno).

La práctica requerirá de un examen oral sobre la entrega realizada. 

## Cómo utilizar estos apuntes

Avanza en orden: comienza por un objeto simple, añade el mapeo, observa sus estados, realiza CRUD y finalmente integra las consultas y el componente DAO. Los fragmentos son didácticos: el **proyecto descargable** reúne las piezas en una aplicación Maven.

!!! warning "Alcance"
    Hibernate nativo (`Session`, `SessionFactory`, XML `hbm.xml`) y Jakarta Persistence (`EntityManager`, anotaciones) son dos vías relacionadas, pero no idénticas. Se explican las dos; el proyecto integrador utiliza **Jakarta Persistence con Hibernate como proveedor**.
