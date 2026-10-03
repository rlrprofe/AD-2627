# org.json — Resumen y referencia rápida

### 1. ¿Qué hemos aprendido?

`org.json` es una librería Java que permite **crear, consultar y manipular estructuras JSON de forma explícita**.

Las tres clases que hemos utilizado principalmente son:

```text
JSONObject
JSONArray
JSONTokener
```

Cada una tiene una función diferente:

```text
JSONObject
    │
    └── representa un objeto JSON
        { ... }


JSONArray
    │
    └── representa un array JSON
        [ ... ]


JSONTokener
    │
    └── ayuda a interpretar
        texto JSON
```

A diferencia de Gson, con `org.json` trabajamos directamente con la estructura del documento JSON.

---

## Mapa general

### 2. Los conceptos principales

```text
                         org.json
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
          ▼                 ▼                 ▼
     JSONObject         JSONArray        JSONTokener
          │                 │                 │
          │                 │                 │
       objetos            arrays            lectura
        { ... }            [ ... ]          de JSON
          │                 │                 │
          └─────────────────┼─────────────────┘
                            │
                ┌───────────┴───────────┐
                │                       │
                ▼                       ▼
              CREAR                   CONSULTAR
                │                       │
              put()                 get...()
                                    opt...()
                │                       │
                └───────────┬───────────┘
                            │
                            ▼
                         FICHEROS
                            │
                     ┌──────┴──────┐
                     ▼             ▼
                   GUARDAR        LEER
```

---

## 3. JSONObject

`JSONObject` representa un **objeto JSON**.

Por ejemplo:

```json
{
  "nombre": "Ana",
  "edad": 21,
  "activo": true
}
```

En Java:

```java
JSONObject alumno =
        new JSONObject();
```

Podemos añadir propiedades mediante:

```java
alumno.put(
    "nombre",
    "Ana"
);

alumno.put(
    "edad",
    21
);

alumno.put(
    "activo",
    true
);
```

El resultado será equivalente a:

```json
{
  "nombre": "Ana",
  "edad": 21,
  "activo": true
}
```

---

## 4. La idea clave de JSONObject

Podemos imaginar un `JSONObject` como un conjunto de pares:

```text
CLAVE          VALOR

"nombre"  →    "Ana"

"edad"    →    21

"activo"  →    true
```

Por tanto:

```text
JSONObject
     │
     ├── clave → valor
     ├── clave → valor
     └── clave → valor
```

---

## 5. Crear propiedades con put()

El método fundamental para construir un `JSONObject` es:

```java
put()
```

Ejemplo:

```java
JSONObject alumno =
        new JSONObject();

alumno.put(
    "id",
    1
);

alumno.put(
    "nombre",
    "Ana"
);

alumno.put(
    "nota",
    8.5
);
```

Podemos resumir:

```text
JSONObject
     │
     │ put(clave, valor)
     ▼
 propiedad JSON
```

---

## 6. Recuperar valores

Una vez construido el objeto podemos recuperar sus valores.

Por ejemplo:

```java
String nombre =
        alumno.getString(
            "nombre"
        );
```

También disponemos de métodos como:

```java
getInt()
getDouble()
getBoolean()
getJSONObject()
getJSONArray()
```

La elección depende del tipo de dato que esperamos encontrar.

---

## 7. Métodos get...

Los métodos `get...()` esperan que la propiedad exista y que podamos obtenerla con el tipo correspondiente.

Ejemplos:

```java
String nombre =
        alumno.getString(
            "nombre"
        );
```

```java
int id =
        alumno.getInt(
            "id"
        );
```

```java
double nota =
        alumno.getDouble(
            "nota"
        );
```

Podemos asociar:

```text
getString()     → String

getInt()        → int

getDouble()     → double

getBoolean()    → boolean

getJSONObject() → JSONObject

getJSONArray()  → JSONArray
```

---

## 8. Métodos opt...

Cuando una propiedad puede no existir podemos utilizar los métodos:

```java
opt...
```

Por ejemplo:

```java
String telefono =
        alumno.optString(
            "telefono",
            "No disponible"
        );
```

Si existe:

```json
"telefono": "600123123"
```

obtendremos:

```text
600123123
```

Si no existe, podremos obtener el valor indicado:

```text
No disponible
```

---

## 9. get... frente a opt...

Una de las diferencias importantes que debemos recordar es:

```text
get...
   │
   └── esperamos que el dato exista


opt...
   │
   └── permitimos tratar
       datos opcionales
```

Ejemplo:

```java
alumno.getString(
    "nombre"
);
```

frente a:

```java
alumno.optString(
    "telefono",
    "No disponible"
);
```

!!! tip
    Los métodos `opt...()` son especialmente útiles cuando trabajamos con información que puede ser opcional.

---

## 10. Comprobar si existe una propiedad

Podemos utilizar:

```java
has()
```

Por ejemplo:

```java
if (alumno.has("telefono")) {

    System.out.println(
        alumno.getString(
            "telefono"
        )
    );
}
```

Conceptualmente:

```text
JSONObject
     │
     │ has("telefono")
     ▼
¿existe la propiedad?
```

---

## 11. Eliminar una propiedad

Podemos eliminar una propiedad mediante:

```java
remove()
```

Por ejemplo:

```java
alumno.remove(
    "telefono"
);
```

Después la propiedad dejará de formar parte del objeto.

---

## 12. Modificar una propiedad

Podemos volver a utilizar:

```java
put()
```

sobre una clave existente.

Por ejemplo:

```java
alumno.put(
    "nota",
    8.5
);
```

y posteriormente:

```java
alumno.put(
    "nota",
    9.2
);
```

El valor asociado a:

```text
nota
```

quedará actualizado.

---

## 13. Valores null

JSON permite representar la ausencia explícita de un valor mediante:

```json
null
```

En `org.json` podemos encontrarnos con:

```java
JSONObject.NULL
```

Es importante distinguir conceptualmente:

```text
propiedad inexistente
```

de:

```text
propiedad existente
con valor null
```

Por ejemplo:

```json
{
  "telefono": null
}
```

no es exactamente lo mismo que:

```json
{
}
```

---

## 14. Objetos anidados

Un objeto JSON puede contener otro objeto.

Por ejemplo:

```json
{
  "id": 1,
  "nombre": "Ana",
  "direccion": {
    "ciudad": "Alcalá de Henares",
    "codigoPostal": "28801"
  }
}
```

Podemos construirlo mediante:

```java
JSONObject direccion =
        new JSONObject();

direccion.put(
    "ciudad",
    "Alcalá de Henares"
);

direccion.put(
    "codigoPostal",
    "28801"
);

JSONObject alumno =
        new JSONObject();

alumno.put(
    "id",
    1
);

alumno.put(
    "nombre",
    "Ana"
);

alumno.put(
    "direccion",
    direccion
);
```

---

## 15. Recuperar un objeto anidado

Podemos obtener:

```java
JSONObject direccion =
        alumno.getJSONObject(
            "direccion"
        );
```

y después:

```java
String ciudad =
        direccion.getString(
            "ciudad"
        );
```

El recorrido es:

```text
alumno
   │
   │ getJSONObject("direccion")
   ▼
direccion
   │
   │ getString("ciudad")
   ▼
"Alcalá de Henares"
```

---

## 16. JSONArray

`JSONArray` representa un **array JSON**.

Por ejemplo:

```json
[
  "Java",
  "Python",
  "Kotlin"
]
```

En Java podemos crear:

```java
JSONArray lenguajes =
        new JSONArray();
```

y añadir elementos mediante:

```java
lenguajes.put(
    "Java"
);

lenguajes.put(
    "Python"
);

lenguajes.put(
    "Kotlin"
);
```

---

## 17. put() en JSONArray

También utilizamos:

```java
put()
```

para añadir elementos a un array.

Pero ahora no proporcionamos una clave:

```java
array.put(valor);
```

Por ejemplo:

```java
lenguajes.put(
    "Java"
);
```

Los elementos quedan almacenados mediante posiciones:

```text
JSONArray
   │
   ├── [0] "Java"
   ├── [1] "Python"
   └── [2] "Kotlin"
```

---

## 18. length()

Podemos conocer el número de elementos mediante:

```java
length()
```

Por ejemplo:

```java
int cantidad =
        lenguajes.length();
```

Si tenemos:

```json
[
  "Java",
  "Python",
  "Kotlin"
]
```

