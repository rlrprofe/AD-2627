# 3.4. Componentes de acceso a ficheros

!!! info "Proyecto de trabajo"
    Continúa con el [proyecto inicial de Gestión de inventario](../descargas/ut3/Gestion_Inventario_Inicial_Java21_Maven.zip). Añade los archivos y las dependencias de este apartado. La solución completa se facilita al finalizar la UT3.


## Objetivos

- Implementar el contrato `ProductoDAO` utilizando un archivo CSV.
- Construir una aplicación de consola funcional.
- Separar el código de lectura/escritura del menú y de las reglas de negocio.

## 1. Primera versión: almacenamiento CSV

Partimos del modelo, la interfaz DAO y el servicio creados en 3.3. El archivo `datos/productos.csv` tendrá el formato:

```csv
id;nombre;precio;stock
1;Teclado;19.95;12
2;Raton;9.50;20
```

!!! warning "Simplificación didáctica"
    Utilizaremos punto decimal y separador `;`. En este ejemplo los nombres de productos no pueden contener `;` ni saltos de línea. Para datos CSV generales sería preferible una biblioteca específica.

## 2. Implementación del DAO

Archivo: **`src/main/java/es/iesisidra/inventario/dao/ProductoFicheroDAO.java`**.

```java
package es.iesisidra.inventario.dao;

import es.iesisidra.inventario.modelo.Producto;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

public class ProductoFicheroDAO implements ProductoDAO {
    private final Path ruta;

    public ProductoFicheroDAO(Path ruta) {
        this.ruta = ruta;
    }

    @Override
    public List<Producto> listar() {
        if (!Files.exists(ruta)) return new ArrayList<>();
        try {
            List<Producto> productos = new ArrayList<>();
            for (String linea : Files.readAllLines(ruta, StandardCharsets.UTF_8)) {
                if (linea.isBlank() || linea.equals("id;nombre;precio;stock")) continue;
                String[] c = linea.split(";", -1);
                if (c.length != 4) throw new IllegalStateException("CSV incorrecto: " + linea);
                productos.add(new Producto(Integer.parseInt(c[0]), c[1],
                        Double.parseDouble(c[2]), Integer.parseInt(c[3])));
            }
            return productos;
        } catch (IOException e) {
            throw new IllegalStateException("Error al leer CSV", e);
        }
    }

    @Override
    public Optional<Producto> buscarPorId(int id) {
        return listar().stream().filter(p -> p.id() == id).findFirst();
    }

    @Override
    public void insertar(Producto p) {
        List<Producto> productos = listar();
        if (productos.stream().anyMatch(x -> x.id() == p.id())) {
            throw new IllegalArgumentException("El ID ya existe");
        }
        productos.add(p);
        guardar(productos);
    }

    @Override
    public boolean actualizar(Producto p) {
        List<Producto> productos = listar();
        for (int i = 0; i < productos.size(); i++) {
            if (productos.get(i).id() == p.id()) {
                productos.set(i, p);
                guardar(productos);
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean eliminar(int id) {
        List<Producto> productos = listar();
        boolean eliminado = productos.removeIf(p -> p.id() == id);
        if (eliminado) guardar(productos);
        return eliminado;
    }

    private void guardar(List<Producto> productos) {
        try {
            Path carpeta = ruta.toAbsolutePath().getParent();
            if (carpeta != null) Files.createDirectories(carpeta);
            List<String> lineas = new ArrayList<>();
            lineas.add("id;nombre;precio;stock");
            for (Producto p : productos) {
                if (p.nombre().contains(";") || p.nombre().contains("\n")
                        || p.nombre().contains("\r")) {
                    throw new IllegalArgumentException("Nombre incompatible con el CSV simplificado");
                }
                lineas.add(p.id() + ";" + p.nombre() + ";" + p.precio() + ";" + p.stock());
            }
            Files.write(ruta, lineas, StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new IllegalStateException("Error al guardar CSV", e);
        }
    }
}
```

### ¿Qué hemos encapsulado?

- La lectura y escritura con `Files`.
- La conversión de líneas CSV a objetos `Producto`.
- Las operaciones CRUD sobre el conjunto de productos.

La aplicación **no necesita saber** cómo se guarda físicamente la información.

## 3. Crear una interfaz de consola sin mezclar responsabilidades

Una vez que `ProductoFicheroDAO` puede guardar y recuperar productos, necesitamos que el usuario pueda interactuar con la aplicación. **No escribiremos el menú dentro de `main`**: crearemos una vista y un controlador.

### 3.1. La vista: `ConsolaVista`

Archivo: `src/main/java/es/iesisidra/inventario/vista/ConsolaVista.java`.

