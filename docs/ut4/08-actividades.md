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

## Proyecto descargable

- [Proyecto Maven: Gestión de productos con Hibernate/JPA](../descargas/ut4/UT4_Gestion_Productos_Hibernate_Java21_Maven.zip)
- [Plantilla de configuración y guía de ejecución](../descargas/ut4/UT4_Gestion_Productos_Hibernate_Java21_Maven.zip)

!!! warning "Antes de ejecutar"
    Crea la base de datos MySQL, copia `config/bd.properties.example` a `config/bd.properties` y completa tus credenciales. No subas el fichero real al repositorio.

## Evaluación

Según la programación: **40 % prueba objetiva** y **60 % práctica(s)**. La práctica debe permitir evidenciar los CE del RA3 y el componente ORM del RA6.e; puede incluir comprobación individual de funcionamiento y explicación.

!!! note "Material del curso anterior"
    Los PDF y ejemplos de las carpetas 01–07 se han utilizado como referencias para los contenidos. No se incluyen automáticamente todos los proyectos antiguos, porque sus dependencias y configuraciones deben verificarse antes de presentarlos como soluciones actualizadas.
