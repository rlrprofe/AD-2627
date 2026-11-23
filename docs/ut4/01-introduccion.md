# 4.1. Introducción a la persistencia y ORM

## Antes de empezar: Hibernate nativo y Jakarta Persistence

Antes de comenzar a trabajar con persistencia en Java, conviene aclarar una cuestión que genera confusión al consultar vídeos, tutoriales y ejemplos de Internet: **Hibernate se ha utilizado de distintas formas a lo largo de su evolución**. Por eso encontraremos ejemplos con API, ficheros de configuración y versiones diferentes.

### 1. Primero apareció Hibernate nativo

Hibernate nació como una herramienta de mapeo objeto-relacional y originalmente ofrecía **su propia API**, basada en elementos como:

- `SessionFactory`: fábrica que permite crear sesiones.
- `Session`: objeto utilizado para interactuar con la persistencia.
- `Transaction`: mecanismo para delimitar transacciones.
- `hibernate.cfg.xml`: fichero de configuración habitual en ejemplos de Hibernate nativo.

A esta forma de trabajar la llamaremos **Hibernate nativo (Session API)**. Encontrarás muchos tutoriales antiguos —y también ejemplos actuales— que utilizan esta API.

### 2. Después apareció JPA, actualmente Jakarta Persistence

Más tarde se definió una API estándar de persistencia, conocida originalmente como **JPA (Java Persistence API)**. En documentación antigua verás importaciones como `javax.persistence.*`. En el ecosistema Jakarta EE actual se utiliza **Jakarta Persistence**, con importaciones `jakarta.persistence.*`.

!!! info "Terminología de estos apuntes"
    Cuando en esta unidad aparezca «JPA», nos referiremos a la API estándar **Jakarta Persistence**. Los ejemplos modernos utilizarán `jakarta.persistence.*`.

**JPA/Jakarta Persistence es una especificación**, no un motor ORM que funcione por sí solo. Define contratos y anotaciones que debe proporcionar una implementación, como **Hibernate**. Entre sus elementos principales están:

- `EntityManager`: interfaz estándar para gestionar entidades persistentes.
- `persistence.xml`: fichero habitual para declarar una unidad de persistencia.
- `@Entity`, `@Id`, `@Column` y otras anotaciones estándar para describir el mapeo.

Hibernate puede utilizarse como **proveedor de Jakarta Persistence**, de manera que el código de nuestra aplicación trabaja con la API estándar y Hibernate realiza las operaciones de persistencia.

### 3. ¿Por qué hay ejemplos tan distintos en Internet?

Porque durante años han coexistido distintas versiones y formas de trabajar. Es posible encontrar:

- Código que utiliza `Session` y código que utiliza `EntityManager`.
- Anotaciones de `javax.persistence` y de `jakarta.persistence`.
- Configuraciones mediante `hibernate.cfg.xml` o `persistence.xml`.
- Ejemplos correspondientes a distintas versiones de Hibernate, con métodos y configuraciones que han cambiado.

**No debemos copiar fragmentos de tutoriales diferentes sin comprobar su versión y la API que utilizan.** Una combinación de ejemplos incompatibles puede producir errores difíciles de interpretar.

### 4. ¿Qué enfoque utilizaremos en esta unidad?

Estudiaremos las dos formas **de manera diferenciada** para comprender sus conceptos sin mezclar las API en un mismo ejemplo:

**Parte 1. Hibernate nativo (`Session`)**

Comenzaremos por reconocer `SessionFactory`, `Session` y `Transaction`, comprender el mapeo de una clase Java a una tabla, realizar operaciones CRUD sencillas y observar el SQL que genera Hibernate.

**Parte 2. Jakarta Persistence (`EntityManager`) con Hibernate como proveedor**

Después trabajaremos con `EntityManager`, `persistence.xml`, anotaciones estándar, consultas JPQL y relaciones entre entidades, como uno a muchos y muchos a uno.

Este segundo enfoque permite escribir la lógica de persistencia utilizando una **API estándar**, sin depender directamente de los métodos específicos de Hibernate para las operaciones habituales.

