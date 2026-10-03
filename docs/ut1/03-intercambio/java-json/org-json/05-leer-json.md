# Leer JSON desde un fichero

### 1. Introducción

En el apartado anterior aprendimos a realizar este proceso:

```text
DATOS JAVA
     ↓
JSONObject / JSONArray
     ↓
toString(4)
     ↓
FileWriter
     ↓
FICHERO JSON
```

Ahora vamos a realizar el proceso contrario.

Partiremos de un fichero:

```text
data/persona.json
```

que contiene, por ejemplo:

```json
{
    "nombre": "Ana",
    "edad": 21,
    "nota": 8.5,
    "repetidor": false
}
```

y queremos recuperar esos datos desde nuestro programa Java.

El proceso será:

```text
FICHERO JSON
     ↓
FileReader / BufferedReader
     ↓
JSONTokener
     ↓
JSONObject / JSONArray
     ↓
get...() / opt...()
     ↓
DATOS JAVA
```

!!! important "Idea fundamental"
    Leer un fichero y procesar su contenido como JSON son **dos operaciones diferentes**.

    Las clases de Java como `FileReader` o `BufferedReader` se encargan de **leer el fichero**.

    Las clases de `org.json` se encargan de **interpretar su contenido como JSON**.

---

## El proceso de lectura

### 2. Tres niveles diferentes

Cuando leemos JSON desde un fichero intervienen tres elementos principales.

#### Nivel 1. El fichero

Tenemos físicamente:

```text
data/persona.json
```

con:

```json
{
    "nombre": "Ana",
    "edad": 21
}
```

---

#### Nivel 2. La lectura del fichero

Java necesita abrir el fichero.

Podemos utilizar:

```java
FileReader
```

o combinarlo con:

```java
BufferedReader
```

Estas clases pertenecen a Java.

No pertenecen a `org.json`.

---

#### Nivel 3. Interpretar el JSON

Una vez tenemos acceso al contenido, necesitamos que `org.json` interprete la sintaxis:

```json
{
    "nombre": "Ana",
    "edad": 21
}
```

Aquí entra en juego:

```java
JSONTokener
```

Después podremos construir:

```java
JSONObject
```

o:

```java
JSONArray
```

---

### 3. Mapa general de lectura

Podemos representar el proceso completo así:

```text
┌──────────────────────┐
│   persona.json       │
│                      │
│ {"nombre":"Ana"}     │
└──────────┬───────────┘
           │
           ▼
      FileReader
           │
           │ lee caracteres
           ▼
      JSONTokener
           │
           │ interpreta JSON
           ▼
      JSONObject
           │
           │ get...()
           ▼
       DATOS JAVA
```

Si el fichero contiene un array:

```text
┌──────────────────────┐
│   personas.json      │
│                      │
│ [ {...}, {...} ]     │
└──────────┬───────────┘
           │
           ▼
      FileReader
           │
           ▼
      JSONTokener
           │
           ▼
       JSONArray
           │
           ▼
    JSONObject
           │
           ▼
       DATOS JAVA
```

---

## FileReader

### 4. ¿Qué es FileReader?

`FileReader` es una clase de Java que permite leer un fichero de texto.

Debemos importar:

```java
import java.io.FileReader;
```

Por ejemplo:

```java
FileReader reader =
        new FileReader("data/persona.json");
```

Esto abre el fichero:

```text
data/persona.json
```

para lectura.

!!! note
    `FileReader` no sabe qué es un `JSONObject`, un `JSONArray` ni una propiedad JSON.

    Para `FileReader`, el contenido del fichero es simplemente una secuencia de caracteres.

---

### 5. FileReader no interpreta JSON

Supongamos que el fichero contiene:

```json
{
    "nombre": "Ana",
    "edad": 21
}
```

`FileReader` puede leer los caracteres:

```text
{
"
n
o
m
b
r
e
"
:
...
```

pero no sabe que:

```text
"nombre"
```

