# 5. El archivo pom.xml

El archivo **POM (Project Object Model)** es el elemento central de un proyecto Maven.

Es un archivo XML que describe cómo está configurado el proyecto.

Entre otras cosas, permite indicar:

- Identificación del proyecto.
- Versión del proyecto.
- Tipo de empaquetado.
- Versión de Java.
- Dependencias externas.
- Complementos de construcción.

#### Identificación de un proyecto

Maven utiliza principalmente tres elementos para identificar un proyecto:

| Elemento | Significado | Ejemplo |
|---|---|---|
| `groupId` | Identificador del grupo u organización. | `es.iesisidra` |
| `artifactId` | Nombre del artefacto o proyecto. | `gestion-productos` |
| `version` | Versión del proyecto. | `1.0-SNAPSHOT` |

La combinación de estos valores identifica un artefacto Maven.

Por ejemplo:

```xml
<groupId>es.iesisidra</groupId>
<artifactId>gestion-productos</artifactId>
<version>1.0-SNAPSHOT</version>
```

El sufijo `SNAPSHOT` suele indicar una versión en desarrollo.
