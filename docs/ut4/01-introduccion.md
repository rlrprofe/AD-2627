# 4.1. Introducción a la persistencia y ORM

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

## Desarrollo de los contenidos del documento original

### Persistencia y arquitectura de una aplicación

En una aplicación Java podemos distinguir entre los **datos que solo existen durante la ejecución** y los que deben permanecer cuando el programa termina. Un objeto `Producto` creado con `new` no se guarda por sí mismo. La capa de persistencia se encarga de transformar ese estado temporal en datos almacenados y de recuperarlos cuando sea necesario.

El PDF original presenta las capas habituales de una aplicación. La **vista** se comunica con el usuario; la **lógica de negocio** aplica las reglas; y la **persistencia** accede al almacenamiento. Estas capas no son una característica exclusiva de Hibernate: también se utilizan con JDBC. Lo que cambia es **cómo se implementa el acceso a los datos**.

### ¿Qué problema resuelve el mapeo?

En Java trabajamos con objetos, atributos y referencias. En MySQL trabajamos con tablas, columnas y claves foráneas. El ORM resuelve buena parte de la traducción entre ambos modelos.

Considera una clase `Cliente` con `id`, `nombre` y una colección de pedidos. En la base de datos podríamos tener las tablas `clientes` y `pedidos`, relacionadas mediante `cliente_id`. El ORM necesita saber qué atributo representa la clave primaria y cómo se relacionan las entidades; después puede construir las operaciones SQL necesarias.

### Comparación razonada entre JDBC y ORM

| Aspecto | JDBC | Hibernate/JPA |
|---|---|---|
| Escritura de SQL | Habitualmente manual | Gran parte generada por el ORM |
| Conversión fila-objeto | La programa el desarrollador | Se basa en el mapeo |
| Control de consultas | Muy directo | Requiere conocer el SQL generado |
| Relaciones | Se resuelven manualmente | Se pueden expresar con anotaciones |
| Transacciones | `Connection` | `EntityTransaction` o API nativa |
| Curva de aprendizaje | Menor al principio | Mayor: estados, contexto y asociaciones |

El ORM **no es siempre mejor**. Para consultas muy específicas o tareas sencillas, JDBC puede ser suficiente. Hibernate resulta especialmente útil cuando tenemos muchas entidades y queremos mantener el código centrado en el modelo de objetos.

## Actividades de aprendizaje del material original

**Actividad A. Memoria o persistencia.** Clasifica: una partida que desaparece al cerrar el juego, un pedido que podemos consultar al día siguiente, un formulario sin enviar, un documento guardado en la nube y una variable local `int`.

??? success "Solución orientativa"
    Partida que desaparece, formulario sin enviar y variable local: **memoria temporal**. Pedido consultable y documento guardado: **persistencia**.

**Actividad B. Comparación.** Completa una tabla con quién escribe el SQL, cantidad de código, portabilidad, curva de aprendizaje, control del rendimiento e integración con POO.

??? success "Orientación"
    JDBC proporciona control directo y exige más transformación manual. ORM reduce código repetitivo y encaja con entidades Java, pero obliga a entender su configuración y el SQL que genera.

**Actividad C. Arquitectura por capas.** Elige una aplicación (tienda, biblioteca o reservas) e identifica clases de vista, negocio y persistencia. Explica dónde encajan JDBC y ORM.

??? success "Orientación"
    En una tienda: `MenuVista`, `ProductoService` y `ProductoDAO`. JDBC o Hibernate son **alternativas de implementación** de la persistencia, no sustitutos de la vista ni de las reglas de negocio.


## Documentación teórica original de referencia

- [Consultar PDF: 1.1 IntroORM](../descargas/ut4/teoria/1.1%20IntroORM.pdf)
- [Consultar PDF: 1.2 ActividadesAprendizaje](../descargas/ut4/teoria/1.2%20ActividadesAprendizaje.pdf)
