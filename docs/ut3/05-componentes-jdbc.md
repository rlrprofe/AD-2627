# 3.5. Componente de acceso a datos mediante JDBC

**Duración orientativa:** 4 horas · **CE d), i)**

## 1. Objetivo

Implementaremos `ProductoJdbcDAO` con las **mismas operaciones** que `ProductoFicheroDAO`. Recuperamos JDBC de la UT2 y lo encapsulamos dentro de un componente.

## 2. Base de datos de ejemplo

Ejecuta el fichero SQL descargable en MySQL:

```sql
CREATE DATABASE IF NOT EXISTS ut3_componentes;
USE ut3_componentes;

CREATE TABLE IF NOT EXISTS productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);
```

## 3. Separar la configuración

La aplicación debe obtener la URL, el usuario y la contraseña de la base de datos desde variables de entorno, evitando escribir contraseñas en el código o subirlas a GitHub:

```powershell
$env:UT3_DB_URL="jdbc:mysql://localhost:3306/ut3_componentes"
$env:UT3_DB_USER="usuario"
$env:UT3_DB_PASSWORD="tu_clave"
```

En el proyecto descargable `Main` utiliza estas variables cuando se selecciona la opción JDBC.

## 4. Clase DAO con constructor

```java
public class ProductoJdbcDAO implements ProductoDAO {

    private final String url;
    private final String usuario;
    private final String clave;

    public ProductoJdbcDAO(String url, String usuario, String clave) {
        this.url = url;
        this.usuario = usuario;
        this.clave = clave;
    }

    // Métodos del contrato ProductoDAO.
}
```

Este componente **no pide datos por teclado**. Recibe la configuración necesaria a través del constructor.

## 5. Guardar un producto con `PreparedStatement`

```java
String sql = "INSERT INTO productos (id, nombre, precio) VALUES (?, ?, ?)";

try (Connection conexion = DriverManager.getConnection(url, usuario, clave);
     PreparedStatement ps = conexion.prepareStatement(sql)) {

    ps.setInt(1, producto.id());
    ps.setString(2, producto.nombre());
    ps.setDouble(3, producto.precio());
    ps.executeUpdate();

} catch (SQLException e) {
    throw new AccesoDatosException("No se pudo guardar el producto", e);
}
```

El `try-with-resources` cierra automáticamente la conexión y la sentencia, incluso si ocurre una excepción.

## 6. Buscar productos

```java
String sql = "SELECT id, nombre, precio FROM productos WHERE id = ?";

try (Connection conexion = DriverManager.getConnection(url, usuario, clave);
     PreparedStatement ps = conexion.prepareStatement(sql)) {

    ps.setInt(1, id);

    try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            Producto producto = new Producto(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getDouble("precio")
            );
            return Optional.of(producto);
        }
    }
    return Optional.empty();

} catch (SQLException e) {
    throw new AccesoDatosException("No se pudo buscar el producto", e);
}
```

## 7. Mismo contrato, distinta implementación

```java
ProductoDAO dao = new ProductoJdbcDAO(url, usuario, clave);
ProductoService servicio = new ProductoService(dao);
```

El servicio **no sabe** que los datos están en MySQL. Solo utiliza los métodos definidos por `ProductoDAO`.

## 8. Actividad guiada

1. Crea la base de datos con el script SQL.
2. Configura las variables de entorno y ejecuta el proyecto en modo JDBC.
3. Guarda y recupera productos.
4. Comprueba los registros desde MySQL Workbench.
5. Desconecta MySQL e identifica qué excepción se genera y cómo llega al menú.
6. Compara `ProductoJdbcDAO` con `ProductoFicheroDAO`: ¿qué métodos tienen en común? ¿Qué código cambia?

## 9. Ejercicios

- Implementa `buscarPorId` sin utilizar `Statement` ni concatenar el ID dentro del SQL.
- Explica por qué `ResultSet` debe cerrarse y qué problema evita `try-with-resources`.
- Propón cómo añadirías una operación `actualizarPrecio` en ambas implementaciones sin modificar `Main`.

!!! note "Relación con la UT2"
    Aquí no repetimos todo JDBC: reutilizamos conexiones, `PreparedStatement`, `ResultSet` y gestión de excepciones para construir un **componente de persistencia**.
