# 2.7 · Proyectos Maven y scripts SQL

Los proyectos están organizados por concepto y preparados para **Java 21 + MySQL**. Todos incluyen código comentado, `pom.xml`, scripts SQL y un README con requisitos, configuración, ejecución y ejercicios.

| Proyecto | Contenido | Descargar |
|---|---|---|
| `jdbc-statement` | SQL fijo, DDL y consulta | [ZIP](../descargas/ut2/jdbc-statement.zip) |
| `jdbc-preparedstatement` | CRUD con modelo, DAO, servicio y menú | [ZIP](../descargas/ut2/jdbc-preparedstatement.zip) |
| `jdbc-callablestatement` | Procedimientos `OUT` e `INOUT` | [ZIP](../descargas/ut2/jdbc-callablestatement.zip) |
| `jdbc-resultados` | `ResultSet` y `ResultSetMetaData` | [ZIP](../descargas/ut2/jdbc-resultados.zip) |
| `jdbc-transacciones` | Transferencia con `commit`/`rollback` | [ZIP](../descargas/ut2/jdbc-transacciones.zip) |

## Scripts por separado

- [Base de datos `curso` (original de prácticas)](../descargas/ut2/01-curso-original.sql).
- [Procedimientos almacenados para `curso`](../descargas/ut2/02-procedimientos-curso.sql).
- [Base de datos `empresa` para transacciones](../descargas/ut2/03-empresa-transacciones.sql).

!!! danger "Atención antes de ejecutar"
    El script de `curso` elimina y recrea la base de datos. **Hazlo únicamente en un entorno de pruebas.** Los ejemplos que insertan, actualizan o eliminan registros modifican datos reales de ese entorno.

## Orden recomendado

1. Prepara MySQL y ejecuta el script SQL del proyecto.
2. Configura `JDBC_URL`, `JDBC_USER` y `JDBC_PASSWORD`.
3. Abre la carpeta Maven en VS Code.
4. Ejecuta `mvn clean compile` y después la clase principal.
5. Compara la salida de consola con los datos de MySQL.
6. Modifica el ejemplo y explica el efecto de cada cambio.

**No es necesario utilizar expresiones lambda para resolver ninguna actividad.**
