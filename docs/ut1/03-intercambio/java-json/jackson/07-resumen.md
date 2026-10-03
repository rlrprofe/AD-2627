# Resumen de Jackson

Esta página reúne los conceptos y operaciones principales del minicurso para utilizarla como **guía rápida de consulta**.

---

## 1. Mapa general

```text
                         JACKSON
                            │
                            ▼
                       ObjectMapper
                            │
          ┌─────────────────┼─────────────────┐
          ▼                 ▼                 ▼
    SERIALIZACIÓN     DESERIALIZACIÓN      TREE MODEL
      Java → JSON        JSON → Java         JsonNode
          │                 │                 │
          ▼                 ▼                 ▼
 writeValue...()        readValue()        readTree()
          │                 │
          └────────┬────────┘
                   ▼
               FICHEROS
                   │
                   ▼
            data/alumnos.json
```

---

## 2. Dependencia Maven

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.22.3</version>
</dependency>
```

Y para Java 21:

```xml
<maven.compiler.release>21</maven.compiler.release>
```

---

## 3. Crear ObjectMapper

```java
ObjectMapper mapper = new ObjectMapper();
```

Import:

```java
import com.fasterxml.jackson.databind.ObjectMapper;
```

---

## 4. Serialización

Objeto Java → JSON:

```java
String json = mapper.writeValueAsString(alumno);
```

Con formato legible:

```java
String json = mapper
        .writerWithDefaultPrettyPrinter()
        .writeValueAsString(alumno);
```

---

## 5. Deserialización

JSON → objeto Java:

```java
Alumno alumno = mapper.readValue(
        json,
        Alumno.class
);
```

---

## 6. Colecciones

Java → JSON:

```java
String json = mapper.writeValueAsString(alumnos);
```

JSON → `List<Alumno>`:

```java
List<Alumno> alumnos = mapper.readValue(
        json,
        new TypeReference<List<Alumno>>() {}
);
```

---

## 7. Ficheros

Guardar:

```java
mapper
    .writerWithDefaultPrettyPrinter()
    .writeValue(ruta.toFile(), alumnos);
```

Leer:

```java
List<Alumno> alumnos = mapper.readValue(
        ruta.toFile(),
        new TypeReference<List<Alumno>>() {}
);
```

---

## 8. Tree Model

```java
JsonNode raiz = mapper.readTree(json);
```

Consultar:

```java
raiz.get("nombre").asText();
raiz.get("id").asInt();
raiz.get("nota").asDouble();
```

---

## 9. Anotaciones básicas

Cambiar el nombre JSON:

```java
@JsonProperty("nombre_completo")
private String nombre;
```

Ignorar una propiedad:

```java
@JsonIgnore
private String passwordTemporal;
```

---

## 10. Chuleta de métodos

| Necesito... | Utilizo... |
|---|---|
| Crear el mapper | `new ObjectMapper()` |
| Java → `String` JSON | `writeValueAsString()` |
| Java → fichero JSON | `writeValue()` |
| JSON → objeto | `readValue(..., Clase.class)` |
| JSON → colección genérica | `readValue(..., TypeReference)` |
| JSON → árbol | `readTree()` |
| Obtener nodo hijo | `get()` |
| JSON con sangrado | `writerWithDefaultPrettyPrinter()` |

---

## 11. Gson y Jackson: equivalencias conceptuales

| Operación | Gson | Jackson |
|---|---|---|
| Objeto principal | `Gson` | `ObjectMapper` |
| Java → JSON | `toJson()` | `writeValueAsString()` |
| JSON → Java | `fromJson()` | `readValue()` |
| Tipo genérico | `TypeToken` | `TypeReference` |
| Configuración | `GsonBuilder` | configuración de `ObjectMapper` / writers |

---

## 12. org.json, Gson y Jackson

```text
org.json
   │
   └── JSONObject / JSONArray
       trabajo explícito con la estructura

Gson
   │
   └── Gson
       objetos Java ⇄ JSON

Jackson
   │
   └── ObjectMapper
       objetos Java ⇄ JSON
       + JsonNode
       + configuración/anotaciones
```

---

## 13. Proyecto de ejemplos

```text
jackson-ejemplos/
├── pom.xml
├── README.md
├── data/
│   └── alumnos.json
└── src/main/java/com/example/
    ├── Alumno.java
    ├── DemoJackson.java
    ├── DemoListaJackson.java
    ├── GuardarAlumnosJackson.java
    ├── LeerAlumnosJackson.java
    ├── DemoJsonNode.java
    ├── AlumnoAnotado.java
    └── DemoAnotaciones.java
```

[📦 **Descargar proyecto Maven completo de Jackson**](../../../../descargas/ut1/java-json/jackson-ejemplos.zip)

---

## 14. Orden recomendado de los ejemplos

```text
DemoJackson
     │
     ▼
DemoListaJackson
     │
     ▼
GuardarAlumnosJackson
     │
     ▼
data/alumnos.json
     │
     ▼
LeerAlumnosJackson
     │
     ▼
DemoJsonNode
     │
     ▼
DemoAnotaciones
```

---

## 15. Preguntas de repaso

1. ¿Qué función cumple `ObjectMapper`?
2. ¿Qué diferencia existe entre `writeValueAsString()` y `writeValue()`?
3. ¿Qué método utilizamos para deserializar?
4. ¿Por qué utilizamos `TypeReference<List<Alumno>>`?
5. ¿Qué diferencia conceptual existe entre `Alumno.class` y `TypeReference<List<Alumno>>`?
6. ¿Qué representa `JsonNode`?
7. ¿Qué hace `readTree()`?
8. ¿Para qué sirven `@JsonProperty` y `@JsonIgnore`?
9. ¿Qué similitud existe entre `TypeToken` de Gson y `TypeReference` de Jackson?
10. Explica el recorrido completo desde `List<Alumno>` hasta un fichero JSON y de vuelta a `List<Alumno>`.

---

!!! success "Idea final"
    Si recuerdas este esquema, tienes la base del minicurso:

    ```text
                    ObjectMapper
                  /              \
                 /                \
          Java ───────► JSON ───────► fichero
          Java ◄─────── JSON ◄─────── fichero

          List<T>  → TypeReference<T>
          árbol    → JsonNode
    ```
