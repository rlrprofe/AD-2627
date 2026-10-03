# Flujos de caracteres

Los flujos de caracteres están especializados en **texto**. Son apropiados para `.txt`, `.csv`, `.xml`, `.json`, etc.

## 1. Bytes frente a caracteres

- **Bytes:** información binaria en crudo.
- **Caracteres:** los bytes se interpretan como texto.

## 2. `FileReader`

```java
try (FileReader fr = new FileReader("texto.txt")) {
    int c;

    while ((c = fr.read()) != -1) {
        System.out.print((char) c);
    }
}
```

## 3. `FileWriter`

```java
try (FileWriter fw = new FileWriter("salida.txt")) {
    fw.write("Primera línea\n");
    fw.write("Segunda línea\n");
}
```

Para añadir al final:

```java
new FileWriter("salida.txt", true)
```

## 4. `BufferedReader`

Permite leer cómodamente línea a línea mediante `readLine()`.

```java
try (BufferedReader br =
         new BufferedReader(new FileReader("texto.txt"))) {

    String linea;

    while ((linea = br.readLine()) != null) {
        System.out.println(linea);
    }
}
```

## 5. `PrintWriter`

```java
try (PrintWriter pw =
         new PrintWriter(new FileWriter("salida.txt"))) {

    pw.println("Primera línea");
    pw.println("Segunda línea");
    pw.printf("La nota media es %.2f%n", 8.75);
}
```

## 6. Resumen

| Clase | Uso principal |
|---|---|
| `FileReader` | Leer caracteres |
| `FileWriter` | Escribir caracteres |
| `BufferedReader` | Leer texto por líneas |
| `BufferedWriter` | Escritura de texto con buffer |
| `PrintWriter` | Escritura cómoda con `print`, `println`, `printf` |
