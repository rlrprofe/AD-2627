# Guardar y leer JSON en ficheros

### 1. De la memoria al fichero

Hasta ahora hemos trabajado principalmente con datos que permanecían en memoria.

Por ejemplo:

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
String con JSON
```

Pero cuando finaliza el programa, esa variable desaparece.

Si queremos que los datos sean **persistentes**, debemos almacenarlos en algún soporte.

En este apartado utilizaremos un fichero:

```text
alumnos.json
```

!!! important "Persistencia"
    Guardar los datos en un fichero permite conservarlos aunque termine la ejecución del programa.

    Posteriormente podremos abrir el fichero y reconstruir nuestros objetos Java.

---

## El ciclo completo

### 2. Guardar y recuperar

Vamos a realizar dos procesos diferentes.

#### Guardar

```text
List<Alumno>
     │
     │ Gson
     ▼
alumnos.json
```

#### Leer

```text
alumnos.json
     │
     │ Gson
     ▼
List<Alumno>
```

Uniendo ambos:

```text
                  GUARDAR

List<Alumno> ───────────────► alumnos.json


                  LEER

List<Alumno> ◄─────────────── alumnos.json
```

---

## Primera parte: guardar

### 3. Qué necesitamos para guardar

Para guardar una lista utilizaremos:

```text
List<Alumno>
      +
Gson
      +
Writer
```

El flujo será:

```text
List<Alumno>
     │
     ▼
    Gson
     │
     │ toJson(lista, writer)
     ▼
   Writer
     │
     ▼
alumnos.json
```

---

### 4. Crear los datos

Partimos de una colección Java:

```java
List<Alumno> alumnos =
        new ArrayList<>();
```

Añadimos varios alumnos:

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

En memoria tenemos:

```text
List<Alumno>
   │
   ├── Ana
   ├── Luis
   └── Marta
```

---

## Preparar Gson

### 5. Utilizar GsonBuilder

Para generar un fichero fácil de leer podemos utilizar:

```java
Gson gson =
        new GsonBuilder()
            .setPrettyPrinting()
            .create();
```

Gracias a:

```java
setPrettyPrinting()
```

el fichero tendrá un formato similar a:

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

en lugar de:

```json
[{"id":1,"nombre":"Ana","nota":8.5},{"id":2,"nombre":"Luis","nota":7.2},{"id":3,"nombre":"Marta","nota":9.1}]
```

Los datos son equivalentes.

---

## El directorio data

### 6. Separar datos y código

Podemos organizar el proyecto así:

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
                    ├── Alumno.java
                    ├── DemoGson.java
                    ├── GuardarAlumnosGson.java
                    └── LeerAlumnosGson.java
```

Utilizaremos:

```text
data/
```

para los ficheros de datos.

Así mantenemos separados:

```text
src/     → código fuente

data/    → datos utilizados por el programa
```

---

### 7. Crear el directorio si no existe

Podemos utilizar:

```java
Path directorio =
        Path.of("data");

Files.createDirectories(
        directorio
);
```

Necesitamos:

```java
import java.nio.file.Files;
import java.nio.file.Path;
```

`createDirectories()` crea el directorio si es necesario.

Si ya existe, podemos continuar utilizando el mismo directorio.

---

## La ruta del fichero

### 8. Path

Podemos representar el fichero mediante:

```java
Path ruta =
        Path.of(
            "data",
            "alumnos.json"
        );
```

Conceptualmente:

```text
data
 └── alumnos.json
```

La ruta:

```java
Path.of(
    "data",
    "alumnos.json"
);
```

es una **ruta relativa**.

---

### 9. ¿Relativa a qué?

Una ruta como:

```text
data/alumnos.json
```

no comienza desde:

```text
C:\
```

ni desde:

```text
/
```

Se interpreta a partir del **directorio de trabajo del programa**.

En nuestro proyecto esperamos obtener:

```text
gson-ejemplos/
│
├── data/
│   └── alumnos.json
│
├── pom.xml
└── src/
```

