# 6. Configuración básica de Maven

Vamos a examinar un ejemplo de `pom.xml` para un proyecto Java que utiliza JDK 21.

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="
           http://maven.apache.org/POM/4.0.0
           https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>es.iesisidra</groupId>
    <artifactId>gestion-productos</artifactId>
    <version>1.0-SNAPSHOT</version>

    <packaging>jar</packaging>

    <properties>
        <maven.compiler.release>21</maven.compiler.release>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

</project>
```

#### Explicación de las etiquetas principales

| Etiqueta | Función |
|---|---|
| `<project>` | Elemento raíz del archivo POM. |
| `<modelVersion>` | Versión del modelo POM. |
| `<groupId>` | Identificador de la organización o grupo. |
| `<artifactId>` | Identificador del proyecto. |
| `<version>` | Versión del artefacto. |
| `<packaging>` | Tipo de empaquetado, en este caso JAR. |
| `<properties>` | Propiedades de configuración. |
| `<maven.compiler.release>` | Versión de Java utilizada para compilar. |
| `<project.build.sourceEncoding>` | Codificación de los archivos fuente. |

En nuestro caso, la propiedad:

```xml
<maven.compiler.release>21</maven.compiler.release>
```

indica que el proyecto debe compilarse para **Java 21**, utilizando un JDK compatible.

!!! tip "Importante"
    El archivo `pom.xml` debe situarse en la raíz del proyecto.

    Los comandos Maven se ejecutarán normalmente desde la carpeta que contiene este archivo.
