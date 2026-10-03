# JsonNode y anotaciones

En los apartados anteriores hemos utilizado Jackson principalmente para convertir directamente entre **objetos Java** y **JSON**.

Jackson también permite trabajar con la estructura del JSON como un **árbol de nodos** y personalizar el mapeo mediante **anotaciones**.

---

## Parte 1. Modelo de árbol con JsonNode

### 1. ¿Qué es `JsonNode`?

`JsonNode` representa un nodo de un árbol JSON.

```text
JSON
 │
 ▼
JsonNode raíz
 ├── id
 ├── nombre
 ├── nota
 └── direccion
      ├── ciudad
      └── codigoPostal
```

Este enfoque recuerda en parte al trabajo explícito que realizamos con `JSONObject` y `JSONArray`, aunque utilizando la API de Jackson.

---

### 2. `readTree()`

Podemos convertir un texto JSON en un árbol:

```java
JsonNode raiz = mapper.readTree(json);
```

Import:

```java
import com.fasterxml.jackson.databind.JsonNode;
```

---

### 3. Consultar propiedades

```java
JsonNode nombre = raiz.get("nombre");
```

Para obtener el texto:

```java
String valor = raiz.get("nombre").asText();
```

Para un entero:

```java
int id = raiz.get("id").asInt();
```

Para un decimal:

```java
double nota = raiz.get("nota").asDouble();
```

---

### 4. Ejemplo: `DemoJsonNode.java`

```java
package com.example;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class DemoJsonNode {

    public static void main(String[] args) throws Exception {

        String json = """
                {
                  "id": 1,
                  "nombre": "Ana",
                  "nota": 8.5,
                  "modulos": ["Acceso a Datos", "PMDM"]
                }
                """;

        ObjectMapper mapper = new ObjectMapper();
        JsonNode raiz = mapper.readTree(json);

        System.out.println("Nombre: " + raiz.get("nombre").asText());
        System.out.println("Nota: " + raiz.get("nota").asDouble());

        JsonNode modulos = raiz.get("modulos");

        for (JsonNode modulo : modulos) {
            System.out.println("- " + modulo.asText());
        }
    }
}
```

---

### 5. ¿Cuándo resulta útil?

El modelo de árbol puede ser interesante cuando:

- no queremos crear inmediatamente una clase Java para toda la estructura;
- queremos inspeccionar campos concretos;
- la estructura puede variar;
- necesitamos navegar por el JSON antes de decidir cómo procesarlo.

---

### 6. Data binding frente a tree model

```text
DATA BINDING
JSON ⇄ Alumno

TREE MODEL
JSON ⇄ JsonNode
```

Jackson permite ambos enfoques.

---

## Parte 2. Personalizar el mapeo con anotaciones

### 7. `@JsonProperty`

Supongamos que en Java tenemos:

```java
private String nombre;
```

pero queremos que en JSON aparezca:

```json
"nombre_completo": "Ana García"
```

Podemos utilizar:

```java
@JsonProperty("nombre_completo")
private String nombre;
```

Import:

```java
import com.fasterxml.jackson.annotation.JsonProperty;
```

---

### 8. `@JsonIgnore`

Podemos indicar que una propiedad no debe incluirse en el JSON:

```java
@JsonIgnore
private String passwordTemporal;
```

Import:

```java
import com.fasterxml.jackson.annotation.JsonIgnore;
```

---

### 9. Ejemplo de modelo anotado

```java
package com.example;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

public class AlumnoAnotado {

    private int id;

    @JsonProperty("nombre_completo")
    private String nombre;

    private double nota;

    @JsonIgnore
    private String passwordTemporal;

    public AlumnoAnotado() {
    }

    public AlumnoAnotado(
            int id,
            String nombre,
            double nota,
            String passwordTemporal) {

        this.id = id;
        this.nombre = nombre;
        this.nota = nota;
        this.passwordTemporal = passwordTemporal;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public double getNota() { return nota; }
    public void setNota(double nota) { this.nota = nota; }

    public String getPasswordTemporal() { return passwordTemporal; }
    public void setPasswordTemporal(String passwordTemporal) {
        this.passwordTemporal = passwordTemporal;
    }
}
```

---

### 10. Resultado

Al serializar:

```java
AlumnoAnotado alumno = new AlumnoAnotado(
        1,
        "Ana García",
        8.5,
        "abc123"
);

String json = mapper
        .writerWithDefaultPrettyPrinter()
        .writeValueAsString(alumno);
```

obtendremos una estructura donde el nombre de la propiedad está personalizado y la propiedad ignorada no aparece:

```json
{
  "id" : 1,
  "nota" : 8.5,
  "nombre_completo" : "Ana García"
}
```

---

### 11. No confundir anotaciones con `TypeReference`

```text
TypeReference
     │
     └── describe un tipo genérico
         List<Alumno>

Anotaciones
     │
     └── modifican cómo se mapean
         determinadas propiedades
```

---

### 12. Resumen

| Elemento | Función |
|---|---|
| `JsonNode` | Nodo de un árbol JSON |
| `readTree()` | JSON → árbol `JsonNode` |
| `get()` | Acceder a un nodo hijo |
| `asText()` | Obtener un valor como texto |
| `asInt()` | Obtener un valor entero |
| `asDouble()` | Obtener un valor decimal |
| `@JsonProperty` | Personalizar el nombre JSON |
| `@JsonIgnore` | Excluir una propiedad |

!!! success
    Con Jackson podemos elegir entre mapear directamente JSON a objetos Java o trabajar con la estructura como un árbol de nodos.
