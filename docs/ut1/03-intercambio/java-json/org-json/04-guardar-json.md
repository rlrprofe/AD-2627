# Guardar JSON en un fichero

### 1. Introducción

Hasta ahora hemos aprendido a construir estructuras JSON en memoria utilizando las clases:

```java
JSONObject
JSONArray
```

Por ejemplo:

```java
JSONObject alumno = new JSONObject();

alumno.put("id", 1);
alumno.put("nombre", "Ana");
alumno.put("nota", 8.5);
```

Mientras el programa se está ejecutando, el objeto existe en memoria.

Podemos mostrarlo por consola:

```java
System.out.println(alumno.toString(4));
```

pero cuando termina el programa esa información desaparece.

Si queremos conservarla, debemos almacenarla en algún sistema de persistencia.

Una posibilidad es guardarla en un **fichero JSON**.

Por ejemplo:

```text
data/alumno.json
```

con el siguiente contenido:

```json
{
    "id": 1,
    "nombre": "Ana",
    "nota": 8.5
}
```

!!! info "Persistencia"
    Guardar información en un fichero permite que los datos permanezcan almacenados aunque el programa finalice.

    Posteriormente podremos volver a leer el fichero y reconstruir la estructura JSON.

---

### 2. Proceso general para guardar JSON

Con `org.json`, guardar información en un fichero puede entenderse como un proceso de varias etapas:

```text
DATOS
  │
  ▼
JSONObject / JSONArray
  │
  │ put(...)
  ▼
Estructura JSON en memoria
  │
  │ toString(4)
  ▼
Texto JSON
  │
  │ FileWriter
  ▼
FICHERO .json
```

Los pasos principales serán:

```text
1. Crear JSONObject o JSONArray
             ↓
2. Añadir los datos con put()
             ↓
3. Preparar el directorio y el fichero
             ↓
4. Abrir FileWriter
             ↓
5. Convertir el JSON a texto
             ↓
6. Escribir el contenido
             ↓
7. Cerrar el fichero
```

En Java veremos normalmente algo parecido a:

```java
JSONObject objeto = new JSONObject();

objeto.put("nombre", "Ana");
objeto.put("edad", 21);

try (FileWriter writer =
        new FileWriter("data/persona.json")) {

    writer.write(objeto.toString(4));
}
```

---

## De JSONObject a texto

### 3. ¿Qué guarda realmente FileWriter?

Una cuestión importante es distinguir entre:

```text
JSONObject
```

y:

```text
fichero JSON
```

`JSONObject` es un **objeto Java que está en memoria**.

Por ejemplo:

```java
JSONObject alumno = new JSONObject();

alumno.put("nombre", "Ana");
alumno.put("edad", 21);
```

Antes de escribirlo en un fichero necesitamos obtener su representación textual.

Para ello utilizamos:

```java
toString()
```

o:

```java
toString(4)
```

Por ejemplo:

```java
String textoJSON =
        alumno.toString(4);
```

Ahora `textoJSON` contiene un `String` similar a:

```json
{
    "nombre": "Ana",
    "edad": 21
}
```

Por tanto:

```text
JSONObject
     │
     │ toString(4)
     ▼
   String
     │
     │ FileWriter
     ▼
 fichero JSON
```

!!! important "FileWriter escribe texto"
    `FileWriter` no conoce la clase `JSONObject`.

    Lo que escribimos realmente en el fichero es la **representación textual del JSON** obtenida mediante `toString()`.

---

### 4. `toString()` frente a `toString(4)`

Podemos convertir un objeto JSON a texto de dos formas habituales.

#### Sin formato

```java
objeto.toString()
```

produce:

```json
{"nombre":"Ana","edad":21,"nota":8.5}
```

#### Con indentación

```java
objeto.toString(4)
```

produce:

```json
{
    "nombre": "Ana",
    "edad": 21,
    "nota": 8.5
}
```

El número:

```text
4
```

indica el número de espacios utilizados para la indentación.

Para nuestros ejemplos utilizaremos:

```java
toString(4)
```

porque facilita mucho la lectura del fichero.

