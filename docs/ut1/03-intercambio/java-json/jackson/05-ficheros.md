# Ficheros JSON con Jackson

!!! note "Ejemplos y proyecto descargable (Java 21)"
    Los fragmentos de esta página ilustran conceptos. La versión **completa y ejecutable** utiliza paquetes separados (`com.example.app`, `model`, `repository` y, cuando corresponde, `config`/`adapter`). Consulta el [orden didáctico y la estructura del proyecto](index.md#guia-del-proyecto-maven-actualizado-java-21) y el [ZIP actualizado](../../../../descargas/ut1/java-json/jackson-ejemplos.zip).

### 1. De la memoria a la persistencia

Hasta ahora el JSON podía vivir únicamente en una variable `String`.

Ahora queremos almacenarlo:

```text
List<Alumno>
      │
      ▼
 ObjectMapper
      │
      ▼
 data/alumnos.json
```

Y después recuperarlo:

```text
data/alumnos.json
      │
      ▼
 ObjectMapper
      │
      ▼
List<Alumno>
```

---

### 2. Preparar el directorio

```java
Path ruta = Path.of("data", "alumnos.json");
Files.createDirectories(ruta.getParent());
```

Imports:

```java
import java.nio.file.Files;
import java.nio.file.Path;
```

---

### 3. Guardar directamente en un fichero

Jackson permite escribir directamente en un destino:

```java
mapper.writeValue(ruta.toFile(), alumnos);
```

Si queremos formato legible:

```java
mapper
    .writerWithDefaultPrettyPrinter()
    .writeValue(ruta.toFile(), alumnos);
```

---

### 4. Ejemplo: `GuardarAlumnosJackson.java`

```java
package com.example.app;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.example.config.JacksonConfig;
import com.example.model.Alumno;
import com.example.repository.AlumnoJsonRepository;
import java.io.IOException;


import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

/** Ejemplo didáctico de Jackson. */
public class GuardarAlumnosJackson {
    public static void main(String[] args) {
        ObjectMapper mapper = JacksonConfig.crearMapper();
        

        List<Alumno> alumnos = List.of(
                new Alumno(1, "Ana", 8.5),
                new Alumno(2, "Luis", 7.2),
                new Alumno(3, "Marta", 9.1)
        );

        Path fichero = Path.of("data", "alumnos.json");
        AlumnoJsonRepository repositorio = new AlumnoJsonRepository(mapper, fichero);
        try {
            // La capa repository gestiona el fichero mediante try-with-resources.
            repositorio.guardar(alumnos);
            System.out.println("Datos guardados en: " + fichero.toAbsolutePath());
        } catch (IOException e) {
            System.err.println("No se pudo guardar el JSON: " + e.getMessage());
        }
    }
}
```

---

### 5. Fichero generado

```json
[
  {
    "id" : 1,
    "nombre" : "Ana",
    "nota" : 8.5
  },
  {
    "id" : 2,
    "nombre" : "Luis",
    "nota" : 7.2
  },
  {
    "id" : 3,
    "nombre" : "Marta",
    "nota" : 9.1
  }
]
```

---

### 6. Leer desde el fichero

Como el fichero contiene una colección necesitamos `TypeReference`:

```java
List<Alumno> alumnos = mapper.readValue(
        ruta.toFile(),
        new TypeReference<List<Alumno>>() {}
);
```

---

### 7. Ejemplo: `LeerAlumnosJackson.java`

```java
package com.example.app;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.example.config.JacksonConfig;
import com.example.model.Alumno;
import com.example.repository.AlumnoJsonRepository;
import java.io.IOException;

import java.nio.file.Path;
import java.util.List;

/** Ejemplo didáctico de Jackson. */
public class LeerAlumnosJackson {
    public static void main(String[] args) {
        ObjectMapper mapper = JacksonConfig.crearMapper();

        Path fichero = Path.of("data", "alumnos.json");

        AlumnoJsonRepository repositorio = new AlumnoJsonRepository(mapper, fichero);
        try {
            // TypeReference y cierre seguro del lector se gestionan en repository.
            List<Alumno> alumnos = repositorio.leer();
            alumnos.forEach(System.out::println);
        } catch (IOException e) {
            System.err.println("No se pudo leer el JSON: " + e.getMessage());
        }
    }
}
```

---

### 8. Diferencia entre `writeValueAsString()` y `writeValue()`

```java
mapper.writeValueAsString(alumno);
```

devuelve un `String`.

```java
mapper.writeValue(fichero, alumno);
```

escribe el resultado en el destino indicado.

```text
writeValueAsString() → JSON en memoria
writeValue()         → JSON en un destino
```

---

### 9. Diferencia entre leer un objeto y una lista

Objeto individual:

```java
Alumno alumno = mapper.readValue(
        fichero,
        Alumno.class
);
```

Colección:

```java
List<Alumno> alumnos = mapper.readValue(
        fichero,
        new TypeReference<List<Alumno>>() {}
);
```

---

### 10. Orden recomendado de ejecución

```text
1. GuardarAlumnosJackson
           │
           ▼
   data/alumnos.json
           │
           ▼
2. LeerAlumnosJackson
           │
           ▼
     List<Alumno>
```

!!! warning
    Si intentamos ejecutar primero el programa de lectura y el fichero todavía no existe, la operación fallará.

---

### 11. Resumen

| Operación | Jackson |
|---|---|
| Objeto → `String` JSON | `writeValueAsString()` |
| Objeto → fichero | `writeValue()` |
| JSON → objeto | `readValue(..., Alumno.class)` |
| JSON → lista | `readValue(..., TypeReference)` |

!!! success
    Hemos completado el ciclo de persistencia: objetos Java → fichero JSON → objetos Java.
