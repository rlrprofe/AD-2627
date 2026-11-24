# 4.2. Configuración de Hibernate y mapeo objeto-relacional

## Objetivos

Instalar la herramienta mediante Maven, configurarla y comprender el mapeo mediante **ficheros XML** y **anotaciones**. Criterios **RA3 a), b), c)**.

## 1. Dos enfoques que debemos distinguir

**Hibernate nativo** utiliza `SessionFactory`, `Session` y puede definir el mapeo con archivos `*.hbm.xml`.


**Jakarta Persistence** utiliza `EntityManagerFactory`, `EntityManager` y habitualmente anotaciones `@Entity`, `@Id`, etc. Hibernate puede ser el proveedor de Jakarta Persistence.

No debemos mezclar ejemplos sin explicar qué API utiliza cada uno.

## 2. Preparar un proyecto Maven (Java 21)

En `pom.xml` configuramos Java 21 e incluimos Hibernate, el controlador MySQL y las dependencias de prueba. El proyecto completo está en Descargas.

```xml
<properties>
    <maven.compiler.release>21</maven.compiler.release>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>
```

Maven descarga las dependencias al compilar. **Instalar Hibernate** en este contexto significa incorporarlo al proyecto como dependencia y comprobar que Maven la resuelve.

## 3. Mapeo mediante anotaciones

```java
@Entity
@Table(name = "productos")
public class Producto {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(nullable = false)
    private double precio;

    protected Producto() { } // Constructor requerido por JPA

    public Producto(String nombre, double precio) {
        this.nombre = nombre;
        this.precio = precio;
    }
    // Getters y setters
}
```

`@Entity` identifica una clase persistente; `@Table` indica su tabla; `@Id` señala la clave primaria; `@GeneratedValue` indica cómo se obtiene su valor; `@Column` personaliza la columna. El ORM requiere una forma de construir la entidad y acceder a sus atributos.

## 4. Configuración de Jakarta Persistence

El archivo `src/main/resources/META-INF/persistence.xml` define la **unidad de persistencia** y el proveedor. Para evitar publicar contraseñas, en el proyecto descargable las credenciales se leen desde un fichero local `config/bd.properties` y se suministran al crear `EntityManagerFactory`.

!!! warning "Seguridad"
    Nunca publiques `bd.properties` con una contraseña real. Utiliza `bd.properties.example` como plantilla y excluye el fichero privado de Git.

## 5. Mapeo con ficheros XML en Hibernate nativo

En los apuntes del curso anterior se trabaja también `hibernate.cfg.xml` junto con `Producto.hbm.xml`. Un fichero de mapeo describe la clase, la tabla, el identificador y las propiedades sin anotarlas directamente en Java.

Ejemplo **conceptual**:

```xml
<class name="com.ejemplo.Producto" table="productos">
    <id name="id" column="id">
        <generator class="identity"/>
    </id>
    <property name="nombre" column="nombre"/>
    <property name="precio" column="precio"/>
</class>
```

!!! note "Diferencias de versiones"
    La sintaxis y el soporte de determinadas configuraciones XML pueden variar entre versiones de Hibernate. Los ejemplos antiguos se conservan como referencia teórica; el proyecto principal actualizado utiliza anotaciones Jakarta Persistence.

## 6. Actividad

¿Qué cambiarías si la columna de la tabla se llamase `descripcion` pero el atributo Java se llamase `nombre`?

??? success "Solución"
    `@Column(name = "descripcion")` en el atributo `nombre`. No hace falta renombrar el atributo Java.

**Referencias:** `2.1 Mapeo OMR con Hibernate nativo.pdf` y `2.2 Mapeo OMR JakartaPersistence.pdf`.

## Recorrido guiado por los dos proyectos del PDF

El documento **2.1** enseña Hibernate nativo mediante un proyecto organizado en modelo, DAO, servicio, controlador y vista. La idea central es que los objetos Java no necesitan anotaciones de persistencia cuando su correspondencia se declara en archivos `*.hbm.xml`.

