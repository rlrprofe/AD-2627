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
