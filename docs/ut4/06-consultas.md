# 4.6. Consultas HQL, JPQL y SQL nativo

## 1. ¿Qué consultamos con HQL?

HQL (*Hibernate Query Language*) permite consultar **entidades y sus propiedades**, en vez de escribir únicamente nombres físicos de tablas y columnas. JPQL es el lenguaje de consultas estándar de Jakarta Persistence; HQL es el lenguaje de Hibernate y ofrece capacidades adicionales.

SQL:

```sql
SELECT * FROM productos WHERE precio >= 20;
```

JPQL/HQL:

```sql
SELECT p FROM Producto p WHERE p.precio >= :minimo
```

Observa que `Producto` es el **nombre de la entidad Java** y `precio` su propiedad.

## 2. Consulta parametrizada

```java
List<Producto> productos = em.createQuery(
        "SELECT p FROM Producto p WHERE p.precio >= :minimo ORDER BY p.nombre",
        Producto.class)
    .setParameter("minimo", 20.0)
    .getResultList();
```

Los parámetros evitan concatenar valores en el texto de la consulta. También facilitan reutilizarla.

## 3. Consultar un único resultado

```java
List<Producto> encontrados = em.createQuery(
        "SELECT p FROM Producto p WHERE p.nombre = :nombre",
        Producto.class)
    .setParameter("nombre", "Teclado")
    .getResultList();
```

Si esperamos cero o un resultado, debemos decidir cómo tratar ambos casos. Una lista evita asumir que siempre habrá un producto.

## 4. SQL nativo: criterio RA3 f)

La programación exige **desarrollar aplicaciones que realizan consultas usando SQL**. Por ello no nos limitaremos a HQL: también practicaremos consultas SQL nativas a través del ORM.

```java
List<?> filas = em.createNativeQuery(
        "SELECT nombre, precio FROM productos WHERE precio >= :minimo")
    .setParameter("minimo", 20.0)
    .getResultList();
```

Los resultados de una consulta SQL nativa que selecciona varias columnas pueden llegar como filas de valores (`Object[]`), según la consulta y el proveedor. En el proyecto se incluye una consulta nativa de recuento para mostrar un caso sencillo.

## 5. Actividad

Corrige esta consulta:

```java
"SELECT * FROM Producto WHERE precio > " + minimo
```

??? success "Solución"
    Para JPQL/HQL: `SELECT p FROM Producto p WHERE p.precio > :minimo` y después `setParameter("minimo", minimo)`. `SELECT *` corresponde a SQL, no a una selección de entidad JPQL.

**Referencia:** `6.1_HQL.pdf`.

## Ejemplo del PDF: consultas JPQL sobre clientes y pedidos

El documento original comienza comparando SQL con HQL/JPQL: **SQL consulta tablas y columnas; JPQL consulta entidades y propiedades Java**. También explica los alias, la navegación por relaciones, los parámetros y las consultas tipadas.


### Proyecto: `jpa-demo-jpql-consultas-mysql`

**[Descargar proyecto Maven Java 21](../descargas/ut4/06-consultas/jpa-demo-jpql-consultas-mysql-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** `DemoConsultasJPQL`, `SeedDao`, `Cliente` y `Pedido`; analiza cada consulta y el tipo de resultado.

**Clases de referencia:** `DemoConsultasJPQL`, `SeedDao`, `Cliente`, `Pedido`, `JPAUtil`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

### Recorrido de aprendizaje

1. Ejecuta la preparación de datos del ejemplo (`SeedDao`) después de configurar una base de pruebas.
2. Abre `DemoConsultasJPQL.java` y localiza consultas que devuelven entidades completas.
3. Identifica los alias (`c`, `p` u otros) y las propiedades Java utilizadas.
4. Busca consultas con `WHERE`, `ORDER BY`, parámetros y navegación por asociaciones.
5. Contrasta una consulta JPQL con su equivalente SQL sobre las tablas.

### SQL nativo y el CE f) del RA3

Aunque el documento se centra en HQL/JPQL, la programación 2026-2027 también exige evidencias de **consultas SQL**. Añade al ejemplo una consulta SQL nativa ejecutada desde `EntityManager` y explica qué devuelve.

```java
Object total = em.createNativeQuery(
        "SELECT COUNT(*) FROM clientes").getSingleResult();
System.out.println("Clientes: " + total);
```

??? success "Actividad"
    JPQL: `SELECT c FROM Cliente c ORDER BY c.nombre` consulta la entidad `Cliente`. SQL nativo: `SELECT * FROM clientes ORDER BY nombre` consulta directamente la tabla.


## Documentación teórica original de referencia

- [Consultar PDF: 6.1_HQL](../descargas/ut4/teoria/6.1_HQL.pdf)