obtendremos:

```text
3
```

---

## 19. Acceder por posición

Podemos recuperar los elementos indicando su índice.

Por ejemplo:

```java
String lenguaje =
        lenguajes.getString(0);
```

obtendremos:

```text
Java
```

Recordemos que los índices comienzan en:

```text
0
```

---

## 20. Recorrer un JSONArray

Una forma habitual es utilizar:

```java
for
```

junto con:

```java
length()
```

Por ejemplo:

```java
for (int i = 0;
        i < lenguajes.length();
        i++) {

    System.out.println(
        lenguajes.getString(i)
    );
}
```

Esquema:

```text
i = 0 → Java

i = 1 → Python

i = 2 → Kotlin
```

---

## 21. JSONArray de objetos

Un `JSONArray` puede contener objetos.

Por ejemplo:

```json
[
  {
    "id": 1,
    "nombre": "Ana"
  },
  {
    "id": 2,
    "nombre": "Luis"
  }
]
```

Conceptualmente:

```text
JSONArray
   │
   ├── JSONObject
   │      ├── id
   │      └── nombre
   │
   └── JSONObject
          ├── id
          └── nombre
```

---

## 22. Recorrer un array de objetos

Podemos hacer:

```java
for (int i = 0;
        i < alumnos.length();
        i++) {

    JSONObject alumno =
            alumnos.getJSONObject(i);

    System.out.println(
        alumno.getString(
            "nombre"
        )
    );
}
```

El proceso es:

```text
JSONArray
    │
    │ getJSONObject(i)
    ▼
JSONObject
    │
    │ getString("nombre")
    ▼
nombre
```

---

## 23. JSONObject con JSONArray

También podemos combinar ambas estructuras:

```json
{
  "nombre": "Ana",
  "modulos": [
    "Acceso a Datos",
    "Programación Multimedia",
    "Sistemas de Gestión Empresarial"
  ]
}
```

En Java:

```java
JSONArray modulos =
        new JSONArray();

modulos.put(
    "Acceso a Datos"
);

modulos.put(
    "Programación Multimedia"
);

modulos.put(
    "Sistemas de Gestión Empresarial"
);

JSONObject alumno =
        new JSONObject();

alumno.put(
    "nombre",
    "Ana"
);

alumno.put(
    "modulos",
    modulos
);
```

---

## 24. Recuperar un JSONArray anidado

Podemos hacer:

```java
JSONArray modulos =
        alumno.getJSONArray(
            "modulos"
        );
```

y después recorrerlo:

```java
for (int i = 0;
        i < modulos.length();
        i++) {

    System.out.println(
        modulos.getString(i)
    );
}
```

---

## 25. Recorrer las claves de JSONObject

También podemos recorrer las propiedades de un objeto.

Por ejemplo:

```java
for (String clave :
        alumno.keySet()) {

    System.out.println(
        clave
        + " = "
        + alumno.get(clave)
    );
}
```

Si tenemos:

```json
{
  "id": 1,
  "nombre": "Ana",
  "nota": 8.5
}
```

podremos acceder a sus diferentes claves y valores.

---

## 26. Guardar JSON en un fichero

Una estructura JSON que está en memoria desaparece cuando termina el programa.

Para conservarla debemos guardarla.

Por ejemplo:

```text
JSONObject
     │
     │ toString()
     ▼
texto JSON
     │
     ▼
FileWriter
     │
     ▼
 fichero
```

---

## 27. toString()

Podemos obtener la representación JSON mediante:

```java
objeto.toString();
```

Por ejemplo:

```java
String json =
        alumno.toString();
```

---

## 28. JSON con formato

También podemos utilizar:

```java
toString(4)
```

Por ejemplo:

```java
String json =
        alumno.toString(4);
```

El número:

```text
4
```

indica la indentación utilizada para presentar el JSON.

Así obtenemos un documento más legible.

---

## 29. FileWriter

Podemos escribir:

```java
try (FileWriter writer =
        new FileWriter(
            "data/persona.json"
        )) {

    writer.write(
        persona.toString(4)
    );
}
```

El recorrido es:

```text
JSONObject
     │
     │ toString(4)
     ▼
String JSON
     │
     │ write()
     ▼
FileWriter
     │
     ▼
persona.json
```

