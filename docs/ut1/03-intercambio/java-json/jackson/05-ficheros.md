# Ficheros JSON con Jackson

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
package com.example;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class GuardarAlumnosJackson {

    public static void main(String[] args) throws Exception {

        List<Alumno> alumnos = List.of(
                new Alumno(1, "Ana", 8.5),
                new Alumno(2, "Luis", 7.2),
                new Alumno(3, "Marta", 9.1)
        );

        Path ruta = Path.of("data", "alumnos.json");
        Files.createDirectories(ruta.getParent());

        ObjectMapper mapper = new ObjectMapper();

        mapper
            .writerWithDefaultPrettyPrinter()
            .writeValue(ruta.toFile(), alumnos);

        System.out.println("Datos guardados en: " + ruta.toAbsolutePath());
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
package com.example;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.nio.file.Path;
import java.util.List;

public class LeerAlumnosJackson {

    public static void main(String[] args) throws Exception {

        Path ruta = Path.of("data", "alumnos.json");

        ObjectMapper mapper = new ObjectMapper();

        List<Alumno> alumnos = mapper.readValue(
                ruta.toFile(),
                new TypeReference<List<Alumno>>() {}
        );

        for (Alumno alumno : alumnos) {
            System.out.println(alumno);
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