es una clave ni que:

```text
21
```

es el valor asociado a `"edad"`.

Necesitamos otra herramienta que interprete esa sintaxis.

Esa herramienta será:

```java
JSONTokener
```

---

## JSONTokener

### 6. ¿Qué es JSONTokener?

`JSONTokener` es una clase de la librería `org.json`.

Debemos importar:

```java
import org.json.JSONTokener;
```

Su función es ayudar a analizar una secuencia de caracteres que contiene JSON.

Podemos crear uno a partir de un `Reader`:

```java
JSONTokener tokener =
        new JSONTokener(reader);
```

El flujo será:

```text
FileReader
     │
     │ proporciona caracteres
     ▼
JSONTokener
     │
     │ interpreta la sintaxis JSON
     ▼
JSONObject / JSONArray
```

!!! important "JSONTokener no abre el fichero"
    No debemos confundir las responsabilidades.

    `FileReader`:

    ```text
    abre y lee el fichero
    ```

    `JSONTokener`:

    ```text
    procesa el contenido como JSON
    ```

---

### 7. ¿Por qué se llama Tokener?

Cuando un analizador procesa un texto necesita reconocer sus diferentes elementos.

Por ejemplo:

```json
{
    "nombre": "Ana",
    "edad": 21
}
```

aparecen elementos como:

```text
{
"nombre"
:
"Ana"
,
"edad"
:
21
}
```

`JSONTokener` permite a la librería avanzar por esa secuencia e interpretar la estructura JSON.

Para trabajar con `org.json` no necesitamos implementar nosotros ese análisis.

---

## Leer un JSONObject

### 8. Construir JSONObject desde JSONTokener

Si sabemos que el fichero contiene un **objeto JSON**, podemos escribir:

```java
try (FileReader reader =
        new FileReader("data/persona.json")) {

    JSONTokener tokener =
            new JSONTokener(reader);

    JSONObject persona =
            new JSONObject(tokener);
}
```

Observa el proceso:

```text
persona.json
     ↓
FileReader
     ↓
JSONTokener
     ↓
JSONObject
```

Una vez construido el `JSONObject`, podemos utilizar todo lo estudiado anteriormente:

```java
persona.getString("nombre");
persona.getInt("edad");
persona.optDouble("nota", 0.0);
```

---

### 9. Recuperar los datos

Supongamos que `persona.json` contiene:

```json
{
    "nombre": "Ana",
    "edad": 21,
    "nota": 8.5,
    "repetidor": false
}
```

Después de:

```java
JSONObject persona =
        new JSONObject(tokener);
```

podemos hacer:

```java
String nombre =
        persona.getString("nombre");

int edad =
        persona.getInt("edad");

double nota =
        persona.getDouble("nota");

boolean repetidor =
        persona.getBoolean("repetidor");
```

Y mostrar:

```java
System.out.println(nombre);
System.out.println(edad);
System.out.println(nota);
System.out.println(repetidor);
```

---

## Primer ejemplo completo

### 10. LeerJSONv1.java

El primer caso corresponde al fichero:

```text
data/persona.json
```

El proceso será:

```text
persona.json
      ↓
 FileReader
      ↓
 JSONTokener
      ↓
 JSONObject
      ↓
 getString()
 getInt()
 getDouble()
 getBoolean()
      ↓
 datos Java
```

Un ejemplo completo:

