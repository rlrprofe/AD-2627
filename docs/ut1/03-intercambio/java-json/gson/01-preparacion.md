# Preparación del proyecto

### 1. Introducción

Para trabajar con **Gson** desde Java necesitamos incorporar la librería a nuestro proyecto.

Gson no forma parte de la biblioteca estándar de Java, por lo que debemos añadirla como una **dependencia externa**.

En este minicurso utilizaremos:

- **Java 21**
- **Maven**
- **Gson**

La estructura inicial será:

```text
Proyecto Java
     │
     ├── JDK 21
     │
     └── Maven
           │
           └── dependencia Gson
```

!!! info "¿Por qué utilizamos Maven?"
    Maven permite declarar las librerías que necesita nuestro proyecto dentro del fichero `pom.xml`.

    A partir de esa información, Maven puede descargar automáticamente las dependencias necesarias.

---

### 2. Crear un proyecto Maven

Nuestro proyecto tendrá una estructura similar a:

```text
gson-ejemplos/
│
├── pom.xml
│
└── src/
    └── main/
        └── java/
            └── com/
                └── example/
```

El fichero fundamental para configurar Maven es:

```text
pom.xml
```

En él indicaremos:

- información sobre el proyecto;
- versión de Java;
- dependencias;
- configuración necesaria para la compilación.

---

### 3. Configurar Java 21

En nuestros proyectos utilizaremos **Java 21**.

Dentro del `pom.xml` tendremos:

```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.release>21</maven.compiler.release>
</properties>
```

La propiedad:

```xml
<maven.compiler.release>21</maven.compiler.release>
```

indica que Maven debe compilar el proyecto para **Java 21**.

!!! important "JDK del proyecto"
    Para poder compilar correctamente, el equipo debe tener instalado un **JDK 21** y el entorno de desarrollo debe estar configurado para utilizarlo.

---

## Añadir Gson

### 4. Dependencia Maven

Para utilizar Gson debemos añadir su dependencia dentro del bloque:

```xml
<dependencies>
```

del `pom.xml`.

La dependencia tiene esta estructura:

```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.11.0</version>
</dependency>
```

Por tanto:

```text
com.google.code.gson
        │
        ▼
      gson
        │
        ▼
     versión
```

!!! note "Versión de Gson"
    En el proyecto de ejemplos utilizaremos una versión concreta de Gson en el `pom.xml`.

    Cuando trabajemos con dependencias reales conviene consultar Maven Central para comprobar qué versiones están disponibles en lugar de escribir una versión al azar.

---

### 5. ¿Qué significan groupId, artifactId y version?

Una dependencia Maven se identifica principalmente mediante tres elementos:

```xml
<groupId>...</groupId>
<artifactId>...</artifactId>
<version>...</version>
```

#### groupId

En Gson:

```xml
<groupId>com.google.code.gson</groupId>
```

identifica el grupo al que pertenece el artefacto.

---

#### artifactId

```xml
<artifactId>gson</artifactId>
```

identifica la librería concreta.

---

#### version

```xml
<version>...</version>
```

indica qué versión de la librería queremos utilizar.

Podemos pensar en las coordenadas Maven como:

```text
groupId
   +
artifactId
   +
version
   =
dependencia concreta
```

---

## Maven Central

### 6. ¿De dónde obtiene Maven Gson?

Normalmente Maven descarga las dependencias desde repositorios de artefactos.

Uno de los repositorios más importantes es **Maven Central**.

Podemos buscar:

```text
Gson
```

o directamente sus coordenadas:

```text
com.google.code.gson
gson
```

en:

