# Adaptadores personalizados en Gson

### 1. Cuando la conversión automática no es suficiente

Una de las principales ventajas de Gson es que puede convertir automáticamente muchos objetos Java a JSON.

Por ejemplo, si tenemos:

```java
public class Alumno {

    private int id;
    private String nombre;
    private double nota;

}
```

Gson puede serializar un objeto:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );
```

mediante:

```java
String json =
        gson.toJson(alumno);
```

obteniendo algo similar a:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

En este caso la conversión es sencilla porque trabajamos con tipos habituales:

```text
int
String
double
```

Pero nuestros modelos pueden contener tipos más complejos.

Por ejemplo:

```java
LocalDate
```

---

## Añadir una fecha al modelo

### 2. Un Alumno con fecha de nacimiento

Podemos ampliar nuestro modelo:

```java
private LocalDate fechaNacimiento;
```

Ahora un alumno podría contener:

```text
Alumno
 │
 ├── id
 ├── nombre
 ├── nota
 │
 └── fechaNacimiento
          │
          ▼
       LocalDate
```

Por ejemplo:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5,
            LocalDate.of(
                2005,
                3,
                15
            )
        );
```

Queremos que la fecha se represente en JSON de una forma sencilla:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5,
  "fechaNacimiento": "2005-03-15"
}
```

Es decir:

```text
LocalDate
2005-03-15

      │
      │ serialización
      ▼

"2005-03-15"
```

---

## El problema

### 3. ¿Cómo debe representar Gson un LocalDate?

`LocalDate` no es simplemente un:

```java
String
```

Es una clase de Java:

```java
java.time.LocalDate
```

Por tanto necesitamos establecer claramente cómo queremos realizar las conversiones:

```text
SERIALIZAR

LocalDate
    │
    ▼
String JSON
```

y:

```text
DESERIALIZAR

String JSON
    │
    ▼
LocalDate
```

Queremos definir una regla como:

```text
LocalDate                  JSON

2005-03-15    ─────────►   "2005-03-15"

2005-03-15    ◄─────────   "2005-03-15"
```

Para ello podemos crear un **adaptador personalizado**.

---

## ¿Qué es un adaptador?

### 4. Enseñar a Gson cómo realizar una conversión

Un adaptador permite definir cómo queremos convertir un determinado tipo.

En nuestro caso queremos enseñar a Gson:

```text
¿Cómo convierto LocalDate a JSON?

¿Cómo convierto JSON a LocalDate?
```

Necesitamos por tanto dos operaciones:

```text
LocalDate ───────► JSON
          serializar


LocalDate ◄─────── JSON
        deserializar
```

Para ello Gson proporciona, entre otras, las interfaces:

```java
JsonSerializer<T>
```

y:

```java
JsonDeserializer<T>
```

---

## JsonSerializer

### 5. Conversión Java → JSON

`JsonSerializer` se utiliza para definir cómo queremos serializar un tipo.

Para `LocalDate`:

```java
JsonSerializer<LocalDate>
```

podemos interpretarlo como:

```text
"Sé cómo convertir un LocalDate a JSON"
```

El recorrido será:

```text
LocalDate
    │
    │ JsonSerializer
    ▼
  JSON
```

---

## JsonDeserializer

### 6. Conversión JSON → Java

`JsonDeserializer` realiza el proceso contrario.

Para `LocalDate`:

```java
JsonDeserializer<LocalDate>
```

podemos interpretarlo como:

```text
"Sé cómo convertir el JSON
en un LocalDate"
```

El recorrido será:

```text
 JSON
   │
   │ JsonDeserializer
   ▼