La vista es responsable de **toda la entrada y salida**. Contiene métodos como:

| Método | Función |
|---|---|
| `solicitarOpcion()` | Muestra el menú y devuelve la opción elegida. |
| `solicitarProducto()` | Solicita ID, nombre, precio y stock y crea un `Producto`. |
| `solicitarId()` | Pide el identificador de un producto. |
| `mostrarProducto(...)` | Presenta un producto con formato. |
| `mostrarProductos(...)` | Presenta un listado o indica que está vacío. |
| `mostrarMensaje(...)` y `mostrarError(...)` | Centralizan los mensajes de salida. |

Fragmento del código de la solución:

```java
public void mostrarProducto(Producto producto) {
    salida.printf("ID: %d | Nombre: %s | Precio: %.2f | Stock: %d%n",
            producto.id(), producto.nombre(), producto.precio(), producto.stock());
}
```

La vista puede utilizar `Scanner` para leer, pero **no ejecuta SQL, no lee el CSV y no valida las reglas de negocio**. Sí comprueba el formato de entrada (por ejemplo, que el usuario introduzca un número entero).

### 3.2. El controlador: `ProductoControlador`

Archivo: `src/main/java/es/iesisidra/inventario/controlador/ProductoControlador.java`.

El controlador recibe en el constructor un servicio y una vista. Su trabajo es **coordinar**, no implementar el almacenamiento:

```java
private void alta() {
    Producto producto = vista.solicitarProducto();
    servicio.alta(producto);
    vista.mostrarMensaje("Producto registrado.");
}
```

Observa que este método tiene solo tres instrucciones y cada una tiene una finalidad clara: solicitar datos, ejecutar la operación y mostrar el resultado.

El controlador contiene métodos distintos para `alta`, `buscar`, `listar`, `modificar` y `eliminar`. Así evitamos que el `switch` del menú acumule toda la lógica.

### 3.3. `App`: conectar los objetos

Archivo: `src/main/java/es/iesisidra/inventario/App.java`.

Por ahora utilizaremos el DAO CSV:

```java
ProductoDAO dao = new ProductoFicheroDAO(Path.of("datos", "productos.csv"));
ProductoService servicio = new ProductoService(dao);

try (Scanner scanner = new Scanner(System.in)) {
    ConsolaVista vista = new ConsolaVista(scanner, System.out);
    new ProductoControlador(servicio, vista).iniciar();
}
```

Para que compile, incorpora las importaciones de las clases y de `Path` y `Scanner`. La solución final contiene la clase completa.

En 3.7 sustituiremos la construcción directa del DAO por `Configuracion.crearDao()`, que permitirá elegir CSV o MySQL sin cambiar la vista, el controlador ni el servicio.

!!! note "Proyecto inicial y solución final"
    El proyecto inicial es un **esqueleto de trabajo**. La solución final contiene las clases `ConsolaVista`, `ProductoControlador` y `Configuracion`, que deben incorporarse durante el desarrollo. No es necesario copiar toda la solución desde el principio.

## 4. Compilar y ejecutar

Desde la raíz del proyecto:

```bash
mvn clean compile
```

En este punto, ejecuta `App` desde el IDE. **Todavía no hemos configurado el JAR ejecutable**; completaremos su empaquetado en 3.7.

Una vez terminada la unidad podrás utilizar:

```bash
mvn clean package
java -jar target/gestion-inventario-1.0-SNAPSHOT.jar
```

Por defecto, la aplicación utiliza **CSV**.

Ejemplo de interacción:

```text
1. Alta  2. Buscar  3. Listar  4. Modificar  5. Eliminar  0. Salir
Opción: 3
ID: 1 | Nombre: Teclado | Precio: 19.95 | Stock: 12
ID: 2 | Nombre: Raton | Precio: 9.50 | Stock: 20
```

## 5. Limitaciones de esta implementación

Para facilitar el aprendizaje, cada operación vuelve a leer el archivo y las modificaciones reescriben su contenido completo. La solución de referencia utiliza un fichero temporal y procura sustituir el original de forma segura; aun así, no ofrece control de acceso concurrente ni garantías de transacción equivalentes a una base de datos. Son limitaciones que debemos conocer antes de utilizar esta solución en una aplicación real.

## 6. Actividades

1. Añade un producto y comprueba que aparece en `productos.csv`.
2. Modifica su precio y vuelve a abrir el archivo.
3. Intenta insertar dos productos con el mismo identificador.
4. Explica qué métodos de `ProductoService` habría que modificar para cambiar a MySQL. **Respuesta esperada: ninguno.**

**Continúa con:** [3.5. Componentes de acceso mediante JDBC](05-componentes-jdbc.md).
