# Gestión de ficheros y directorios con `File`

## 1. La clase `File`

`File` representa una **ruta** a un fichero o directorio. Crear un objeto `File` no crea automáticamente el fichero en disco.

```java
File fichero = new File("datos.txt");
```

Podemos preguntar por el estado de esa ruta:

```java
if (fichero.exists()) {
    System.out.println("El fichero existe");
} else {
    System.out.println("No existe");
}
```

## 2. Métodos principales

| Método | Utilidad |
|---|---|
| `exists()` | Comprueba si existe |
| `createNewFile()` | Crea un fichero vacío |
| `delete()` | Borra un fichero o directorio |
| `mkdir()` | Crea un directorio |
| `listFiles()` | Obtiene el contenido de un directorio |
| `getAbsolutePath()` | Obtiene la ruta absoluta |
| `isFile()` | Comprueba si es fichero |
| `isDirectory()` | Comprueba si es directorio |

## 3. Crear un directorio

```java
File carpeta = new File("datos");

if (!carpeta.exists()) {
    boolean creada = carpeta.mkdir();
    System.out.println("Directorio creado: " + creada);
}
```

## 4. Recorrer un directorio

```java
File carpeta = new File(".");

File[] elementos = carpeta.listFiles();

if (elementos != null) {
    for (File elemento : elementos) {
        System.out.println(
            elemento.getName() +
            (elemento.isDirectory() ? " [DIR]" : " [FICHERO]")
        );
    }
}
```

!!! note
    Un objeto `File` describe una ruta. Las operaciones de lectura y escritura del contenido se realizan mediante otras clases de entrada/salida.
