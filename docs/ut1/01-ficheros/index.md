# 1. Ficheros, flujos y excepciones

Java proporciona distintas clases para trabajar con ficheros y directorios. La elección depende de qué información queremos almacenar y de cómo necesitamos acceder a ella.

## Qué vamos a estudiar

- Gestión de ficheros y directorios con `File`.
- Acceso secuencial y acceso aleatorio.
- Flujos de bytes.
- Flujos de caracteres.
- Manejo de excepciones.
- `try-with-resources`.

## Idea principal

No existe una única clase adecuada para todos los ficheros:

| Necesidad | Clases habituales |
|---|---|
| Gestionar rutas, ficheros y carpetas | `File` |
| Leer/escribir binario | `FileInputStream`, `FileOutputStream` |
| Mejorar eficiencia en binario | `BufferedInputStream`, `BufferedOutputStream` |
| Leer/escribir tipos primitivos | `DataInputStream`, `DataOutputStream` |
| Leer/escribir texto | `FileReader`, `FileWriter` |
| Leer texto por líneas | `BufferedReader` |
| Escribir texto cómodamente | `PrintWriter` |
| Acceso a posiciones concretas | `RandomAccessFile` |

## Proyecto de ejemplos

[📦 **Descargar ejemplos de ficheros**](../../descargas/ut1/ficheros/code_examples_1-1.zip)
