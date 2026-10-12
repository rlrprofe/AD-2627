# Serialización con Jackson

!!! note "Ejemplos y proyecto descargable (Java 21)"
    Los fragmentos de esta página ilustran conceptos. La versión **completa y ejecutable** utiliza paquetes separados (`com.example.app`, `model`, `repository` y, cuando corresponde, `config`/`adapter`). Consulta el [orden didáctico y la estructura del proyecto](index.md#guia-del-proyecto-maven-actualizado-java-21) y el [ZIP actualizado](../../../../descargas/ut1/java-json/jackson-ejemplos.zip).

### 1. ¿Qué es serializar?

Serializar consiste en transformar un objeto Java en una representación que pueda almacenarse o intercambiarse. En nuestro caso, la representación será **JSON**.

```text
OBJETO JAVA ─────────► JSON
             Jackson
```

---

### 2. Modelo `Alumno`

```java
package com.example;

public class Alumno {

    private int id;
    private String nombre;
    private double nota;

    public Alumno() {
    }

    public Alumno(int id, String nombre, double nota) {
        this.id = id;
        this.nombre = nombre;
        this.nota = nota;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public double getNota() {
        return nota;
    }

    public void setNota(double nota) {
        this.nota = nota;
    }

    @Override
    public String toString() {
        return "Alumno{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", nota=" + nota +
                '}';
    }
}
```

---

### 3. Convertir un objeto en JSON

```java
ObjectMapper mapper = new ObjectMapper();

Alumno alumno = new Alumno(1, "Ana", 8.5);

String json = mapper.writeValueAsString(alumno);
```

Salida:

```json
{"id":1,"nombre":"Ana","nota":8.5}
```

---

### 4. `writeValueAsString()`

El método:

```java
writeValueAsString(objeto)
```

recibe un objeto y devuelve un `String` que contiene JSON.

```text
Alumno
  │
  │ writeValueAsString()
  ▼
String JSON
```

---

### 5. JSON con formato legible

```java
String json = mapper
        .writerWithDefaultPrettyPrinter()
        .writeValueAsString(alumno);
```

Resultado:

```json
{
  "id" : 1,
  "nombre" : "Ana",
  "nota" : 8.5
}
```

---

### 6. Ejemplo completo: `DemoJackson.java`

```java
package com.example.app;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.example.config.JacksonConfig;
import com.example.model.Alumno;


/** Ejemplo didáctico de Jackson. */
public class DemoJackson {
    public static void main(String[] args) {
        ObjectMapper mapper = JacksonConfig.crearMapper();
        

        Alumno original = new Alumno(1, "Ana", 8.5);

        try {
            // Serialización: objeto Java a texto JSON.
            String json = mapper.writeValueAsString(original);
        System.out.println("JSON:");
        System.out.println(json);

        // Deserialización: texto JSON a objeto Java.
        Alumno recuperado = mapper.readValue(json, Alumno.class);
        System.out.println("\nObjeto recuperado:");
        System.out.println(recuperado);
        } catch (com.fasterxml.jackson.core.JsonProcessingException e) {
            System.err.println("Error al procesar JSON: " + e.getOriginalMessage());
        }
    }
}
```

---

### 7. ¿Cómo relaciona los datos?

Conceptualmente:

```text
Alumno                         JSON

id        ─────────────────►   "id"
nombre    ─────────────────►   "nombre"
nota      ─────────────────►   "nota"
```

Jackson aplica sus reglas de mapeo para relacionar propiedades Java y propiedades JSON.

---

### 8. Objetos anidados

Una clase puede contener otra clase:

```java
public class Direccion {
    private String ciudad;
    private String codigoPostal;

    // constructores, getters y setters
}
```

Y `Alumno` podría contener:

```java
private Direccion direccion;
```

El JSON resultante tendría una estructura anidada:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5,
  "direccion": {
    "ciudad": "Alcalá de Henares",
    "codigoPostal": "28801"
  }
}
```

---

### 9. `toString()` no es serialización JSON

No debemos confundir:

```java
alumno.toString();
```

con:

```java
mapper.writeValueAsString(alumno);
```

`toString()` produce una representación textual definida por nuestra clase. `writeValueAsString()` genera una representación JSON.

---

### 10. Comparación con Gson

```java
// Gson
String json = gson.toJson(alumno);
```

```java
// Jackson
String json = mapper.writeValueAsString(alumno);
```

El concepto es el mismo:

```text
Objeto Java → JSON
```

pero cambia la API utilizada.

---

### 11. Resumen

| Operación | Jackson |
|---|---|
| Crear objeto principal | `new ObjectMapper()` |
| Java → JSON String | `writeValueAsString()` |
| JSON legible | `writerWithDefaultPrettyPrinter()` |

!!! success
    En este punto ya podemos transformar nuestros objetos Java en JSON. El siguiente paso será recuperar el objeto a partir de ese JSON.
