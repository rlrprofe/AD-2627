# Serialización: de objetos Java a JSON

### 1. ¿Qué es serializar?

La **serialización** consiste en transformar un objeto Java en una representación que pueda almacenarse o transmitirse.

En nuestro caso queremos transformar:

```text
OBJETO JAVA
     │
     │ Gson
     ▼
    JSON
```

Gson realiza esta conversión mediante el método:

```java
toJson()
```

Por ejemplo:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );

String json =
        gson.toJson(alumno);
```

El objeto Java:

```text
Alumno
├── id = 1
├── nombre = "Ana"
└── nota = 8.5
```

se transforma en:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

!!! important "Idea fundamental"
    Con Gson trabajaremos principalmente con **objetos Java**.

    Gson se encarga de transformar sus atributos en propiedades JSON.

---

## El modelo de datos

### 2. Antes del JSON tenemos una clase Java

Para entender Gson debemos partir de algo que los alumnos ya conocen de Programación: **las clases y los objetos**.

Supongamos que queremos trabajar con alumnos.

Podemos representarlos mediante una clase:

```java
Alumno
```

con los siguientes datos:

```text
Alumno
 │
 ├── id
 ├── nombre
 └── nota
```

Esta clase constituye nuestro **modelo de datos**.

---

### 3. Alumno.java

Podemos definir la clase de la siguiente forma:

```java
package com.example;

public class Alumno {

    private int id;
    private String nombre;
    private double nota;

    public Alumno() {
    }

    public Alumno(
            int id,
            String nombre,
            double nota) {

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

Esta clase no contiene código relacionado directamente con JSON.

Es simplemente una clase Java que representa nuestros datos.

!!! note "Modelo Java"
    En tus materiales se plantea precisamente este enfoque: utilizar clases Java con sus campos, getters y setters y, de forma recomendable, un constructor vacío.

---

## Crear un objeto

### 4. Instanciar Alumno

Una vez definida la clase podemos crear objetos normalmente:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );
```

En memoria tenemos:

```text
alumno
   │
   ▼
┌─────────────────────┐
│       Alumno        │
├─────────────────────┤
│ id       → 1        │
│ nombre   → "Ana"    │
│ nota     → 8.5      │
└─────────────────────┘
```

Todavía **no tenemos JSON**.

Únicamente tenemos un objeto Java.

---

## Crear Gson

### 5. Objeto Gson

Para realizar la conversión necesitamos un objeto de la clase:

```java
Gson
```

Importamos:

```java
import com.google.gson.Gson;
```

y lo creamos:

```java
Gson gson =
        new Gson();
```

Ahora podemos utilizar:

```java
gson.toJson(...)
```

---

## toJson()

### 6. Serializar nuestro primer objeto

Podemos convertir el objeto `alumno` en JSON:

```java
String json =
        gson.toJson(alumno);
```

Observa los dos elementos:

```text
alumno
```

es el objeto Java que queremos convertir.

Mientras que:

```text
json
```

es un `String` que contiene el JSON generado.

El proceso completo es:

```text
Objeto Alumno
     │
     │ gson.toJson(alumno)
     ▼
String
     │
     ▼
texto JSON
```

---

### 7. ¿Qué devuelve toJson()?

En este caso:

```java
gson.toJson(alumno)
```

devuelve un:

```java
String
```

Por eso podemos escribir:

```java
String json =
        gson.toJson(alumno);
```

y después:

```java
System.out.println(json);
```

El resultado será similar a:

```json
{"id":1,"nombre":"Ana","nota":8.5}
```

!!! warning "JSON no es lo mismo que un objeto Java"
    Después de ejecutar:

    ```java
    String json = gson.toJson(alumno);
    ```

    seguimos teniendo dos cosas diferentes:

    ```text
    alumno → objeto de la clase Alumno

