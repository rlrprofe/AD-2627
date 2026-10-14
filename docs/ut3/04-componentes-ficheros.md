# 3.4. Componente de acceso a ficheros CSV

**Duración orientativa:** 3 horas · **CE c), h)**

## 1. Objetivo

Construiremos `ProductoFicheroDAO`, un componente que implementa `ProductoDAO` y almacena productos en un fichero de texto CSV. Recuperamos así los conocimientos de la UT1, pero **sin mezclar el código de ficheros con el menú**.

## 2. Modelo de datos

```java
package es.iesisidra.productos.modelo;

public record Producto(int id, String nombre, double precio) {
}
```

Utilizamos `record` (Java 21) para representar un dato inmutable. Un producto tiene identificador, nombre y precio. La capa de negocio comprobará que sus valores sean válidos.

## 3. Formato del fichero

Para simplificar el ejemplo utilizaremos el carácter `;` como separador:

```text
id;nombre;precio
1;Teclado;24.50
2;Raton;12.99
```

!!! warning "CSV didáctico"
    En este ejemplo **no se admiten nombres con `;`, comillas ni saltos de línea**. Un CSV general requiere reglas de escape y una biblioteca especializada. El proyecto valida esta limitación para evitar datos ambiguos.

## 4. Lectura y escritura con `Files`

```java
Path ruta = Path.of("datos", "productos.csv");

// Leer todas las líneas con codificación UTF-8.
List<String> lineas = Files.readAllLines(ruta, StandardCharsets.UTF_8);

// Escribir líneas en un fichero con codificación UTF-8.
Files.write(ruta, lineas, StandardCharsets.UTF_8);
```

Al trabajar con el DAO, estas operaciones estarán encapsuladas en sus métodos privados y no serán visibles para el resto de la aplicación.

## 5. Implementación de `guardar`

Fragmento simplificado del componente descargable:

```java
@Override
public void guardar(Producto producto) throws AccesoDatosException {
    List<Producto> productos = listar();

    for (Producto existente : productos) {
        if (existente.id() == producto.id()) {
            throw new AccesoDatosException("Ya existe el ID " + producto.id());
        }
    }

    productos.add(producto);
    escribirTodos(productos);
}
```

En el proyecto descargable utilizamos bucles `for`, sin expresiones lambda, y añadimos comprobaciones y tratamiento de `IOException`.

## 6. ¿Qué ocurre si falla la lectura?

Un componente no debe ocultar los errores importantes. Si el fichero está dañado o no se puede leer, debe informar al consumidor mediante una excepción clara:

```java
try {
    List<String> lineas = Files.readAllLines(ruta, StandardCharsets.UTF_8);
    // Procesar las líneas.
} catch (IOException e) {
    throw new AccesoDatosException("No se pudo leer " + ruta, e);
}
```

El segundo argumento (`e`) conserva la **causa original**, útil para depurar.

## 7. Reglas del contrato

- `guardar`: añade un producto nuevo; si el ID ya existe, informa del error.
- `buscarPorId`: devuelve un `Optional` con el producto o vacío si no existe.
- `listar`: devuelve todos los productos, sin exponer detalles del CSV.
- El DAO no muestra mensajes al usuario ni utiliza `Scanner`.

## 8. Actividad guiada

1. Descarga y ejecuta el proyecto con almacenamiento CSV.
2. Añade un producto y comprueba el contenido del fichero.
3. Busca un ID existente y otro inexistente.
4. Intenta guardar un ID repetido y describe el resultado.
5. Modifica temporalmente una línea del CSV para provocar un error de formato; explica dónde se detecta.
6. Añade comentarios Javadoc a uno de los métodos públicos.

## 9. Ejercicio de ampliación

Incorpora `eliminarPorId(int id)` al contrato y a la implementación CSV. Define previamente qué debe suceder cuando el ID no existe y documenta esa decisión.

!!! tip "Relación con el CE c)"
    La evidencia no consiste únicamente en leer un fichero. Debes demostrar que has construido un **componente reutilizable** que ofrece operaciones de acceso a datos mediante una interfaz.
