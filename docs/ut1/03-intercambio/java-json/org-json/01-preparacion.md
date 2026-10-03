# Preparación del proyecto

Antes de comenzar a trabajar con JSON en Java debemos preparar nuestro proyecto.

Java no incorpora soporte completo para JSON en su biblioteca estándar, por lo que utilizaremos una **librería externa**. En este primer bloque trabajaremos con **org.json**.

---

### 1. Crear un proyecto Maven

Los ejemplos de este minicurso utilizarán **Maven** para gestionar las dependencias del proyecto.

Una estructura básica del proyecto será:

```text
proyecto-json/
├── pom.xml
└── src/
    └── main/
        ├── java/
        │   └── ...
        └── data/
```

!!! info "¿Qué es Maven?"
    Maven es una herramienta que permite gestionar proyectos Java y sus dependencias.

    Gracias a Maven podemos indicar qué librerías necesita nuestro proyecto en el fichero `pom.xml` sin tener que descargar y añadir manualmente los ficheros `.jar`.

---

### 2. Añadir la dependencia de org.json

Para poder utilizar `org.json` debemos añadir la librería a nuestro proyecto.

Abrimos el fichero `pom.xml` y añadimos la dependencia dentro del bloque `<dependencies>`:

```xml
<dependencies>

    <dependency>
        <groupId>org.json</groupId>
        <artifactId>json</artifactId>
        <version>20240303</version>
    </dependency>

</dependencies>
```

Los tres datos que identifican la dependencia son:

| Elemento | Valor | Significado |
|---|---|---|
| `groupId` | `org.json` | Organización o grupo que publica la librería |
| `artifactId` | `json` | Nombre de la librería |
| `version` | `20240303` | Versión que utilizaremos |

Una vez añadida la dependencia, Maven se encargará de descargar la librería y añadirla al proyecto.

!!! warning "Importante"
    La dependencia debe añadirse dentro del bloque `<dependencies>` del fichero `pom.xml`.

---

### 3. ¿De dónde obtenemos las dependencias?

No es necesario memorizar las dependencias de las librerías.

Podemos buscarlas en **Maven Central**, el repositorio central de componentes y librerías utilizado por Maven.

[Maven Central](https://central.sonatype.com/)

Por ejemplo, podemos consultar directamente la librería `org.json`:

[org.json en Maven Central](https://central.sonatype.com/artifact/org.json/json/20240303)

Desde la ficha de una librería podemos consultar información como:

- `groupId`
- `artifactId`
- versiones disponibles
- información del artefacto
- dependencia que debemos incorporar a nuestro proyecto

#### Procedimiento habitual

Cuando necesitemos utilizar una nueva librería:

1. Accedemos a Maven Central.
2. Buscamos el nombre de la librería.
3. Seleccionamos el artefacto correspondiente.
4. Elegimos la versión que queremos utilizar.
5. Copiamos la dependencia.
6. La añadimos dentro de `<dependencies>` en nuestro `pom.xml`.

!!! tip "No memorices las dependencias"
    Lo importante es saber **localizar una librería y añadirla correctamente al proyecto**, no memorizar su `groupId`, `artifactId` o versión.

---

### 4. ¿Y si no utilizamos Maven?

También es posible utilizar `org.json` sin Maven.

En ese caso tendremos que:

1. Descargar manualmente el fichero `.jar` de la librería.
2. Guardarlo en nuestro equipo o dentro del proyecto.
3. Añadir el `.jar` a las librerías o al **classpath** del proyecto.

Podemos localizar las distintas versiones de `org.json` desde Maven Central:

[org.json en Maven Central](https://central.sonatype.com/artifact/org.json/json)

!!! info "Maven o JAR"
    **Con Maven**

    Indicamos la dependencia en `pom.xml` y Maven descarga y gestiona automáticamente la librería.

    **Sin Maven**

    Tenemos que descargar el fichero `.jar` y añadirlo manualmente al proyecto.

En estos apuntes utilizaremos **Maven**, ya que facilita la gestión de las librerías y evita tener que distribuir manualmente los ficheros `.jar`.

---

### 5. Clases que utilizaremos

Una vez añadida la dependencia podremos importar las principales clases de `org.json`:

```java
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONTokener;
```

A lo largo de las siguientes lecciones veremos para qué sirve cada una.

| Clase | Uso principal |
|---|---|
| `JSONObject` | Crear y manipular objetos JSON |
| `JSONArray` | Crear y manipular arrays JSON |
| `JSONTokener` | Interpretar JSON procedente de un texto, fichero o stream |

!!! tip "Recuerda"
    `JSONTokener` aparecerá principalmente cuando **leamos** JSON.

    Para crear y guardar documentos utilizaremos fundamentalmente `JSONObject` y `JSONArray`.

---

### 6. Esquema del proceso

A lo largo del minicurso seguiremos dos procesos diferentes:

#### Guardar JSON

```text
Datos
   ↓
JSONObject / JSONArray
   ↓
toString()
   ↓
Fichero .json
```

#### Leer JSON

```text
Fichero .json
   ↓
Reader
   ↓
JSONTokener
   ↓
JSONObject / JSONArray
   ↓
Datos
```

!!! important "Guardar y leer son procesos diferentes"
    Al **guardar**, nosotros construimos la estructura JSON utilizando `JSONObject` o `JSONArray`.

    Al **leer**, `JSONTokener` nos ayuda a interpretar el contenido JSON que procede del fichero.

---

### 7. Videotutorial

Para repasar cómo se gestionan las dependencias en un proyecto Maven puedes consultar el siguiente vídeo:

#### Gestión de dependencias con Maven

[▶️ Curso Apache Maven | Cómo agregar, eliminar, buscar y modificar dependencias](https://www.youtube.com/watch?v=XcA8UpBMGO4)

En el vídeo se muestra:

- dónde se encuentran las dependencias en `pom.xml`;
- cómo buscar una librería;
- cómo consultar Maven Central / MVN Repository;
- cómo elegir una versión;
- cómo copiar la dependencia;
- cómo incorporarla al proyecto.

!!! tip "¿Qué parte nos interesa especialmente?"
    Presta especial atención a la parte dedicada a **buscar y añadir dependencias**.

    Después aplica el mismo procedimiento para localizar y añadir la dependencia de `org.json`.