!!! tip "JSON legible"
    Para una aplicación, ambas representaciones contienen esencialmente la misma estructura de datos.

    Durante el aprendizaje utilizaremos la versión indentada porque resulta mucho más fácil comprobar el fichero manualmente.

---

## FileWriter

### 5. Escribir un fichero con FileWriter

Para escribir texto en un fichero podemos utilizar:

```java
FileWriter
```

Debemos importar:

```java
import java.io.FileWriter;
```

Un ejemplo sencillo sería:

```java
FileWriter writer =
        new FileWriter("data/persona.json");

writer.write(
        objeto.toString(4)
);

writer.close();
```

El proceso es:

```text
new FileWriter(...)
       │
       ▼
abrimos el fichero
       │
       ▼
writer.write(...)
       │
       ▼
escribimos
       │
       ▼
writer.close()
       │
       ▼
cerramos el recurso
```

---

### 6. ¿Por qué debemos cerrar el fichero?

Cuando abrimos un fichero estamos utilizando un recurso del sistema.

Después de escribir debemos cerrarlo:

```java
writer.close();
```

Si no lo hacemos correctamente pueden producirse problemas, por ejemplo:

- recursos que permanecen abiertos;
- información pendiente de escribir;
- problemas al intentar acceder posteriormente al fichero.

Java proporciona una forma especialmente cómoda de gestionar estos recursos:

```text
try-with-resources
```

---

## try-with-resources

### 7. Escritura recomendada

En lugar de escribir:

```java
FileWriter writer =
        new FileWriter("data/persona.json");

writer.write(objeto.toString(4));

writer.close();
```

podemos utilizar:

```java
try (FileWriter writer =
        new FileWriter("data/persona.json")) {

    writer.write(
        objeto.toString(4)
    );
}
```

Esta construcción se denomina:

```text
try-with-resources
```

La ventaja principal es que Java se encarga de cerrar automáticamente el recurso cuando termina el bloque.

```text
try (
    abrir recurso
) {

    utilizar recurso

}

↓ automáticamente

cerrar recurso
```

!!! tip "Forma recomendada"
    En nuestros ejemplos utilizaremos preferentemente `try-with-resources`.

    De esta forma evitamos olvidar el cierre del fichero.

---

### 8. IOException

Las operaciones con ficheros pueden producir errores.

Por ejemplo:

- la ruta puede no existir;
- podemos no tener permisos;
- puede producirse un error durante la escritura.

Por este motivo debemos gestionar:

```java
IOException
```

Importaremos:

```java
import java.io.IOException;
```

Por ejemplo:

```java
try (FileWriter writer =
        new FileWriter("data/persona.json")) {

    writer.write(
        objeto.toString(4)
    );

} catch (IOException e) {

    System.out.println(
        "Error al guardar el fichero"
    );
}
```

También podemos consultar información del error:

```java
System.out.println(e.getMessage());
```

---

## Directorio de datos

### 9. La carpeta `data`

En nuestros ejemplos almacenaremos los ficheros JSON dentro de una carpeta:

```text
data
```

La estructura del proyecto será similar a:

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
```

Así mantenemos separados:

```text
src  → código fuente Java

data → ficheros de datos
```

---

### 10. Rutas relativas

Cuando escribimos:

```java
new FileWriter("data/persona.json")
```

estamos utilizando una **ruta relativa**.

No estamos indicando algo como:

```text
C:\Users\Ana\Documents\...
```

sino una ruta relativa al directorio de trabajo desde el que se ejecuta el programa.

Esto hace que el proyecto sea más fácil de compartir.

Por ejemplo, evitaremos:

```java
new FileWriter(
    "C:\\Users\\usuario\\Documents\\persona.json"
);
```

porque esa ruta únicamente tendría sentido en un equipo concreto.

Preferiremos:

```java
new FileWriter(
    "data/persona.json"
);
```

!!! warning "Evita rutas absolutas"
    Si utilizamos una ruta absoluta vinculada a nuestro ordenador, el proyecto probablemente dejará de funcionar cuando otro alumno lo descargue.

---

## Crear el directorio automáticamente

### 11. ¿Qué ocurre si `data` no existe?

`FileWriter` puede crear el fichero:

```text
persona.json
```

pero necesita que el directorio en el que queremos guardarlo exista.

Por tanto, si:

```text
data/
```

no existe, debemos crearlo.

Una forma moderna de hacerlo es mediante:

```java
Files.createDirectories()
```

Necesitaremos:

```java
import java.nio.file.Files;
import java.nio.file.Path;
```

Podemos escribir:

```java
Path directorio = Path.of("data");

