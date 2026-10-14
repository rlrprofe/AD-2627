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

## 3. Crear el menú de consola

Archivo: **`src/main/java/es/iesisidra/inventario/App.java`**.

Partiendo del [proyecto inicial](../descargas/ut3/Gestion_Inventario_Inicial_Java21_Maven.zip), implementa la clase siguiendo los ejemplos anteriores. La parte fundamental es la creación del servicio:

```java
ProductoDAO dao = new ProductoFicheroDAO(Path.of("datos", "productos.csv"));
ProductoService servicio = new ProductoService(dao);
```

A partir de ahí, el menú llama a `servicio.alta(...)`, `servicio.buscar(...)`, `servicio.listar()`, `servicio.modificar(...)` y `servicio.baja(...)`.

!!! note "Por qué no copiamos aquí dos veces el menú"
    El menú completo se conserva en **un único archivo `App.java`** y será idéntico para CSV y MySQL. Constrúyelo progresivamente a partir del proyecto inicial, siguiendo las indicaciones de este apartado.

## 4. Compilar y ejecutar

Desde la raíz del proyecto:

```bash
mvn clean package
java -jar target/gestion-inventario-1.0-SNAPSHOT.jar
```

Con el `pom.xml` del proyecto inicial, ejecuta la clase `App` desde el IDE. La generación de un JAR ejecutable se completará en 3.7.

Por defecto, la aplicación utiliza **CSV**.

Ejemplo de interacción:

```text
1. Alta  2. Buscar  3. Listar  4. Modificar  5. Eliminar  0. Salir
Opción: 3
Producto[id=1, nombre=Teclado, precio=19.95, stock=12]
Producto[id=2, nombre=Raton, precio=9.5, stock=20]
```

## 5. Limitaciones de esta implementación

Para facilitar el aprendizaje, cada operación vuelve a leer el archivo y las modificaciones reescriben su contenido completo. No hay control de acceso concurrente ni escritura atómica. Son limitaciones que debemos conocer antes de utilizar esta solución en una aplicación real.

## 6. Actividades

1. Añade un producto y comprueba que aparece en `productos.csv`.
2. Modifica su precio y vuelve a abrir el archivo.
3. Intenta insertar dos productos con el mismo identificador.
4. Explica qué métodos de `ProductoService` habría que modificar para cambiar a MySQL. **Respuesta esperada: ninguno.**

**Continúa con:** [3.5. Componentes de acceso mediante JDBC](05-componentes-jdbc.md).
