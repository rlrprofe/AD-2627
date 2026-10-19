# 2.3 · Procesamiento de resultados y metadatos

## El objeto `ResultSet`

`executeQuery()` devuelve un `ResultSet`, que representa las filas resultantes de una consulta. Habitualmente se recorre mediante un **cursor**. No debe asumirse que todos los resultados se cargan íntegramente en memoria: el comportamiento depende del driver y su configuración.

```mermaid
flowchart LR
 A[Antes de primera fila] -->|next| B[Fila 1]
 B -->|next| C[Fila 2]
 C -->|next| D[Fin: false]
```

```java
try (Connection con = ConexionBD.abrir();
     PreparedStatement ps = con.prepareStatement(
         "SELECT emp_no, apellido, salario FROM empleados WHERE dep_no = ?")) {
    ps.setInt(1, 30);
    try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            int numero = rs.getInt("emp_no");
            String apellido = rs.getString("apellido");
            BigDecimal salario = rs.getBigDecimal("salario");
            System.out.printf("%d | %s | %s%n", numero, apellido, salario);
        }
    }
}
```

El cursor comienza **antes de la primera fila**; `next()` lo avanza y devuelve `false` cuando no quedan filas. Los índices de columna, si se utilizan en lugar de nombres, empiezan en **1**.

## Tipos de cursores

| Constante | Comportamiento |
|---|---|
| `TYPE_FORWARD_ONLY` | Avance hacia delante; el tipo habitual por defecto |
| `TYPE_SCROLL_INSENSITIVE` | Desplazable; normalmente no refleja cambios externos |
| `TYPE_SCROLL_SENSITIVE` | Solicita reflejar cambios externos, si el driver lo admite |

```java
try (Connection con = ConexionBD.abrir();
     Statement st = con.createStatement(
         ResultSet.TYPE_SCROLL_INSENSITIVE,
         ResultSet.CONCUR_READ_ONLY);
     ResultSet rs = st.executeQuery("SELECT emp_no, apellido FROM empleados")) {
    if (rs.last()) {
        System.out.println("Último empleado: " + rs.getString("apellido"));
    }
}
```

!!! warning "Compatibilidad"
    El soporte real de cursores desplazables, sensibles y actualizables **depende del driver y de la consulta**. Solicitar un tipo no garantiza que esté disponible; se pueden consultar las capacidades con `DatabaseMetaData`.

## `ResultSetMetaData`

Permite descubrir la estructura de las columnas devueltas por una consulta.

| Método | Información |
|---|---|
| `getColumnCount()` | Número de columnas |
| `getColumnLabel(i)` | Etiqueta visible, incluido un alias `AS` |
| `getColumnName(i)` | Nombre de columna, según el driver |
| `getColumnTypeName(i)` | Nombre del tipo SQL |
| `isNullable(i)` | Posibilidad de valores `NULL` |
| `getColumnDisplaySize(i)` | Tamaño de presentación recomendado |

```java
ResultSetMetaData meta = rs.getMetaData();
for (int i = 1; i <= meta.getColumnCount(); i++) {
    System.out.printf("%s (%s)%n", meta.getColumnLabel(i), meta.getColumnTypeName(i));
}
```

## `NULL` y tipos de datos

- `getString()` y `getBigDecimal()` devuelven `null` para valores SQL nulos.
- `getInt()` devuelve `0` tanto si el valor es cero como si es `NULL`; utiliza `rs.wasNull()` si necesitas distinguirlos.
- Para dinero, prefiere `DECIMAL` en MySQL y `BigDecimal` en Java.

## `ResultSet` actualizables

Algunos drivers admiten `CONCUR_UPDATABLE` para modificar filas desde el cursor (`updateXxx`, `updateRow`, `insertRow`, `deleteRow`). La consulta debe cumplir restricciones del driver; por ejemplo, suele necesitar una tabla y su clave primaria.

En aplicaciones ordinarias es preferible utilizar `UPDATE`, `INSERT` y `DELETE` mediante `PreparedStatement`, porque la operación queda explícita y es más fácil comprobar las filas afectadas.


## Navegación por el cursor: estados y movimientos

Un `ResultSet` es el conjunto de resultados de una consulta JDBC; no es una lista de objetos Java. Su **cursor** señala la fila desde la que se leen las columnas. Inicialmente se encuentra **antes de la primera fila**. `next()` devuelve `true` cuando logra situarse sobre una fila y `false` al alcanzar el final.

| Método | Efecto |
|---|---|
| `next()` | Avanza a la fila siguiente. |
| `previous()` | Retrocede una fila. |
| `first()` / `last()` | Se sitúa en la primera o última fila. |
| `absolute(n)` | Se sitúa en la fila `n` (desde 1); con valores negativos cuenta desde el final. |
| `relative(n)` | Se desplaza `n` filas respecto a la posición actual. |
| `beforeFirst()` / `afterLast()` | Coloca el cursor fuera de las filas, al inicio o al final. |
| `getRow()` | Devuelve el número de fila actual; `0` si no está situado sobre una fila válida. |
| `isBeforeFirst()` / `isAfterLast()` | Comprueba posiciones fuera del conjunto, con particularidades si está vacío. |

