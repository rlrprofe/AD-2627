# 2.6 · Actividades y proyecto de consolidación

## Actividades de introducción

Resuelve la actividad y comprueba tu trabajo desplegando la propuesta de solución.

**1. Dibuja el flujo Aplicación Java → API JDBC → Driver → MySQL.**

??? success "Mostrar solución · Actividad 1"
    ```mermaid
    flowchart LR
        A[Aplicación Java] --> B[API JDBC]
        B --> C[MySQL Connector/J]
        C --> D[(Servidor MySQL)]
    ```

    La aplicación invoca interfaces JDBC; el driver implementa esas interfaces y traduce las operaciones al protocolo de MySQL. El servidor ejecuta SQL y devuelve los resultados.


**2. Compara un SGBD embebido y otro independiente.**

??? success "Mostrar solución · Actividad 2"
    **SQLite** suele funcionar integrado en el proceso de la aplicación y almacenar la base en un archivo. **MySQL** utiliza un servidor independiente al que se conectan uno o varios clientes. Ambos pueden utilizarse desde Java mediante un driver JDBC adecuado; la instalación y las URL son distintas.


**3. Localiza en un proyecto Maven la dependencia del driver.**

??? success "Mostrar solución · Actividad 3"
    Abre `pom.xml` y localiza el bloque:

    ```xml
    <dependency>
      <groupId>com.mysql</groupId>
      <artifactId>mysql-connector-j</artifactId>
      <version>9.3.0</version>
    </dependency>
    ```

    Maven gestiona la descarga y el classpath del driver. La versión mostrada es la utilizada como referencia en estos apuntes; comprueba la del proyecto entregado.


**4. Interpreta una URL JDBC e identifica host, puerto y base de datos.**

??? success "Mostrar solución · Actividad 4"
    Para `jdbc:mysql://localhost:3306/curso`: **subprotocolo:** `mysql`; **host:** `localhost`; **puerto:** `3306`; **base de datos:** `curso`. Si MySQL se ejecuta en otro equipo, sustituye `localhost` por su nombre o dirección de red.



## Actividades de desarrollo

Resuelve la actividad y comprueba tu trabajo desplegando la propuesta de solución.

**1. Ejecuta el ejemplo de `Statement` y explica qué hace cada instrucción.**

??? success "Mostrar solución · Actividad 1"
    En el ejemplo del apartado 2.2, `ConexionBD.abrir()` obtiene una conexión; `createStatement()` crea la sentencia; `executeQuery(sql)` ejecuta el `SELECT`; `rs.next()` recorre las filas; `getInt()` y `getString()` leen columnas. El bloque `try-with-resources` cierra los recursos. Comprueba que la salida coincide con las filas de `empleados`.


**2. Inserta, consulta, modifica y elimina un producto con `PreparedStatement`.**

??? success "Mostrar solución · Actividad 2"
    Ejecuta el **CRUD** en este orden sobre un identificador de pruebas:

    ```sql
    INSERT INTO productos (producto_no, descripcion, precio_actual, stock_disponible)
    VALUES (?, ?, ?, ?);
    SELECT producto_no, descripcion, precio_actual, stock_disponible
    FROM productos WHERE producto_no = ?;
    UPDATE productos SET stock_disponible = ? WHERE producto_no = ?;
    DELETE FROM productos WHERE producto_no = ?;
    ```

    Cada sentencia se prepara desde Java y recibe sus parámetros mediante `setInt`, `setString` o `setBigDecimal`. Para `INSERT`, `UPDATE` y `DELETE` utiliza `executeUpdate()` y comprueba el número de filas. Para `SELECT`, `executeQuery()` y `ResultSet`. No ejecutes `DELETE` sin `WHERE`.


**3. Ejecuta procedimientos con parámetros `OUT` e `INOUT`.**

??? success "Mostrar solución · Actividad 3"
    **OUT:** con `contarEmpleados`, registra el parámetro mediante `registerOutParameter(1, Types.INTEGER)`, ejecuta y recupera el total con `getInt(1)`.

    **INOUT:** en el procedimiento suministrado en `jdbc-callablestatement`, asigna primero el valor de entrada con el `setXxx()` correspondiente, registra el mismo parámetro como salida mediante `registerOutParameter()` y recupera su valor tras `execute()`. El nombre y tipo exactos dependen del procedimiento del script SQL; no deben inventarse.


**4. Recorre un `ResultSet` y muestra sus metadatos.**