!!! warning "Cuidado con las rutas relativas"
    Si ejecutamos el programa utilizando un directorio de trabajo diferente, una ruta relativa puede apuntar a otro lugar.

    Si no encontramos el fichero, una de las primeras cosas que debemos comprobar es **desde qué directorio estamos ejecutando el programa**.

---

## FileWriter

### 10. Abrir el fichero para escritura

Para escribir podemos utilizar:

```java
FileWriter
```

Necesitamos:

```java
import java.io.FileWriter;
```

Por ejemplo:

```java
FileWriter writer =
        new FileWriter(
            ruta.toFile()
        );
```

El `Writer` representa el destino donde queremos escribir.

---

## try-with-resources

### 11. Cerrar correctamente el fichero

En lugar de abrir y cerrar manualmente el `FileWriter`, utilizaremos:

```java
try-with-resources
```

Por ejemplo:

```java
try (FileWriter writer =
        new FileWriter(
            ruta.toFile()
        )) {

    // escribir

}
```

Al finalizar el bloque:

```java
try
```

Java se encarga de cerrar el recurso.

!!! tip "try-with-resources"
    Es la forma recomendada de trabajar con recursos que deben cerrarse, como ficheros, conexiones o flujos.

---

## toJson() y Writer

### 12. Escribir directamente el JSON

Hasta ahora habíamos utilizado:

```java
String json =
        gson.toJson(alumnos);
```

Pero Gson dispone también de una forma que permite enviar el JSON directamente a un `Writer`:

```java
gson.toJson(
    alumnos,
    writer
);
```

Observa la diferencia.

#### JSON en memoria

```java
String json =
        gson.toJson(alumnos);
```

```text
List<Alumno>
     │
     │ toJson()
     ▼
String JSON
```

#### JSON enviado a un Writer

```java
gson.toJson(
    alumnos,
    writer
);
```

```text
List<Alumno>
     │
     │ toJson()
     ▼
  Writer
     │
     ▼
 fichero
```

---

## GuardarAlumnosGson.java

### 13. Ejemplo completo de escritura

```java
package com.example;

import java.io.FileWriter;
import java.io.IOException;

import java.nio.file.Files;
import java.nio.file.Path;

import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class GuardarAlumnosGson {

    public static void main(String[] args) {

        // ==========================================
        // 1. CREAR LOS ALUMNOS
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
        // 3. PREPARAR RUTAS
        // ==========================================

        Path directorio =
                Path.of("data");

        Path ruta =
                directorio.resolve(
                    "alumnos.json"
                );


        // ==========================================
        // 4. CREAR DIRECTORIO
        // ==========================================

        try {

            Files.createDirectories(
                directorio
            );


            // ======================================
            // 5. ABRIR EL FICHERO
            // ======================================

            try (FileWriter writer =
                    new FileWriter(
                        ruta.toFile()
                    )) {


                // ==================================
                // 6. GUARDAR LA LISTA COMO JSON
                // ==================================

                gson.toJson(
                    alumnos,
                    writer
                );
            }


            // ======================================
            // 7. INFORMAR AL USUARIO
            // ======================================

            System.out.println(
                "Datos guardados en: "
                + ruta.toAbsolutePath()
            );

        } catch (IOException e) {

            System.err.println(
                "Error al guardar el fichero: "
                + e.getMessage()
            );
        }
    }
}
```

---

## Analizar GuardarAlumnosGson

### 14. Paso 1: tenemos objetos Java

```java
List<Alumno> alumnos
```

Tenemos una colección Java normal.

---

### 15. Paso 2: configuramos Gson

```java
Gson gson =
        new GsonBuilder()
            .setPrettyPrinting()
            .create();
```

Queremos generar un JSON legible.

---

### 16. Paso 3: definimos el fichero

```java
Path ruta =
        directorio.resolve(
            "alumnos.json"
        );
```

Nuestro destino será:

```text
data/alumnos.json
```

---

