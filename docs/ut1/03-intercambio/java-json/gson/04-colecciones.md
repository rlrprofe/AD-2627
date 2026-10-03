# Colecciones y TypeToken

### 1. De un objeto a varios objetos

Hasta ahora hemos trabajado con un único objeto:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );
```

que Gson puede transformar en un objeto JSON:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

Pero normalmente una aplicación necesita trabajar con **varios alumnos**.

En Java podemos almacenarlos en una colección:

```java
List<Alumno>
```

Por ejemplo:

```java
List<Alumno> alumnos =
        new ArrayList<>();
```

Conceptualmente:

```text
List<Alumno>
     │
     ├── Alumno
     ├── Alumno
     └── Alumno
```

En JSON esta estructura se representará mediante un **array**:

```text
List<Alumno>
     │
     │ Gson
     ▼
array JSON
```

---

## Crear una lista de objetos

### 2. List y ArrayList

Necesitamos importar:

```java
import java.util.ArrayList;
import java.util.List;
```

Creamos la lista:

```java
List<Alumno> alumnos =
        new ArrayList<>();
```

y añadimos varios objetos:

```java
alumnos.add(
    new Alumno(
        1,
        "Ana",
        8.5
    )
);

alumnos.add(
    new Alumno(
        2,
        "Luis",
        7.2
    )
);

alumnos.add(
    new Alumno(
        3,
        "Marta",
        9.1
    )
);
```

Ahora tenemos:

```text
alumnos
   │
   ▼
List<Alumno>
   │
   ├── [0] Alumno
   │       id = 1
   │       nombre = "Ana"
   │       nota = 8.5
   │
   ├── [1] Alumno
   │       id = 2
   │       nombre = "Luis"
   │       nota = 7.2
   │
   └── [2] Alumno
           id = 3
           nombre = "Marta"
           nota = 9.1
```

---

## Serializar una colección

### 3. List<Alumno> → JSON

Serializar una colección con Gson es muy sencillo.

Creamos Gson:

```java
Gson gson =
        new GsonBuilder()
            .setPrettyPrinting()
            .create();
```

y hacemos:

```java
String json =
        gson.toJson(alumnos);
```

No necesitamos recorrer manualmente la lista para construir el JSON.

Gson se encarga de convertir:

```text
List<Alumno>
     │
     │ toJson()
     ▼
 array JSON
```

---

### 4. Resultado

El resultado será similar a:

```json
[
  {
    "id": 1,
    "nombre": "Ana",
    "nota": 8.5
  },
  {
    "id": 2,
    "nombre": "Luis",
    "nota": 7.2
  },
  {
    "id": 3,
    "nombre": "Marta",
    "nota": 9.1
  }
]
```

Observa la correspondencia:

```text
JAVA                        JSON

List<Alumno>     ───────►   [ ... ]

Alumno           ───────►   { ... }

Alumno           ───────►   { ... }

Alumno           ───────►   { ... }
```

!!! important "Colección Java y array JSON"
    Una colección de objetos Java puede representarse como un array JSON cuyos elementos son objetos JSON.

---

## Comparación con org.json

### 5. Construcción manual frente a conversión automática

Con `org.json` habíamos utilizado:

```java
JSONArray alumnos =
        new JSONArray();
```

Después debíamos crear los objetos:

```java
JSONObject alumno1 =
        new JSONObject();

alumno1.put("id", 1);
alumno1.put("nombre", "Ana");
alumno1.put("nota", 8.5);

alumnos.put(alumno1);
```

Con Gson partimos directamente de:

```java
List<Alumno> alumnos =
        new ArrayList<>();
```

y realizamos:

```java
String json =
        gson.toJson(alumnos);
```

Por tanto:

```text
org.json
────────────────────

JSONArray
   │
JSONObject
   │
put()
   │
JSONArray.put()
   │
JSON


Gson
────────────────────

List<Alumno>
   │
toJson()
   │
JSON
```

---

## El problema aparece al leer

### 6. JSON → List<Alumno>

Ahora queremos realizar el proceso contrario.

Partimos de:

```json
[
  {
    "id": 1,
    "nombre": "Ana",
    "nota": 8.5
  },
  {
    "id": 2,
    "nombre": "Luis",
    "nota": 7.2
  }
]
```

y queremos obtener:

```java
List<Alumno>
```

Conceptualmente:

```text
array JSON
     │
     │ fromJson()
     ▼
