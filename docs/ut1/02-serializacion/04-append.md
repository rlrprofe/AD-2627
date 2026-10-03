# Añadir objetos a un fichero existente

## 1. El problema de la cabecera

`ObjectOutputStream` escribe una cabecera al crear el flujo. Si abrimos un fichero en modo `append` y creamos un nuevo `ObjectOutputStream`, aparecerá otra cabecera en mitad del fichero.

Esto puede provocar `StreamCorruptedException`.

## 2. Patrón A: un único flujo

Mientras la aplicación está ejecutándose, podemos mantener un único `ObjectOutputStream` abierto y llamar varias veces a `writeObject()`.

Es sencillo, pero no permite cerrar el programa y reabrir posteriormente el fichero para seguir añadiendo objetos.

## 3. Patrón B: omitir la cabecera en escrituras posteriores

```java
public class AppendingObjectOutputStream
        extends ObjectOutputStream {

    public AppendingObjectOutputStream(OutputStream out)
            throws IOException {
        super(out);
    }

    @Override
    protected void writeStreamHeader() throws IOException {
        reset();
    }
}
```

Al escribir comprobamos si el fichero ya contiene información:

```java
File f = new File("personas.dat");
boolean existe = f.exists() && f.length() > 0;

try (OutputStream fos = new FileOutputStream(f, true);
     ObjectOutputStream oos = existe
         ? new AppendingObjectOutputStream(fos)
         : new ObjectOutputStream(fos)) {

    oos.writeObject(persona);
}
```

Así la cabecera se escribe únicamente al crear el fichero por primera vez.
