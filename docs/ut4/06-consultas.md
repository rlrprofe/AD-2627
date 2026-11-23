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