!!! warning "Regla para los ejemplos de la unidad"
    No mezclaremos las operaciones de `Session` y `EntityManager` dentro de un mismo ejemplo didáctico. Las estudiaremos por separado y explicaremos sus equivalencias cuando corresponda.

### 5. Resumen para recordar

| Concepto | Qué significa | API o configuración característica |
|---|---|---|
| **Hibernate nativo** | Uso directo de la API propia de Hibernate | `Session`, `SessionFactory`, `Transaction`, habitualmente `hibernate.cfg.xml` |
| **Jakarta Persistence (JPA)** | Especificación estándar de persistencia | `EntityManager`, `@Entity`, `@Id`, habitualmente `persistence.xml` |
| **Hibernate como proveedor JPA** | Hibernate implementa la especificación Jakarta Persistence | Nuestra aplicación usa `EntityManager`; Hibernate ejecuta las operaciones |

**Idea clave:** Hibernate puede trabajar de las dos maneras. Saber cuál utiliza cada ejemplo es el primer paso para comprenderlo y ejecutarlo correctamente.

---

## Objetivos


Comprender qué significa persistir datos, por qué los objetos Java no se guardan automáticamente al finalizar el programa y qué aporta un ORM frente al acceso mediante JDBC.

## 1. Persistencia: memoria frente a almacenamiento

Cuando creamos `new Producto("Teclado", 19.95)`, el objeto vive en la memoria de la aplicación. Si el proceso termina, ese objeto desaparece. **Persistir** significa almacenar sus datos en un medio duradero para recuperarlos en otra ejecución.

En JDBC aprendimos a abrir una conexión, preparar una sentencia SQL, asignar parámetros y transformar filas de `ResultSet` en objetos Java. Este trabajo es correcto, pero suele repetirse en cada DAO.

## 2. ¿Qué es ORM?

**Object-Relational Mapping** (mapeo objeto-relacional) es una técnica que relaciona las clases y propiedades de un programa con tablas y columnas de una base de datos relacional.

| Java | Base de datos |
|---|---|
| Clase `Producto` | Tabla `productos` |
| Objeto `Producto` | Fila |
| Atributo `nombre` | Columna `nombre` |
| Atributo `id` | Clave primaria |
| Referencia a otra entidad | Clave foránea o tabla intermedia |

Hibernate es una implementación muy utilizada de esta técnica. **JPA/Jakarta Persistence** define una API y unas reglas estándar; Hibernate puede actuar como su proveedor.

## 3. ORM frente a JDBC

**Ventajas:** menos código repetitivo, trabajo orientado a objetos, seguimiento de cambios de entidades y gestión de asociaciones. **Inconvenientes:** curva de aprendizaje, SQL generado menos evidente, posibles consultas ineficientes y necesidad de entender el contexto de persistencia.

!!! tip "ORM no elimina SQL"
    El ORM genera o ejecuta SQL contra la base de datos. Comprender claves, índices, transacciones y consultas SQL sigue siendo imprescindible.

## 4. Ejemplo conceptual

Con JDBC:

```java
String sql = "INSERT INTO productos (nombre, precio) VALUES (?, ?)";
try (PreparedStatement ps = conexion.prepareStatement(sql)) {
    ps.setString(1, producto.getNombre());
    ps.setDouble(2, producto.getPrecio());
    ps.executeUpdate();
}
```

Con Jakarta Persistence, dentro de una transacción:

```java
entityManager.persist(producto);
```

La segunda instrucción parece más sencilla porque **el mapeo ya indica cómo almacenar la entidad**. La configuración y la transacción siguen siendo necesarias.

## 5. Actividad de inicio

Explica con tus palabras qué problemas aparecen si una aplicación mantiene todos los productos únicamente en un `ArrayList`.

??? success "Orientación"
    Los objetos desaparecen al finalizar el programa; no hay persistencia. Para conservarlos necesitamos ficheros, una base de datos u otro almacenamiento. Un ORM permite trabajar con objetos sin programar manualmente todas las sentencias CRUD.

**Referencia de partida:** PDF `1.1 IntroORM.pdf` del material del curso anterior.
