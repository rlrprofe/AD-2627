# 3.6. Pruebas y documentación de componentes

!!! info "Proyecto de trabajo"
    Continúa con el [proyecto inicial de Gestión de inventario](../descargas/ut3/Gestion_Inventario_Inicial_Java21_Maven.zip). Añade los archivos y las dependencias de este apartado. La solución completa se facilita al finalizar la UT3.


## Objetivos

- Verificar las reglas de negocio de forma independiente del almacenamiento.
- Introducir JUnit 5 en el proyecto Maven.
- Documentar el contrato público de los componentes.

## 1. ¿Qué debemos probar?

| Caso | Resultado esperado |
|---|---|
| Alta válida | El producto queda almacenado. |
| Alta con ID repetido | Se rechaza la operación. |
| Precio negativo | Se rechaza la operación. |
| Búsqueda inexistente | Devuelve `Optional.empty()`. |
| Modificación inexistente | Devuelve `false`. |
| Baja existente | Devuelve `true`. |

## 2. Añadir JUnit 5

En el `pom.xml` que estás construyendo a partir del proyecto inicial, incorpora:

```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.11.4</version>
    <scope>test</scope>
</dependency>
```

Además, configuramos `maven-surefire-plugin` para ejecutar las pruebas con `mvn test`.

### ¿Por qué no necesitamos abrir la aplicación completa para probar el servicio?

Una prueba unitaria debe comprobar una responsabilidad concreta. Para verificar las validaciones de `ProductoService`, no necesitamos mostrar menús ni conectarnos a MySQL. Basta con proporcionarle una implementación de `ProductoDAO` en memoria.

Esta es una consecuencia práctica de la **inyección de dependencias** que estudiamos en 3.3.

## 3. Probar sin depender de MySQL ni del CSV

Una ventaja de depender de la interfaz `ProductoDAO` es que podemos usar una implementación **en memoria** durante las pruebas.

Archivo: **`src/test/java/es/iesisidra/inventario/servicio/ProductoServiceTest.java`**.

```java
package es.iesisidra.inventario.servicio;

import es.iesisidra.inventario.dao.ProductoDAO;
import es.iesisidra.inventario.modelo.Producto;
import org.junit.jupiter.api.Test;
import java.util.*;
import static org.junit.jupiter.api.Assertions.*;

class ProductoServiceTest {
    static class DaoMemoria implements ProductoDAO {
        private final Map<Integer, Producto> datos = new HashMap<>();
        public void insertar(Producto p) { datos.put(p.id(), p); }
        public Optional<Producto> buscarPorId(int id) { return Optional.ofNullable(datos.get(id)); }
        public List<Producto> listar() { return new ArrayList<>(datos.values()); }
        public boolean actualizar(Producto p) {
            if (!datos.containsKey(p.id())) return false;
            datos.put(p.id(), p);
            return true;
        }
        public boolean eliminar(int id) { return datos.remove(id) != null; }
    }

    @Test
    void altaValida() {
        ProductoService servicio = new ProductoService(new DaoMemoria());
        servicio.alta(new Producto(1, "Teclado", 19.95, 12));
        assertTrue(servicio.buscar(1).isPresent());
    }

    @Test
    void rechazaPrecioNegativo() {
        ProductoService servicio = new ProductoService(new DaoMemoria());
        assertThrows(IllegalArgumentException.class,
                () -> servicio.alta(new Producto(2, "Raton", -1, 3)));
    }

    @Test
    void rechazaIdDuplicado() {
        ProductoService servicio = new ProductoService(new DaoMemoria());
        servicio.alta(new Producto(1, "Teclado", 19.95, 12));
        assertThrows(IllegalArgumentException.class,
                () -> servicio.alta(new Producto(1, "Otro", 10, 2)));
    }
}
```

!!! info "Ventaja del desacoplamiento"
    Estas pruebas se ejecutan sin arrancar MySQL y sin crear un archivo CSV. Comprueban las reglas de negocio, no la infraestructura.

## 4. Ejecutar las pruebas

```bash
mvn test
```

Los informes de Surefire se generan habitualmente en `target/surefire-reports/`.

Para compilar, ejecutar pruebas y generar el JAR:

```bash
mvn clean package
```

## 5. Probar la integración entre controlador y vista

Además de las pruebas del servicio, la solución de referencia incluye pruebas de `ProductoControlador` y `ProductoFicheroDAO`.

Para comprobar el controlador podemos **simular la entrada del usuario** con un `Scanner` creado a partir de una cadena y **capturar la salida** con `ByteArrayOutputStream`. Así verificamos el menú sin introducir datos manualmente.

```java
String entradas = "3\n0\n";
ByteArrayOutputStream salidaBytes = new ByteArrayOutputStream();

try (Scanner scanner = new Scanner(entradas);
     PrintStream salida = new PrintStream(salidaBytes)) {
    ConsolaVista vista = new ConsolaVista(scanner, salida);
    ProductoService servicio = new ProductoService(new DaoMemoria());
    new ProductoControlador(vista, servicio).iniciar();
}

String resultado = salidaBytes.toString();
assertTrue(resultado.contains("GESTIÓN DE INVENTARIO"));
```

Este fragmento requiere las importaciones de `Scanner`, `ByteArrayOutputStream`, `PrintStream` y JUnit, así como un DAO de prueba que implemente `ProductoDAO`.

**¿Qué estamos comprobando?** Que el controlador coordina correctamente la vista y el servicio; no que MySQL esté funcionando.

Para el DAO CSV, las pruebas deben utilizar un archivo temporal y comprobar que los cambios se mantienen tras volver a leerlo.

## 6. Documentación con Javadoc

En nuestro proyecto documentaremos especialmente la interfaz `ProductoDAO`, porque es el contrato que otras clases deben conocer.

Ejemplo:

```java
/**
 * Busca un producto por su identificador.
 * @param id identificador del producto
 * @return producto encontrado o Optional vacío
 */
Optional<Producto> buscarPorId(int id);
```

La documentación debe describir las operaciones públicas, sus parámetros, sus resultados y las excepciones relevantes, sin limitarse a repetir el nombre del método.

## 7. Pruebas de integración

Las pruebas anteriores son **unitarias**. También conviene comprobar cada implementación real:

- CSV: insertar, leer, actualizar y eliminar sobre un archivo temporal.
- JDBC: ejecutar las mismas operaciones contra una base de datos de pruebas independiente.

No utilizaremos la base de datos de producción para realizar pruebas destructivas.

## 8. Actividades

1. Añade una prueba que verifique el resultado de una búsqueda inexistente.
2. Añade una prueba que compruebe la eliminación de un producto.
3. Explica qué diferencia hay entre prueba unitaria y prueba de integración.
4. Documenta los cinco métodos de `ProductoDAO`.

**Continúa con:** [3.7. Integración de componentes en aplicaciones](07-integracion.md).