Files.createDirectories(directorio);
```

Si el directorio ya existe, podemos seguir trabajando con él.

Después:

```java
Path fichero =
        directorio.resolve("persona.json");
```

obtendremos una ruta equivalente a:

```text
data/persona.json
```

El proceso queda:

```text
Path.of("data")
       │
       ▼
directorio
       │
       │ Files.createDirectories()
       ▼
aseguramos que existe
       │
       │ resolve("persona.json")
       ▼
data/persona.json
```

---

## Primer caso: guardar un JSONObject

### 12. GuardarJSONv1.java

Nuestro primer ejemplo de escritura será:

```text
GuardarJSONv1.java
```

El objetivo es sencillo:

```text
crear una persona
        ↓
crear JSONObject
        ↓
añadir propiedades
        ↓
convertir a texto
        ↓
guardar persona.json
```

Queremos obtener un fichero similar a:

```json
{
    "nombre": "Ana",
    "edad": 21,
    "nota": 8.5,
    "repetidor": false
}
```

---

### 13. Paso 1: crear el JSONObject

Creamos el objeto:

```java
JSONObject persona =
        new JSONObject();
```

Añadimos sus propiedades:

```java
persona.put("nombre", "Ana");
persona.put("edad", 21);
persona.put("nota", 8.5);
persona.put("repetidor", false);
```

En memoria tenemos:

```text
JSONObject persona
│
├── nombre     → Ana
├── edad       → 21
├── nota       → 8.5
└── repetidor  → false
```

---

### 14. Paso 2: preparar la carpeta

Creamos la ruta:

```java
Path directorio =
        Path.of("data");
```

Nos aseguramos de que exista:

```java
Files.createDirectories(
        directorio
);
```

---

### 15. Paso 3: preparar la ruta del fichero

Podemos construir la ruta mediante:

```java
Path fichero =
        directorio.resolve(
            "persona.json"
        );
```

Ahora:

```text
directorio → data

fichero → data/persona.json
```

---

### 16. Paso 4: abrir FileWriter

Abrimos el fichero:

```java
try (FileWriter writer =
        new FileWriter(
            fichero.toFile()
        )) {

}
```

Dentro del bloque realizaremos la escritura.

---

### 17. Paso 5: escribir el JSON

Convertimos el objeto a texto:

```java
persona.toString(4)
```

y lo escribimos:

```java
writer.write(
        persona.toString(4)
);
```

El bloque completo queda:

```java
try (FileWriter writer =
        new FileWriter(
            fichero.toFile()
        )) {

    writer.write(
        persona.toString(4)
    );
}
```

---

### 18. Resultado

Después de ejecutar el programa tendremos:

```text
data/
└── persona.json
```

con un contenido similar a:

```json
{
    "nombre": "Ana",
    "edad": 21,
    "nota": 8.5,
    "repetidor": false
}
```

!!! note "Orden de las propiedades"
    No debemos basar la lógica del programa en que las propiedades de un objeto JSON aparezcan siempre visualmente en el mismo orden.

    Lo importante son las claves y sus valores.

---

### 19. Ejemplo completo: GuardarJSONv1.java

```java
package com.example;

import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import org.json.JSONObject;

public class GuardarJSONv1 {

