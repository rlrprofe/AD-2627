# Gson — Resumen y referencia rápida

### 1. ¿Qué hemos aprendido?

Gson es una librería Java que permite convertir datos entre:

```text
OBJETOS JAVA  ⇄  JSON
```

A diferencia de `org.json`, donde manipulábamos explícitamente `JSONObject` y `JSONArray`, con Gson trabajamos principalmente con nuestros propios objetos Java.

Por ejemplo:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );
```

puede convertirse automáticamente en:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

y también podemos realizar el proceso contrario.

---

## Mapa general

### 2. Los conceptos principales

```text
                              GSON
                               │
        ┌──────────────────────┼──────────────────────┐
        │                      │                      │
        ▼                      ▼                      ▼
     OBJETOS               COLECCIONES             FICHEROS
        │                      │                      │
        │                      │                      │
    Alumno.java           List<Alumno>          Writer / Reader
        │                      │                      │
        ▼                      ▼                      ▼
     toJson()               toJson()            toJson(...,
     fromJson()             fromJson()             writer)
                               │
                               ▼                 fromJson(
                           TypeToken               reader,
                                                    tipo)
        │                      │                      │
        └──────────────────────┼──────────────────────┘
                               │
                               ▼
                          GsonBuilder
                               │
                   ┌───────────┴───────────┐
                   │                       │
                   ▼                       ▼
             PrettyPrinting           Adaptadores
                                           │
                                           ▼
                                      LocalDate
```

---

## 3. Las dos operaciones fundamentales

Todo el bloque de Gson gira alrededor de dos operaciones.

### Serialización

```text
JAVA ─────────────► JSON
```

Utilizamos:

```java
toJson()
```

Por ejemplo:

```java
String json =
        gson.toJson(alumno);
```

---

### Deserialización

```text
JAVA ◄───────────── JSON
```

Utilizamos:

```java
fromJson()
```

Por ejemplo:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

!!! important "Regla básica"
    Si recuerdas únicamente dos métodos de Gson, deben ser:

    ```text
    toJson()      Java → JSON

    fromJson()    JSON → Java
    ```

---

## 4. Crear un objeto Gson

La forma más sencilla es:

```java
Gson gson =
        new Gson();
```

Necesitamos:

```java
import com.google.gson.Gson;
```

Podemos utilizar esta opción cuando no necesitamos ninguna configuración especial.

---

## 5. GsonBuilder

Cuando queremos configurar Gson utilizamos:

```java
GsonBuilder
```

Por ejemplo:

```java
Gson gson =
        new GsonBuilder()
            .setPrettyPrinting()
            .create();
```

Necesitamos:

```java
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
```

---

## 6. Pretty Printing

Por defecto podemos obtener:

```json
{"id":1,"nombre":"Ana","nota":8.5}
```

Con:

```java
.setPrettyPrinting()
```

obtenemos:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

El contenido es equivalente.

La diferencia está en la presentación.

---

## 7. Modelo Java

Gson resulta especialmente útil cuando nuestra aplicación trabaja con clases que representan los datos.

Por ejemplo:

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

    // getters y setters
}
```

Podemos representar la relación:

```text
JAVA                     JSON

id          ◄────────►   "id"

nombre      ◄────────►   "nombre"

nota        ◄────────►   "nota"
```

---

## 8. Serializar un objeto

Partimos de:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );
```

Serializamos:

```java
String json =
        gson.toJson(alumno);
```

Resultado:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

Esquema:

```text
Alumno
  │
  │ toJson()
  ▼
 JSON
```

---

## 9. Deserializar un objeto

Partimos de:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

y hacemos:

```java
Alumno alumno =
        gson.fromJson(
            json,
            Alumno.class
        );
```

Esquema:

```text
 JSON
   │
   │ fromJson()
   │ Alumno.class
   ▼