### 17. Paso 4: abrimos el Writer

```java
try (FileWriter writer =
        new FileWriter(
            ruta.toFile()
        )) {
```

Ahora tenemos un flujo de escritura asociado al fichero.

---

### 18. Paso 5: Gson escribe

La instrucción fundamental es:

```java
gson.toJson(
    alumnos,
    writer
);
```

Aquí Gson:

1. examina `List<Alumno>`;
2. serializa los alumnos;
3. genera JSON;
4. envía el resultado al `Writer`.

Conceptualmente:

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

## ¿Qué ocurre si el fichero ya existe?

### 19. Sobrescritura

Con el uso habitual de:

```java
new FileWriter(
    ruta.toFile()
)
```

si el fichero ya existe, su contenido se sustituye.

Por tanto, si ejecutamos varias veces:

```text
GuardarAlumnosGson
```

no queremos ir concatenando documentos JSON independientes.

Queremos generar nuevamente:

```text
alumnos.json
```

con el estado actual de nuestra lista.

!!! warning "No utilizar append para concatenar documentos JSON"
    Añadir un documento JSON completo detrás de otro normalmente produciría un fichero que ya no representa una única estructura JSON válida.

---

## Segunda parte: leer

### 20. Recuperar los datos

Ahora tenemos:

```text
data/
└── alumnos.json
```

y queremos recuperar:

```java
List<Alumno>
```

El proceso será:

```text
alumnos.json
     │
     ▼
 FileReader
     │
     ▼
    Gson
     │
     │ fromJson()
     ▼
List<Alumno>
```

Pero, como aprendimos anteriormente, necesitamos además indicar:

```text
List<Alumno>
```

mediante:

```java
TypeToken
```

---

## FileReader

### 21. Abrir el fichero

Para leer utilizaremos:

```java
FileReader
```

Importamos:

```java
import java.io.FileReader;
```

y podemos abrir:

```java
FileReader reader =
        new FileReader(
            ruta.toFile()
        );
```

---

### 22. Utilizar try-with-resources

También debemos cerrar correctamente el fichero de lectura.

Por eso utilizaremos:

```java
try (FileReader reader =
        new FileReader(
            ruta.toFile()
        )) {

    // leer

}
```

Al terminar el bloque se cerrará automáticamente.

---

## Definir el tipo

### 23. TypeToken<List<Alumno>>

Antes de realizar la conversión debemos indicar a Gson que queremos recuperar:

```java
List<Alumno>
```

Utilizamos:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

Necesitamos:

```java
import java.lang.reflect.Type;
```

y:

```java
import com.google.gson.reflect.TypeToken;
```

Recordemos:

```text
TypeToken
    │
    └── describe el tipo
        List<Alumno>
```

No realiza la lectura.

---

## fromJson() y Reader

### 24. Leer directamente desde el fichero

Ahora podemos hacer:

```java
List<Alumno> alumnos =
        gson.fromJson(
            reader,
            tipo
        );
```

Observa que ya no pasamos:

```java
String json
```

sino:

```java
reader
```

Por tanto:

```text
FileReader
     │
     ▼
fromJson(reader, tipo)
     │
     ▼
List<Alumno>
```

---

## LeerAlumnosGson.java

### 25. Ejemplo completo de lectura

```java
package com.example;

import java.io.FileReader;
import java.io.IOException;

import java.lang.reflect.Type;

import java.nio.file.Path;

import java.util.List;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class LeerAlumnosGson {

    public static void main(String[] args) {

        // ==========================================
        // 1. CREAR GSON
        // ==========================================

        Gson gson =
                new Gson();


        // ==========================================
        // 2. DEFINIR EL FICHERO
        // ==========================================

        Path ruta =
                Path.of(
                    "data",
                    "alumnos.json"
                );


        // ==========================================
        // 3. DEFINIR EL TIPO
        // ==========================================

        Type tipo =
                new TypeToken<List<Alumno>>() {}
                    .getType();


        // ==========================================
        // 4. ABRIR Y LEER EL FICHERO
        // ==========================================

        try (FileReader reader =
                new FileReader(
                    ruta.toFile()
                )) {


            // ======================================
            // 5. DESERIALIZAR
            // ======================================

            List<Alumno> alumnos =
                    gson.fromJson(
                        reader,
                        tipo
                    );


            // ======================================
            // 6. MOSTRAR LOS OBJETOS RECUPERADOS
            // ======================================

            for (Alumno alumno :
                    alumnos) {

                System.out.println(
                    alumno
                );
            }

        } catch (IOException e) {

            System.err.println(
                "Error al leer el fichero: "
                + e.getMessage()
            );
        }
    }
}
```