    public static void main(String[] args) {

        // ==========================================
        // 1. CREAR EL OBJETO JSON
        // ==========================================

        JSONObject persona =
                new JSONObject();

        persona.put("nombre", "Ana");
        persona.put("edad", 21);
        persona.put("nota", 8.5);
        persona.put("repetidor", false);


        // ==========================================
        // 2. MOSTRAR POR CONSOLA
        // ==========================================

        System.out.println(
            "JSON que vamos a guardar:"
        );

        System.out.println(
            persona.toString(4)
        );


        // ==========================================
        // 3. PREPARAR DIRECTORIO Y FICHERO
        // ==========================================

        Path directorio =
                Path.of("data");

        Path fichero =
                directorio.resolve(
                    "persona.json"
                );


        // ==========================================
        // 4. GUARDAR EL JSON
        // ==========================================

        try {

            Files.createDirectories(
                directorio
            );

            try (FileWriter writer =
                    new FileWriter(
                        fichero.toFile()
                    )) {

                writer.write(
                    persona.toString(4)
                );
            }

            System.out.println(
                "\nFichero guardado en:"
            );

            System.out.println(
                fichero.toAbsolutePath()
            );

        } catch (IOException e) {

            System.out.println(
                "Error al guardar el fichero:"
            );

            System.out.println(
                e.getMessage()
            );
        }
    }
}
```

---

## Segundo caso: guardar un JSONArray

### 20. GuardarJSONv2.java

Ahora vamos a guardar una estructura más completa.

En lugar de almacenar una sola persona queremos almacenar **varias personas**.

El JSON tendrá esta forma:

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

La estructura principal ya no es:

```text
JSONObject
```

sino:

```text
JSONArray
```

---

### 21. Paso 1: crear los objetos

Creamos la primera persona:

```java
JSONObject persona1 =
        new JSONObject();

persona1.put("id", 1);
persona1.put("nombre", "Ana");
persona1.put("edad", 21);
```

La segunda:

```java
JSONObject persona2 =
        new JSONObject();

persona2.put("id", 2);
persona2.put("nombre", "Luis");
persona2.put("edad", 23);
```

La tercera:

```java
JSONObject persona3 =
        new JSONObject();

persona3.put("id", 3);
persona3.put("nombre", "Marta");
persona3.put("edad", 20);
```

---

### 22. Paso 2: crear el JSONArray

Creamos:

```java
JSONArray personas =
        new JSONArray();
```

Añadimos los objetos:

```java
personas.put(persona1);
personas.put(persona2);
personas.put(persona3);
```

Tenemos:

```text
JSONArray personas
│
├── [0] JSONObject persona1
├── [1] JSONObject persona2
└── [2] JSONObject persona3
```

---

### 23. Paso 3: convertir el JSONArray a texto

Exactamente igual que con `JSONObject`, podemos utilizar:

```java
personas.toString(4)
```

Por tanto:

```java
String json =
        personas.toString(4);
```

contendrá una representación textual del array JSON.

---

### 24. Paso 4: guardar el fichero

Queremos obtener:

```text
data/personas.json
```

Creamos la ruta:

```java
Path directorio =
        Path.of("data");

Path fichero =
        directorio.resolve(
            "personas.json"
        );
```

Y escribimos:

```java
try (FileWriter writer =
        new FileWriter(
            fichero.toFile()
        )) {

    writer.write(
        personas.toString(4)
    );
}
```

---

### 25. Ejemplo completo: GuardarJSONv2.java

```java
package com.example;

import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import org.json.JSONArray;
import org.json.JSONObject;

public class GuardarJSONv2 {

    public static void main(String[] args) {

        // ==========================================
        // 1. CREAR LAS PERSONAS
        // ==========================================

        JSONObject persona1 =
                new JSONObject();

        persona1.put("id", 1);
        persona1.put("nombre", "Ana");
        persona1.put("edad", 21);


        JSONObject persona2 =
                new JSONObject();

        persona2.put("id", 2);
        persona2.put("nombre", "Luis");
        persona2.put("edad", 23);


        JSONObject persona3 =
                new JSONObject();

        persona3.put("id", 3);
        persona3.put("nombre", "Marta");
        persona3.put("edad", 20);


        // ==========================================
        // 2. CREAR EL ARRAY
        // ==========================================

        JSONArray personas =
                new JSONArray();

        personas.put(persona1);
        personas.put(persona2);
        personas.put(persona3);


        // ==========================================
        // 3. MOSTRAR POR CONSOLA
        // ==========================================

        System.out.println(
            "JSON que vamos a guardar:"
        );

        System.out.println(
            personas.toString(4)
        );


        // ==========================================
        // 4. PREPARAR RUTAS
        // ==========================================

        Path directorio =
                Path.of("data");

        Path fichero =
                directorio.resolve(
                    "personas.json"
                );


        // ==========================================
        // 5. GUARDAR EL JSON
        // ==========================================

        try {

            Files.createDirectories(
                directorio
            );

            try (FileWriter writer =
                    new FileWriter(
                        fichero.toFile()
                    )) {

                writer.write(
                    personas.toString(4)
                );
            }

            System.out.println(
                "\nFichero guardado en:"
            );

            System.out.println(
                fichero.toAbsolutePath()
            );

        } catch (IOException e) {

            System.out.println(
                "Error al guardar el fichero:"
            );

            System.out.println(
                e.getMessage()
            );
        }
    }
}
```

---

## Comparación de los dos ejemplos

### 26. GuardarJSONv1 frente a GuardarJSONv2

Los dos ejemplos realizan prácticamente el mismo proceso.

La diferencia principal está en la estructura JSON que queremos almacenar.

| Ejemplo | Estructura principal | Fichero |
|---|---|---|
| `GuardarJSONv1.java` | `JSONObject` | `persona.json` |
| `GuardarJSONv2.java` | `JSONArray` de objetos | `personas.json` |

#### Versión 1

```text
JSONObject
     │
     │ toString(4)
     ▼