```java
package com.example;

import java.io.FileReader;
import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

public class LeerJSONv1 {

    public static void main(String[] args) {

        String ruta =
                "data/persona.json";

        try (FileReader reader =
                new FileReader(ruta)) {

            // =====================================
            // 1. CREAR JSONTOKENER
            // =====================================

            JSONTokener tokener =
                    new JSONTokener(reader);


            // =====================================
            // 2. CONSTRUIR EL JSONOBJECT
            // =====================================

            JSONObject persona =
                    new JSONObject(tokener);


            // =====================================
            // 3. MOSTRAR EL JSON
            // =====================================

            System.out.println(
                "Contenido del fichero:"
            );

            System.out.println(
                persona.toString(4)
            );


            // =====================================
            // 4. RECUPERAR LOS DATOS
            // =====================================

            String nombre =
                    persona.getString(
                        "nombre"
                    );

            int edad =
                    persona.getInt(
                        "edad"
                    );

            double nota =
                    persona.getDouble(
                        "nota"
                    );

            boolean repetidor =
                    persona.getBoolean(
                        "repetidor"
                    );


            // =====================================
            // 5. UTILIZAR LOS DATOS
            // =====================================

            System.out.println(
                "\nDatos recuperados:"
            );

            System.out.println(
                "Nombre: " + nombre
            );

            System.out.println(
                "Edad: " + edad
            );

            System.out.println(
                "Nota: " + nota
            );

            System.out.println(
                "Repetidor: " + repetidor
            );

        } catch (IOException e) {

            System.out.println(
                "Error al leer el fichero:"
            );

            System.out.println(
                e.getMessage()
            );

        } catch (JSONException e) {

            System.out.println(
                "El contenido no tiene "
                + "el formato JSON esperado:"
            );

            System.out.println(
                e.getMessage()
            );
        }
    }
}
```

---

## Errores de lectura

### 11. Dos tipos de problemas diferentes

Al leer JSON desde un fichero pueden aparecer, al menos, dos tipos de errores conceptualmente distintos.

#### Problema de entrada/salida

Por ejemplo:

```text
persona.json no existe
```

Esto está relacionado con:

```java
IOException
```

#### Problema con el JSON

Por ejemplo, el fichero contiene:

```text
{
   "nombre": "Ana",
   "edad":
```

El fichero puede existir y abrirse correctamente, pero su contenido no representa el JSON esperado.

Aquí interviene:

```java
JSONException
```

Por eso podemos diferenciar:

```java
catch (IOException e) {

    // problema de fichero

} catch (JSONException e) {

    // problema de JSON
}
```

---

### 12. El fichero no existe

Si escribimos:

```java
new FileReader(
    "data/persona.json"
);
```

pero el fichero no existe, no podremos leerlo.

Una posibilidad es comprobar previamente:

```java
Path fichero =
        Path.of(
            "data",
            "persona.json"
        );

if (Files.exists(fichero)) {

    // leer

}
```

Para ello:

```java
import java.nio.file.Files;
import java.nio.file.Path;
```

Aunque también podemos gestionar directamente la excepción producida al intentar abrirlo.

---

## Leer un JSONArray

### 13. ¿Qué ocurre con personas.json?

Ahora supongamos que tenemos:

```text
data/personas.json
```

con:

```json
[
    {
        "id": 1,
        "nombre": "Ana",
        "edad": 21
    },
    {
        "id": 2,
        "nombre": "Luis",
        "edad": 23
    },
    {
        "id": 3,
        "nombre": "Marta",
        "edad": 20
    }
]
```

La estructura principal es:

```text
JSONArray
```

Por tanto, podríamos hacer:

```java
try (FileReader reader =
        new FileReader(
            "data/personas.json"
        )) {

    JSONTokener tokener =
            new JSONTokener(reader);

    JSONArray personas =
            new JSONArray(tokener);
}
```

El proceso es:

```text
personas.json
      ↓
 FileReader
      ↓
 JSONTokener
      ↓
 JSONArray
```

---

### 14. Recorrer los objetos del JSONArray

Una vez tenemos:

```java
JSONArray personas
```

podemos recorrerlo:

```java
for (int i = 0;
     i < personas.length();
     i++) {

    JSONObject persona =
            personas.getJSONObject(i);

    String nombre =
            persona.getString(
                "nombre"
            );

    System.out.println(nombre);
}
```

El proceso es:

```text
JSONArray
   │
   ├── posición 0
   │       ↓
   │   JSONObject
   │
   ├── posición 1
   │       ↓
   │   JSONObject
   │
   └── posición 2
           ↓
       JSONObject
```