### Hibernate nativo: piezas que debes localizar

- **`Configuration`** lee la configuración y los mapeos.
- **`SessionFactory`** se construye normalmente una vez y permite crear sesiones.
- **`Session`** representa la unidad de trabajo con Hibernate.
- **`Transaction`** delimita cambios que deben confirmarse o revertirse.
- **`hibernate.cfg.xml`** configura la conexión y declara los mapeos.
- **`Cliente.hbm.xml`, `Producto.hbm.xml`, `Pedido.hbm.xml`** describen la relación clase-tabla.

Sigue este orden: abre `pom.xml`; localiza `hibernate.cfg.xml`; compara `Cliente.java` con `Cliente.hbm.xml`; abre `HibernateUtil.java`; después sigue una operación desde `MenuView` hasta `ClienteDao`. No intentes entender todas las capas a la vez.


### Proyecto: `demo-hibernate-nativo`

**[Descargar proyecto Maven Java 21](../descargas/ut4/02-mapeo/demo-hibernate-nativo-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** cómo se conectan `Session`, `SessionFactory`, `hibernate.cfg.xml` y los archivos de mapeo XML.

**Clases de referencia:** `App`, `ClienteController`, `PedidoController`, `ProductoController`, `ClienteDao`, `PedidoDao`, `ProductoDao`, `Cliente`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

### Jakarta Persistence: la misma idea con otra API

El documento **2.2** utiliza el mismo dominio de clientes, productos y pedidos, pero ahora las entidades se describen mediante anotaciones de `jakarta.persistence.*`. La configuración principal se encuentra en `META-INF/persistence.xml`.

El cambio fundamental no es la base de datos, sino la **API de trabajo**: `EntityManagerFactory` y `EntityManager` sustituyen al uso directo de `SessionFactory` y `Session` en los ejemplos. Hibernate sigue actuando como proveedor ORM.


### Proyecto: `demo-jackarta-hibernate`

**[Descargar proyecto Maven Java 21](../descargas/ut4/02-mapeo/demo-jackarta-hibernate-Java21.zip)**

Este es el ejemplo asociado a la teoría del curso anterior. **Qué debes observar:** las anotaciones de `Cliente`, `Producto` y `Pedido`, `persistence.xml` y la clase `JPAUtil`.

**Clases de referencia:** `App`, `ClienteController`, `PedidoController`, `ProductoController`, `ClienteDao`, `PedidoDao`, `ProductoDao`, `Cliente`.

!!! warning "Preparación y límites de la revisión"
    El proyecto conserva su estructura y dependencias del curso anterior. Se ha cambiado la configuración de compilación a Java 21 y se han sustituido las contraseñas de ejemplo por `CAMBIAR_PASSWORD`. Debes preparar la base MySQL correspondiente. **No se ha verificado todavía la ejecución real con MySQL ni la compilación Maven**.

### Actividad comparativa

Abre ambos proyectos y completa:

| Pregunta | Hibernate nativo | Jakarta Persistence |
|---|---|---|
| ¿Dónde se configura la conexión? | `hibernate.cfg.xml` | `persistence.xml` |
| ¿Dónde se describe el mapeo? | `*.hbm.xml` | Anotaciones en las entidades |
| ¿Qué clase gestiona las operaciones? | `Session` | `EntityManager` |
| ¿Qué clase crea esos objetos? | `SessionFactory` | `EntityManagerFactory` |

??? success "Comprobación"
    Ambas opciones permiten persistir entidades. La diferencia principal está en las interfaces y los mecanismos de configuración que utilizamos; Hibernate puede intervenir en ambos casos.


## Documentación teórica original de referencia

- [Consultar PDF: 2.1 Mapeo OMR con Hibernate nativo](../descargas/ut4/teoria/2.1%20Mapeo%20OMR%20con%20Hibernate%20nativo.pdf)
- [Consultar PDF: 2.2 Mapeo OMR JakartaPersistence](../descargas/ut4/teoria/2.2%20Mapeo%20OMR%20JakartaPersistence.pdf)
