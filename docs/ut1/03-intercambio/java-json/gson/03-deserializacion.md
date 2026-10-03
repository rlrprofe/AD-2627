# Deserialización: de JSON a objetos Java

### 1. ¿Qué es deserializar?

En el apartado anterior hemos aprendido a realizar este proceso:

```text
OBJETO JAVA
     │
     │ toJson()
     ▼
    JSON
```

Este proceso recibe el nombre de **serialización**.

Ahora vamos a realizar el proceso contrario:

```text
    JSON
     │
     │ fromJson()
     ▼
OBJETO JAVA
```

Este proceso recibe el nombre de **deserialización**.

Gson utiliza para ello el método:

```java
fromJson()
```

!!! important "Dos operaciones fundamentales"
    Con Gson debemos distinguir claramente:

    ```text
                 toJson()
    OBJETO JAVA ──────────► JSON


                 fromJson()
    OBJETO JAVA ◄────────── JSON
    ```

---

## Partimos de un JSON

### 2. JSON almacenado en una cadena

Supongamos que recibimos los siguientes datos:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

En Java podemos almacenarlos inicialmente en un `String`.

Con Java 21 podemos utilizar un **text block**:

```java
String json =
        """
        {
          "id": 1,
          "nombre": "Ana",
          "nota": 8.5
        }
        """;
```

En este momento tenemos:

```text
String json
     │
     ▼
┌──────────────────────────┐
│ {                        │
│   "id": 1,               │
│   "nombre": "Ana",       │
│   "nota": 8.5            │
│ }                        │
└──────────────────────────┘
```

Todavía no tenemos un objeto `Alumno`.

---

## Necesitamos el modelo Java

### 3. Alumno.java

Para que Gson pueda transformar el JSON en un objeto necesitamos indicar qué tipo de objeto queremos obtener.

Continuaremos utilizando nuestro modelo:

```java
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

Podemos representar la correspondencia así:

```text
JSON                       CLASE JAVA

"id"        ───────────►   id

"nombre"    ───────────►   nombre

"nota"      ───────────►   nota
```

---

## Crear Gson

### 4. Objeto Gson

Necesitamos nuevamente un objeto `Gson`:

```java
import com.google.gson.Gson;
```

y:

```java
Gson gson =
        new Gson();
```

Ahora podemos utilizar:

```java
gson.fromJson(...)
```

---

## fromJson()

### 5. Primera deserialización

Podemos transformar el JSON anterior en un objeto `Alumno`:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

Esta instrucción es una de las más importantes de Gson.

Analicémosla:

```text
gson.fromJson(json, Alumno.class)
              │          │
              │          │
              │          └── tipo de objeto
              │              que queremos obtener
              │
              └── JSON que queremos leer
```

El resultado se guarda en:

```java
Alumno alumno
```

---

### 6. ¿Qué devuelve fromJson()?

En este caso:

```java
gson.fromJson(
    json,
    Alumno.class
)
```

devuelve un objeto de tipo:

```java
Alumno
```

Por eso podemos escribir:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

El proceso es:

```text
String con JSON
      │
      │ fromJson()
      ▼
    Alumno
```

---

## ¿Qué significa Alumno.class?

### 7. Indicar el tipo que queremos obtener

Observa esta parte:

```java
Alumno.class
```

Gson necesita saber **qué tipo de objeto debe construir** a partir del JSON.

Por ejemplo, si tenemos:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

indicamos:

```java
Alumno.class
```

porque queremos que Gson interprete esos datos utilizando la estructura de la clase:

```java
Alumno
```

Conceptualmente:

```text
JSON
 │
 │ "Quiero interpretar estos datos
 │  como un Alumno"
 │
 ▼
Alumno.class
 │
 ▼