---

## nextValue()

### 15. ¿Y si no sabemos qué contiene el fichero?

Hasta ahora hemos supuesto que conocemos de antemano la estructura.

Si sabemos que contiene:

```json
{ ... }
```

podemos construir:

```java
new JSONObject(tokener)
```

Si sabemos que contiene:

```json
[ ... ]
```

podemos construir:

```java
new JSONArray(tokener)
```

Pero podemos encontrarnos con una situación en la que queramos analizar primero qué estructura contiene el fichero.

Para ello `JSONTokener` proporciona:

```java
nextValue()
```

Por ejemplo:

```java
Object contenido =
        tokener.nextValue();
```

Ahora podemos comprobar qué tipo de estructura hemos obtenido.

---

### 16. Comprobar si es JSONObject

Podemos utilizar:

```java
if (contenido instanceof JSONObject) {

    JSONObject objeto =
            (JSONObject) contenido;
}
```

Con Java moderno podemos utilizar pattern matching:

```java
if (contenido instanceof JSONObject objeto) {

    System.out.println(
        objeto.toString(4)
    );
}
```

Como nuestros proyectos utilizan **Java 21**, podemos emplear esta segunda forma.

---

### 17. Comprobar si es JSONArray

Podemos hacer:

```java
if (contenido instanceof JSONArray array) {

    System.out.println(
        array.toString(4)
    );
}
```

Por tanto:

```java
Object contenido =
        tokener.nextValue();

if (contenido instanceof JSONObject objeto) {

    // objeto JSON

} else if (contenido instanceof JSONArray array) {

    // array JSON

}
```

---

### 18. Ventaja de nextValue()

Con:

```java
nextValue()
```

podemos escribir código capaz de trabajar con distintas estructuras.

```text
              JSONTokener
                   │
                   │ nextValue()
                   ▼
                 Object
                /      \
               /        \
              ▼          ▼
       JSONObject     JSONArray
```

Esto es especialmente útil para comprender que un documento JSON no tiene por qué comenzar siempre con:

```text
{
```

También puede comenzar con:

```text
[
```

---

## BufferedReader

### 19. ¿Qué es BufferedReader?

Otra clase habitual para trabajar con ficheros de texto es:

```java
BufferedReader
```

Debemos importar:

```java
import java.io.BufferedReader;
```

Podemos combinarlo con `FileReader`:

```java
BufferedReader reader =
        new BufferedReader(
            new FileReader(
                "data/personas.json"
            )
        );
```

La estructura es:

```text
FICHERO
   ↓
FileReader
   ↓
BufferedReader
   ↓
JSONTokener
```

---

### 20. ¿Qué aporta BufferedReader?

`FileReader` proporciona acceso a los caracteres del fichero.

`BufferedReader` añade un búfer sobre otro `Reader`, permitiendo una lectura más eficiente y ofreciendo además métodos como:

```java
readLine()
```

En nuestro caso podemos entregar directamente el `BufferedReader` a:

```java
JSONTokener
```

porque `JSONTokener` puede trabajar con un `Reader`.

Por ejemplo:

```java
try (BufferedReader reader =
        new BufferedReader(
            new FileReader(
                "data/personas.json"
            )
        )) {

    JSONTokener tokener =
            new JSONTokener(reader);

    Object contenido =
            tokener.nextValue();
}
```

---

### 21. No necesitamos leer línea a línea

Podríamos pensar en hacer:

```java
reader.readLine()
```

repetidamente y reconstruir manualmente todo el texto JSON.

Pero si vamos a utilizar `JSONTokener`, no necesitamos hacerlo.

Podemos pasar directamente:

```java
reader
```

al constructor:

```java
new JSONTokener(reader)
```

y dejar que la librería procese el contenido.

!!! tip
    No debemos complicar innecesariamente la lectura reconstruyendo manualmente el documento JSON línea a línea si `JSONTokener` puede consumir directamente el `Reader`.

