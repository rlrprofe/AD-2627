# Manejo de excepciones en ficheros

Las operaciones de E/S pueden fallar: fichero inexistente, permisos insuficientes, ruta inválida, error de lectura, disco lleno, etc.

## 1. Excepciones frecuentes

| Excepción | Situación |
|---|---|
| `IOException` | Error general de entrada/salida |
| `FileNotFoundException` | No se encuentra el fichero |
| `EOFException` | Fin de fichero en determinadas lecturas |
| `UnsupportedEncodingException` | Codificación no soportada |

## 2. `try-catch-finally`

```java
FileReader fr = null;

try {
    fr = new FileReader("ejemplo.txt");
    // lectura
} catch (IOException e) {
    System.err.println("Error de E/S: " + e.getMessage());
} finally {
    if (fr != null) {
        try {
            fr.close();
        } catch (IOException e) {
            System.err.println("Error al cerrar");
        }
    }
}
```

## 3. `try-with-resources`

Es la opción recomendada para recursos que implementan `AutoCloseable`.

```java
try (FileReader fr = new FileReader("ejemplo.txt")) {
    int caracter;

    while ((caracter = fr.read()) != -1) {
        System.out.print((char) caracter);
    }

} catch (IOException e) {
    System.err.println("Error de E/S: " + e.getMessage());
}
```

Al salir del `try`, el recurso se cierra automáticamente, incluso si se produce una excepción.

## 4. Propagar con `throws`

```java
public static void leerFichero(String nombre) throws IOException {
    try (FileReader fr = new FileReader(nombre)) {
        // ...
    }
}
```

## 5. Buenas prácticas

- Utilizar `try-with-resources`.
- Mostrar mensajes de error comprensibles.
- Evitar capturar `Exception` de forma genérica sin necesidad.
- Tratar específicamente los errores que podamos resolver.
