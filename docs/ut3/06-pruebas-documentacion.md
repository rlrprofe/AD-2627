# 3.6. Pruebas y documentación de componentes

**Duración orientativa:** 3 horas · **CE h)**

## 1. ¿Por qué probar un componente?

Una aplicación puede mostrar un menú correctamente y, sin embargo, guardar datos erróneos. Probar un componente de forma independiente permite comprobar **sus operaciones y su contrato**, sin depender de la interfaz de usuario.

## 2. Diseñar casos de prueba

| Caso | Datos | Resultado esperado |
|---|---|---|
| Guardar un producto nuevo | ID 1, nombre y precio válidos | El producto aparece en el listado. |
| Buscar uno existente | ID 1 | Se obtiene el producto. |
| Buscar uno inexistente | ID 999 | `Optional.empty()`. |
| Guardar ID duplicado | Dos productos con ID 1 | Se informa de error. |
| Precio negativo | Precio -5 | La capa de negocio rechaza el producto. |
| CSV mal formado | Línea incompleta | El DAO informa de un fallo de acceso. |
| MySQL no disponible | Conexión rechazada | El DAO informa de un fallo de acceso. |

## 3. Pruebas automatizadas con JUnit 5

Ejemplo basado en el proyecto descargable:

```java
@Test
void guardarYBuscarProducto() throws Exception {
    Path temporal = Files.createTempFile("productos-", ".csv");
    try {
        ProductoDAO dao = new ProductoFicheroDAO(temporal);
        Producto producto = new Producto(1, "Teclado", 25.0);

        dao.guardar(producto);

        assertEquals(producto, dao.buscarPorId(1).orElseThrow());
    } finally {
        Files.deleteIfExists(temporal);
    }
}
```

Este ejemplo utiliza un fichero temporal para que la prueba no modifique los datos reales del alumnado.

Para comprobar el comportamiento ante errores:

```java
assertThrows(AccesoDatosException.class,
        () -> dao.guardar(new Producto(1, "Duplicado", 20.0)));
```

!!! warning "Pruebas JDBC"
    Las pruebas que dependen de MySQL requieren una base de datos disponible y preparada. En esta unidad podemos probar automáticamente el DAO CSV y realizar pruebas de integración JDBC de forma guiada. No debemos afirmar que una prueba JDBC se ha ejecutado si no se ha conectado realmente a MySQL.

## 4. Javadoc: documentar el contrato

```java
/**
 * Busca un producto por su identificador.
 *
 * @param id identificador del producto
 * @return producto encontrado o vacío si no existe
 * @throws AccesoDatosException si falla el almacenamiento
 */
Optional<Producto> buscarPorId(int id) throws AccesoDatosException;
```

La documentación debe explicar **qué garantiza** el método y cómo se comporta ante situaciones especiales, no limitarse a repetir su nombre.

## 5. README y documentación de uso

Un README mínimo debería contener:

1. Objetivo del componente.
2. Requisitos (JDK 21, Maven y, para JDBC, MySQL).
3. Instrucciones para compilar y ejecutar.
4. Configuración de conexión sin exponer credenciales.
5. Ejemplo de uso del componente.
6. Cómo ejecutar las pruebas.
7. Limitaciones conocidas (por ejemplo, el formato CSV didáctico).

## 6. Comandos de verificación

```powershell
mvn test
mvn package
mvn javadoc:javadoc
```

La documentación generada por Javadoc puede consultarse en `target/reports/apidocs/` o en la ruta configurada por el plugin; comprueba el mensaje de salida de Maven para localizarla.

## 7. Actividad evaluable

Entrega un documento o tabla con **al menos seis casos de prueba**, indicando entrada, resultado esperado, resultado obtenido y conclusión. Adjunta el código de las pruebas JUnit y el README actualizado.

**Preguntas de comprobación individual:** ¿por qué utilizas un fichero temporal?, ¿qué diferencia hay entre un fallo de validación y uno de acceso a datos?, ¿qué ocurre si no se cierra la conexión?
