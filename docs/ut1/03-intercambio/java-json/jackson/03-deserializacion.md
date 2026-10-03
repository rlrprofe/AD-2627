# Deserialización con Jackson

### 1. ¿Qué es deserializar?

La deserialización realiza el proceso contrario a la serialización:

```text
JSON ─────────► OBJETO JAVA
       Jackson
```

---

### 2. `readValue()`

Para convertir un JSON en un objeto utilizaremos principalmente:

```java
readValue()
```

Ejemplo:

```java
String json = """
        {
          "id": 1,
          "nombre": "Ana",
          "nota": 8.5
        }
        """;

Alumno alumno = mapper.readValue(json, Alumno.class);
```

---

### 3. ¿Por qué indicamos `Alumno.class`?

Jackson recibe un texto JSON, pero necesita saber qué objeto queremos construir.

```text
JSON
 │
 │ + Alumno.class
 ▼
ObjectMapper
 │
 ▼
Alumno
```

`Alumno.class` proporciona la información del tipo de destino.

---

### 4. Mostrar el objeto recuperado

```java
System.out.println(alumno);
```

Si `Alumno` tiene un `toString()` adecuado, podremos ver sus valores.

---

### 5. Ciclo completo

```java
ObjectMapper mapper = new ObjectMapper();

Alumno original = new Alumno(1, "Ana", 8.5);

String json = mapper.writeValueAsString(original);

Alumno recuperado = mapper.readValue(json, Alumno.class);

System.out.println(json);
System.out.println(recuperado);
```

Flujo:

```text
Alumno original
      │
      │ writeValueAsString()
      ▼
     JSON
      │
      │ readValue()
      ▼
Alumno recuperado
```

---

### 6. Constructor sin argumentos

En modelos Java sencillos utilizados en clase mantendremos un constructor sin argumentos:

```java
public Alumno() {
}
```

Esto facilita el trabajo de las herramientas de mapeo y mantiene nuestros modelos compatibles con el enfoque que estamos utilizando en los ejemplos.

---

### 7. Propiedades que faltan

Supongamos:

```json
{
  "id": 1,
  "nombre": "Ana"
}
```

No aparece `nota`. Al construir el objeto, el atributo primitivo `double` conservará su valor por defecto si no se proporciona otro valor:

```text
0.0
```

---

### 8. Propiedades desconocidas

Si el JSON contiene propiedades que nuestro modelo no conoce, debemos ser conscientes de la configuración de Jackson. Podemos configurar el mapper para ignorarlas:

```java
mapper.configure(
        DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES,
        false
);
```

Import necesario:

```java
import com.fasterxml.jackson.databind.DeserializationFeature;
```

!!! note
    Esta configuración puede ser útil cuando recibimos JSON con más información de la que necesita nuestra aplicación. No debemos aplicarla mecánicamente: primero hay que comprender qué datos estamos aceptando e ignorando.

---

### 9. Tipos incompatibles

Si el JSON contiene un valor incompatible con el tipo esperado, la deserialización puede fallar.

Por ejemplo, nuestro modelo declara:

```java
private double nota;
```

Por eso debemos validar y tratar adecuadamente los datos de entrada en aplicaciones reales.

---

### 10. Objetos anidados

Si el modelo contiene otro objeto, Jackson puede reconstruir la jerarquía:

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

```text
JSON
 └── direccion
       │
       ▼
Alumno
 └── Direccion
```

---

### 11. Comparación con Gson

```java
// Gson
Alumno alumno = gson.fromJson(json, Alumno.class);
```

```java
// Jackson
Alumno alumno = mapper.readValue(json, Alumno.class);
```

En ambos casos necesitamos indicar el tipo de destino.

---

### 12. Resumen

```text
writeValueAsString()   Java → JSON
readValue()            JSON → Java
```

!!! success
    Ya podemos completar un ciclo Java ⇄ JSON para un objeto individual. A continuación veremos qué cambia cuando trabajamos con `List<Alumno>`.
