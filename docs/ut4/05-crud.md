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