---

## Analizar LeerAlumnosGson

### 26. Paso 1: localizamos el fichero

```java
Path ruta =
        Path.of(
            "data",
            "alumnos.json"
        );
```

Queremos leer:

```text
data/alumnos.json
```

---

### 27. Paso 2: indicamos qué queremos recuperar

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

Esto indica:

```text
El JSON representa una List<Alumno>
```

---

### 28. Paso 3: abrimos el Reader

```java
FileReader reader =
        new FileReader(
            ruta.toFile()
        );
```

El `Reader` proporciona a Gson acceso al contenido del fichero.

---

### 29. Paso 4: deserializamos

La instrucción fundamental es:

```java
List<Alumno> alumnos =
        gson.fromJson(
            reader,
            tipo
        );
```

El recorrido es:

```text
alumnos.json
     │
     ▼
 FileReader
     │
     ▼
fromJson(reader, tipo)
     │
     ▼
List<Alumno>
```

---

### 30. Paso 5: volvemos a trabajar con Java

Después de:

```java
gson.fromJson(...)
```

ya tenemos:

```java
List<Alumno>
```

Por tanto podemos trabajar normalmente:

```java
for (Alumno alumno : alumnos) {

    System.out.println(
        alumno.getNombre()
    );
}
```

También podríamos:

```java
alumnos.get(0);
```

o:

```java
alumnos.size();
```

El JSON ya ha sido convertido en objetos Java.

---

## Comparar escritura y lectura

### 31. Los dos recorridos

#### Guardar

```java
gson.toJson(
    alumnos,
    writer
);
```

representa:

```text
List<Alumno>
     │
     ▼
    Gson
     │
     ▼
  Writer
     │
     ▼
 fichero
```

#### Leer

```java
List<Alumno> alumnos =
        gson.fromJson(
            reader,
            tipo
        );
```

representa:

```text
 fichero
     │
     ▼
  Reader
     │
     ▼
    Gson
     │
     ▼
List<Alumno>
```

---

## Writer y Reader

### 32. No son funciones de Gson

Es importante distinguir responsabilidades.

#### Gson

Se ocupa de:

```text
Objeto Java ⇄ JSON
```

#### Writer

Se ocupa de:

```text
escribir caracteres
```

#### Reader

Se ocupa de:

```text
leer caracteres
```

Por tanto:

```text
           GUARDAR

Objetos
   │
   ▼
 Gson       ← convierte
   │
   ▼
Writer      ← escribe
   │
   ▼
Fichero
```

y:

```text
            LEER

Fichero
   │
   ▼
Reader      ← lee
   │
   ▼
 Gson       ← convierte
   │
   ▼
Objetos
```

!!! important "Responsabilidades"
    Gson no sustituye a las clases de entrada/salida de Java.

    Gson se encarga de la **conversión JSON**, mientras que `Reader` y `Writer` permiten trabajar con el fichero.

---

## Comparación con org.json

### 33. Guardar con org.json

Con `org.json` hacíamos algo parecido a:

```java
writer.write(
    lista.toString(4)
);
```

Primero teníamos una estructura:

```java
JSONArray
```

y después generábamos su representación textual.

---

### 34. Guardar con Gson

Con Gson podemos hacer:

```java
gson.toJson(
    alumnos,
    writer
);
```