---

## Segundo ejemplo

### 22. LeerJSONv2.java

En nuestro segundo ejemplo queremos una lectura algo más flexible.

Utilizaremos:

```text
BufferedReader
      ↓
JSONTokener
      ↓
nextValue()
      ↓
Object
      ↓
¿JSONArray?
¿JSONObject?
```

De esta forma podremos comprobar cuál es la estructura principal.

---

### 23. Ejemplo de lectura flexible

```java
package com.example;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

public class LeerJSONv2 {

    public static void main(String[] args) {

        String ruta =
                "data/personas.json";

        try (BufferedReader reader =
                new BufferedReader(
                    new FileReader(ruta)
                )) {

            // =====================================
            // 1. CREAR JSONTOKENER
            // =====================================

            JSONTokener tokener =
                    new JSONTokener(reader);


            // =====================================
            // 2. LEER EL SIGUIENTE VALOR JSON
            // =====================================

            Object contenido =
                    tokener.nextValue();


            // =====================================
            // 3. COMPROBAR LA ESTRUCTURA
            // =====================================

            if (contenido
                    instanceof JSONArray personas) {

                procesarPersonas(personas);

            } else if (contenido
                    instanceof JSONObject persona) {

                procesarPersona(persona);

            } else {

                System.out.println(
                    "La estructura JSON "
                    + "no es la esperada."
                );
            }

        } catch (IOException e) {

            System.out.println(
                "Error al leer el fichero:"
            );

            System.out.println(
                e.getMessage()
            );

        } catch (JSONException e) {

            System.out.println(
                "Error al procesar el JSON:"
            );

            System.out.println(
                e.getMessage()
            );
        }
    }


    private static void procesarPersonas(
            JSONArray personas) {

        System.out.println(
            "Se ha leído un JSONArray."
        );

        System.out.println(
            "Número de personas: "
            + personas.length()
        );

        for (int i = 0;
             i < personas.length();
             i++) {

            JSONObject persona =
                    personas.getJSONObject(i);

            procesarPersona(persona);
        }
    }


    private static void procesarPersona(
            JSONObject persona) {

        int id =
                persona.optInt(
                    "id",
                    -1
                );

        String nombre =
                persona.optString(
                    "nombre",
                    "Sin nombre"
                );

        int edad =
                persona.optInt(
                    "edad",
                    0
                );

        System.out.println(
            "ID: " + id
            + " | Nombre: " + nombre
            + " | Edad: " + edad
        );
    }
}
```

---

## get frente a opt al leer ficheros

### 24. Datos obligatorios

Si sabemos que una propiedad debe existir podemos utilizar:

```java
getString()
getInt()
getDouble()
getBoolean()
```

Por ejemplo:

```java
String nombre =
        persona.getString("nombre");
```

Si `"nombre"` es obligatorio, que no exista puede indicar que el fichero no tiene la estructura que esperaba nuestro programa.

---

### 25. Datos opcionales

Si una propiedad puede faltar, podemos utilizar:

```java
optString()
optInt()
optDouble()
optBoolean()
```

Por ejemplo:

```java
String email =
        persona.optString(
            "email",
            "No indicado"
        );
```

Esto permite definir un valor alternativo.

---

### 26. Ejemplo combinando datos obligatorios y opcionales

Supongamos que tenemos:

```json
{
    "id": 1,
    "nombre": "Ana",
    "email": "ana@email.com"
}
```

Podemos decidir que:

```text
id      → obligatorio
nombre  → obligatorio
email   → opcional
```

Entonces:

```java
int id =
        persona.getInt("id");

String nombre =
        persona.getString("nombre");

String email =
        persona.optString(
            "email",
            "No indicado"
        );
```

!!! important "get u opt es una decisión de diseño"
    No debemos utilizar `opt...()` simplemente para ocultar cualquier error.

    Primero debemos decidir qué datos son obligatorios y cuáles pueden faltar.