---

## 30. Leer JSON desde un fichero

Para recuperar un JSON almacenado podemos utilizar:

```text
FileReader
     +
JSONTokener
```

El recorrido será:

```text
fichero
   │
   ▼
FileReader
   │
   ▼
JSONTokener
   │
   ▼
JSONObject / JSONArray
```

---

## 31. JSONTokener

`JSONTokener` ayuda a interpretar una secuencia de caracteres como contenido JSON.

Por ejemplo:

```java
try (FileReader reader =
        new FileReader(
            "data/persona.json"
        )) {

    JSONTokener tokener =
            new JSONTokener(
                reader
            );

    JSONObject persona =
            new JSONObject(
                tokener
            );
}
```

---

## 32. ¿Qué papel tiene cada clase?

```text
FileReader
    │
    └── lee caracteres
        desde el fichero


JSONTokener
    │
    └── interpreta el flujo
        como contenido JSON


JSONObject
    │
    └── representa el objeto
        JSON resultante
```

---

## 33. nextValue()

Cuando no sabemos de antemano si la raíz del documento es un objeto o un array, podemos utilizar:

```java
tokener.nextValue();
```

Por ejemplo:

```java
Object valor =
        tokener.nextValue();
```

Después podemos comprobar qué estructura hemos recibido.

Con Java 21 podemos utilizar:

```java
if (valor instanceof JSONObject objeto) {

    System.out.println(
        "Es un objeto JSON"
    );

} else if (
        valor instanceof JSONArray array) {

    System.out.println(
        "Es un array JSON"
    );
}
```

---

## 34. JSONObject o JSONArray en la raíz

Un documento puede comenzar por:

```json
{
```

En ese caso tenemos:

```text
JSONObject
```

O puede comenzar por:

```json
[
```

En ese caso tenemos:

```text
JSONArray
```

Podemos resumir:

```text
{ ... }  → JSONObject

[ ... ]  → JSONArray
```

---

## 35. El ciclo completo

Ya podemos realizar todo el proceso:

```text
                    CREAR

datos Java
    │
    ▼
JSONObject / JSONArray
    │
    │ put()
    ▼
estructura JSON
    │
    │ toString(4)
    ▼
FileWriter
    │
    ▼
fichero JSON
    │
    │ FileReader
    ▼
JSONTokener
    │
    ▼
JSONObject / JSONArray
    │
    │ get...() / opt...()
    ▼
datos
```

---

## 36. Chuleta de JSONObject

| Operación | Método |
|---|---|
| Crear objeto | `new JSONObject()` |
| Añadir propiedad | `put(clave, valor)` |
| Obtener valor genérico | `get(clave)` |
| Obtener texto | `getString(clave)` |
| Obtener entero | `getInt(clave)` |
| Obtener decimal | `getDouble(clave)` |
| Obtener booleano | `getBoolean(clave)` |
| Obtener objeto | `getJSONObject(clave)` |
| Obtener array | `getJSONArray(clave)` |
| Texto opcional | `optString(clave)` |
| Entero opcional | `optInt(clave)` |
| Decimal opcional | `optDouble(clave)` |
| Comprobar propiedad | `has(clave)` |
| Eliminar propiedad | `remove(clave)` |
| Recorrer claves | `keySet()` |
| Generar JSON | `toString()` |
| JSON indentado | `toString(4)` |

---

## 37. Chuleta de JSONArray

| Operación | Método |
|---|---|
| Crear array | `new JSONArray()` |
| Añadir elemento | `put(valor)` |
| Número de elementos | `length()` |
| Obtener elemento | `get(indice)` |
| Obtener texto | `getString(indice)` |
| Obtener entero | `getInt(indice)` |
| Obtener decimal | `getDouble(indice)` |
| Obtener objeto | `getJSONObject(indice)` |
| Obtener array | `getJSONArray(indice)` |
| Generar JSON | `toString()` |
| JSON indentado | `toString(4)` |

---

## 38. Chuleta de lectura de ficheros

Para un objeto:

```java
try (FileReader reader =
        new FileReader(
            "data/persona.json"
        )) {

    JSONTokener tokener =
            new JSONTokener(
                reader
            );

    JSONObject persona =
            new JSONObject(
                tokener
            );
}
```

