# Serializar y deserializar un objeto

## 1. Serialización

```java
Persona p = new Persona("Ana", 25, "secreto123");

try (ObjectOutputStream oos =
         new ObjectOutputStream(
             new FileOutputStream("persona.dat"))) {

    oos.writeObject(p);
}
```

Pasos:

1. La clase implementa `Serializable`.
2. Se abre `FileOutputStream`.
3. `ObjectOutputStream` envuelve al flujo anterior.
4. `writeObject()` escribe el objeto.
5. `try-with-resources` cierra el flujo.

## 2. Deserialización

```java
try (ObjectInputStream ois =
         new ObjectInputStream(
             new FileInputStream("persona.dat"))) {

    Persona p = (Persona) ois.readObject();
    System.out.println(p);

} catch (IOException | ClassNotFoundException e) {
    System.err.println(e.getMessage());
}
```

`readObject()` devuelve `Object`, por lo que normalmente debemos hacer un **cast** al tipo esperado.

!!! note
    El fichero debe haber sido creado previamente mediante serialización compatible.