---

## JSON anidado leído desde fichero

### 27. Leer estructuras anidadas

Todo lo estudiado sobre `JSONObject` y `JSONArray` continúa siendo válido después de leer el fichero.

Supongamos:

```json
{
    "id": 1,
    "nombre": "Ana",
    "direccion": {
        "ciudad": "Alcalá de Henares",
        "codigoPostal": "28801"
    },
    "modulos": [
        "Acceso a Datos",
        "Desarrollo de Interfaces"
    ]
}
```

Después de construir:

```java
JSONObject alumno =
        new JSONObject(tokener);
```

podemos obtener el objeto anidado:

```java
JSONObject direccion =
        alumno.getJSONObject(
            "direccion"
        );
```

y:

```java
String ciudad =
        direccion.getString(
            "ciudad"
        );
```

---

### 28. Recuperar un JSONArray anidado

Podemos obtener:

```java
JSONArray modulos =
        alumno.getJSONArray(
            "modulos"
        );
```

y recorrerlo:

```java
for (int i = 0;
     i < modulos.length();
     i++) {

    System.out.println(
        modulos.getString(i)
    );
}
```

Por tanto:

```text
FICHERO
   ↓
JSONObject alumno
   │
   ├── id
   ├── nombre
   │
   ├── direccion
   │       ↓
   │   JSONObject
   │
   └── modulos
           ↓
       JSONArray
```

---

## Guardar y leer: visión conjunta

### 29. El ciclo completo

Ahora podemos ver conjuntamente las dos operaciones.

#### Escritura

```text
DATOS
  ↓
JSONObject / JSONArray
  ↓
toString(4)
  ↓
FileWriter
  ↓
FICHERO
```

#### Lectura

```text
FICHERO
  ↓
FileReader / BufferedReader
  ↓
JSONTokener
  ↓
JSONObject / JSONArray
  ↓
get...() / opt...()
  ↓
DATOS
```

---

### 30. Esquema completo

```text
             ESCRITURA

     DATOS DEL PROGRAMA
              │
              ▼
    JSONObject / JSONArray
              │
              │ toString(4)
              ▼
          FileWriter
              │
              ▼
        ┌───────────┐
        │ FICHERO   │
        │   JSON    │
        └───────────┘
              │
              ▼
     FileReader /
     BufferedReader
              │
              ▼
         JSONTokener
              │
              ▼
    JSONObject / JSONArray
              │
              │ get / opt
              ▼
     DATOS DEL PROGRAMA

              LECTURA
```

---

## Errores frecuentes

### 31. Pensar que FileReader interpreta JSON

Incorrecto conceptualmente:

```text
FileReader → entiende claves y valores JSON
```

La idea correcta es:

```text
FileReader
    ↓
lee caracteres

JSONTokener
    ↓
interpreta JSON
```

---

### 32. Crear JSONObject cuando el fichero contiene un array

Si el documento comienza conceptualmente con:

```json
[
```

su estructura principal es un:

```java
JSONArray
```

No debemos tratarlo como si fuese:

```java
JSONObject
```

---

### 33. Crear JSONArray cuando el fichero contiene un objeto

Si tenemos:

```json
{
    "nombre": "Ana"
}
```

la estructura principal es:

```java
JSONObject
```

No:

```java
JSONArray
```

---

### 34. Confundir getJSONObject() con getJSONArray()

Si tenemos:

```json
{
    "direccion": {
        "ciudad": "Alcalá de Henares"
    },
    "modulos": [
        "AD",
        "DI"
    ]
}
```

debemos utilizar:

```java
getJSONObject("direccion")
```

porque:

```text
direccion → { }
```

y:

```java
getJSONArray("modulos")
```

porque:

```text
modulos → [ ]
```

---

### 35. Utilizar un índice que no existe

Si:

```java
personas.length()
```

devuelve:

```text
3
```

los índices válidos son:

```text
0
1
2
```