Alumno
```

---

## 10. ¿Para qué sirve Alumno.class?

En:

```java
gson.fromJson(
    json,
    Alumno.class
);
```

estamos indicando a Gson:

```text
"Interpreta este JSON
como un Alumno"
```

Por tanto:

```java
Alumno.class
```

describe el tipo de objeto que queremos obtener.

---

## 11. Colecciones

En una aplicación normalmente tendremos varios objetos:

```java
List<Alumno> alumnos =
        new ArrayList<>();
```

Por ejemplo:

```text
List<Alumno>
   │
   ├── Ana
   ├── Luis
   └── Marta
```

En JSON se puede representar como:

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

Por tanto:

```text
List<Alumno>  ⇄  array JSON
```

---

## 12. Serializar una colección

Es tan sencillo como:

```java
String json =
        gson.toJson(alumnos);
```

Esquema:

```text
List<Alumno>
     │
     │ toJson()
     ▼
 array JSON
```

---

## 13. Deserializar una colección

Aquí aparece una diferencia importante.

Para un único alumno utilizábamos:

```java
Alumno.class
```

Pero ahora queremos recuperar:

```java
List<Alumno>
```

Para describir este tipo genérico utilizamos:

```java
TypeToken
```

---

## 14. TypeToken

Definimos:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

Necesitamos:

```java
import java.lang.reflect.Type;

import com.google.gson.reflect.TypeToken;
```

Después:

```java
List<Alumno> alumnos =
        gson.fromJson(
            json,
            tipo
        );
```

Esquema:

```text
array JSON
     │
     │ fromJson()
     │
     │ TypeToken<List<Alumno>>
     ▼
List<Alumno>
```

---

## 15. Regla para recordar TypeToken

Podemos asociar:

```text
UN OBJETO
─────────

JSON
 ↓
Alumno.class
 ↓
Alumno
```

frente a:

```text
UNA COLECCIÓN
─────────────

JSON
 ↓
TypeToken<List<Alumno>>
 ↓
List<Alumno>
```

!!! tip
    `TypeToken` no realiza la conversión.

    Sirve para proporcionar a Gson información sobre un tipo genérico como:

    ```java
    List<Alumno>
    ```

---

## 16. Trabajar con ficheros

Hasta ahora podíamos mantener el JSON en memoria:

```java
String json =
        gson.toJson(alumnos);
```

Pero también podemos almacenarlo en un fichero:

```text
data/alumnos.json
```

Así conseguimos persistencia.

---

## 17. Guardar en un fichero

Podemos utilizar:

```java
FileWriter
```

junto con:

```java
gson.toJson(
    alumnos,
    writer
);
```

Por ejemplo:

```java
try (FileWriter writer =
        new FileWriter(
            "data/alumnos.json"
        )) {

    gson.toJson(
        alumnos,
        writer
    );
}
```

Esquema:

```text
List<Alumno>
     │
     ▼
   Gson
     │
     │ toJson(alumnos, writer)
     ▼
 FileWriter
     │
     ▼
alumnos.json
```

---

## 18. Leer desde un fichero

Para recuperar los datos podemos utilizar:

```java
FileReader
```

junto con:

```java
gson.fromJson(
    reader,
    tipo
);
```

Por ejemplo:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();

try (FileReader reader =
        new FileReader(
            "data/alumnos.json"
        )) {

    List<Alumno> alumnos =
            gson.fromJson(
                reader,
                tipo
            );
}
```

Esquema:

```text
alumnos.json
     │
     ▼
 FileReader
     │
     ▼
   Gson
     │
     │ fromJson(reader, tipo)
     ▼
List<Alumno>
```

---

## 19. Ciclo completo de persistencia

Ya podemos realizar:

```text
                    GUARDAR

┌─────────────────────┐
│    List<Alumno>     │
└──────────┬──────────┘
           │
           │ toJson()
           ▼
┌─────────────────────┐
│    alumnos.json     │
└──────────┬──────────┘
           │
           │ fromJson()
           ▼
┌─────────────────────┐
│    List<Alumno>     │
└─────────────────────┘

                    LEER
```

