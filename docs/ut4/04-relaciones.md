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

## Estudio de los ejemplos originales de asociaciones

El PDF **4.1** desarrolla las asociaciones 1:1, 1:N y N:M. Para cada una hay un proyecto separado. Es preferible **ejecutarlos por separado**, porque cada uno representa una estructura de tablas y unas reglas de asociación distintas.


### Proyecto: `jpa-demo-relacion-1a1`

**[Descargar proyecto Maven Java 21](../descargas/ut4/04-relaciones/jpa-demo-relacion-1a1-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** `Persona` y `Dni`; identifica `@OneToOne`, `@JoinColumn` y el lado propietario.

**Clases de referencia:** `DemoRelacion1a1`, `JPAUtil`, `Dni`, `Persona`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

### Proyecto: `jpa-demo-relacion-1aN`

**[Descargar proyecto Maven Java 21](../descargas/ut4/04-relaciones/jpa-demo-relacion-1aN-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** `Cliente` y `Pedido`; compara `@OneToMany`, `@ManyToOne` y `mappedBy`.

**Clases de referencia:** `DemoRelacion1aN`, `JPAUtil`, `Cliente`, `Pedido`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

### Proyecto: `jpa-demo-relacion-NaN`

**[Descargar proyecto Maven Java 21](../descargas/ut4/04-relaciones/jpa-demo-relacion-NaN-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** `Alumno` y `Asignatura`; observa la tabla intermedia y la asociación `@ManyToMany`.

**Clases de referencia:** `DemoRelacionNaN`, `JPAUtil`, `Alumno`, `Asignatura`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

## Generalización y especialización: los cuatro proyectos del PDF 4.2

La herencia de clases **no es lo mismo que una asociación entre entidades**. En el documento se utiliza el ejemplo `Persona`, `Alumno` y `Profesor` para comparar las estrategias de mapeo.

| Estrategia | Representación | Consecuencia principal |
|---|---|---|
| `SINGLE_TABLE` | Una tabla con discriminador | Estructura sencilla, columnas opcionales |
| `JOINED` | Tabla base y tablas especializadas | Consultas con uniones |
| `TABLE_PER_CLASS` | Tabla por clase concreta | Posibles consultas `UNION` |
| `@MappedSuperclass` | Herencia de atributos sin tabla para la clase base | La clase base no es una entidad consultable |


### Proyecto: `jpa-herencia-single-table`

**[Descargar proyecto Maven Java 21](../descargas/ut4/04-relaciones/jpa-herencia-single-table-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** la anotación `@Inheritance` y la columna discriminadora.

**Clases de referencia:** `Main`, `Alumno`, `Persona`, `Profesor`, `JPAUtil`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

### Proyecto: `jpa-herencia-joined`

**[Descargar proyecto Maven Java 21](../descargas/ut4/04-relaciones/jpa-herencia-joined-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** las tablas para `Persona`, `Alumno` y `Profesor` y cómo se enlazan.

**Clases de referencia:** `Main`, `Alumno`, `Persona`, `Profesor`, `JPAUtil`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

### Proyecto: `jpa-herencia-table-per-class`

**[Descargar proyecto Maven Java 21](../descargas/ut4/04-relaciones/jpa-herencia-table-per-class-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** cómo se distribuyen los atributos heredados entre las tablas concretas.

**Clases de referencia:** `Main`, `Alumno`, `Persona`, `Profesor`, `JPAUtil`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

### Proyecto: `jpa-mappedsuperclass`

**[Descargar proyecto Maven Java 21](../descargas/ut4/04-relaciones/jpa-mappedsuperclass-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** qué atributos heredan `Alumno` y `Profesor` de `PersonaBase` sin que esta sea una entidad.

**Clases de referencia:** `Main`, `Alumno`, `PersonaBase`, `Profesor`, `JPAUtil`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

## Ejercicios originales del PDF 4.3

**Ejercicio 1.** Implementa `Empleado` y `TarjetaAcceso` con relación 1:1 bidireccional. Decide quién posee la clave foránea, utiliza `mappedBy` en el lado inverso y comprueba el efecto de `cascade` al crear y eliminar.

??? success "Orientación de solución"
    Sitúa `@JoinColumn` en el lado propietario y `mappedBy` en el inverso. Si deseas que al persistir `Empleado` se persista su tarjeta, configura la cascada correspondiente. Comprueba que ambas referencias Java están sincronizadas.

**Ejercicio 2.** Diseña la relación entre un `Curso` y sus `Modulo` asociados, como se plantea en el documento original.

??? success "Orientación de solución"
    Un `Modulo` pertenece a un `Curso` (`@ManyToOne`) y un `Curso` agrupa varios módulos (`@OneToMany(mappedBy=...)`). La clave foránea se almacena normalmente en la tabla de módulos.


## Documentación teórica original de referencia

- [Consultar PDF: 4.1_Relaciones_Entidades](../descargas/ut4/teoria/4.1_Relaciones_Entidades.pdf)
- [Consultar PDF: 4.2_Relaciones_Generalización-Especializacion](../descargas/ut4/teoria/4.2_Relaciones_Generalización-Especializacion.pdf)
- [Consultar PDF: 4.3_Ejercicios](../descargas/ut4/teoria/4.3_Ejercicios.pdf)