Partimos directamente de:

```java
List<Alumno>
```

No necesitamos crear manualmente un:

```java
JSONArray
```

---

### 35. Leer con org.json

El recorrido era:

```text
FileReader
     │
     ▼
JSONTokener
     │
     ▼
JSONObject / JSONArray
```

---

### 36. Leer con Gson

Ahora tenemos:

```text
FileReader
     │
     ▼
fromJson()
     │
     ▼
List<Alumno>
```

Para la colección indicamos además:

```java
TypeToken<List<Alumno>>
```

---

## Comparación completa

### 37. org.json frente a Gson

```text
                 org.json

GUARDAR
datos
  ↓
JSONObject / JSONArray
  ↓
toString()
  ↓
Writer
  ↓
fichero


LEER
fichero
  ↓
Reader
  ↓
JSONTokener
  ↓
JSONObject / JSONArray
  ↓
get...()
```

frente a:

```text
                   Gson

GUARDAR
List<Alumno>
     ↓
Gson
     ↓
toJson(..., writer)
     ↓
fichero


LEER
fichero
     ↓
Reader
     ↓
Gson
     ↓
fromJson(..., tipo)
     ↓
List<Alumno>
```

---

## El ciclo de persistencia completo

### 38. Desde Java hasta el fichero y vuelta

Ahora ya podemos representar el proceso completo:

```text
┌─────────────────────┐
│    List<Alumno>     │
│                     │
│ Ana                 │
│ Luis                │
│ Marta               │
└──────────┬──────────┘
           │
           │ gson.toJson(lista, writer)
           ▼
┌─────────────────────┐
│    alumnos.json     │
│                     │
│ [                   │
│   {...},            │
│   {...},            │
│   {...}             │
│ ]                   │
└──────────┬──────────┘
           │
           │ FileReader
           │
           │ gson.fromJson(reader, tipo)
           ▼
┌─────────────────────┐
│    List<Alumno>     │
│                     │
│ Ana                 │
│ Luis                │
│ Marta               │
└─────────────────────┘
```

Esto constituye un ejemplo sencillo de:

```text
PERSISTENCIA DE DATOS
```

---

## ¿En qué orden ejecutar los ejemplos?

### 39. Primero guardar

Ejecutamos:

```text
GuardarAlumnosGson.java
```

Esto debe crear:

```text
data/alumnos.json
```

---

### 40. Comprobar el fichero

Abrimos:

```text
data/alumnos.json
```

y comprobamos que contiene los alumnos.

Por ejemplo:

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

---

### 41. Después leer

Ejecutamos:

```text
LeerAlumnosGson.java
```

El programa:

1. abre `alumnos.json`;
2. lee su contenido;
3. Gson lo deserializa;
4. crea una `List<Alumno>`;
5. recorremos los objetos recuperados.

---

## Errores frecuentes

### 42. Ejecutar LeerAlumnosGson antes de crear el fichero

Si:

```text
data/alumnos.json
```

no existe, `FileReader` no podrá abrirlo.

Por eso, durante las primeras pruebas, ejecutaremos primero:

```text
GuardarAlumnosGson
```

y después:

```text
LeerAlumnosGson
```

---

### 43. Ruta incorrecta

Si aparece un error indicando que no se encuentra:

```text
data/alumnos.json
```

debemos comprobar:

- que existe el directorio `data`;
- que existe `alumnos.json`;
- que el nombre está correctamente escrito;
- cuál es el directorio de trabajo desde el que ejecutamos el programa.

---

### 44. Olvidar TypeToken

Para recuperar:

```java
List<Alumno>
```

necesitamos proporcionar el tipo correspondiente.

En nuestro ejemplo:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();
```

---

### 45. Confundir Writer y Reader

Recuerda:

```text
Writer
  ↓
escribir
```

mientras que:

```text
Reader
  ↓
leer
```

Una asociación sencilla:

```text
WRITE → escribir