??? success "Mostrar solución · Actividad 4"
    ```java
    try (Connection con = ConexionBD.abrir();
         PreparedStatement ps = con.prepareStatement("SELECT emp_no, apellido FROM empleados");
         ResultSet rs = ps.executeQuery()) {
        ResultSetMetaData md = rs.getMetaData();
        for (int i = 1; i <= md.getColumnCount(); i++) {
            System.out.println(md.getColumnLabel(i) + ": " + md.getColumnTypeName(i));
        }
        while (rs.next()) {
            System.out.println(rs.getInt("emp_no") + " - " + rs.getString("apellido"));
        }
    }
    ```

    El número y tipo de columnas proceden de los metadatos; los valores de cada fila proceden del `ResultSet`.



## Actividades procedimentales

Resuelve la actividad y comprueba tu trabajo desplegando la propuesta de solución.

**1. Provoca una violación de clave primaria y registra el `SQLState`.**

??? success "Mostrar solución · Actividad 1"
    Inserta un producto de prueba con un `producto_no` nuevo y repite el `INSERT` con el **mismo identificador**. La segunda inserción debe fallar por clave duplicada.

    ```java
    catch (SQLException e) {
        System.out.println("SQLState: " + e.getSQLState());
        System.out.println("Código: " + e.getErrorCode());
    }
    ```

    En MySQL es habitual `SQLState` **`23000`** para violación de integridad, aunque debes **anotar el valor real** obtenido. Hazlo únicamente en la base de pruebas.


**2. Ejecuta una actualización que no encuentre filas y comprueba el resultado.**

??? success "Mostrar solución · Actividad 2"
    Prepara `UPDATE productos SET stock_disponible = ? WHERE producto_no = ?` y asigna un identificador que no exista. `executeUpdate()` debería devolver **0**. La aplicación debe informar de que no se encontró el producto, en lugar de mostrar un mensaje de actualización exitosa.


**3. Simula un fallo en una transferencia y verifica el `rollback()`.**

??? success "Mostrar solución · Actividad 3"
    Registra los saldos iniciales. Intenta transferir a una cuenta de destino inexistente, de manera que la segunda actualización afecte a cero filas. Comprueba que el servicio ejecuta `rollback()` y que **ambos saldos permanecen como antes**. Las dos operaciones deben compartir la misma conexión.


**4. Implementa una consulta por intervalo de precios usando dos parámetros `?`.**

??? success "Mostrar solución · Actividad 4"
    ```java
    String sql = """
        SELECT producto_no, descripcion, precio_actual
        FROM productos
        WHERE precio_actual BETWEEN ? AND ?
        ORDER BY precio_actual
        """;
    try (Connection con = ConexionBD.abrir();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setBigDecimal(1, new BigDecimal("10.00"));
        ps.setBigDecimal(2, new BigDecimal("50.00"));
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                System.out.println(rs.getString("descripcion") + " - " + rs.getBigDecimal("precio_actual"));
            }
        }
    }
    ```

    `BETWEEN` incluye ambos extremos. Valida que el precio mínimo no supere al máximo.



## Proyecto de consolidación: gestor de productos

**Objetivo:** aplicación de consola con MySQL que permita listar, buscar, insertar, modificar stock y eliminar productos.

### Requisitos funcionales

- Menú que se repite hasta seleccionar «Salir».
- Validación de identificadores, precios y existencias.
- Consultas parametrizadas con `PreparedStatement`.
- Mensajes distintos para operación correcta y registro inexistente.
- Comprobación de filas afectadas.
- Cierre automático de los recursos JDBC.
- Registro de errores sin exponer credenciales.

### Diseño propuesto

```text
app/MenuProductos.java
modelo/Producto.java
servicio/ProductoService.java
dao/ProductoDAO.java
config/ConexionBD.java
sql/01-curso-original.sql
```

### Entregables

1. Proyecto Maven que compile con Java 21.
2. Script SQL y README de ejecución.
3. Capturas o evidencias de al menos cuatro operaciones correctas.
4. Dos pruebas de error justificadas.
5. Explicación individual del flujo menú → servicio → DAO → MySQL.

### Lista de comprobación

- [ ] La conexión funciona sin contraseña en el código.
- [ ] Los parámetros de entrada se validan.
- [ ] No se concatenan datos de usuario en SQL.
- [ ] El programa maneja registros inexistentes.
- [ ] Todos los recursos se cierran.
- [ ] El README permite reproducir la práctica.
- [ ] Puedo explicar cada clase y justificar su responsabilidad.

### Orientaciones de solución del proyecto

El proyecto de consolidación es una actividad de desarrollo individual. La siguiente guía permite **comprobar el diseño y el funcionamiento** sin sustituir la implementación que debes realizar.