Objeto Alumno
```

!!! note "`Alumno.class` no crea el objeto"
    `Alumno.class` proporciona a Gson información sobre el tipo Java que queremos obtener.

    Es `fromJson()` quien realiza la conversión.

---

## Resultado de la deserialización

### 8. Recuperar los datos

Después de:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

podemos utilizar el objeto como cualquier otro objeto Java:

```java
System.out.println(
        alumno.getId()
);
```

```java
System.out.println(
        alumno.getNombre()
);
```

```java
System.out.println(
        alumno.getNota()
);
```

Obtendremos:

```text
1
Ana
8.5
```

Es decir, hemos pasado de:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

a algo equivalente a:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );
```

---

## DemoGson.java

### 9. Serializar y deserializar en el mismo ejemplo

Podemos utilizar `DemoGson.java` para comprobar los dos recorridos.

```java
package com.example;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class DemoGson {

    public static void main(String[] args) {

        // ==========================================
        // 1. CREAR OBJETO JAVA
        // ==========================================

        Alumno alumnoOriginal =
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
        //    Java -> JSON
        // ==========================================

        String json =
                gson.toJson(
                    alumnoOriginal
                );

        System.out.println(
            "JSON generado:"
        );

        System.out.println(json);


        // ==========================================
        // 4. DESERIALIZAR
        //    JSON -> Java
        // ==========================================

        Alumno alumnoRecuperado =
                gson.fromJson(
                    json,
                    Alumno.class
                );


        // ==========================================
        // 5. UTILIZAR EL OBJETO RECUPERADO
        // ==========================================

        System.out.println(
            "\nAlumno recuperado:"
        );

        System.out.println(
            alumnoRecuperado
        );
    }
}
```

---

### 10. ¿Qué está ocurriendo?

El programa anterior realiza un recorrido completo:

```text
┌─────────────────────────┐
│     alumnoOriginal      │
│       Alumno            │
└────────────┬────────────┘
             │
             │ toJson()
             ▼
┌─────────────────────────┐
│       String json       │
│                         │
│ {                       │
│   "id": 1,              │
│   "nombre": "Ana",      │
│   "nota": 8.5           │
│ }                       │
└────────────┬────────────┘
             │
             │ fromJson()
             │ Alumno.class
             ▼
┌─────────────────────────┐
│   alumnoRecuperado      │
│       Alumno            │
└─────────────────────────┘
```

Tenemos por tanto:

```text
              toJson()
Alumno ─────────────────► JSON
                           │
                           │ fromJson()
                           ▼
                         Alumno
```

---

## El objeto original y el recuperado

### 11. Son dos objetos

Es importante comprender que:

```java
Alumno alumnoOriginal =
        new Alumno(
            1,
            "Ana",
            8.5
        );
```

y:

```java
Alumno alumnoRecuperado =
        gson.fromJson(
            json,
            Alumno.class
        );
```

son **dos objetos Java distintos**.

Los datos pueden ser iguales:

```text
alumnoOriginal
    │
    ├── id = 1
    ├── nombre = "Ana"
    └── nota = 8.5


alumnoRecuperado
    │
    ├── id = 1
    ├── nombre = "Ana"
    └── nota = 8.5
```

pero no debemos interpretar que Gson está recuperando mágicamente el mismo objeto que existía anteriormente.

Está construyendo un objeto a partir de los datos contenidos en el JSON.

---

## Correspondencia de nombres

### 12. Gson relaciona las propiedades JSON con los campos Java

Supongamos:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

y nuestra clase:

```java
public class Alumno {

    private int id;
    private String nombre;
    private double nota;

}
```

Gson puede establecer:

```text
JSON                JAVA

"id"       ───────► id

"nombre"   ───────► nombre

"nota"     ───────► nota
```

Los nombres tienen por tanto una gran importancia en el mapeo automático.

---

## ¿Qué ocurre si falta un campo?

### 13. JSON incompleto

Supongamos que recibimos:

```json
{
  "id": 1,
  "nombre": "Ana"
}
```

pero nuestra clase tiene:

```java
private int id;
private String nombre;
private double nota;
```

El JSON no contiene:

```text
nota
```

Para un tipo primitivo como:

```java
double
```

el campo conservará su valor por defecto:

```text
0.0
```

Por tanto podríamos obtener conceptualmente:

