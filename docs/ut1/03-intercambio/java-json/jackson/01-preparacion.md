# Preparación del proyecto

### 1. Introducción

Jackson no forma parte de la biblioteca estándar de Java. Para utilizarlo añadiremos la librería al proyecto mediante **Maven**.

En este minicurso trabajaremos con:

- **Java 21**;
- **Maven**;
- **Jackson Databind**.

---

### 2. Estructura del proyecto

```text
jackson-ejemplos/
├── pom.xml
├── data/
└── src/
    └── main/
        └── java/
            └── com/
                └── example/
```

El fichero `pom.xml` describe el proyecto y sus dependencias.

---

### 3. Configurar Java 21

```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.release>21</maven.compiler.release>
</properties>
```

!!! important
    La propiedad `maven.compiler.release` queda fijada a **21** para que todos los proyectos del minicurso utilicen la misma versión de Java.

---

### 4. Añadir Jackson Databind

La dependencia principal será:

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.22.3</version>
</dependency>
```

`jackson-databind` proporciona el mecanismo de enlace de datos (*data binding*) que utilizaremos mediante `ObjectMapper`.

!!! note "Versión utilizada"
    El proyecto del minicurso fija una versión concreta para que todos trabajemos con el mismo entorno. Si se crea otro proyecto en el futuro, conviene comprobar en Maven Central la versión disponible.

---

### 5. `pom.xml` completo

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>jackson-ejemplos</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.release>21</maven.compiler.release>
    </properties>

    <dependencies>
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>2.22.3</version>
        </dependency>
    </dependencies>

</project>
```

---

### 6. Importar ObjectMapper

```java
import com.fasterxml.jackson.databind.ObjectMapper;
```

Y crear el objeto:

```java
ObjectMapper mapper = new ObjectMapper();
```

Este objeto será el centro de la mayoría de ejemplos.

---

### 7. Primer ejemplo

```java
package com.example;

import com.fasterxml.jackson.databind.ObjectMapper;

public class PrimerJackson {

    public static void main(String[] args) throws Exception {

        ObjectMapper mapper = new ObjectMapper();

        String[] modulos = {
                "Acceso a Datos",
                "Programación de Servicios"
        };

        String json = mapper.writeValueAsString(modulos);

        System.out.println(json);
    }
}
```

Salida aproximada:

```json
["Acceso a Datos","Programación de Servicios"]
```

---

### 8. ¿Qué ha ocurrido?

```text
String[]
   │
   ▼
ObjectMapper
   │
   │ writeValueAsString()
   ▼
String JSON
```

No hemos construido manualmente `[` `]`, comas ni comillas. Jackson ha realizado la serialización.

---

### 9. Formato legible

Podemos pedir una salida con sangrado:

```java
String json = mapper
        .writerWithDefaultPrettyPrinter()
        .writeValueAsString(modulos);
```

Resultado:

```json
[
  "Acceso a Datos",
  "Programación de Servicios"
]
```

---

### 10. Comprobaciones antes de continuar

Antes de pasar a la serialización de nuestros propios objetos debemos comprobar que:

- el proyecto utiliza JDK 21;
- Maven reconoce el `pom.xml`;
- la dependencia se ha descargado;
- `ObjectMapper` puede importarse;
- el ejemplo se ejecuta sin errores.

!!! tip
    Si VS Code no reconoce inmediatamente una dependencia después de modificar `pom.xml`, espera a que Maven actualice el proyecto o recarga el proyecto Java.

---

### 11. Idea que debemos recordar

```text
Jackson Databind
      │
      ▼
 ObjectMapper
      │
      ├── write... → serializar
      │
      └── read...  → deserializar
```