READ  → leer
```

---

### 46. Confundir toJson() con fromJson()

Para guardar:

```java
gson.toJson(
    alumnos,
    writer
);
```

Para recuperar:

```java
gson.fromJson(
    reader,
    tipo
);
```

---

## Resumen de clases

### 47. Elementos utilizados

| Elemento | Función |
|---|---|
| `Alumno` | Modelo Java |
| `List<Alumno>` | Colección que queremos guardar |
| `Gson` | Serialización y deserialización |
| `GsonBuilder` | Configuración de Gson |
| `setPrettyPrinting()` | JSON legible |
| `FileWriter` | Escritura del fichero |
| `FileReader` | Lectura del fichero |
| `Path` | Representación de rutas |
| `Files.createDirectories()` | Creación de directorios |
| `TypeToken<List<Alumno>>` | Describe el tipo genérico al leer |
| `toJson()` | Java → JSON |
| `fromJson()` | JSON → Java |

---

## Ejemplos de este apartado

### 48. Clases que debemos comprender

Los dos ejemplos fundamentales son:

| Fichero | Finalidad |
|---|---|
| `GuardarAlumnosGson.java` | Guarda una `List<Alumno>` en `data/alumnos.json` |
| `LeerAlumnosGson.java` | Recupera `data/alumnos.json` como `List<Alumno>` |

Ambos utilizan también:

```text
Alumno.java
```

como modelo de datos.

---

## Qué debemos reconocer en GuardarAlumnosGson

### 49. Pasos principales

```text
1. Crear List<Alumno>

           ↓

2. Crear GsonBuilder

           ↓

3. Preparar data/alumnos.json

           ↓

4. Abrir FileWriter

           ↓

5. gson.toJson(alumnos, writer)
```

El código fundamental es:

```java
Gson gson =
        new GsonBuilder()
            .setPrettyPrinting()
            .create();

try (FileWriter writer =
        new FileWriter(
            ruta.toFile()
        )) {

    gson.toJson(
        alumnos,
        writer
    );
}
```

---

## Qué debemos reconocer en LeerAlumnosGson

### 50. Pasos principales

```text
1. Crear Gson

           ↓

2. Localizar data/alumnos.json

           ↓

3. Definir TypeToken<List<Alumno>>

           ↓

4. Abrir FileReader

           ↓

5. gson.fromJson(reader, tipo)

           ↓

6. Obtener List<Alumno>
```

El código fundamental es:

```java
Type tipo =
        new TypeToken<List<Alumno>>() {}
            .getType();

try (FileReader reader =
        new FileReader(
            ruta.toFile()
        )) {

    List<Alumno> alumnos =
            gson.fromJson(
                reader,
                tipo
            );
}
```

---

## Antes de continuar

### 51. Comprueba que sabes explicar...

**¿Qué hace este código?**

```java
gson.toJson(
    alumnos,
    writer
);
```

```text
Serializa la lista de alumnos y
envía el JSON al Writer.
```

**¿Qué hace este código?**

```java
gson.fromJson(
    reader,
    tipo
);
```

```text
Lee el JSON proporcionado por el Reader
y lo deserializa utilizando el tipo indicado.
```

**¿Por qué necesitamos `TypeToken`?**

```text
Porque queremos recuperar un tipo genérico:
List<Alumno>.
```

**¿Qué hace `FileWriter`?**

```text
Permite escribir en el fichero.
```

**¿Qué hace `FileReader`?**

```text
Permite leer el fichero.
```

**¿Gson sustituye a FileReader y FileWriter?**

```text
No.

Gson realiza la conversión entre
objetos Java y JSON.
```

---

!!! success "Ciclo completo"
    Ya podemos realizar un ciclo completo de persistencia con Gson:

    ```text
    List<Alumno>
         │
         │ toJson()
         ▼
    alumnos.json
         │
         │ fromJson()
         ▼
    List<Alumno>
    ```

    Los datos salen de nuestros objetos Java, se almacenan en un fichero JSON y posteriormente pueden recuperarse de nuevo como objetos Java.