```text
Alumno
 │
 ├── id = 1
 ├── nombre = "Ana"
 └── nota = 0.0
```

!!! warning "Un campo ausente no siempre provoca un error"
    Esto puede ser cómodo, pero también puede ocultar datos que faltan.

    Después de deserializar datos externos conviene comprobar que la información obtenida cumple los requisitos de nuestra aplicación.

---

## ¿Qué ocurre si sobra una propiedad?

### 14. JSON con información adicional

Supongamos:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5,
  "grupo": "2DAM"
}
```

pero nuestra clase solamente contiene:

```java
private int id;
private String nombre;
private double nota;
```

La propiedad:

```json
"grupo": "2DAM"
```

no tiene un campo equivalente en nuestro modelo.

En una deserialización normal, Gson puede ignorar esa información adicional y construir el objeto con los campos que reconoce.

Conceptualmente:

```text
JSON                    Alumno

"id"       ───────────► id

"nombre"   ───────────► nombre

"nota"     ───────────► nota

"grupo"    ───────────► no existe
                        en Alumno
```

---

## ¿Y si los tipos no coinciden?

### 15. El tipo de los datos también importa

Nuestra clase espera:

```java
private double nota;
```

y normalmente el JSON debería contener:

```json
"nota": 8.5
```

Si recibimos estructuras o valores incompatibles con el tipo esperado, la conversión puede fallar.

Por tanto, aunque Gson automatice gran parte del trabajo, seguimos necesitando conocer:

- la estructura del JSON;
- nuestro modelo Java;
- los tipos de los datos;
- la correspondencia entre ambos.

!!! important
    Gson automatiza la conversión, pero eso no significa que cualquier JSON pueda convertirse en cualquier clase Java.

---

## Objetos anidados

### 16. Deserializar estructuras más complejas

Supongamos que tenemos:

```java
public class Direccion {

    private String ciudad;
    private String codigoPostal;

    // ...
}
```

y:

```java
public class Alumno {

    private int id;
    private String nombre;
    private double nota;
    private Direccion direccion;

    // ...
}
```

Podemos recibir:

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

y realizar:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

---

### 17. Gson reconstruye también el objeto anidado

Conceptualmente:

```text
JSON
 │
 ├── id
 ├── nombre
 ├── nota
 │
 └── direccion
       │
       ├── ciudad
       └── codigoPostal

             │
             │ fromJson()
             ▼

Alumno
 │
 ├── id
 ├── nombre
 ├── nota
 │
 └── Direccion
       │
       ├── ciudad
       └── codigoPostal
```

Después podremos hacer:

```java
System.out.println(
    alumno.getDireccion()
          .getCiudad()
);
```

y obtener:

```text
Alcalá de Henares
```

---

## Comparación con org.json

### 18. Lectura manual frente a mapeo automático

Con `org.json` podíamos recuperar los datos manualmente:

```java
String nombre =
        objeto.getString(
            "nombre"
        );

double nota =
        objeto.getDouble(
            "nota"
        );
```

Después, si queríamos construir un `Alumno`, podríamos hacer:

```java
Alumno alumno =
        new Alumno(
            id,
            nombre,
            nota
        );
```

Con Gson:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

Podemos representarlo así:

```text
org.json
────────────────────────────

JSON
 ↓
JSONObject
 ↓
getInt()
getString()
getDouble()
 ↓
datos
 ↓
new Alumno(...)


Gson
────────────────────────────

JSON
 ↓
fromJson()
 ↓
Alumno
```

!!! tip "Ventaja del mapeo"
    Cuanto más complejo es nuestro modelo de objetos, más útil puede resultar que la librería realice automáticamente gran parte de la conversión.

---

## No estamos leyendo todavía un fichero

### 19. El JSON sigue estando en memoria

En este ejemplo:

```java
String json =
        """
        {
          "id": 1,
          "nombre": "Ana",
          "nota": 8.5
        }
        """;
```

los datos están en una variable.

Por tanto:

```text
MEMORIA

String JSON
    │
    │ fromJson()
    ▼
  Alumno
