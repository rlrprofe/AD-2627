# 2.7 · Proyectos Maven y scripts SQL

Los proyectos están organizados por concepto y preparados para **Java 21 + MySQL**. Todos incluyen código comentado, `pom.xml`, scripts SQL y un README con requisitos, configuración, ejecución y ejercicios.

| Proyecto | Contenido | Descargar |
|---|---|---|
| `jdbc-statement` | SQL fijo, DDL y consulta | [ZIP](../descargas/ut2/jdbc-statement.zip) |
| `jdbc-preparedstatement` | CRUD con modelo, DAO, servicio y menú | [ZIP](../descargas/ut2/jdbc-preparedstatement.zip) |
| `jdbc-callablestatement` | Procedimientos `OUT`, `INOUT` e `IN`; configuración `db.properties` | [ZIP](../descargas/ut2/jdbc-callablestatement.zip) |
| `jdbc-resultados` | `ResultSet` y `ResultSetMetaData` | [ZIP](../descargas/ut2/jdbc-resultados.zip) |
| `jdbc-transacciones` | Transferencia con `commit`/`rollback`, pedido con `Savepoint` y conexión por `db.properties` | [ZIP](../descargas/ut2/jdbc-transacciones.zip) |

## Scripts por separado

- [Base de datos `curso` (original de prácticas)](../descargas/ut2/01-curso-original.sql).
- [Procedimientos almacenados para `curso`](../descargas/ut2/02-procedimientos-curso.sql).
- [Base de datos `empresa` para transacciones](../descargas/ut2/03-empresa-transacciones.sql).

!!! danger "Atención antes de ejecutar"
    El script de `curso` elimina y recrea la base de datos. **Hazlo únicamente en un entorno de pruebas.** Los ejemplos que insertan, actualizan o eliminan registros modifican datos reales de ese entorno.

!!! tip "Cómo funcionan las variables de entorno"
    El proyecto `jdbc-statement` muestra también la variante con `System.getenv()` y variables `JDBC_URL`, `JDBC_USER` y `JDBC_PASSWORD`. **`jdbc-transacciones` utiliza `db.properties`, no variables de entorno.** Si no conoces este método, revisa [su explicación, el ejemplo comentado y las soluciones](01-fundamentos.md) antes de ejecutar el ZIP de `jdbc-statement`.

## Orden recomendado

1. Prepara MySQL y ejecuta el script SQL del proyecto.
2. Configura la conexión según el README de cada proyecto. Para `jdbc-transacciones`, copia `src/main/resources/db.properties.example` a `db.properties` en esa misma carpeta y completa `jdbc.url`, `jdbc.user` y `jdbc.password` (base `empresa`).
3. Abre la carpeta Maven en VS Code.
4. Ejecuta `mvn clean compile` y después la clase principal.
5. Compara la salida de consola con los datos de MySQL.
6. Modifica el ejemplo y explica el efecto de cada cambio.

**No es necesario utilizar expresiones lambda para resolver ninguna actividad.**

### `jdbc-transacciones`: clases ejecutables

- `es.dam.jdbc.app.DemoTransferencia`: transferencia bancaria con `setAutoCommit(false)`, `commit()` y `rollback()`. **Cada ejecución correcta cambia los saldos.**
- `es.dam.jdbc.app.DemoSavepoint`: confirmación del pedido 1001 con un albarán opcional y `Savepoint`.

Ambas demostraciones utilizan la base **`empresa`** y la configuración privada `src/main/resources/db.properties`. Consulta la explicación en [2.4 · Transacciones](04-transacciones.md).


### Proyecto `jdbc-callablestatement`: instrucciones específicas

1. Ejecuta `sql/01-curso-original.sql` y después `sql/02-procedimientos-curso.sql` (**el primero elimina y recrea `curso`**).
2. Copia `src/main/resources/db.properties.example` a `src/main/resources/db.properties` y configura URL, usuario y contraseña de MySQL.
3. Compila con `mvn clean compile` y ejecuta `es.dam.jdbc.app.DemoCallable` desde VS Code.
4. Observa las demostraciones `OUT` e `INOUT`. El procedimiento `aumentarSalario` con parámetros `IN` modifica datos y no se ejecuta automáticamente.

El proyecto contiene Javadoc y comentarios internos. **No tiene una clase modelo** porque devuelve valores escalares y no objetos de dominio.