[**Maven Central**](https://central.sonatype.com/)

!!! tip "No memorices las dependencias"
    Es más importante saber **localizar correctamente una dependencia** que memorizar todos sus datos.

    En Maven Central podemos consultar:

    - `groupId`;
    - `artifactId`;
    - versiones disponibles;
    - fragmento XML para Maven.

---

### 7. Buscar Gson en Maven Central

Podemos buscar:

```text
gson
```

y localizar el artefacto:

```text
com.google.code.gson:gson
```

La información que necesitamos trasladar al `pom.xml` será:

```text
Group:
com.google.code.gson

Artifact:
gson

Version:
versión seleccionada
```

Después Maven podrá descargar la librería automáticamente.

---

## ¿Qué hace Maven?

### 8. Proceso de resolución de la dependencia

Cuando Maven procesa nuestro proyecto:

```text
pom.xml
   │
   │ encuentra dependencia
   ▼
com.google.code.gson:gson
   │
   ▼
Repositorio Maven
   │
   │ descarga
   ▼
Librería Gson
   │
   ▼
Disponible en nuestro proyecto
```

No necesitamos descargar manualmente un `.jar` y copiarlo dentro del proyecto.

---

### 9. ¿Dónde descarga Maven las librerías?

Maven mantiene un repositorio local en nuestro ordenador.

En Windows suele encontrarse dentro del directorio del usuario:

```text
.m2/repository
```

Por ejemplo, conceptualmente:

```text
Usuario
└── .m2
    └── repository
        └── com
            └── google
                └── code
                    └── gson
                        └── gson
```

Dentro encontraremos las versiones que Maven haya descargado.

!!! note
    Normalmente no necesitamos manipular manualmente estos ficheros.

    Maven gestiona las dependencias por nosotros.

---

## Primer contacto con la librería

### 10. Importar Gson

Una vez que Maven ha incorporado correctamente la dependencia podremos importar:

```java
import com.google.gson.Gson;
```

La clase:

```java
Gson
```

será la clase principal que utilizaremos durante gran parte del minicurso.

---

### 11. Crear un objeto Gson

La forma más sencilla de crear Gson es:

```java
Gson gson =
        new Gson();
```

A partir de este objeto podremos realizar las dos operaciones fundamentales:

```text
                 Gson
                  │
          ┌───────┴───────┐
          │               │
          ▼               ▼
       toJson()        fromJson()
          │               │
          ▼               ▼
    Java → JSON       JSON → Java
```

---

### 12. Primera prueba

Podemos comprobar que la librería funciona con un ejemplo muy sencillo:

```java
package com.example;

import com.google.gson.Gson;

public class DemoGson {

    public static void main(String[] args) {

        Gson gson =
                new Gson();

        String[] modulos = {
            "Acceso a Datos",
            "Desarrollo de Interfaces",
            "Programación de Servicios"
        };

        String json =
                gson.toJson(modulos);

        System.out.println(json);
    }
}
```

Obtendremos un resultado similar a:

```json
["Acceso a Datos","Desarrollo de Interfaces","Programación de Servicios"]
```

Aquí ya hemos realizado nuestra primera:

```text
SERIALIZACIÓN
```

porque hemos convertido:

```text
String[]
    │
    │ toJson()
    ▼
  JSON
```

---

## JSON legible

### 13. GsonBuilder

El JSON anterior aparece en una única línea:

```json
["Acceso a Datos","Desarrollo de Interfaces","Programación de Servicios"]
```

Podemos configurar Gson para generar un formato más legible.

Para ello utilizaremos:

```java
GsonBuilder
```

Debemos importar:

```java
import com.google.gson.GsonBuilder;
```

---

### 14. setPrettyPrinting()

Podemos crear Gson así:

```java
Gson gson =
        new GsonBuilder()
            .setPrettyPrinting()
            .create();
```

Ahora:

```java
String json =
        gson.toJson(modulos);
```

producirá un resultado más parecido a:

```json
[
  "Acceso a Datos",
  "Desarrollo de Interfaces",
  "Programación de Servicios"
]
```

El proceso es:

```text
new GsonBuilder()
        │
        ▼
setPrettyPrinting()
        │
        ▼
     create()
        │
        ▼
       Gson
```

---

### 15. Gson frente a GsonBuilder

Podemos crear Gson directamente:

```java
Gson gson =
        new Gson();
```

o mediante un constructor configurable:

```java
Gson gson =
        new GsonBuilder()
            .setPrettyPrinting()
            .create();
```

La diferencia conceptual es:

| Forma | Uso |
|---|---|
| `new Gson()` | Configuración estándar |
| `new GsonBuilder()` | Permite configurar el comportamiento |
| `setPrettyPrinting()` | Genera JSON con formato legible |
| `create()` | Construye finalmente el objeto `Gson` |

Más adelante volveremos a utilizar `GsonBuilder` para configuraciones más avanzadas.

---

## Primer ejemplo completo

### 16. DemoGson.java

Podemos dejar nuestro primer programa de prueba así:

```java
package com.example;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class DemoGson {

    public static void main(String[] args) {

        // ==========================================
        // 1. CREAR GSON
        // ==========================================

        Gson gson =
                new GsonBuilder()
                    .setPrettyPrinting()
                    .create();


        // ==========================================
        // 2. DATOS JAVA
        // ==========================================

        String[] modulos = {
            "Acceso a Datos",
            "Desarrollo de Interfaces",
            "Programación de Servicios"
        };


        // ==========================================
        // 3. CONVERTIR JAVA A JSON
        // ==========================================

        String json =
                gson.toJson(modulos);


        // ==========================================
        // 4. MOSTRAR RESULTADO
        // ==========================================

        System.out.println(json);
    }
}
```

El flujo es:

```text
String[]
   │
   │ gson.toJson()
   ▼
String con JSON
   │
   ▼
consola
```

---

## Diferencia respecto a org.json

### 17. No estamos creando JSONArray manualmente

Con `org.json`, para representar una colección escribíamos:

```java
JSONArray modulos =
        new JSONArray();

modulos.put("Acceso a Datos");
modulos.put("Desarrollo de Interfaces");
modulos.put("Programación de Servicios");
```

Con Gson podemos partir directamente de una estructura Java:

```java
String[] modulos = {
    "Acceso a Datos",
    "Desarrollo de Interfaces",
    "Programación de Servicios"
};
```

y realizar:

```java
gson.toJson(modulos);
```

Por tanto:

```text
org.json

crear JSONArray
      ↓
put()
      ↓
put()
      ↓
put()
      ↓
JSON
```

frente a:

```text
Gson

array Java
    ↓
 toJson()
    ↓
  JSON
```

!!! important "Este es el cambio que debemos comprender"
    Gson intenta realizar automáticamente el **mapeo entre estructuras Java y estructuras JSON**.

    En los siguientes apartados veremos que esto resulta todavía más interesante cuando trabajamos con nuestros propios objetos Java.

---

## Comprobar que todo funciona

### 18. Antes de continuar

Antes de avanzar debemos comprobar que:

- el proyecto utiliza **JDK 21**;
- Maven reconoce correctamente el `pom.xml`;
- la dependencia de Gson está disponible;
- podemos importar `com.google.gson.Gson`;
- podemos importar `com.google.gson.GsonBuilder`;
- el programa `DemoGson.java` se ejecuta;
- `toJson()` genera correctamente una cadena JSON.

Podemos comprobar también desde terminal:

```bash
mvn compile
```

Si la compilación termina correctamente, Maven debería mostrar:

```text
BUILD SUCCESS
```

---

### 19. Problemas frecuentes

#### `Gson cannot be resolved to a type`

Si aparece un error similar a:

```text
Gson cannot be resolved to a type
```

debemos comprobar primero que la dependencia está correctamente declarada en:

```text
pom.xml
```

y que Maven ha actualizado el proyecto.

---

#### El import aparece en rojo

Comprueba:

```java
import com.google.gson.Gson;
```

Si VS Code no reconoce el import, puede que todavía no haya cargado o descargado correctamente las dependencias Maven.

---

#### Maven utiliza otra versión de Java

Podemos comprobar Java desde terminal:

```bash
java -version
```

y:

```bash
javac -version
```

Para nuestros proyectos esperamos trabajar con:

```text
21
```

También podemos comprobar Maven:

```bash
mvn -version
```

Este comando muestra, entre otros datos, la versión de Java que está utilizando Maven.

!!! warning "Java de VS Code y Java de Maven"
    Tener instalado JDK 21 no garantiza por sí solo que todas las herramientas estén utilizándolo.

    Si aparecen errores relacionados con la versión de Java, conviene comprobar tanto la configuración de VS Code como la salida de:

    ```bash
    mvn -version
    ```

---

## Resumen

### 20. Preparación del proyecto

El proceso inicial puede resumirse así:

```text
           PROYECTO MAVEN
                 │
                 ▼
              pom.xml
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
     Java 21        dependencia Gson
                          │
                          ▼
                  com.google.code.gson
                          │
                          ▼
                         gson
                          │
                          ▼
                    Maven Central
```

Una vez disponible la librería:

```text
import Gson
      │
      ▼
new Gson()
      │
      ├── toJson()
      │
      └── fromJson()
```

y si necesitamos configurar Gson:

```text
GsonBuilder
      │
      ▼
configuración
      │
      ▼
   create()
      │
      ▼
     Gson
```

!!! success "Preparación completada"
    Una vez configurada la dependencia y comprobado que `DemoGson.java` funciona, tenemos preparado el proyecto para comenzar a estudiar el aspecto más importante de Gson: la **conversión entre nuestros propios objetos Java y JSON**.