```

Todavía **no estamos leyendo `alumnos.json` desde el disco**.

Más adelante realizaremos:

```text
FICHERO JSON
     │
     ▼
   Reader
     │
     ▼
 fromJson()
     │
     ▼
Objeto Java
```

Es importante aprender primero ambas conversiones en memoria.

---

## fromJson() y el tipo de destino

### 20. Un objeto sencillo

Para un objeto sencillo podemos utilizar:

```java
Alumno.class
```

Por ejemplo:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

Pero más adelante querremos recuperar algo como:

```java
List<Alumno>
```

y entonces aparecerá una dificultad:

```text
¿Cómo indicamos a Gson
que queremos exactamente
una List<Alumno>?
```

Ahí necesitaremos estudiar:

```java
TypeToken
```

!!! info "Todavía no necesitamos TypeToken"
    Para convertir un único objeto `Alumno` podemos utilizar directamente:

    ```java
    Alumno.class
    ```

    Introduciremos `TypeToken` cuando trabajemos con colecciones genéricas.

---

## Errores conceptuales frecuentes

### 21. Confundir toJson() y fromJson()

Recuerda:

```text
toJson()
Java → JSON
```

mientras que:

```text
fromJson()
JSON → Java
```

---

### 22. Olvidar indicar la clase

Para obtener un `Alumno` necesitamos indicar:

```java
Alumno.class
```

Por ejemplo:

```java
gson.fromJson(
    json,
    Alumno.class
);
```

---

### 23. Pensar que fromJson() devuelve siempre un String

No.

En:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

obtenemos un:

```java
Alumno
```

El tipo de destino que proporcionamos es fundamental.

---

### 24. Confundir deserializar con leer un fichero

Esto:

```java
gson.fromJson(
    json,
    Alumno.class
);
```

puede trabajar con un JSON que ya tenemos en memoria.

Leer un fichero será otro paso:

```text
fichero
   ↓
Reader
   ↓
Gson
   ↓
objeto Java
```

---

## Serialización y deserialización juntas

### 25. Los dos caminos

Ya podemos comprender el núcleo de Gson:

```text
                  SERIALIZAR

                   toJson()
┌────────────┐ ───────────────► ┌────────────┐
│            │                  │            │
│   Alumno   │                  │    JSON    │
│            │ ◄─────────────── │            │
└────────────┘    fromJson()    └────────────┘

                 DESERIALIZAR
```

Los dos métodos fundamentales son:

| Método | Conversión |
|---|---|
| `toJson()` | Java → JSON |
| `fromJson()` | JSON → Java |

---

## Ejemplos de este apartado

### 26. Clases que debemos comprender

Seguimos utilizando principalmente:

| Fichero | Finalidad |
|---|---|
| `Alumno.java` | Modelo de datos |
| `DemoGson.java` | Serialización y deserialización en memoria |

El fragmento fundamental de este apartado es:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

que representa:

```text
JSON
 │
 │ fromJson()
 │ Alumno.class
 ▼
Alumno
```

---

## Antes de continuar

### 27. Comprueba que sabes explicar...

**¿Qué es deserializar?**

```text
Convertir JSON en un objeto Java.
```

**¿Qué método utilizamos?**

```java
fromJson()
```

**¿Para qué sirve `Alumno.class`?**

```text
Para indicar a Gson el tipo Java
que queremos obtener.
```

**¿Necesitamos utilizar `JSONObject`?**

```text
No.
```

**¿fromJson() implica necesariamente leer un fichero?**

```text
No.
```

**¿Cuál es la diferencia fundamental entre los dos métodos?**

```text
toJson()    → Java a JSON

fromJson()  → JSON a Java
```

---

!!! success "Ya conocemos las dos direcciones"
    Ya podemos realizar las dos operaciones fundamentales de Gson:

    ```text
                 toJson()
    OBJETO JAVA ──────────► JSON

                 fromJson()
    OBJETO JAVA ◄────────── JSON
    ```

    El siguiente paso será aplicar este mismo mecanismo a **varios objetos**, trabajando con colecciones como `List<Alumno>`.