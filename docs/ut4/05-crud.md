# 4.5. Operaciones CRUD y transacciones

## 1. Antes de escribir CRUD

Necesitamos una unidad de persistencia, un `EntityManagerFactory`, un `EntityManager` y, para las operaciones de escritura, una transacción. El `EntityManagerFactory` suele crearse una vez para la aplicación; cada operación abre y cierra su `EntityManager`.

## 2. Crear (CREATE)

```java
EntityTransaction tx = em.getTransaction();
try {
    tx.begin();
    em.persist(new Producto("Teclado", 19.95));
    tx.commit();
} catch (RuntimeException e) {
    if (tx.isActive()) tx.rollback();
    throw e;
}
```

**Por qué hacemos rollback:** si una operación falla, no queremos confirmar cambios parciales. El ejemplo completo del DAO también garantiza el cierre del `EntityManager`.

## 3. Recuperar (READ)

```java
Producto producto = em.find(Producto.class, 1L);
```

`find()` busca por identificador y devuelve `null` si no existe. Para listas y filtros utilizaremos HQL/JPQL en 4.6.

## 4. Modificar (UPDATE)

```java
Producto p = em.find(Producto.class, 1L);
if (p != null) {
    p.setPrecio(24.95);
}
```

Dentro de una transacción, los cambios de una entidad gestionada se sincronizan al confirmar. Si la entidad está separada, `merge()` permite copiar su estado a una entidad gestionada.

## 5. Eliminar (DELETE)

```java
Producto p = em.find(Producto.class, 1L);
if (p != null) {
    em.remove(p);
}
```

`remove()` requiere una entidad gestionada y, normalmente, una transacción activa.

## 6. Cierre seguro

`EntityManager` debe cerrarse al terminar. En el proyecto se utiliza un bloque `finally`, porque el código mantiene un estilo compatible con el ciclo de vida habitual de JPA. En JDBC, en cambio, ya utilizamos `try-with-resources` para `Connection`, `PreparedStatement` y `ResultSet`.

## 7. Actividad

¿Qué sucede si realizas dos cambios y el segundo falla antes del `commit()`?

??? success "Solución"
    Si ambos pertenecen a una única transacción y ejecutamos `rollback()`, ninguno debe quedar confirmado. Si los confirmamos en transacciones distintas, el primero podría permanecer.

**Referencia:** `5.1_Operaciones_CRUD.pdf`.

## Ejemplo completo del PDF: CRUD y estados con MySQL

El documento original empieza explicando por qué `EntityManagerFactory`, `EntityManager`, contexto de persistencia y `EntityTransaction` son piezas diferentes. A continuación estudia **CREATE, READ, UPDATE y DELETE**, incluyendo `persist`, `find`, detección de cambios (*dirty checking*), `merge` y `remove`.


### Proyecto: `jpa-demo-crud-estados-mysql`

**[Descargar proyecto Maven Java 21](../descargas/ut4/05-crud/jpa-demo-crud-estados-mysql-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** `CrudEstadosDemo`, `ClienteDao`, `Cliente` y `Pedido`. Sigue las transacciones y observa el estado de las entidades.

**Clases de referencia:** `CrudEstadosDemo`, `ClienteDao`, `Cliente`, `Pedido`, `JPAUtil`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

### Guía de lectura del código

1. **Preparación:** abre `pom.xml` y `META-INF/persistence.xml`.
2. **Utilidad JPA:** abre `JPAUtil.java` y busca cómo se crea `EntityManagerFactory`.
3. **DAO:** en `ClienteDao.java` localiza los métodos que realizan altas, búsquedas, modificaciones y bajas.
4. **Demostración:** sigue `CrudEstadosDemo.java` y anota qué operaciones requieren transacción.
5. **Errores:** identifica dónde se realiza `rollback()` si falla una escritura.

### Actividad de ampliación

Modifica el ejemplo para que no se permita un nombre vacío al crear un cliente. ¿Dónde situarías la validación en una aplicación por capas?

??? success "Orientación"
    La regla de negocio debe situarse preferentemente en el servicio o en una capa de validación, no en la vista ni mezclada con el código de conexión del DAO.


## Documentación teórica original de referencia

- [Consultar PDF: 5.1_Operaciones_CRUD](../descargas/ut4/teoria/5.1_Operaciones_CRUD.pdf)
