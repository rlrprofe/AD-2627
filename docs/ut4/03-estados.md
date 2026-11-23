# 4.3. Clases persistentes, sesiones y estados

## 1. ¿Qué es una entidad persistente?

Es un objeto Java cuyo estado puede gestionarse mediante ORM. No todos los objetos de una aplicación son entidades: las clases de vista, controlador y configuración no tienen por qué almacenarse.

## 2. Contexto de persistencia

El `EntityManager` administra un **contexto de persistencia**: mantiene entidades gestionadas, detecta cambios y coordina su sincronización con la base de datos.

| Estado | Significado | Ejemplo |
|---|---|---|
| Nuevo o transitorio | Objeto Java aún no gestionado | `new Producto(...)` |
| Gestionado (*managed*) | Asociado al contexto de persistencia | Después de `persist()` o `find()` |
| Separado (*detached*) | Existió en un contexto, pero ya no está gestionado | Tras cerrar el `EntityManager` |
| Eliminado (*removed*) | Marcado para eliminar | Después de `remove()` |

## 3. Ejemplo comentado

```java
Producto p = new Producto("Ratón", 12.50); // Nuevo
em.getTransaction().begin();
em.persist(p);                              // Gestionado
em.getTransaction().commit();               // Se sincroniza
em.close();                                 // Separado
```

El momento exacto en que se envía SQL puede depender de la estrategia de generación de identificadores, del `flush` y de la transacción.

## 4. Actualización de objetos

Una entidad gestionada puede cambiarse con sus setters. Hibernate detecta el cambio (*dirty checking*) y lo sincroniza cuando corresponde.

```java
Producto p = em.find(Producto.class, 1L);
if (p != null) {
    p.setPrecio(15.0);
}
```

Este código debe ejecutarse en el contexto y transacción adecuados cuando queremos confirmar modificaciones.

## 5. Carga diferida (*lazy loading*)

Una relación configurada como `LAZY` puede no cargarse hasta que se accede a ella. Si cerramos el contexto antes de acceder, podemos encontrarnos con un error. Conviene recuperar los datos necesarios **dentro de la operación de servicio o DAO**, sin dejar que la vista navegue por entidades separadas.

## 6. Actividad

¿Por qué no es recomendable mantener un `EntityManager` abierto durante toda la vida de una aplicación de consola?

??? success "Solución"
    Porque el contexto puede acumular entidades, mantener recursos ocupados y mezclar operaciones independientes. Es preferible delimitarlo por unidad de trabajo y cerrarlo al terminar.

**Referencia:** `3.1_Estados_Clases_persistentes.pdf`.
