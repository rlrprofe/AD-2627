# Flujos de bytes

Los flujos de bytes trabajan con información binaria **sin interpretarla como texto**. Son adecuados para imágenes, audio, vídeo, PDF, ejecutables y otros formatos binarios.

## 1. `FileInputStream` y `FileOutputStream`

```java
try (FileInputStream in = new FileInputStream("origen.bin");
     FileOutputStream out = new FileOutputStream("copia.bin")) {

    byte[] buffer = new byte[8192];
    int leidos;

    while ((leidos = in.read(buffer)) != -1) {
        out.write(buffer, 0, leidos);
    }
}
```

## 2. Flujos con buffer

`BufferedInputStream` y `BufferedOutputStream` reducen el número de accesos físicos al dispositivo.

```java
try (InputStream in = new BufferedInputStream(
        new FileInputStream("video.mp4"))) {

    byte[] buffer = new byte[16_384];

    while (in.read(buffer) != -1) {
        // procesar
    }
}
```

## 3. Datos primitivos

`DataInputStream` y `DataOutputStream` permiten guardar y recuperar directamente `int`, `double`, `boolean`, cadenas UTF, etc.

```java
try (DataOutputStream dos =
         new DataOutputStream(new FileOutputStream("registro.bin"))) {
    dos.writeInt(42);
    dos.writeUTF("Ana");
    dos.writeDouble(9.1);
}
```

La lectura debe respetar **el mismo orden y los mismos tipos**:

```java
try (DataInputStream dis =
         new DataInputStream(new FileInputStream("registro.bin"))) {
    int id = dis.readInt();
    String nombre = dis.readUTF();
    double nota = dis.readDouble();
}
```

## 4. Bytes en memoria

`ByteArrayInputStream` y `ByteArrayOutputStream` permiten tratar un array de bytes como un flujo.

```java
ByteArrayOutputStream baos = new ByteArrayOutputStream();
baos.write(new byte[]{10, 20, 30});

byte[] datos = baos.toByteArray();
```

## 5. Resumen

| Clase | Uso |
|---|---|
| `FileInputStream` | Leer bytes de un fichero |
| `FileOutputStream` | Escribir bytes |
| `BufferedInputStream` | Lectura binaria con buffer |
| `BufferedOutputStream` | Escritura binaria con buffer |
| `DataInputStream` | Leer tipos primitivos |
| `DataOutputStream` | Escribir tipos primitivos |
| `ByteArrayInputStream` | Leer desde memoria |
| `ByteArrayOutputStream` | Escribir en memoria |