Este flujo representa un ejemplo sencillo de:

```text
persistencia de objetos
```

---

## 20. Reader y Writer

Debemos distinguir las responsabilidades.

```text
Writer
  │
  └── escribe datos
      en un destino
```

```text
Reader
  │
  └── lee datos
      desde un origen
```

Mientras que:

```text
Gson
  │
  └── realiza la conversión
      Java ⇄ JSON
```

Por tanto:

```text
GUARDAR

Java
 ↓
Gson
 ↓
Writer
 ↓
Fichero
```

y:

```text
LEER

Fichero
 ↓
Reader
 ↓
Gson
 ↓
Java
```

---

## 21. Adaptadores personalizados

La conversión automática de Gson no siempre es suficiente para todos los tipos.

En nuestro ejemplo hemos estudiado:

```java
LocalDate
```

Queremos almacenar una fecha como:

```json
"2005-03-15"
```

Para ello podemos definir nuestras propias reglas de conversión.

---

## 22. JsonSerializer

Para:

```text
JAVA → JSON
```

podemos implementar:

```java
JsonSerializer<LocalDate>
```

Por ejemplo:

```text
LocalDate
2005-03-15
     │
     │ serialize()
     ▼
JSON
"2005-03-15"
```

---

## 23. JsonDeserializer

Para:

```text
JSON → JAVA
```

podemos implementar:

```java
JsonDeserializer<LocalDate>
```

Por ejemplo:

```text
JSON
"2005-03-15"
     │
     │ deserialize()
     ▼
LocalDate
2005-03-15
```

---

## 24. Registrar el adaptador

El adaptador debe registrarse:

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

Podemos interpretarlo como:

```text
"Cuando encuentres LocalDate,
utiliza LocalDateAdapter"
```

---

## 25. TypeToken y adaptadores no son lo mismo

Es importante no confundir:

```text
TypeToken
```

con:

```text
adaptador
```

#### TypeToken

Responde a:

```text
¿Qué tipo quiero obtener?
```

Ejemplo:

```java
List<Alumno>
```

#### Adaptador

Responde a:

```text
¿Cómo quiero convertir este tipo?
```

Ejemplo:

```java
LocalDate
```

---

## 26. Chuleta de métodos

| Operación | Código |
|---|---|
| Crear Gson | `new Gson()` |
| Crear Gson configurable | `new GsonBuilder().create()` |
| JSON con formato | `.setPrettyPrinting()` |
| Java → JSON | `gson.toJson(objeto)` |
| JSON → objeto | `gson.fromJson(json, Clase.class)` |
| Escribir JSON | `gson.toJson(objeto, writer)` |
| Leer JSON | `gson.fromJson(reader, tipo)` |
| Obtener tipo genérico | `new TypeToken<List<Alumno>>() {}.getType()` |
| Registrar adaptador | `.registerTypeAdapter(Tipo.class, adaptador)` |

---

## 27. Chuleta visual

```text
┌──────────────────────────────────────────────┐
│                  GSON                        │
├──────────────────────────────────────────────┤
│                                              │
│ Java → JSON                                  │
│                                              │
│ gson.toJson(objeto)                          │
│                                              │
├──────────────────────────────────────────────┤
│                                              │
│ JSON → objeto                                │
│                                              │
│ gson.fromJson(json, Alumno.class)            │
│                                              │
├──────────────────────────────────────────────┤
│                                              │
│ JSON → List<Alumno>                          │
│                                              │
│ Type tipo =                                  │
│   new TypeToken<List<Alumno>>() {}           │
│       .getType();                            │
│                                              │
│ gson.fromJson(json, tipo)                    │
│                                              │
├──────────────────────────────────────────────┤
│                                              │
│ Java → fichero JSON                          │
│                                              │
│ gson.toJson(objeto, writer)                  │
│                                              │
├──────────────────────────────────────────────┤
│                                              │
│ fichero JSON → Java                          │
│                                              │
│ gson.fromJson(reader, tipo)                  │
│                                              │
└──────────────────────────────────────────────┘
```