FileWriter
     │
     ▼
persona.json
```

#### Versión 2

```text
JSONObject ─┐
JSONObject ─┼──► JSONArray
JSONObject ─┘         │
                      │ toString(4)
                      ▼
                  FileWriter
                      │
                      ▼
                personas.json
```

!!! important "El mecanismo de escritura no cambia"
    `FileWriter` no necesita saber si originalmente trabajábamos con un `JSONObject` o un `JSONArray`.

    En ambos casos escribimos finalmente un texto:

    ```java
    estructuraJSON.toString(4)
    ```

---

## Sobrescribir y añadir

### 27. ¿Qué ocurre si el fichero ya existe?

Cuando utilizamos:

```java
new FileWriter("data/persona.json")
```

si el fichero ya existe, su contenido se **sobrescribe**.

Esto suele ser precisamente lo que queremos cuando guardamos un documento JSON completo.

Por ejemplo:

```text
ejecución 1
    ↓
persona.json
    ↓
Ana


ejecución 2
    ↓
persona.json
    ↓
Luis
```

La segunda escritura sustituirá el contenido anterior.

---

### 28. ¿Podemos añadir contenido al final?

`FileWriter` permite abrir un fichero en modo append:

```java
new FileWriter(
    "data/persona.json",
    true
);
```

El parámetro:

```java
true
```

indica que el nuevo contenido se añadirá al final.

Sin embargo, debemos tener cuidado cuando trabajamos con JSON.

Por ejemplo, si tenemos:

```json
{
    "nombre": "Ana"
}
```

y simplemente añadimos:

```json
{
    "nombre": "Luis"
}
```

obtendríamos:

```text
{
    "nombre": "Ana"
}
{
    "nombre": "Luis"
}
```

Esto **no representa un único documento JSON válido**.

!!! warning "No uses append sin pensar en la estructura"
    Para almacenar varios objetos en un único documento JSON, normalmente construiremos una estructura válida, por ejemplo un `JSONArray`, y guardaremos el documento completo.

Por ejemplo:

```json
[
    {
        "nombre": "Ana"
    },
    {
        "nombre": "Luis"
    }
]
```

---

## Errores frecuentes

### 29. Intentar escribir directamente un JSONObject

Debemos recordar el proceso:

```text
JSONObject
    ↓
toString()
    ↓
String
    ↓
FileWriter
```

Por claridad utilizaremos:

```java
writer.write(
    objeto.toString(4)
);
```

---

### 30. La carpeta no existe

Si intentamos escribir:

```java
new FileWriter(
    "data/persona.json"
);
```

pero:

```text
data/
```

no existe, la escritura puede fallar.

Por eso podemos crear previamente el directorio:

```java
Files.createDirectories(
    Path.of("data")
);
```

---

### 31. Utilizar una ruta absoluta

Evita:

```java
"C:\\Users\\usuario\\Desktop\\persona.json"
```

porque esa ruta depende de un ordenador concreto.

Preferiremos:

```java
"data/persona.json"
```

---

### 32. Olvidar cerrar FileWriter

Si hacemos:

```java
FileWriter writer =
        new FileWriter(...);
