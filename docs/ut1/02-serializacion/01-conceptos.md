# Serializable, `transient` y flujos de objetos

## 1. `Serializable`

La clase que queremos serializar debe implementar `java.io.Serializable`.

```java
public class Persona implements Serializable {
    private static final long serialVersionUID = 1L;

    private String nombre;
    private int edad;
    private transient String password;
}
```

`Serializable` es una **interfaz marcador**: no obliga a implementar métodos.

## 2. Atributos serializables

Los atributos que forman parte del objeto también deben poder serializarse.

Si un atributo no debe almacenarse podemos utilizar `transient`.

```java
private transient String password;
```

Al recuperar el objeto, ese atributo tendrá su valor por defecto (`null`, `0`, `false`, etc.).

## 3. Clases que intervienen

| Clase | Función |
|---|---|
| `FileOutputStream` | Abre un fichero para escribir bytes |
| `ObjectOutputStream` | Convierte objetos en bytes |
| `FileInputStream` | Abre un fichero para leer bytes |
| `ObjectInputStream` | Reconstruye objetos desde bytes |
