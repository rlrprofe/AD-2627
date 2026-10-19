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
