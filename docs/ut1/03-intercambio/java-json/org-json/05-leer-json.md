# Leer JSON desde un fichero

!!! note "Ejemplos y proyecto descargable (Java 21)"
    Los fragmentos de esta página ilustran conceptos. La versión **completa y ejecutable** utiliza paquetes separados (`com.example.examples`, `model`, `repository` y, cuando corresponde, `config`/`adapter`). Consulta el [orden didáctico y la estructura del proyecto](index.md#guia-del-proyecto-maven-actualizado-java-21) y el [ZIP actualizado](../../../../descargas/ut1/java-json/org-json-ejemplos.zip).

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
/* Lectura */
package com.example.examples;



import java.io.BufferedReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.charset.StandardCharsets;
import org.json.JSONException;
import java.io.IOException;
import org.json.JSONObject;
import org.json.JSONTokener;

public class LeerJSONv1 {
    public static void main(String[] args) {
        // Ruta del fichero 
        String ruta = "data/persona.json";

        try (BufferedReader reader = Files.newBufferedReader(Path.of(ruta), StandardCharsets.UTF_8)) {
            // JSONTokener convierte el flujo de caracteres en datos JSON
            JSONTokener tokener = new JSONTokener(reader);

            // Creamos el objeto JSONObject a partir del fichero
            JSONObject obj = new JSONObject(tokener);

            // Accedemos a las claves
            String nombre = obj.getString("nombre");
            int edad = obj.getInt("edad");

            // Mostrar por consola
            System.out.println("Contenido del JSON:");
            System.out.println("Nombre: " + nombre);
            System.out.println("Edad: " + edad);

        } catch (JSONException e) {
            System.err.println("JSON no válido: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("Error al leer el fichero JSON: " + e.getMessage());
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
/*Lee un JSONArray de personas*/
package com.example.examples;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

public class LeerJSONv2 {

    // Ruta del fichero JSON 
    private static final Path RUTA_JSON = Path.of("data/personas.json");

    public static void main(String[] args) {
        // 1) Comprobaciones previas: existencia y tamaño > 0
        if (!Files.exists(RUTA_JSON)) {
            System.err.println("No existe el fichero: " + RUTA_JSON.toAbsolutePath());
            return;
        }
        try {
            if (Files.size(RUTA_JSON) == 0) {
                System.err.println("El fichero está vacío: " + RUTA_JSON.toAbsolutePath());
                return;
            }
        } catch (IOException e) {
            System.err.println("No se pudo comprobar el tamaño del fichero: " + e.getMessage());
            return;
        }

        // 2) Lectura con BufferedReader y UTF-8 (buena práctica)
        try (BufferedReader br = Files.newBufferedReader(RUTA_JSON, StandardCharsets.UTF_8)) {
            // 3) El tokener interpretará el flujo de texto como JSON
            JSONTokener tokener = new JSONTokener(br);
            /*
            * JSONTokener es una clase de la librería org.json.
            * Su función es leer un flujo de texto carácter a carácter y convertirlo 
            * en tokens JSON (objetos, arrays, claves, valores…).
            */


            // 4) La raíz puede ser un array de objetos o un objeto único
            Object raiz = tokener.nextValue();

            if (raiz instanceof JSONArray) {
                procesarArray((JSONArray) raiz);
            } else if (raiz instanceof JSONObject) {
                procesarObjetoUnico((JSONObject) raiz);
            } else {
                System.err.println("El contenido del JSON no es un objeto ni un array válido.");
            }

        } catch (IOException e) {
            System.err.println("Error de lectura: " + e.getMessage());
        } catch (JSONException e) {
            System.err.println("El contenido no es un JSON válido: " + e.getMessage());
        }
    }

    /**
     * Procesa un array JSON con forma:
     * [
     *   {"nombre":"Ana","edad":25},
     *   {"nombre":"Luis","edad":30}
     * ]
     */
    private static void procesarArray(JSONArray array) {
        if (array.isEmpty()) {
            System.out.println("El fichero JSON contiene un array vacío.");
            return;
        }

        int totalValidas = 0;
        int sumaEdades = 0;

        System.out.println("Listado de personas leídas de " + RUTA_JSON.toAbsolutePath() + ":");

        // Bucle básico sin 'continue': se resuelve cada caso en un if/else
        for (int i = 0, n = array.length(); i < n; i++) {
            Object entrada = array.get(i);

            // Validar que cada elemento sea un objeto JSON
            if (!(entrada instanceof JSONObject)) {
                System.out.println(" - Entrada " + i + " ignorada: no es un objeto JSON.");
            } else {
                JSONObject persona = (JSONObject) entrada;

                // Extracción segura de campos
                String nombre = persona.optString("nombre", null);

                // Edad: validar existencia y tipo entero
                Integer edad = null;
                if (persona.has("edad")) {
                    try {
                        edad = persona.getInt("edad");
                    } catch (JSONException e) {
                        edad = null; // la clave existe pero no es un entero válido
                    }
                }

                // Reglas mínimas de validación
                boolean nombreValido = (nombre != null && !nombre.isBlank());
                boolean edadValida = (edad != null && edad >= 0);

                if (!nombreValido || !edadValida) {
                    System.out.println(" - Entrada " + i + " inválida o incompleta: " + persona);
                } else {
                    // Caso válido: mostrar y acumular
                    System.out.println(" - " + nombre + " (" + edad + " años)");
                    totalValidas++;
                    sumaEdades += edad;
                }
            }
        }

        // Resumen final
        if (totalValidas == 0) {
            System.out.println("No se encontraron personas válidas en el fichero.");
        } else {
            double media = (double) sumaEdades / totalValidas;
            System.out.printf("Total: %d  |  Edad media: %.2f%n", totalValidas, media);
        }
    }

    /**
     * Procesa el caso alternativo con un único objeto JSON:
     * {"nombre":"Ana","edad":25}
     */
    private static void procesarObjetoUnico(JSONObject obj) {
        String nombre = obj.optString("nombre", null);

        Integer edad = null;
        if (obj.has("edad")) {
            try {
                edad = obj.getInt("edad");
            } catch (JSONException e) {
                edad = null;
            }
        }

        boolean nombreValido = (nombre != null && !nombre.isBlank());
        boolean edadValida = (edad != null && edad >= 0);

        if (!nombreValido || !edadValida) {
            System.out.println("Objeto único inválido o incompleto: " + obj);
        } else {
            System.out.println("Se encontró un único objeto:");
            System.out.println(" - " + nombre + " (" + edad + " años)");
        }
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