    json   → String que contiene JSON
    ```

---

## ¿Cómo realiza Gson la conversión?

### 8. Correspondencia entre campos y propiedades

Gson analiza los campos del objeto.

Nuestro objeto contiene:

```text
id       = 1
nombre   = "Ana"
nota     = 8.5
```

y genera:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

Podemos observar la correspondencia:

| Java | JSON |
|---|---|
| `id` | `"id"` |
| `1` | `1` |
| `nombre` | `"nombre"` |
| `"Ana"` | `"Ana"` |
| `nota` | `"nota"` |
| `8.5` | `8.5` |

Conceptualmente:

```text
CAMPO JAVA             PROPIEDAD JSON

id       ────────────► "id"

nombre   ────────────► "nombre"

nota     ────────────► "nota"
```

---

## DemoGson.java

### 9. Ejemplo completo

Nuestro primer ejemplo puede ser:

```java
package com.example;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class DemoGson {

    public static void main(String[] args) {

        // ==========================================
        // 1. CREAR EL OBJETO JAVA
        // ==========================================

        Alumno alumno =
                new Alumno(
                    1,
                    "Ana",
                    8.5
                );


        // ==========================================
        // 2. CREAR GSON
        // ==========================================

        Gson gson =
                new GsonBuilder()
                    .setPrettyPrinting()
                    .create();


        // ==========================================
        // 3. SERIALIZAR
        // ==========================================

        String json =
                gson.toJson(alumno);


        // ==========================================
        // 4. MOSTRAR EL JSON
        // ==========================================

        System.out.println(json);
    }
}
```

El resultado será:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

---

## GsonBuilder

### 10. ¿Por qué usamos GsonBuilder?

También podríamos haber escrito:

```java
Gson gson =
        new Gson();
```

Sin embargo, en el ejemplo hemos utilizado:

```java
Gson gson =
        new GsonBuilder()
            .setPrettyPrinting()
            .create();
```

Esto permite configurar Gson.

En este caso:

```java
setPrettyPrinting()
```

hace que el JSON generado sea más legible.

---

### 11. Comparación

Con:

```java
Gson gson =
        new Gson();
```

podemos obtener:

```json
{"id":1,"nombre":"Ana","nota":8.5}
```

Con:

```java
Gson gson =
        new GsonBuilder()
            .setPrettyPrinting()
            .create();
```

obtenemos:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

Los datos son los mismos.

Lo que cambia es únicamente su presentación.

---

## Varios tipos de datos

### 12. Gson convierte los tipos básicos automáticamente

Supongamos una clase más completa:

```java
public class Alumno {

    private int id;
    private String nombre;
    private double nota;
    private boolean matriculado;

    // ...
}
```

y un objeto:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5,
            true
        );
```

Gson puede generar:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5,
  "matriculado": true
}
```

Observa cómo se mantienen los tipos:

```text
JAVA                 JSON

int        ───────► número

double     ───────► número

String     ───────► cadena

boolean    ───────► booleano
```

---

## Valores null

### 13. ¿Qué ocurre con null?

Supongamos:

```java
Alumno alumno =
        new Alumno(
            1,
            null,
            8.5
        );
```

Por defecto, Gson puede omitir los campos cuyo valor sea `null`.

Si necesitamos incluirlos podemos configurar Gson mediante `GsonBuilder`.

Por ejemplo:

```java
Gson gson =
        new GsonBuilder()
            .serializeNulls()
            .setPrettyPrinting()
            .create();
```

De esta forma puede aparecer:

```json
{
  "id": 1,
  "nombre": null,
  "nota": 8.5
}
```

!!! note
    `GsonBuilder` no sirve únicamente para dar formato al JSON.

    También permite modificar diferentes aspectos del comportamiento de Gson.

---

## Objetos dentro de objetos

### 14. Objetos anidados

Una de las ventajas del mapeo automático aparece cuando nuestros modelos se hacen más complejos.

Supongamos:

```java
public class Direccion {

    private String ciudad;
    private String codigoPostal;

    // constructores
    // getters y setters
}
```

y que `Alumno` contiene:

```java
private Direccion direccion;
```

Entonces podríamos tener:

```text
Alumno
 │
 ├── id
 ├── nombre
 ├── nota
 │
 └── direccion
       │
       ├── ciudad
       └── codigoPostal
```

---

### 15. Serialización de un objeto anidado

Creamos:

```java
Direccion direccion =
        new Direccion(
            "Alcalá de Henares",
            "28801"
        );

Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5,
            direccion
        );
```

y simplemente hacemos:

```java
String json =
        gson.toJson(alumno);
```

Gson puede generar:

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

No hemos tenido que crear manualmente el objeto JSON correspondiente a `direccion`.

Gson ha detectado la relación:

```text
Alumno
   │
   └── Direccion
```

y la ha transformado en:

```text
objeto JSON
   │
   └── objeto JSON
```

---

## Comparación con org.json

### 16. El mismo problema con dos enfoques

Con `org.json` podríamos construir los datos manualmente:

```java
JSONObject alumno =
        new JSONObject();

alumno.put("id", 1);
alumno.put("nombre", "Ana");
alumno.put("nota", 8.5);
```

Con Gson:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );

String json =
        gson.toJson(alumno);
```

La diferencia fundamental es:

```text
org.json
──────────────────────

Nosotros construimos
la estructura JSON.

JSONObject
JSONArray
put()


Gson
──────────────────────

Nosotros construimos
el modelo Java.

Alumno
Direccion
List<Alumno>

Gson realiza
la conversión.
```

!!! tip "Relaciona ambas librerías"
    `org.json` nos ha servido para comprender cómo se construye y manipula directamente una estructura JSON.

    Gson nos permite subir un nivel de abstracción y trabajar principalmente con nuestro **modelo de objetos Java**.

---

## No confundas toString() con toJson()

### 17. Son operaciones diferentes

Nuestra clase `Alumno` puede tener:

```java
@Override
public String toString() {

    return "Alumno{" +
            "id=" + id +
            ", nombre='" + nombre + '\'' +
            ", nota=" + nota +
            '}';
}
```

Si hacemos:

```java
System.out.println(alumno);
```

podemos obtener:

```text
Alumno{id=1, nombre='Ana', nota=8.5}
```

Eso **no es JSON**.

En cambio:

```java
System.out.println(
        gson.toJson(alumno)
);
```

produce:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

Por tanto:

```text
alumno.toString()
        │
        ▼
representación textual
del objeto Java


gson.toJson(alumno)
        │
        ▼
representación JSON
```

!!! warning
    No debemos utilizar `toString()` como sustituto de `toJson()`.

---

## No hemos creado ningún fichero

### 18. Todo está todavía en memoria

Es importante observar que:

```java
String json =
        gson.toJson(alumno);
```

**no crea ningún fichero**.

Tenemos:

```text
MEMORIA

Objeto Alumno
     │
     │ toJson()
     ▼
String json
```

El JSON está almacenado en una variable de tipo:

```java
String
```

Para obtener:

```text
alumnos.json
```

tendremos que aprender posteriormente a escribir el JSON en un fichero.

!!! important "Dos operaciones distintas"
    **Serializar un objeto**

    ```java
    gson.toJson(alumno);
    ```

    no significa necesariamente:

    **guardar un fichero**.

    Primero debemos entender la conversión en memoria. Después veremos cómo escribir el resultado en disco.

---

## Flujo completo

### 19. Qué ocurre realmente

Cuando escribimos:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );

String json =
        gson.toJson(alumno);
```

podemos representarlo así:

```text
┌──────────────────────────┐
│       OBJETO JAVA        │
│                          │
│          Alumno          │
│                          │
│ id = 1                   │
│ nombre = "Ana"           │
│ nota = 8.5               │
└────────────┬─────────────┘
             │
             │
             │ gson.toJson(alumno)
             │
             ▼
┌──────────────────────────┐
│       STRING JSON        │
│                          │
│ {                        │
│   "id": 1,               │
│   "nombre": "Ana",       │
│   "nota": 8.5            │
│ }                        │
└──────────────────────────┘
```

A este proceso lo llamamos:

```text
SERIALIZACIÓN
```

---

## Errores conceptuales frecuentes

### 20. Pensar que Gson crea el objeto Alumno

No.

Primero creamos nosotros:

```java
Alumno alumno =
        new Alumno(...);
```

Después Gson lo convierte:

```java
gson.toJson(alumno);
```

---

### 21. Pensar que toJson() devuelve un JSONObject

No.

En este ejemplo:

```java
String json =
        gson.toJson(alumno);
```

obtenemos un:

```java
String
```

No estamos trabajando con:

```java
JSONObject
```

como hacíamos con `org.json`.

---

### 22. Pensar que toJson() guarda automáticamente un fichero

Tampoco.

Esto:

```java
String json =
        gson.toJson(alumno);
```

solo realiza la conversión en memoria.

Más adelante utilizaremos:

```java
Writer
```

para escribir los datos en un fichero.

---

### 23. Pensar que toString() genera JSON

No necesariamente.

```java
alumno.toString()
```

y:

```java
gson.toJson(alumno)
```

tienen objetivos diferentes.

---

## Métodos utilizados

### 24. Resumen

| Elemento | Función |
|---|---|
| `Alumno` | Modelo de datos Java |
| `Gson` | Realiza las conversiones |
| `GsonBuilder` | Permite configurar Gson |
| `toJson()` | Serializa Java → JSON |
| `setPrettyPrinting()` | Genera JSON con formato legible |
| `create()` | Construye el objeto `Gson` configurado |
| `serializeNulls()` | Permite incluir campos con valor `null` |

---

## Ejemplos de este apartado

### 25. Clases que debemos comprender

En este apartado las clases fundamentales son:

| Fichero | Finalidad |
|---|---|
| `Alumno.java` | Define el modelo de datos |
| `DemoGson.java` | Convierte un objeto `Alumno` a JSON en memoria |

El ejemplo fundamental que debemos reconocer es:

```java
Gson gson =
        new Gson();

String json =
        gson.toJson(alumno);
```

que representa:

```text
Alumno
   │
   │ toJson()
   ▼
 JSON
```

---

## Antes de continuar

### 26. Comprueba que sabes explicar...

Antes de pasar al proceso contrario deberíamos poder responder:

**¿Qué es serializar?**

```text
Convertir un objeto Java a JSON.
```

**¿Qué método utilizamos?**

```java
toJson()
```

**¿Qué objeto realiza la conversión?**

```java
Gson
```

**¿Necesitamos construir un JSONObject?**

```text
No.
```

**¿toJson() crea automáticamente un fichero?**

```text
No.
```

**¿Qué papel tiene Alumno.java?**

```text
Representa nuestro modelo de datos.
```

---

!!! success "Serialización"
    Ya conocemos el primer recorrido fundamental de Gson:

    ```text
    OBJETO JAVA
         │
         │ toJson()
         ▼
        JSON
    ```

    El siguiente paso será aprender a recorrer el camino contrario:

    ```text
    JSON
      │
      │ fromJson()
      ▼
    OBJETO JAVA
    ```