Para una raíz desconocida:

```java
try (FileReader reader =
        new FileReader(
            "data/datos.json"
        )) {

    JSONTokener tokener =
            new JSONTokener(
                reader
            );

    Object valor =
            tokener.nextValue();
}
```

---

## 39. Chuleta visual

```text
┌───────────────────────────────────────────────┐
│                   org.json                    │
├───────────────────────────────────────────────┤
│                                               │
│ OBJETO JSON                                   │
│                                               │
│ JSONObject objeto = new JSONObject();         │
│                                               │
├───────────────────────────────────────────────┤
│                                               │
│ ARRAY JSON                                    │
│                                               │
│ JSONArray array = new JSONArray();            │
│                                               │
├───────────────────────────────────────────────┤
│                                               │
│ AÑADIR                                        │
│                                               │
│ objeto.put("clave", valor);                   │
│ array.put(valor);                             │
│                                               │
├───────────────────────────────────────────────┤
│                                               │
│ CONSULTAR                                     │
│                                               │
│ objeto.getString("nombre");                   │
│ objeto.getInt("id");                          │
│ objeto.optString("telefono");                 │
│                                               │
├───────────────────────────────────────────────┤
│                                               │
│ ESTRUCTURAS ANIDADAS                          │
│                                               │
│ objeto.getJSONObject("direccion");            │
│ objeto.getJSONArray("modulos");               │
│                                               │
├───────────────────────────────────────────────┤
│                                               │
│ GUARDAR                                       │
│                                               │
│ writer.write(objeto.toString(4));             │
│                                               │
├───────────────────────────────────────────────┤
│                                               │
│ LEER                                          │
│                                               │
│ FileReader → JSONTokener → JSONObject         │
│                              / JSONArray      │
│                                               │
└───────────────────────────────────────────────┘
```

---

## 40. Los 11 ejemplos del minicurso

A lo largo del bloque hemos trabajado con estos ejemplos:

| Nº | Fichero | Concepto principal |
|---:|---|---|
| 1 | `DemoOrgJson.java` | Primer contacto con `org.json` |
| 2 | `DemoJSONObject.java` | Creación y consulta de `JSONObject` |
| 3 | `JSONObjectOpcionales.java` | Propiedades opcionales y métodos `opt...()` |
| 4 | `JSONObjectAnidado.java` | Objetos y estructuras anidadas |
| 5 | `RecorrerJSONObject.java` | Recorrido de las propiedades |
| 6 | `DemoJSONArray.java` | Creación y recorrido de `JSONArray` |
| 7 | `JSONArrayAnidado.java` | Arrays con objetos y estructuras anidadas |
| 8 | `GuardarJSONv1.java` | Guardar un objeto JSON en fichero |
| 9 | `LeerJSONv1.java` | Leer un objeto JSON desde fichero |
| 10 | `GuardarJSONv2.java` | Guardar estructuras JSON más completas |
| 11 | `LeerJSONv2.java` | Lectura de estructuras y uso de `JSONTokener` |

---

## 41. Recorrido recomendado de los ejemplos

```text
1. DemoOrgJson.java
          │
          ▼
   Primer contacto
          │
          ▼
2. DemoJSONObject.java
          │
          ▼
      JSONObject
          │
          ├─────────────────────┐
          ▼                     ▼
3. JSONObjectOpcionales   4. JSONObjectAnidado
          │                     │
          └──────────┬──────────┘
                     ▼
             5. RecorrerJSONObject
                     │
                     ▼
             6. DemoJSONArray
                     │
                     ▼
             7. JSONArrayAnidado
                     │
                     ▼
                PERSISTENCIA
                     │
             ┌───────┴────────┐
             ▼                ▼
      8. GuardarJSONv1   9. LeerJSONv1
             │                │
             └───────┬────────┘
                     ▼
            10. GuardarJSONv2
                     │
                     ▼
             11. LeerJSONv2
```

---

## 42. Dependencia Maven

Para utilizar `org.json` en nuestro proyecto Maven hemos añadido:

```xml
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20240303</version>
</dependency>
```

Nuestro proyecto está preparado para:

```text
Java 21
+
Maven
+
org.json
```

y utiliza:

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

---