---

## 28. org.json frente a Gson

Después de estudiar ambas librerías podemos comparar su forma de trabajar.

| Aspecto | org.json | Gson |
|---|---|---|
| Forma de trabajo | Manipulación explícita del JSON | Mapeo de objetos |
| Objeto JSON | `JSONObject` | Objeto Java |
| Array JSON | `JSONArray` | `List`, arrays, etc. |
| Crear propiedades | `put()` | Campos del objeto |
| Leer propiedades | `get...()` / `opt...()` | Mapeo automático |
| Java → JSON | Construcción manual | `toJson()` |
| JSON → Java | Lectura manual | `fromJson()` |
| Colecciones genéricas | Manipulación de `JSONArray` | `TypeToken` |
| Configuración | Limitada | `GsonBuilder` |
| Adaptadores | — | Personalizables |

---

## 29. Mismo problema con org.json y Gson

Supongamos que tenemos:

```java
Alumno alumno =
        new Alumno(
            1,
            "Ana",
            8.5
        );
```

Con `org.json` podríamos construir:

```java
JSONObject json =
        new JSONObject();

json.put(
    "id",
    alumno.getId()
);

json.put(
    "nombre",
    alumno.getNombre()
);

json.put(
    "nota",
    alumno.getNota()
);
```

Con Gson:

```java
String json =
        gson.toJson(alumno);
```

---

## 30. ¿Por qué hemos estudiado primero org.json?

El trabajo manual con `org.json` nos permite comprender claramente la estructura JSON:

```text
objeto
array
propiedad
valor
objeto anidado
array anidado
```

Después, Gson introduce una abstracción:

```text
Objeto Java
     │
     │ Gson
     ▼
    JSON
```

Así podemos entender qué trabajo está automatizando la librería.

---

## 31. Recorrido de los ejemplos

A lo largo del bloque hemos utilizado distintos ejemplos.

```text
Alumno.java
     │
     ▼
modelo de datos
```

```text
DemoGson.java
     │
     ▼
Alumno ⇄ JSON
en memoria
```

```text
DemoListaGson.java
     │
     ▼
List<Alumno> ⇄ JSON
```

```text
GuardarAlumnosGson.java
     │
     ▼
List<Alumno>
     ↓
alumnos.json
```

```text
LeerAlumnosGson.java
     │
     ▼
alumnos.json
     ↓
List<Alumno>
```

```text
LocalDateAdapter.java
     │
     ▼
LocalDate ⇄ JSON
```

```text
DemoLocalDateGson.java
     │
     ▼
uso de un adaptador
personalizado
```

---

## 32. Orden recomendado para ejecutar los ejemplos

Podemos seguir este orden:

```text
1
Alumno.java
   │
   ▼
Modelo de datos


2
DemoGson.java
   │
   ▼
Objeto ⇄ JSON


3
DemoListaGson.java
   │
   ▼
Colección ⇄ JSON


4
GuardarAlumnosGson.java
   │
   ▼
Crear alumnos.json


5
LeerAlumnosGson.java
   │
   ▼
Recuperar alumnos.json


6
LocalDateAdapter.java
   +
DemoLocalDateGson.java
   │
   ▼
Conversión personalizada
```

---

## 33. ¿Qué fichero genera el ejemplo?

`GuardarAlumnosGson.java` genera:

```text
data/
└── alumnos.json
```

con un contenido similar a:

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

Después:

```text
LeerAlumnosGson.java
```

recupera ese fichero como:

```java
List<Alumno>
```

---

## 34. Dependencia Maven

Para utilizar Gson necesitamos añadir la dependencia correspondiente al proyecto Maven:

```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.11.0</version>
</dependency>
```

En nuestro proyecto utilizamos además:

```xml
<properties>
    <project.build.sourceEncoding>
        UTF-8
    </project.build.sourceEncoding>

    <maven.compiler.release>
        21
    </maven.compiler.release>
</properties>
```

Por tanto, nuestros ejemplos están preparados para:

```text
Java 21
+
Maven
+
Gson
```

---

## 35. Estructura del proyecto de ejemplos

El proyecto completo de ejemplos puede organizarse así:

```text
gson-ejemplos/
│
├── pom.xml
│
├── data/
│   └── alumnos.json
│
└── src/
    └── main/
        └── java/
            └── com/
                └── example/
                    │
                    ├── Alumno.java
                    │
                    ├── DemoGson.java
                    │
                    ├── DemoListaGson.java
                    │
                    ├── GuardarAlumnosGson.java
                    │
                    ├── LeerAlumnosGson.java
                    │
                    ├── LocalDateAdapter.java
                    │
                    └── DemoLocalDateGson.java
```

---

## 36. Qué debes saber al terminar

Al finalizar este bloque deberías ser capaz de explicar y utilizar:

- qué es serializar;
- qué es deserializar;
- `Gson`;
- `GsonBuilder`;
- `toJson()`;
- `fromJson()`;
- `setPrettyPrinting()`;
- conversión de objetos Java;
- conversión de colecciones;
- `TypeToken`;
- escritura mediante `Writer`;
- lectura mediante `Reader`;
- persistencia en ficheros JSON;
- adaptadores personalizados;
- `JsonSerializer`;
- `JsonDeserializer`;
- `registerTypeAdapter()`.

---

## 37. Preguntas de repaso

#### 1. ¿Qué diferencia existe entre `toJson()` y `fromJson()`?

#### 2. ¿Para qué utilizamos `Alumno.class`?

#### 3. ¿Por qué aparece `TypeToken` cuando trabajamos con `List<Alumno>`?

#### 4. ¿Qué diferencia existe entre `FileReader` y `FileWriter`?

#### 5. ¿Qué hace `setPrettyPrinting()`?

#### 6. ¿Qué diferencia existe entre `TypeToken` y un adaptador?

#### 7. ¿Para qué sirve `registerTypeAdapter()`?

#### 8. ¿Qué método utilizarías para guardar directamente un objeto utilizando un `Writer`?

#### 9. ¿Qué método utilizarías para recuperar una lista desde un `Reader`?

#### 10. ¿Qué ventaja principal aporta Gson frente a construir manualmente `JSONObject` y `JSONArray`?

---

## 38. Resumen final

```text
                         GSON
                          │
                          ▼
               OBJETOS JAVA ⇄ JSON
                          │
          ┌───────────────┼───────────────┐
          │               │               │
          ▼               ▼               ▼
      toJson()        fromJson()      GsonBuilder
          │               │               │
          │               │       ┌───────┴────────┐
          │               │       │                │
          │               │       ▼                ▼
          │               │  PrettyPrinting   Adaptadores
          │               │                        │
          │               │                    LocalDate
          │               │
          │          ┌────┴────┐
          │          │         │
          │          ▼         ▼
          │      Clase.class  TypeToken
          │          │         │
          │          ▼         ▼
          │        Alumno   List<Alumno>
          │
          └──────────────┬─────────────────┐
                         │                 │
                         ▼                 ▼
                       Writer            Reader
                         │                 │
                         ▼                 ▼
                     GUARDAR             LEER
                         │                 │
                         └────────┬────────┘
                                  ▼
                            FICHEROS JSON
```

---

!!! success "Gson completado"
    Ya conocemos el flujo principal de trabajo con Gson:

    ```text
    OBJETOS JAVA
         │
         │ toJson()
         ▼
        JSON
         │
         │ fromJson()
         ▼
    OBJETOS JAVA
    ```

    y podemos aplicar el mismo mecanismo a colecciones, ficheros y tipos que necesitan una conversión personalizada.