List<Alumno>
```

Pero aquí aparece una cuestión importante.

---

## ¿Por qué no utilizamos List.class?

### 7. Un único objeto era sencillo

Cuando queríamos recuperar un alumno hacíamos:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

Podíamos indicar directamente:

```java
Alumno.class
```

porque queríamos obtener:

```text
Alumno
```

---

### 8. Ahora necesitamos más información

Para una colección queremos indicar:

```text
List<Alumno>
```

No solamente:

```text
List
```

Necesitamos que Gson conozca también el tipo de los elementos:

```text
List
 │
 └── Alumno
```

Es decir:

```text
No queremos simplemente una List.

Queremos una List<Alumno>.
```

Aquí aparece:

```java
TypeToken
```

---

## TypeToken

### 9. ¿Qué es TypeToken?

`TypeToken` nos permite representar información sobre un tipo genérico como:

```java
List<Alumno>
```

Necesitamos importar:

```java
import com.google.gson.reflect.TypeToken;
```

y también:

```java
import java.lang.reflect.Type;
```

Podemos escribir:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

Este código puede resultar extraño la primera vez que se ve.

Lo importante inicialmente es comprender **para qué sirve**:

```text
TypeToken<List<Alumno>>
          │
          ▼
"El tipo que quiero recuperar
 es una lista de alumnos"
```

---

### 10. Descomponiendo la instrucción

Tenemos:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

Podemos interpretarlo en tres partes.

#### Parte 1

```java
List<Alumno>
```

es el tipo que queremos recuperar.

---

#### Parte 2

```java
TypeToken<List<Alumno>>
```

permite conservar información sobre ese tipo genérico.

---

#### Parte 3

```java
.getType()
```

obtiene un objeto `Type` que posteriormente podemos proporcionar a Gson.

El resultado se almacena en:

```java
Type tipo
```

---

## Utilizar TypeToken con fromJson()

### 11. Deserializar la lista

Una vez definido:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

podemos utilizar:

```java
List<Alumno> alumnos =
        gson.fromJson(
            json,
            tipo
        );
```

Ahora Gson sabe que debe interpretar el JSON como:

```text
List<Alumno>
```

El proceso completo es:

```text
JSON
 │
 │
 ▼
TypeToken<List<Alumno>>
 │
 │ informa del tipo
 ▼
fromJson()
 │
 ▼
List<Alumno>
```

---

## Ejemplo completo en memoria

### 12. Serializar y recuperar una lista

```java
package com.example;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

public class DemoListaGson {

    public static void main(String[] args) {

        // ==========================================
        // 1. CREAR LA LISTA
        // ==========================================

        List<Alumno> alumnos =
                new ArrayList<>();

        alumnos.add(
            new Alumno(
                1,
                "Ana",
                8.5
            )
        );

        alumnos.add(
            new Alumno(
                2,
                "Luis",
                7.2
            )
        );

        alumnos.add(
            new Alumno(
                3,
                "Marta",
                9.1
            )
        );


        // ==========================================
        // 2. CREAR GSON
        // ==========================================

        Gson gson =
                new GsonBuilder()
                    .setPrettyPrinting()
                    .create();


        // ==========================================
        // 3. SERIALIZAR LA LISTA
        //    List<Alumno> -> JSON
        // ==========================================

        String json =
                gson.toJson(alumnos);

        System.out.println(
            "JSON generado:"
        );

        System.out.println(json);


        // ==========================================
        // 4. DEFINIR EL TIPO
        // ==========================================

        Type tipo =
                new TypeToken<List<Alumno>>() {}
                    .getType();


        // ==========================================
        // 5. DESERIALIZAR
        //    JSON -> List<Alumno>
        // ==========================================

        List<Alumno> alumnosRecuperados =
                gson.fromJson(
                    json,
                    tipo
                );


        // ==========================================
        // 6. RECORRER LA LISTA
        // ==========================================

        System.out.println(
            "\nAlumnos recuperados:"
        );

        for (Alumno alumno :
                alumnosRecuperados) {

            System.out.println(alumno);
        }
    }
}
```

---

## Analizar el ejemplo

### 13. Primera dirección: serialización

Esta parte:

```java
String json =
        gson.toJson(alumnos);