## 43. Estructura del proyecto de ejemplos

El proyecto descargable del minicurso contiene los ejemplos en una única estructura Maven:

```text
org-json-ejemplos/
│
├── pom.xml
├── README.md
│
├── data/
│   ├── persona.json
│   └── personas.json
│
└── src/
    └── main/
        └── java/
            └── com/
                └── example/
                    │
                    ├── DemoOrgJson.java
                    ├── DemoJSONObject.java
                    ├── JSONObjectOpcionales.java
                    ├── JSONObjectAnidado.java
                    ├── RecorrerJSONObject.java
                    ├── DemoJSONArray.java
                    ├── JSONArrayAnidado.java
                    ├── GuardarJSONv1.java
                    ├── LeerJSONv1.java
                    ├── GuardarJSONv2.java
                    └── LeerJSONv2.java
```

---

## 44. ¿Qué debes saber al terminar?

Al finalizar este bloque deberías ser capaz de:

- distinguir `JSONObject` y `JSONArray`;
- crear objetos JSON;
- crear arrays JSON;
- añadir propiedades y elementos con `put()`;
- recuperar valores mediante `get...()`;
- trabajar con propiedades opcionales mediante `opt...()`;
- comprobar propiedades mediante `has()`;
- modificar y eliminar propiedades;
- crear objetos y arrays anidados;
- recorrer un `JSONObject`;
- recorrer un `JSONArray`;
- generar la representación textual del JSON;
- utilizar `toString(4)` para obtener JSON indentado;
- guardar JSON en un fichero;
- leer JSON desde un fichero;
- comprender la función de `JSONTokener`;
- distinguir una raíz `JSONObject` de una raíz `JSONArray`;
- utilizar `nextValue()` cuando sea necesario.

---

## 45. Preguntas de repaso

#### 1. ¿Qué diferencia existe entre `JSONObject` y `JSONArray`?

#### 2. ¿Para qué sirve `put()`?

#### 3. ¿Qué diferencia existe entre `getString()` y `optString()`?

#### 4. ¿Cómo podemos comprobar si existe una propiedad?

#### 5. ¿Cómo eliminamos una propiedad?

#### 6. ¿Cómo obtenemos un objeto JSON que está anidado dentro de otro?

#### 7. ¿Cómo obtenemos un array JSON que está dentro de un objeto?

#### 8. ¿Para qué utilizamos `length()`?

#### 9. ¿Qué diferencia existe entre `toString()` y `toString(4)`?

#### 10. ¿Qué función realiza `JSONTokener`?

#### 11. ¿Qué utilidad tiene `nextValue()`?

#### 12. ¿Qué clases de Java hemos utilizado para escribir y leer ficheros?

---

## 46. Resumen final

```text
                         org.json
                            │
           ┌────────────────┼────────────────┐
           │                │                │
           ▼                ▼                ▼
      JSONObject        JSONArray       JSONTokener
           │                │                │
           ▼                ▼                ▼
        { ... }           [ ... ]         lectura
           │                │
           │                │
           ▼                ▼
         put()            put()
           │                │
           └────────┬───────┘
                    │
                    ▼
             ESTRUCTURA JSON
                    │
         ┌──────────┼──────────┐
         │          │          │
         ▼          ▼          ▼
      get...()   opt...()   estructuras
                              anidadas
         │          │          │
         └──────────┼──────────┘
                    │
                    ▼
                toString(4)
                    │
                    ▼
                 Writer
                    │
                    ▼
               FICHERO JSON
                    │
                    ▼
                 Reader
                    │
                    ▼
               JSONTokener
                    │
             ┌──────┴──────┐
             ▼             ▼
        JSONObject      JSONArray
```

---

!!! success "org.json completado"
    Ya conocemos el flujo completo de trabajo con `org.json`:

    ```text
    CREAR
      ↓
    JSONObject / JSONArray
      ↓
    MANIPULAR Y CONSULTAR
      ↓
    GUARDAR
      ↓
    FICHERO JSON
      ↓
    LEER
      ↓
    JSONTokener
      ↓
    JSONObject / JSONArray
    ```

    Con `org.json` hemos aprendido a trabajar directamente con la estructura de un documento JSON antes de pasar al mapeo automático de objetos que proporciona Gson.