??? success "Mostrar solución · Ver propuesta de estructura y responsabilidades"
    - `MenuProductos`: muestra opciones, lee datos y comunica mensajes.
    - `Producto`: representa los atributos del producto.
    - `ProductoService`: valida identificadores, precios y stock y coordina las operaciones.
    - `ProductoDAO`: implementa el CRUD con SQL parametrizado y convierte filas en objetos.
    - `ConexionBD`: centraliza la apertura de conexiones y su configuración.

    **Flujo esperado:** menú → servicio → DAO → MySQL → DAO → servicio → menú.

    El DAO no debe utilizar `Scanner` ni imprimir el menú. El servicio no debe construir consultas SQL.


??? success "Mostrar solución · Ver consultas SQL de referencia"
    Adapta las consultas a la estructura real de la tabla `productos`:

    ```sql
    SELECT producto_no, descripcion, precio_actual, stock_disponible
    FROM productos ORDER BY producto_no;

    SELECT producto_no, descripcion, precio_actual, stock_disponible
    FROM productos WHERE producto_no = ?;

    INSERT INTO productos (producto_no, descripcion, precio_actual, stock_disponible)
    VALUES (?, ?, ?, ?);

    UPDATE productos SET stock_disponible = ? WHERE producto_no = ?;

    DELETE FROM productos WHERE producto_no = ?;
    ```

    En Java, utiliza `PreparedStatement` para los valores variables y `BigDecimal` para los precios.


??? success "Mostrar solución · Ver pruebas de aceptación orientativas"
    1. **Inserción válida:** el nuevo producto aparece al listar.
    2. **Búsqueda válida:** se muestran los datos del identificador existente.
    3. **Modificación válida:** el stock cambia y se informa de una fila afectada.
    4. **Eliminación válida:** el producto deja de aparecer.
    5. **Error de búsqueda:** un identificador inexistente produce un mensaje específico.
    6. **Error de validación:** precio negativo o stock inválido se rechazan antes de ejecutar SQL.
    7. **Seguridad:** las credenciales no están incluidas en el código ni en Git.
    8. **Recursos:** las conexiones y sentencias se cierran mediante `try-with-resources`.

    El README debe explicar cómo preparar MySQL, configurar variables de entorno, compilar y ejecutar la aplicación.


!!! info "Evaluación"
    La valoración concreta de las prácticas seguirá los criterios y porcentajes indicados en la [guía de la UT2](index.md) y las instrucciones de entrega del aula virtual.

## Orientaciones para practicar transacciones con el proyecto descargable

Para las actividades de transferencia y `rollback()`, utiliza [`jdbc-transacciones`](07-descargas.md). Configura primero `db.properties` con la base `empresa` y ejecuta el script `03-empresa-transacciones.sql`.

- **Caso correcto:** ejecuta `DemoTransferencia` y comprueba los dos saldos con `SELECT` antes y después.
- **Error de destino:** prueba `new Transferencia(1, 9999, new BigDecimal("20.00"))` y comprueba que el saldo del origen no cambia gracias al `rollback()`.
- **Savepoint:** ejecuta `DemoSavepoint` y explica por qué el pedido puede confirmarse aunque no se cree su albarán opcional.
- **Análisis del código:** identifica qué clase abre la conexión, cuál ejecuta el SQL y cuál decide `commit()` o `rollback()`.

!!! warning "Repetición de pruebas"
    Cada transferencia correcta vuelve a modificar los saldos. El script SQL repone los saldos iniciales, pero no borra los albaranes que ya existan.


## Actividad complementaria: llamadas a procedimientos almacenados

Utiliza el proyecto [`jdbc-callablestatement`](07-descargas.md), configura `db.properties` y ejecuta los scripts SQL en el orden indicado en el README.

**1. Parámetro OUT.** Ejecuta `contarEmpleados()` y explica por qué es necesario registrar el parámetro de salida antes de llamar a `execute()`.

??? success "Orientación · OUT"
    `registerOutParameter(1, Types.INTEGER)` declara el tipo del primer parámetro de salida. Tras `execute()`, `getInt(1)` recupera el total calculado en MySQL.

**2. Parámetro INOUT.** Ejecuta `doblarNumero(12)` y repite con otro número. Identifica la diferencia entre `setInt()` y `registerOutParameter()`.

??? success "Orientación · INOUT"
    `setInt(1, 12)` proporciona el valor de entrada y `registerOutParameter(1, Types.INTEGER)` indica que el mismo parámetro devolverá un valor. Tras `execute()`, el resultado de la primera prueba será `24`.

**3. Parámetros IN.** Localiza `aumentarSalario()` y explica por qué no se ejecuta automáticamente. Si realizas la prueba en una base de datos desechable, compara salarios y `log_acciones` antes y después.

??? success "Orientación · IN"
    El procedimiento recibe departamento y porcentaje, actualiza la tabla `empleados` y registra la acción. No tiene un parámetro `OUT` que comunique filas afectadas. Su ejecución cambia datos persistentes, por lo que se debe controlar cuidadosamente.