!!! warning "No todos los cursores admiten estos movimientos"
    El cursor habitual `TYPE_FORWARD_ONLY` permite avanzar con `next()`, pero no presupongas que admite retroceder o saltar a otra fila. Para navegar en ambas direcciones solicita un cursor desplazable, por ejemplo `TYPE_SCROLL_INSENSITIVE`, y comprueba el soporte del driver.

El proyecto descargable incluye **`es.dam.jdbc.app.DemoCursorDesplazable`**, que solicita `TYPE_SCROLL_INSENSITIVE` y `CONCUR_READ_ONLY`, muestra el tipo de cursor efectivo y practica `first()`, `last()`, `absolute(2)`, `previous()` y `getRow()`.

```java
try (Connection con = ConexionBD.abrir();
     Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
             ResultSet.CONCUR_READ_ONLY);
     ResultSet rs = st.executeQuery(
             "SELECT emp_no, apellido FROM empleados ORDER BY emp_no")) {
    if (rs.first()) {
        System.out.println("Primera fila: " + rs.getString("apellido"));
    }
    if (rs.last()) {
        System.out.println("Última fila, posición " + rs.getRow());
    }
    if (rs.absolute(2)) {
        System.out.println("Segunda fila: " + rs.getString("apellido"));
    }
}
```

## Convertir filas de `ResultSet` en objetos del modelo

Un `ResultSet` pertenece a JDBC y se cierra al terminar la consulta. Para trabajar con los datos fuera del bloque de conexión, el DAO puede construir **objetos Java independientes** a partir de cada fila. En `jdbc-resultados`, `ConsultaDAO.buscarPorDepartamento(int)` devuelve una `List<Empleado>`.

La clase `modelo/Empleado.java` es una **clase convencional** con atributos privados, constructor, getters, setters, `toString()` y documentación Javadoc. No realiza consultas SQL.

```java
List<Empleado> empleados = new ArrayList<>();
try (Connection con = ConexionBD.abrir();
     PreparedStatement ps = con.prepareStatement(
             "SELECT emp_no, apellido, salario, comision " +
             "FROM empleados WHERE dep_no = ? ORDER BY emp_no")) {
    ps.setInt(1, 30);
    try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            empleados.add(new Empleado(
                    rs.getInt("emp_no"),
                    rs.getString("apellido"),
                    rs.getBigDecimal("salario"),
                    rs.getBigDecimal("comision")));
        }
    }
}
// La lista contiene objetos independientes del ResultSet, ya cerrado.
```

`getBigDecimal()` devuelve `null` si el valor SQL es `NULL`. En cambio, al utilizar getters primitivos como `getInt()` hay que comprobar `wasNull()` cuando sea necesario distinguir un cero de un valor nulo.

## `ResultSetMetaData` frente a `DatabaseMetaData`

- **`ResultSetMetaData`** describe las columnas de una consulta concreta: número, etiqueta, nombre, tipo y posibilidad de `NULL`. Se obtiene mediante `rs.getMetaData()`.
- **`DatabaseMetaData`** describe el gestor y el driver, así como las capacidades de la conexión. Se obtiene mediante `con.getMetaData()` y permite consultar `supportsResultSetType(...)` o `supportsResultSetConcurrency(...)`.

En el proyecto, `ConsultaDAO.mostrarMetadatos()` y `ConsultaDAO.mostrarCapacidadesCursor()` muestran ambos usos.

## Actualización de filas desde un `ResultSet`

Con `CONCUR_UPDATABLE`, y **solo cuando el driver y la consulta lo permiten**, puede actualizarse la fila actual. `updateInt(...)` prepara el nuevo valor en el cursor y `updateRow()` envía la modificación a la base de datos.

```java
if (rs.next()) {
    int nuevoStock = rs.getInt("stock_disponible") + 1;
    rs.updateInt("stock_disponible", nuevoStock);
    rs.updateRow();
}
```

!!! danger "Demostración que modifica datos"
    `DemoResultSetActualizable` busca el producto **9001** e incrementa su stock en una unidad si existe y el cursor es actualizable. Ejecútala únicamente en una base de datos de pruebas. Si no existe el producto, no realiza cambios. Para aplicaciones habituales se recomienda `UPDATE ... WHERE ...` con `PreparedStatement`.

## Ejecutar el proyecto `jdbc-resultados`

1. Descomprime el ZIP y abre la carpeta raíz `jdbc-resultados` como proyecto Maven en VS Code.
2. Copia `src/main/resources/db.properties.example` a `src/main/resources/db.properties` y configura `jdbc.url`, `jdbc.user` y `jdbc.password` con los datos de MySQL local. **Este proyecto no utiliza `System.getenv()`**.
3. Prepara la base de prácticas `curso` siguiendo el README. Ten presente que el script incluido puede recrear la base de datos.
4. Ejecuta `mvn clean compile` y después, desde **Run Java**, las clases indicadas:

| Clase principal | Qué demuestra |
|---|---|
| `es.dam.jdbc.app.DemoResultados` | Recorrido de filas, objetos `Empleado`, metadatos de columnas y capacidades del driver. |
| `es.dam.jdbc.app.DemoCursorDesplazable` | Movimientos y posiciones de un cursor desplazable de solo lectura. |
| `es.dam.jdbc.app.DemoResultSetActualizable` | Modificación opcional del stock del producto 9001 desde el cursor. |

!!! tip "Orden de aprendizaje"
    Empieza por `DemoResultados`, continúa con `DemoCursorDesplazable` y deja la demostración actualizable para el final. Revisa los comentarios internos y Javadoc del proyecto para comprender qué hace cada clase.

## Ejercicios

Intenta resolver cada ejercicio antes de desplegar la solución. Los ejemplos son orientativos y deben adaptarse a la base de datos y al proyecto Maven de prácticas.

**1. Lista empleados por departamento, indicando si la consulta no devuelve filas.**

??? success "Mostrar solución · Ejercicio 1"
    ```java
    String sql = "SELECT emp_no, apellido FROM empleados WHERE dep_no = ?";
    try (Connection con = ConexionBD.abrir();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, 30);
        try (ResultSet rs = ps.executeQuery()) {
            boolean hayFilas = false;
            while (rs.next()) {
                hayFilas = true;
                System.out.println(rs.getInt("emp_no") + " - " + rs.getString("apellido"));
            }
            if (!hayFilas) System.out.println("No hay empleados en ese departamento");
        }
    }
    ```

    El `ResultSet` empieza antes de la primera fila. Si `next()` devuelve `false` desde el principio, la consulta no ha encontrado registros.


**2. Muestra nombre, tipo y número de columnas de una consulta con alias.**

??? success "Mostrar solución · Ejercicio 2"
    ```java
    String sql = "SELECT emp_no AS numero, apellido AS nombre FROM empleados";
    try (Connection con = ConexionBD.abrir();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        ResultSetMetaData md = rs.getMetaData();
        System.out.println("Número de columnas: " + md.getColumnCount());
        for (int i = 1; i <= md.getColumnCount(); i++) {
            System.out.printf("%s | %s%n", md.getColumnLabel(i), md.getColumnTypeName(i));
        }
    }
    ```

    **Resultado:** dos columnas; las etiquetas son `numero` y `nombre`. Los nombres concretos de los tipos dependen del esquema MySQL y del driver.


**3. Comprueba la diferencia entre `getColumnLabel()` y `getColumnName()`.**

??? success "Mostrar solución · Ejercicio 3"
    Con la consulta `SELECT apellido AS nombre FROM empleados`, `getColumnLabel(1)` devuelve normalmente **`nombre`** porque respeta el alias `AS`. `getColumnName(1)` se refiere al nombre de columna, pero su comportamiento **depende del driver**; algunos pueden devolver también el alias.

    ```java
    ResultSetMetaData md = rs.getMetaData();
    System.out.println("Etiqueta: " + md.getColumnLabel(1));
    System.out.println("Nombre: " + md.getColumnName(1));
    ```

    Ejecuta ambos métodos con tu versión de MySQL Connector/J y anota el resultado observado. No supongas que todos los drivers se comportan igual.


**4. Explica por qué `getInt()` puede requerir `wasNull()`.**

??? success "Mostrar solución · Ejercicio 4"
    `getInt()` devuelve `0` tanto si la columna contiene el número cero como si el valor SQL es `NULL`. Para distinguirlos, consulta `wasNull()` **inmediatamente después** de leer la columna.

    ```java
    int valor = rs.getInt("comision");
    if (rs.wasNull()) {
        System.out.println("Comisión no informada (NULL)");
    } else {
        System.out.println("Comisión: " + valor);
    }
    ```

    El ejemplo presupone que la consulta incluye una columna numérica anulable denominada `comision`; adapta el nombre a tu esquema.


**5. Investiga si tu driver permite `TYPE_SCROLL_SENSITIVE`.**

??? success "Mostrar solución · Ejercicio 5"
    Consulta los metadatos de la conexión:

    ```java
    try (Connection con = ConexionBD.abrir()) {
        DatabaseMetaData md = con.getMetaData();
        boolean soportado = md.supportsResultSetType(ResultSet.TYPE_SCROLL_SENSITIVE);
        System.out.println("¿Cursor sensible? " + soportado);
        System.out.println("Driver: " + md.getDriverName());
        System.out.println("Versión: " + md.getDriverVersion());
    }
    ```

    **No existe una respuesta universal**: depende del driver y de su versión. Registra el resultado obtenido y explica que la sensibilidad a cambios externos puede tener limitaciones incluso cuando se admite un tipo de cursor.


**Proyecto:** [jdbc-resultados](07-descargas.md).
