# Acceso secuencial y aleatorio

## 1. Acceso secuencial

En el acceso secuencial los datos se leen o escriben **en orden, de principio a fin**.

Ejemplos habituales:

- recorrer un fichero de texto línea a línea;
- copiar una imagen;
- generar un fichero CSV;
- leer un log.

Clases frecuentes: `FileReader`, `FileWriter`, `BufferedReader`, `PrintWriter`, `FileInputStream` y `FileOutputStream`.

## 2. Acceso aleatorio

El acceso aleatorio permite desplazarnos a una posición concreta del fichero mediante `RandomAccessFile`.

```java
try (RandomAccessFile raf =
         new RandomAccessFile("datos.dat", "rw")) {

    raf.writeInt(101);
    raf.writeUTF("Pedro");
    raf.writeDouble(8.5);

    raf.seek(0);

    int id = raf.readInt();
    String nombre = raf.readUTF();
    double nota = raf.readDouble();

    System.out.println(id + " - " + nombre + " - " + nota);
}
```

## 3. Métodos importantes de `RandomAccessFile`

| Método | Función |
|---|---|
| `seek(long pos)` | Mueve el puntero a una posición en bytes |
| `getFilePointer()` | Devuelve la posición actual |
| `length()` | Devuelve el tamaño del fichero |
| `readInt()`, `readDouble()`, `readUTF()` | Lee distintos tipos |
| `writeInt()`, `writeDouble()`, `writeUTF()` | Escribe distintos tipos |

## 4. Comparativa

| Secuencial | Aleatorio |
|---|---|
| Se recorre en orden | Podemos saltar a una posición |
| Más sencillo | Requiere conocer la organización del fichero |
| Adecuado para texto y procesamiento completo | Adecuado para registros de tamaño/posición conocidos |