```

debemos asegurarnos de cerrarlo.

La opción que utilizaremos será:

```java
try (FileWriter writer =
        new FileWriter(...)) {

    ...
}
```

Así Java gestiona automáticamente el cierre.

---

### 33. Confundir crear JSON con guardar JSON

Estas instrucciones:

```java
JSONObject alumno =
        new JSONObject();

alumno.put("nombre", "Ana");
```

**no crean todavía ningún fichero**.

Solo crean una estructura en memoria.

Necesitamos después:

```java
FileWriter
```

para almacenarla.

```text
new JSONObject()
      ↓
JSON EN MEMORIA

FileWriter
      ↓
JSON EN DISCO
```

---

### 34. Guardar varios objetos uno detrás de otro

No debemos escribir varios objetos independientes consecutivamente pensando que automáticamente se convertirán en un array.

Si necesitamos almacenar varios elementos:

```text
persona1
persona2
persona3
```

primero construiremos:

```java
JSONArray personas =
        new JSONArray();

personas.put(persona1);
personas.put(persona2);
personas.put(persona3);
```

y después:

```java
writer.write(
    personas.toString(4)
);
```

---

## Resumen

### 35. Flujo completo de escritura

El proceso que debemos recordar es:

```text
DATOS JAVA
    │
    ▼
JSONObject / JSONArray
    │
    │ put(...)
    ▼
ESTRUCTURA JSON
    │
    │ toString(4)
    ▼
STRING
    │
    │ FileWriter.write(...)
    ▼
FICHERO .json
```

---

### 36. Elementos principales utilizados

| Elemento | Función |
|---|---|
| `JSONObject` | Representar un objeto JSON |
| `JSONArray` | Representar un array JSON |
| `put()` | Añadir información |
| `toString()` | Convertir la estructura JSON a texto |
| `toString(4)` | Convertir a texto con indentación |
| `Path` | Representar una ruta |
| `Files.createDirectories()` | Crear el directorio si no existe |
| `FileWriter` | Escribir texto en el fichero |
| `try-with-resources` | Cerrar automáticamente el recurso |
| `IOException` | Gestionar errores de entrada/salida |

---

### 37. Los dos ejemplos que debemos comprender

#### GuardarJSONv1.java

```text
JSONObject
     │
     ▼
put()
     │
     ▼
toString(4)
     │
     ▼
FileWriter
     │
     ▼
persona.json
```

#### GuardarJSONv2.java

```text
JSONObject
JSONObject
JSONObject
     │
     ▼
 JSONArray
     │
     ▼
toString(4)
     │
     ▼
FileWriter
     │
     ▼
personas.json
```

---

### 38. Ejemplos incluidos en el proyecto

Los ejemplos correspondientes a este apartado están incluidos en el proyecto Maven descargable de `org.json`:

- `GuardarJSONv1.java` → crea y guarda un `JSONObject` en `data/persona.json`.
- `GuardarJSONv2.java` → crea y guarda un `JSONArray` de objetos en `data/personas.json`.

Puedes descargar el proyecto Maven completo desde la página de **Introducción a org.json**.

!!! tip "Proyecto de ejemplos"
    El proyecto descargable es común a todos los apartados de `org.json`.  
    A medida que avancemos iremos utilizando distintos ejemplos del mismo proyecto.

### 39. ¿Qué ocurre después?

Ya sabemos realizar el recorrido:

```text
JAVA
  ↓
JSONObject / JSONArray
  ↓
JSON
  ↓
FICHERO
```

El siguiente paso será realizar el proceso contrario:

```text
FICHERO
   ↓
leer contenido
   ↓
JSONTokener
   ↓
JSONObject / JSONArray
   ↓
get...() / opt...()
   ↓
DATOS
```

Para ello estudiaremos la clase:

```java
JSONTokener
```

y veremos cómo funcionan los ejemplos:

```text
LeerJSONv1.java
LeerJSONv2.java
```

!!! success "Objetivo alcanzado"
    Llegados a este punto ya sabemos **construir estructuras JSON y almacenarlas de forma persistente en ficheros**.

    En el siguiente apartado aprenderemos a recuperar esos datos.