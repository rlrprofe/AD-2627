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
