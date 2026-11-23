# 4.2. Configuración de Hibernate y mapeo objeto-relacional

## Objetivos

Instalar la herramienta mediante Maven, configurarla y comprender el mapeo mediante **ficheros XML** y **anotaciones**. Criterios **RA3 a), b), c)**.

## 1. Dos enfoques que debemos distinguir

**Hibernate nativo** utiliza `SessionFactory`, `Session` y puede definir el mapeo con archivos `*.hbm.xml`. **Jakarta Persistence** utiliza `EntityManagerFactory`, `EntityManager` y habitualmente anotaciones `@Entity`, `@Id`, etc. Hibernate puede ser el proveedor de Jakarta Persistence.

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