```

realiza:

```text
List<Alumno>
     │
     │ toJson()
     ▼
array JSON
```

Es muy similar a serializar un único `Alumno`.

---

### 14. Segunda dirección: deserialización

Esta parte:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

define:

```text
¿Qué quiero recuperar?

List<Alumno>
```

y:

```java
List<Alumno> alumnosRecuperados =
        gson.fromJson(
            json,
            tipo
        );
```

realiza:

```text
array JSON
     │
     │ fromJson()
     ▼
List<Alumno>
```

---

## ¿Por qué parece más complicado al leer?

### 15. Serializar es directo

Cuando hacemos:

```java
gson.toJson(alumnos);
```

Gson recibe el objeto real:

```text
alumnos
```

y puede inspeccionar su contenido.

Por eso el código resulta sencillo.

---

### 16. Deserializar necesita conocer el destino

Cuando hacemos:

```java
fromJson(...)
```

Gson necesita saber qué debe construir.

Para un objeto sencillo podemos decir:

```java
Alumno.class
```

Pero para:

```java
List<Alumno>
```

necesitamos conservar la información del tipo genérico.

Por eso utilizamos:

```java
TypeToken<List<Alumno>>
```

!!! tip "Qué deben recordar los alumnos"
    No es necesario memorizar desde el primer momento toda la sintaxis interna de `TypeToken`.

    Lo fundamental es asociar:

    ```text
    JSON → Alumno
    ```

    con:

    ```java
    Alumno.class
    ```

    y:

    ```text
    JSON → List<Alumno>
    ```

    con:

    ```java
    TypeToken<List<Alumno>>
    ```

---

## Comparación visual

### 17. Un objeto frente a una colección

#### Un objeto

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

```text
JSON
 │
 │ Alumno.class
 ▼
Alumno
```

#### Una colección

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();

List<Alumno> alumnos =
        gson.fromJson(
            json,
            tipo
        );
```

```text
JSON
 │
 │ TypeToken<List<Alumno>>
 ▼
List<Alumno>
```

---

## Recorrer los objetos recuperados

### 18. Después de fromJson() tenemos objetos Java

Una vez ejecutado:

```java
List<Alumno> alumnos =
        gson.fromJson(
            json,
            tipo
        );
```

ya no estamos trabajando directamente con JSON.

Tenemos una colección Java normal:

```java
List<Alumno>
```

Podemos recorrerla:

```java
for (Alumno alumno : alumnos) {

    System.out.println(
        alumno.getNombre()
    );
}
```

o acceder a un elemento:

```java
Alumno primero =
        alumnos.get(0);
```

y utilizar:

```java
primero.getNombre();
primero.getNota();
```

!!! important
    Una vez deserializado el JSON, volvemos a trabajar con los objetos y colecciones habituales de Java.

---

## Array JSON y List Java

### 19. Correspondencia

Podemos resumir la relación:

```text
JAVA                         JSON

Alumno          ◄────────►   { ... }

List<Alumno>    ◄────────►   [ ... ]
```

Por ejemplo:

```java
List<Alumno>
```

puede corresponderse con:

```json
[
  {
    "id": 1,
    "nombre": "Ana",
    "nota": 8.5
  },
  {
    "id": 2,
    "nombre": "Luis",
    "nota": 7.2
  }
]
```

---

## TypeToken no lee el JSON

### 20. Una distinción importante

Podemos caer en el error de pensar que:

```java
TypeToken
```

es quien lee o convierte el JSON.

No es así.

`TypeToken` proporciona información sobre el **tipo**.

La conversión continúa realizándola:

```java
Gson
```

mediante:

```java
fromJson()
```

Por tanto:

```text
TypeToken
    │
    └── describe el tipo


Gson
    │
    └── realiza la conversión
```

---

## Type no contiene los alumnos

### 21. Otra confusión frecuente

Cuando escribimos:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

la variable:

```java
tipo
```

**no contiene una lista de alumnos**.

Contiene información que describe el tipo:

```text
List<Alumno>
```

Los alumnos aparecerán después:

```java
List<Alumno> alumnos =
        gson.fromJson(
            json,
            tipo
        );
```

---

## Relación con los ficheros

### 22. ¿Por qué estamos aprendiendo esto ahora?

Hasta ahora estamos trabajando en memoria:

```text
List<Alumno>
     │
     │ toJson()
     ▼
String JSON
     │
     │ fromJson()
     ▼
List<Alumno>
```

Pero nuestro siguiente objetivo será guardar los alumnos en:

```text
alumnos.json
```

y posteriormente recuperarlos.

Entonces tendremos:

```text
GUARDAR

List<Alumno>
     │
     ▼
   Gson
     │
     ▼
alumnos.json
```

y:

```text
LEER

alumnos.json
     │
     ▼
   Gson
     │
     ▼
TypeToken<List<Alumno>>
     │
     ▼
List<Alumno>
```

Por eso necesitamos comprender `TypeToken` antes de estudiar la lectura del fichero.

---

## Errores conceptuales frecuentes

### 23. Utilizar Alumno.class para una lista

Esto representa un único alumno:

```java
Alumno.class
```

No una:

```java
List<Alumno>
```

---

### 24. Pensar que TypeToken sustituye a Gson

No.

Seguimos utilizando:

```java
gson.fromJson(...)
```

`TypeToken` solamente proporciona información sobre el tipo genérico.

---

### 25. Confundir List<Alumno> con un objeto JSON

Una lista normalmente se representa como:

```json
[
    ...
]
```

mientras que un único alumno se representa como:

```json
{
    ...
}
```

Por tanto:

```text
Alumno
   ↓
{ }


List<Alumno>
   ↓
[ ]
```

---

### 26. Confundir Type con List

Esta variable:

```java
Type tipo
```

no contiene datos.

Esta variable:

```java
List<Alumno> alumnos
```

sí contiene los objetos recuperados.

---

## Métodos y clases utilizados

### 27. Resumen

| Elemento | Función |
|---|---|
| `List<Alumno>` | Colección de alumnos |
| `ArrayList` | Implementación de `List` |
| `Gson` | Realiza la conversión |
| `toJson()` | Convierte la lista a JSON |
| `fromJson()` | Convierte JSON a objetos Java |
| `TypeToken<T>` | Conserva información sobre un tipo genérico |
| `getType()` | Obtiene la representación `Type` |
| `Type` | Representa el tipo que proporcionaremos a Gson |

---

## Los tres casos que debemos distinguir

### 28. Objeto Java → JSON

```java
String json =
        gson.toJson(alumno);
```

```text
Alumno
  ↓
 JSON
```

---

### 29. JSON → objeto Java

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

```text
 JSON
   ↓
Alumno
```

---

### 30. JSON → colección de objetos

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();

List<Alumno> alumnos =
        gson.fromJson(
            json,
            tipo
        );
```

```text
     JSON
       │
       ▼
TypeToken<List<Alumno>>
       │
       ▼
 List<Alumno>
```

---

## Antes de continuar

### 31. Comprueba que sabes explicar...

**¿Cómo serializamos una lista?**

```java
gson.toJson(alumnos);
```

**¿A qué estructura JSON corresponde normalmente una `List<Alumno>`?**

```text
A un array JSON.
```

**¿Para qué utilizamos `TypeToken`?**

```text
Para proporcionar a Gson información
sobre un tipo genérico como List<Alumno>.
```

**¿TypeToken realiza la deserialización?**

```text
No. La realiza Gson mediante fromJson().
```

**¿Qué utilizaríamos para un único alumno?**

```java
Alumno.class
```

**¿Y para una lista de alumnos?**

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

---

!!! success "Colecciones"
    Ya podemos trabajar con varios objetos:

    ```text
                    toJson()
    List<Alumno> ───────────► JSON
    ```

    y recuperar la colección:

    ```text
                         fromJson()
    List<Alumno> ◄─────────── JSON
         ▲
         │
    TypeToken<List<Alumno>>
    ```

    Con esto ya tenemos los conceptos necesarios para dar el siguiente paso: **guardar la lista de alumnos en un fichero JSON y recuperarla posteriormente**.