LocalDate
```

---

## Un único adaptador para ambas operaciones

### 7. LocalDateAdapter

Podemos crear una clase:

```text
LocalDateAdapter.java
```

que implemente ambas interfaces:

```java
JsonSerializer<LocalDate>
```

y:

```java
JsonDeserializer<LocalDate>
```

La cabecera será:

```java
public class LocalDateAdapter
        implements
            JsonSerializer<LocalDate>,
            JsonDeserializer<LocalDate> {
```

Conceptualmente:

```text
             LocalDateAdapter
                    │
          ┌─────────┴─────────┐
          │                   │
          ▼                   ▼
 JsonSerializer       JsonDeserializer
          │                   │
          ▼                   ▼
 LocalDate → JSON      JSON → LocalDate
```

---

## Formato de la fecha

### 8. DateTimeFormatter

Necesitamos decidir qué formato tendrá la fecha en JSON.

Utilizaremos:

```java
DateTimeFormatter.ISO_LOCAL_DATE
```

que representa fechas como:

```text
yyyy-MM-dd
```

Por ejemplo:

```text
2005-03-15
2026-10-03
2000-01-25
```

Importamos:

```java
import java.time.format.DateTimeFormatter;
```

y podemos definir:

```java
private static final DateTimeFormatter FORMATTER =
        DateTimeFormatter.ISO_LOCAL_DATE;
```

---

## Serializar LocalDate

### 9. Método serialize()

La interfaz:

```java
JsonSerializer<LocalDate>
```

nos obliga a definir el método de serialización.

Podemos escribir:

```java
@Override
public JsonElement serialize(
        LocalDate fecha,
        Type tipo,
        JsonSerializationContext contexto) {

    return new JsonPrimitive(
        fecha.format(FORMATTER)
    );
}
```

Analicemos qué ocurre.

---

### 10. Recibimos un LocalDate

El parámetro:

```java
LocalDate fecha
```

puede contener, por ejemplo:

```text
2005-03-15
```

---

### 11. Convertimos la fecha en texto

Utilizamos:

```java
fecha.format(FORMATTER)
```

obteniendo:

```text
2005-03-15
```

---

### 12. Creamos un valor JSON

Finalmente:

```java
new JsonPrimitive(
    fecha.format(FORMATTER)
)
```

genera un valor JSON equivalente a:

```json
"2005-03-15"
```

El recorrido completo es:

```text
LocalDate
2005-03-15
     │
     │ format()
     ▼
String
"2005-03-15"
     │
     │ JsonPrimitive
     ▼
valor JSON
"2005-03-15"
```

---

## Deserializar LocalDate

### 13. Método deserialize()

Ahora necesitamos realizar el proceso contrario.

La interfaz:

```java
JsonDeserializer<LocalDate>
```

nos permite definir:

```java
@Override
public LocalDate deserialize(
        JsonElement json,
        Type tipo,
        JsonDeserializationContext contexto)
        throws JsonParseException {

    return LocalDate.parse(
        json.getAsString(),
        FORMATTER
    );
}
```

---

### 14. Recibimos un valor JSON

Por ejemplo:

```json
"2005-03-15"
```

Gson nos proporciona un:

```java
JsonElement
```

---

### 15. Obtenemos el texto

Utilizamos:

```java
json.getAsString()
```

obteniendo:

```text
2005-03-15
```

---

### 16. Convertimos el texto en LocalDate

Finalmente:

```java
LocalDate.parse(
    json.getAsString(),
    FORMATTER
);
```

produce:

```java
LocalDate
```

con el valor:

```text
2005-03-15
```

El recorrido es:

```text
JSON
"2005-03-15"
      │
      │ getAsString()
      ▼
String
"2005-03-15"
      │
      │ LocalDate.parse()
      ▼
LocalDate
2005-03-15
```

---

## LocalDateAdapter.java completo

### 17. Implementación del adaptador

```java
package com.example;

import java.lang.reflect.Type;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class LocalDateAdapter
        implements
            JsonSerializer<LocalDate>,
            JsonDeserializer<LocalDate> {

    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ISO_LOCAL_DATE;


    // ==========================================
    // JAVA -> JSON
    // ==========================================

    @Override
    public JsonElement serialize(
            LocalDate fecha,
            Type tipo,
            JsonSerializationContext contexto) {

        return new JsonPrimitive(
            fecha.format(FORMATTER)
        );
    }


    // ==========================================
    // JSON -> JAVA
    // ==========================================

    @Override
    public LocalDate deserialize(
            JsonElement json,
            Type tipo,
            JsonDeserializationContext contexto)
            throws JsonParseException {

        return LocalDate.parse(
            json.getAsString(),
            FORMATTER
        );
    }
}
```

---

## El adaptador no se utiliza automáticamente

### 18. Tenemos que registrarlo

Crear:

```java
LocalDateAdapter
```

no es suficiente.

Debemos indicarle a Gson:

```text
Cuando encuentres un LocalDate,
utiliza este adaptador.
```

Para ello utilizaremos:

```java
GsonBuilder
```

---

## registerTypeAdapter()

### 19. Registrar el adaptador

Podemos crear Gson así:

```java
Gson gson =
        new GsonBuilder()
            .registerTypeAdapter(
                LocalDate.class,
                new LocalDateAdapter()
            )
            .setPrettyPrinting()
            .create();
```

La parte fundamental es:

```java
.registerTypeAdapter(
    LocalDate.class,
    new LocalDateAdapter()
)
```

Podemos leerla como:

```text
Para el tipo:

LocalDate.class

utiliza:

LocalDateAdapter
```

---

## Flujo completo

### 20. Gson utiliza el adaptador cuando encuentra LocalDate

Una vez registrado:

```text
                    Gson
                     │
                     │ encuentra LocalDate
                     ▼
              LocalDateAdapter
                /          \
               /            \
              ▼              ▼
       serialize()      deserialize()
              │              │
              ▼              ▼
          Java→JSON       JSON→Java
```

---

## Modificar Alumno.java

### 21. Añadir fechaNacimiento

Nuestro modelo puede quedar así:

```java
package com.example;

import java.time.LocalDate;

public class Alumno {

    private int id;
    private String nombre;
    private double nota;
    private LocalDate fechaNacimiento;

    public Alumno() {
    }

    public Alumno(
            int id,
            String nombre,
            double nota,
            LocalDate fechaNacimiento) {

        this.id = id;
        this.nombre = nombre;
        this.nota = nota;
        this.fechaNacimiento =
                fechaNacimiento;
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

    public void setNombre(
            String nombre) {

        this.nombre = nombre;
    }

    public double getNota() {
        return nota;
    }

    public void setNota(
            double nota) {

        this.nota = nota;
    }

    public LocalDate getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(
            LocalDate fechaNacimiento) {

        this.fechaNacimiento =
                fechaNacimiento;
    }

    @Override
    public String toString() {

        return "Alumno{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", nota=" + nota +
                ", fechaNacimiento=" +
                fechaNacimiento +
                '}';
    }
}
```

---

## Probar la serialización

### 22. Crear un alumno

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5,
            LocalDate.of(
                2005,
                3,
                15
            )
        );
```

Tenemos:

```text
Alumno
 │
 ├── id = 1
 ├── nombre = "Ana"
 ├── nota = 8.5
 │
 └── fechaNacimiento
        └── LocalDate
            2005-03-15
```

---

### 23. Crear Gson con el adaptador

```java
Gson gson =
        new GsonBuilder()
            .registerTypeAdapter(
                LocalDate.class,
                new LocalDateAdapter()
            )
            .setPrettyPrinting()
            .create();
```

---

### 24. Serializar

Ahora podemos hacer:

```java
String json =
        gson.toJson(alumno);
```

El resultado será:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5,
  "fechaNacimiento": "2005-03-15"
}
```

---

## ¿Quién convierte cada campo?

### 25. Gson y nuestro adaptador colaboran

Podemos imaginar:

```text
Alumno
 │
 ├── id
 │     └── Gson
 │
 ├── nombre
 │     └── Gson
 │
 ├── nota
 │     └── Gson
 │
 └── fechaNacimiento
       │
       └── LocalDateAdapter
```

No estamos sustituyendo Gson.

Estamos indicándole cómo debe tratar un tipo concreto.

!!! important
    El adaptador interviene cuando Gson encuentra el tipo para el que lo hemos registrado.

    El resto del objeto continúa siendo procesado por Gson.

---

## Probar la deserialización

### 26. Recuperar el objeto

Podemos utilizar el mismo `Gson`:

```java
Alumno recuperado =
        gson.fromJson(
            json,
            Alumno.class
        );
```

Ahora Gson encuentra:

```json
"fechaNacimiento": "2005-03-15"
```

y utiliza nuestro:

```java
LocalDateAdapter
```

para convertirlo en:

```java
LocalDate
```

---

## Ejemplo completo

### 27. DemoLocalDateGson.java

```java
package com.example;

import java.time.LocalDate;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class DemoLocalDateGson {

    public static void main(String[] args) {

        // ==========================================
        // 1. CREAR EL ALUMNO
        // ==========================================

        Alumno alumno =
                new Alumno(
                    1,
                    "Ana",
                    8.5,
                    LocalDate.of(
                        2005,
                        3,
                        15
                    )
                );


        // ==========================================
        // 2. CONFIGURAR GSON
        // ==========================================

        Gson gson =
                new GsonBuilder()
                    .registerTypeAdapter(
                        LocalDate.class,
                        new LocalDateAdapter()
                    )
                    .setPrettyPrinting()
                    .create();


        // ==========================================
        // 3. SERIALIZAR
        // ==========================================

        String json =
                gson.toJson(alumno);

        System.out.println(
            "JSON generado:"
        );

        System.out.println(json);


        // ==========================================
        // 4. DESERIALIZAR
        // ==========================================

        Alumno recuperado =
                gson.fromJson(
                    json,
                    Alumno.class
                );


        // ==========================================
        // 5. MOSTRAR RESULTADO
        // ==========================================

        System.out.println(
            "\nAlumno recuperado:"
        );

        System.out.println(
            recuperado
        );
    }
}
```

---

## Analizar el recorrido

### 28. Serialización

Cuando ejecutamos:

```java
gson.toJson(alumno);
```

ocurre:

```text
Alumno
  │
  ├── id ────────────────────┐
  ├── nombre ────────────────┤
  ├── nota ──────────────────┤
  │                          │
  └── fechaNacimiento        │
          │                  │
          ▼                  │
   LocalDateAdapter          │
          │                  │
          ▼                  │
     "2005-03-15"            │
                             │
              ┌──────────────┘
              ▼
             JSON
```

---

### 29. Deserialización

Cuando ejecutamos:

```java
gson.fromJson(
    json,
    Alumno.class
);
```

ocurre el camino contrario:

```text
JSON
 │
 ├── id
 ├── nombre
 ├── nota
 │
 └── "fechaNacimiento"
          │
          ▼
   LocalDateAdapter
          │
          ▼
      LocalDate
          │
          ▼
        Alumno
```

---

## Utilizarlo también con colecciones

### 30. El adaptador no es solo para un Alumno

Si tenemos:

```java
List<Alumno> alumnos
```

y cada alumno contiene:

```java
LocalDate fechaNacimiento
```

podemos utilizar el mismo `Gson` configurado:

```java
Gson gson =
        new GsonBuilder()
            .registerTypeAdapter(
                LocalDate.class,
                new LocalDateAdapter()
            )
            .setPrettyPrinting()
            .create();
```

y después:

```java
gson.toJson(
    alumnos,
    writer
);
```

Cuando Gson encuentre cada:

```java
LocalDate
```

utilizará el adaptador.

---

## Leer una colección con fechas

### 31. TypeToken sigue funcionando igual

Para recuperar:

```java
List<Alumno>
```

seguimos necesitando:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

y:

```java
List<Alumno> alumnos =
        gson.fromJson(
            reader,
            tipo
        );
```

La diferencia es que el objeto `Gson` debe estar configurado con:

```java
registerTypeAdapter(...)
```

---

## No confundir TypeToken y TypeAdapter

### 32. Son conceptos diferentes

Los nombres pueden resultar parecidos:

```text
TypeToken

TypeAdapter / adaptador de tipo
```

pero resuelven problemas diferentes.

#### TypeToken

Lo hemos utilizado para indicar un tipo genérico:

```java
List<Alumno>
```

Por ejemplo:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

#### Adaptador

Lo utilizamos para indicar cómo convertir un tipo determinado:

```java
LocalDate
```

Por ejemplo:

```java
.registerTypeAdapter(
    LocalDate.class,
    new LocalDateAdapter()
)
```

---

### 33. Comparación

| Elemento | Para qué lo utilizamos |
|---|---|
| `TypeToken<List<Alumno>>` | Indicar a Gson que queremos una lista de alumnos |
| `LocalDateAdapter` | Indicar cómo convertir `LocalDate` |
| `registerTypeAdapter()` | Registrar el adaptador en Gson |

Podemos resumirlo así:

```text
TypeToken
   │
   ▼
¿Qué tipo quiero recuperar?


TypeAdapter
   │
   ▼
¿Cómo convierto este tipo?
```

---

## Errores frecuentes

### 34. Crear el adaptador pero no registrarlo

No basta con tener:

```text
LocalDateAdapter.java
```

Debemos crear Gson con:

```java
.registerTypeAdapter(
    LocalDate.class,
    new LocalDateAdapter()
)
```

---

### 35. Utilizar un Gson diferente

Supongamos que configuramos:

```java
Gson gson =
        new GsonBuilder()
            .registerTypeAdapter(
                LocalDate.class,
                new LocalDateAdapter()
            )
            .create();
```

pero después hacemos:

```java
Gson otroGson =
        new Gson();
```

y utilizamos:

```java
otroGson.toJson(alumno);
```

Ese segundo objeto Gson **no tiene registrado nuestro adaptador**.

Debemos utilizar el Gson que hemos configurado.

---

### 36. Utilizar formatos distintos

Si serializamos una fecha con:

```text
yyyy-MM-dd
```

debemos poder interpretar ese mismo formato al deserializar.

Por eso utilizamos en ambos métodos:

```java
DateTimeFormatter.ISO_LOCAL_DATE
```

---

### 37. Confundir JsonSerializer con JsonDeserializer

Recuerda:

```text
JsonSerializer

Java ─────────► JSON
```

y:

```text
JsonDeserializer

Java ◄───────── JSON
```

---

## Clases nuevas de este apartado

### 38. Resumen

| Clase / interfaz | Función |
|---|---|
| `LocalDate` | Representa una fecha sin hora |
| `DateTimeFormatter` | Define el formato de la fecha |
| `JsonSerializer<T>` | Personaliza Java → JSON |
| `JsonDeserializer<T>` | Personaliza JSON → Java |
| `JsonElement` | Representa un elemento JSON |
| `JsonPrimitive` | Representa un valor JSON simple |
| `JsonSerializationContext` | Contexto de serialización |
| `JsonDeserializationContext` | Contexto de deserialización |
| `JsonParseException` | Error durante el procesamiento JSON |
| `registerTypeAdapter()` | Registra el adaptador en Gson |

---

## Ejemplos de este apartado

### 39. Nuevas clases

En este apartado aparecen:

| Fichero | Finalidad |
|---|---|
| `LocalDateAdapter.java` | Define cómo convertir `LocalDate` ⇄ JSON |
| `DemoLocalDateGson.java` | Prueba el adaptador |
| `Alumno.java` | Modelo ampliado con `fechaNacimiento` |

El código fundamental del adaptador es:

```java
public class LocalDateAdapter
        implements
            JsonSerializer<LocalDate>,
            JsonDeserializer<LocalDate> {
```

y su registro:

```java
Gson gson =
        new GsonBuilder()
            .registerTypeAdapter(
                LocalDate.class,
                new LocalDateAdapter()
            )
            .setPrettyPrinting()
            .create();
```

---

## Mapa final

### 40. Todo el proceso

```text
                         GSON
                           │
          ┌────────────────┴────────────────┐
          │                                 │
          ▼                                 ▼
    tipos habituales                    LocalDate
          │                                 │
          │                                 ▼
          │                         LocalDateAdapter
          │                           /          \
          │                          /            \
          │                         ▼              ▼
          │                  serialize()     deserialize()
          │                         │              │
          └─────────────────────────┴──────────────┘
                                    │
                                    ▼
                                   JSON
```

---

## Antes de continuar

### 41. Comprueba que sabes explicar...

**¿Para qué utilizamos un adaptador?**

```text
Para personalizar la conversión
de un determinado tipo.
```

**¿Qué interfaz utilizamos para Java → JSON?**

```java
JsonSerializer<T>
```

**¿Qué interfaz utilizamos para JSON → Java?**

```java
JsonDeserializer<T>
```

**¿Qué formato hemos utilizado para LocalDate?**

```java
DateTimeFormatter.ISO_LOCAL_DATE
```

**¿Cómo indicamos a Gson que debe utilizar nuestro adaptador?**

```java
registerTypeAdapter()
```

**¿TypeToken y un adaptador hacen lo mismo?**

```text
No.

TypeToken describe un tipo genérico.

Un adaptador define cómo convertir
un determinado tipo.
```

---

!!! success "Personalización de Gson"
    Ya no estamos limitados únicamente a las conversiones automáticas de Gson.

    Podemos definir nuestras propias reglas:

    ```text
                  serialize()
    LocalDate ─────────────────► JSON


                deserialize()
    LocalDate ◄───────────────── JSON
    ```

    y registrar esas reglas mediante:

    ```java
    GsonBuilder
        .registerTypeAdapter(...)
    ```

    De esta forma podemos adaptar Gson a los tipos utilizados por nuestro modelo de datos.