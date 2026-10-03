# Colecciones y TypeReference

### 1. De un objeto a muchos objetos

En aplicaciones reales es frecuente trabajar con colecciones:

```java
List<Alumno>
```

que en JSON se representan mediante un array:

```json
[
  { "id": 1, "nombre": "Ana", "nota": 8.5 },
  { "id": 2, "nombre": "Luis", "nota": 7.2 },
  { "id": 3, "nombre": "Marta", "nota": 9.1 }
]
```

---

### 2. Crear la lista

```java
List<Alumno> alumnos = new ArrayList<>();

alumnos.add(new Alumno(1, "Ana", 8.5));
alumnos.add(new Alumno(2, "Luis", 7.2));
alumnos.add(new Alumno(3, "Marta", 9.1));
```

Imports:

```java
import java.util.ArrayList;
import java.util.List;
```

---

### 3. Serializar la colección

```java
String json = mapper
        .writerWithDefaultPrettyPrinter()
        .writeValueAsString(alumnos);
```

No necesitamos recorrer manualmente la lista para construir el JSON.

```text
List<Alumno>
      │
      ▼
 ObjectMapper
      │
      ▼
 array JSON
```

---

### 4. El problema al deserializar genéricos

Para un objeto individual utilizábamos:

```java
Alumno.class
```

Pero queremos recuperar:

```java
List<Alumno>
```

Necesitamos conservar la información completa del tipo genérico.

---

### 5. `TypeReference`

Jackson proporciona:

```java
TypeReference<T>
```

Ejemplo:

```java
List<Alumno> alumnos = mapper.readValue(
        json,
        new TypeReference<List<Alumno>>() {}
);
```

Import:

```java
import com.fasterxml.jackson.core.type.TypeReference;
```

---

### 6. ¿Qué información aporta?

```text
TypeReference<List<Alumno>>
          │
          ▼
"Quiero una List
 cuyos elementos son Alumno"
```

No realiza la conversión. La conversión sigue realizándola `ObjectMapper`.

---

### 7. Ejemplo completo: `DemoListaJackson.java`

```java
package com.example;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.ArrayList;
import java.util.List;

public class DemoListaJackson {

    public static void main(String[] args) throws Exception {

        ObjectMapper mapper = new ObjectMapper();

        List<Alumno> alumnos = new ArrayList<>();
        alumnos.add(new Alumno(1, "Ana", 8.5));
        alumnos.add(new Alumno(2, "Luis", 7.2));
        alumnos.add(new Alumno(3, "Marta", 9.1));

        String json = mapper
                .writerWithDefaultPrettyPrinter()
                .writeValueAsString(alumnos);

        System.out.println(json);

        List<Alumno> recuperados = mapper.readValue(
                json,
                new TypeReference<List<Alumno>>() {}
        );

        System.out.println("Alumnos recuperados:");
        recuperados.forEach(System.out::println);
    }
}
```

---

### 8. Comparación con Gson

En Gson utilizamos:

```java
Type tipo = new TypeToken<List<Alumno>>() {}.getType();
```

En Jackson utilizamos:

```java
new TypeReference<List<Alumno>>() {}
```

Podemos relacionarlos conceptualmente:

```text
Gson       → TypeToken
Jackson    → TypeReference
```

Ambos aparecen cuando necesitamos conservar información sobre tipos genéricos.

---

### 9. Otras colecciones

El mismo concepto puede aplicarse a otros tipos genéricos, por ejemplo:

```java
List<String>
Map<String, Alumno>
```

Lo importante no es memorizar todas las combinaciones, sino entender por qué una colección genérica necesita más información que una clase simple.

---

### 10. Resumen

| Situación | Tipo que proporcionamos |
|---|---|
| Un `Alumno` | `Alumno.class` |
| `List<Alumno>` | `new TypeReference<List<Alumno>>() {}` |

!!! success
    Ya podemos convertir una colección completa en JSON y recuperarla conservando el tipo de sus elementos.