No existe:

```text
3
```

El recorrido correcto será:

```java
for (int i = 0;
     i < personas.length();
     i++) {
```

y no:

```java
i <= personas.length()
```

---

### 36. Suponer que todos los datos existen

Cuando los documentos JSON proceden de fuentes externas, pueden faltar propiedades.

Por ejemplo:

```json
{
    "id": 1,
    "nombre": "Ana"
}
```

puede no tener:

```text
email
```

Si es opcional, podemos utilizar:

```java
optString(
    "email",
    "No indicado"
);
```

---

## Métodos principales

### 37. Resumen de clases y métodos

| Elemento | Función |
|---|---|
| `FileReader` | Leer caracteres de un fichero |
| `BufferedReader` | Añadir lectura con búfer sobre otro `Reader` |
| `JSONTokener` | Analizar una secuencia que contiene JSON |
| `nextValue()` | Obtener el siguiente valor JSON |
| `JSONObject` | Representar un objeto JSON |
| `JSONArray` | Representar un array JSON |
| `getJSONObject()` | Obtener un objeto anidado |
| `getJSONArray()` | Obtener un array anidado |
| `get...()` | Obtener datos esperados |
| `opt...()` | Obtener datos permitiendo ausencia o valor alternativo |
| `length()` | Obtener número de elementos de un array |
| `instanceof` | Comprobar el tipo de estructura obtenida |

---

## Los ejemplos del proyecto

### 38. LeerJSONv1.java

Este ejemplo representa el caso más directo:

```text
persona.json
     ↓
FileReader
     ↓
JSONTokener
     ↓
JSONObject
     ↓
get...()
```

Es adecuado cuando conocemos de antemano que la raíz del documento es un objeto.

---

### 39. LeerJSONv2.java

Este ejemplo amplía el anterior:

```text
personas.json
      ↓
BufferedReader
      ↓
JSONTokener
      ↓
nextValue()
      ↓
Object
     / \
    /   \
   ▼     ▼
JSONObject JSONArray
```

Nos permite comprobar la estructura antes de procesarla.

---

### 40. Ejemplos incluidos en el proyecto

Los ejemplos correspondientes a la lectura de JSON están incluidos en el proyecto Maven descargable de `org.json`:

| Ejemplo | Contenido que practica |
|---|---|
| `LeerJSONv1.java` | Lectura de `data/persona.json` utilizando `FileReader`, `JSONTokener` y `JSONObject` |
| `LeerJSONv2.java` | Lectura de `data/personas.json` utilizando `BufferedReader`, `JSONTokener`, `nextValue()` y comprobación de `JSONObject`/`JSONArray` |

!!! tip "Proyecto de ejemplos"
    Estos ejemplos forman parte del **proyecto Maven común de `org.json`**.

    Para probar correctamente la lectura conviene ejecutar previamente los ejemplos de escritura:

    ```text
    GuardarJSONv1.java → genera persona.json
    GuardarJSONv2.java → genera personas.json
    ```

    El proyecto completo está disponible desde la página de **Introducción a org.json**.

---

## Resumen final

### 41. ¿Qué debemos recordar?

#### Para guardar

```text
JSONObject / JSONArray
        ↓
    toString(4)
        ↓
    FileWriter
        ↓
      fichero
```

#### Para leer

```text
      fichero
        ↓
FileReader / BufferedReader
        ↓
    JSONTokener
        ↓
JSONObject / JSONArray
        ↓
   get...() / opt...()
```

#### Si no conocemos la estructura raíz

```text
JSONTokener
     ↓
 nextValue()
     ↓
   Object
   /    \
  ▼      ▼
JSONObject JSONArray
```

!!! success "Objetivo alcanzado"
    Ya sabemos realizar el ciclo completo de persistencia utilizando `org.json`:

    **crear → guardar → leer → recuperar datos**.

    Con esto tenemos las bases necesarias para trabajar con documentos JSON completos desde Java.