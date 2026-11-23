# 4.4. Relaciones entre entidades

## 1. ¿Por qué existen relaciones?

Una aplicación real no almacena siempre objetos aislados. Un pedido pertenece a un cliente y contiene líneas; una categoría puede agrupar productos. El ORM permite representar esas asociaciones como referencias y colecciones Java.

## 2. Cardinalidades

| Relación | Anotación | Ejemplo |
|---|---|---|
| Uno a uno | `@OneToOne` | Usuario y perfil |
| Muchos a uno | `@ManyToOne` | Varios pedidos de un cliente |
| Uno a muchos | `@OneToMany` | Cliente y sus pedidos |
| Muchos a muchos | `@ManyToMany` | Estudiantes y cursos |

## 3. Ejemplo: producto y categoría

```java
@Entity
public class Categoria {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nombre;

    protected Categoria() { }
}
```

En la clase `Producto`:

```java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "categoria_id")
private Categoria categoria;
```

La tabla `productos` tendrá una clave foránea `categoria_id`. En una relación bidireccional, `mappedBy` indica cuál es el lado inverso; **la clave foránea la controla el lado propietario**.

## 4. Cascadas y eliminación de huérfanos

`cascade` propaga determinadas operaciones a entidades relacionadas. `orphanRemoval = true` puede eliminar registros hijos cuando dejan de pertenecer a la relación. No deben añadirse por comodidad: hay que pensar qué debe ocurrir con los datos reales.

## 5. Herencia

Hibernate y JPA permiten representar jerarquías de clases mediante estrategias como `SINGLE_TABLE`, `JOINED` y `TABLE_PER_CLASS`. Cada una tiene implicaciones en el esquema y las consultas. En esta unidad basta con identificar cuándo conviene usar herencia y cuándo es preferible una relación.

## 6. Actividad

Un pedido pertenece a un cliente y un cliente puede tener muchos pedidos. ¿Dónde pondrías la clave foránea?

??? success "Solución"
    En la tabla `pedidos`, por ejemplo `cliente_id`. En Java, el lado propietario suele representarse mediante `@ManyToOne` en `Pedido`.

**Referencias:** `4.1_Relaciones_Entidades.pdf` y `4.2_Relaciones_Generalización-Especialización.pdf`.
