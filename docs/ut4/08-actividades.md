# 4.8. Actividades, proyecto y descargas

## Secuencia de actividades (15 horas)

| Sesiones orientativas | Trabajo | CE |
|---|---|---|
| 1–2 | Repaso JDBC, ORM y configuración de Maven | RA3 a, b |
| 3–4 | Mapeo XML/anotaciones y entidad `Producto` | RA3 c |
| 5–6 | Estados y relaciones | RA3 c, d |
| 7–9 | CRUD y transacciones | RA3 d, e, g |
| 10–11 | HQL/JPQL y consultas SQL nativas | RA3 e, f |
| 12–15 | Integración DAO, pruebas y práctica | RA3 a–g; RA6 e |

## Actividad 1. Mapeo

Crea una entidad `Categoria` y relaciona cada producto con una categoría. Explica cuál es el lado propietario de la relación.

??? success "Pistas y solución orientativa"
    Usa `@ManyToOne` en `Producto` y `@JoinColumn(name="categoria_id")`. Si añades la colección inversa en `Categoria`, utiliza `@OneToMany(mappedBy="categoria")`.

## Actividad 2. CRUD

Implementa alta, búsqueda por ID, actualización del precio y eliminación. Cada escritura debe confirmar o revertir su transacción.

??? success "Pistas"
    Utiliza `persist`, `find`, modificación de entidad gestionada y `remove`. En el bloque `catch`, ejecuta `rollback()` si la transacción sigue activa. Cierra el `EntityManager` en `finally`.

## Actividad 3. Consultas

Crea una consulta HQL parametrizada para filtrar por precio mínimo y una consulta SQL nativa que cuente productos.

??? success "Pistas"
    HQL: `SELECT p FROM Producto p WHERE p.precio >= :minimo`. SQL nativo: `SELECT COUNT(*) FROM productos`.

## Actividad 4. Componente ORM (RA6.e)

Integra `ProductoJpaDAO` detrás de la interfaz `ProductoDAO`, sin escribir código de persistencia en el controlador.

??? success "Comprobación"
    El controlador solo conoce el servicio; el servicio utiliza la interfaz DAO; la implementación ORM utiliza `EntityManager`.

## Catálogo completo de proyectos de ejemplo

Los proyectos proceden de las carpetas `code` del curso anterior y se han organizado siguiendo la teoría original. Cada ZIP conserva el código fuente y el POM, adaptado para Java 21.

| Apartado | Proyecto | Descarga |
|---|---|---|
| 02-mapeo | `demo-hibernate-nativo` | [Descargar ZIP](../descargas/ut4/02-mapeo/demo-hibernate-nativo-Java21.zip) |\n| 02-mapeo | `demo-jackarta-hibernate` | [Descargar ZIP](../descargas/ut4/02-mapeo/demo-jackarta-hibernate-Java21.zip) |\n| 03-estados | `jpa-hibernate-estados-demo` | [Descargar ZIP](../descargas/ut4/03-estados/jpa-hibernate-estados-demo-Java21.zip) |\n| 04-relaciones | `jpa-demo-relacion-1a1` | [Descargar ZIP](../descargas/ut4/04-relaciones/jpa-demo-relacion-1a1-Java21.zip) |\n| 04-relaciones | `jpa-demo-relacion-1aN` | [Descargar ZIP](../descargas/ut4/04-relaciones/jpa-demo-relacion-1aN-Java21.zip) |\n| 04-relaciones | `jpa-demo-relacion-NaN` | [Descargar ZIP](../descargas/ut4/04-relaciones/jpa-demo-relacion-NaN-Java21.zip) |\n| 04-relaciones | `jpa-herencia-single-table` | [Descargar ZIP](../descargas/ut4/04-relaciones/jpa-herencia-single-table-Java21.zip) |\n| 04-relaciones | `jpa-herencia-joined` | [Descargar ZIP](../descargas/ut4/04-relaciones/jpa-herencia-joined-Java21.zip) |\n| 04-relaciones | `jpa-herencia-table-per-class` | [Descargar ZIP](../descargas/ut4/04-relaciones/jpa-herencia-table-per-class-Java21.zip) |\n| 04-relaciones | `jpa-mappedsuperclass` | [Descargar ZIP](../descargas/ut4/04-relaciones/jpa-mappedsuperclass-Java21.zip) |\n| 05-crud | `jpa-demo-crud-estados-mysql` | [Descargar ZIP](../descargas/ut4/05-crud/jpa-demo-crud-estados-mysql-Java21.zip) |\n| 06-consultas | `jpa-demo-jpql-consultas-mysql` | [Descargar ZIP](../descargas/ut4/06-consultas/jpa-demo-jpql-consultas-mysql-Java21.zip) |\n| 07-desarrollo | `jpa-proyecto` | [Descargar ZIP](../descargas/ut4/07-desarrollo/jpa-proyecto-Java21.zip) |\n
!!! warning "Configuración MySQL y validación"
    Los ejemplos incluyen configuraciones de bases de datos diferentes. Antes de ejecutarlos, crea la base correspondiente y sustituye `CAMBIAR_PASSWORD` en el XML de configuración. Los ZIP están preparados como **materiales para revisión**, no como proyectos ya verificados con MySQL. No utilices una base de datos con información importante si el ejemplo tiene `create` o `create-drop`.

## Cómo trabajar con cada proyecto

1. Lee el apartado teórico y descarga el ZIP que aparece en esa misma página.
2. Descomprime el proyecto y abre su carpeta en VS Code.
3. Revisa el `pom.xml`, el XML de configuración y las entidades antes de ejecutar.
4. Ejecuta `mvn clean test` y, si procede, el método `main` de la demostración.
5. Compara los resultados con el PDF y contesta las preguntas del apartado.

## Evaluación

Según la programación: **40 % prueba objetiva** y **60 % práctica(s)**. La práctica debe permitir evidenciar los CE del RA3 y el componente ORM del RA6.e; puede incluir comprobación individual de funcionamiento y explicación.

!!! note "Material del curso anterior"
    Los PDF y ejemplos de las carpetas 01–07 se han utilizado como referencias para los contenidos. No se incluyen automáticamente todos los proyectos antiguos, porque sus dependencias y configuraciones deben verificarse antes de presentarlos como soluciones actualizadas.
