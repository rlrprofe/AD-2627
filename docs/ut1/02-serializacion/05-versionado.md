# `serialVersionUID`

Java guarda información sobre la versión de la clase junto con el objeto serializado.

```java
private static final long serialVersionUID = 1L;
```

## ¿Por qué declararlo?

Si no se declara, Java genera uno automáticamente a partir de la estructura de la clase. Un cambio en la clase puede modificar ese identificador y hacer incompatibles ficheros creados anteriormente.

El error típico es:

```text
java.io.InvalidClassException
```

Declarar explícitamente `serialVersionUID` permite controlar esa compatibilidad.

!!! warning
    Mantener el mismo `serialVersionUID` no garantiza que cualquier cambio imaginable sea compatible. Debemos valorar cómo ha cambiado la clase y los datos que esperamos recuperar.


---

## Qué significa serialVersionUID

Consulta `model/Persona.java` y `model/Personav2.java`. Un `serialVersionUID` diferente puede provocar `InvalidClassException` al leer un fichero antiguo; mantenerlo no garantiza compatibilidad ante cualquier cambio. **Las dos clases tienen nombres distintos**, por lo que `Personav2` no sustituye automáticamente a `Persona` durante la deserialización.

[**Descargar proyecto Maven revisado (Java 21)**](../../descargas/ut1/serializacion/code_examples_1-2.zip)
