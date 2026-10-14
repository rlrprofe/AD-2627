# Anexo · Apache Maven para proyectos Java

Este anexo amplía los conceptos de Maven utilizados en la **UT3**. Puede consultarse también como material de referencia para otros proyectos Java del módulo. Los ejemplos se plantean con **JDK 21**.

## Apache Maven

### 1. ¿Qué es Maven?

**Apache Maven** es una herramienta de automatización y gestión de proyectos software, especialmente utilizada en el desarrollo de aplicaciones Java.

Permite organizar los proyectos siguiendo una estructura estándar y automatizar tareas que, de otro modo, tendríamos que realizar manualmente.

Entre sus principales funciones se encuentran:

- **Gestión de dependencias:** descarga y administra las bibliotecas que necesita una aplicación.
- **Compilación:** transforma los archivos `.java` en archivos `.class`.
- **Ejecución de pruebas:** permite lanzar pruebas automatizadas.
- **Empaquetado:** genera archivos distribuibles, como JAR.
- **Documentación:** puede generar documentación mediante complementos.
- **Gestión del ciclo de vida:** organiza las tareas de construcción en fases.

#### ¿Qué problema resuelve Maven?

Imagina que desarrollamos una aplicación Java que necesita conectarse a MySQL.

Sin Maven, normalmente tendríamos que:

1. Buscar y descargar el controlador JDBC.
2. Añadir el archivo JAR al proyecto.
3. Configurar el classpath para que Java encuentre la biblioteca.
4. Repetir parte de este proceso cuando cambie la versión del controlador.
5. Configurar manualmente otras bibliotecas necesarias para las pruebas.

Con Maven, declaramos las dependencias en un archivo de configuración llamado `pom.xml`.

Maven se encarga de localizarlas, descargarlas y ponerlas a disposición del proyecto.

!!! tip "Idea fundamental"
    Maven no sustituye a Java ni al entorno de desarrollo.

    **Maven automatiza la construcción y gestión del proyecto**, mientras que el JDK proporciona las herramientas necesarias para compilar y ejecutar código Java.

### 2. Recursos para aprender Maven

**Vídeo complementario en inglés:**


[Maven Tutorial – Crash Course (YouTube, en inglés)](https://www.youtube.com/watch?v=Xatr8AZLOsE)

El vídeo sirve como apoyo visual para los conceptos de:

- Configuración de Maven.
- Gestión del ciclo de vida.
- Dependencias.
- Integración con otras herramientas.

**Documentación oficial:**

- [Apache Maven](https://maven.apache.org/)
- [Introducción a Maven](https://maven.apache.org/guides/getting-started/)
- [Introducción al archivo POM](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html)

!!! note "Recomendación"
    Antes de continuar, asegúrate de comprender tres conceptos: **proyecto Maven**, **archivo `pom.xml`** y **dependencia**.

### 3. Instalación y comprobación de Maven

Para trabajar con Maven necesitamos disponer de un JDK instalado y de Maven accesible desde el sistema, o utilizar el Maven integrado en el entorno de desarrollo.

En esta unidad utilizaremos **JDK 21**.

Abre una terminal y comprueba la versión de Java:

```bash
java -version
```

Comprueba también el compilador:

```bash
javac -version
```

Y finalmente Maven:

```bash
mvn -version
```

La salida de Maven debe indicar su versión y el entorno Java que está utilizando.

!!! warning "Posibles problemas"
    Si aparece un mensaje indicando que `mvn` no se reconoce como comando, Maven no está instalado o no está correctamente configurado en el `PATH`.

    Si Maven utiliza una versión de Java diferente de JDK 21, habrá que revisar la configuración del entorno, especialmente `JAVA_HOME`.

### 4. Organización estándar de un proyecto Maven

Una ventaja de Maven es que utiliza una **estructura de directorios convencional**.

Esto permite que diferentes desarrolladores puedan reconocer rápidamente dónde se encuentra cada elemento de un proyecto.

Ejemplo:

```text
gestion-productos/
│
├── pom.xml
├── README.md
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── es/
│   │   │       └── iesisidra/
│   │   │           └── productos/
│   │   │               ├── modelo/
│   │   │               │   └── Producto.java
│   │   │               └── dao/
│   │   │                   └── ProductoDAO.java
│   │   │
│   │   └── resources/
│   │
│   └── test/
│       ├── java/
│       │   └── es/
│       │       └── iesisidra/
│       │           └── productos/
│       │
│       └── resources/
│
└── target/
```

#### ¿Qué contiene cada directorio?

| Elemento | Función |
|---|---|
| `pom.xml` | Archivo principal de configuración de Maven. |
| `README.md` | Información general y documentación del proyecto. |
| `src/main/java` | Código fuente Java de la aplicación. |
| `src/main/resources` | Archivos de configuración y otros recursos de producción. |
| `src/test/java` | Código de las pruebas automatizadas. |
| `src/test/resources` | Recursos utilizados por las pruebas. |
| `target/` | Resultados de compilación y empaquetado. |

El directorio `target/` se genera durante la construcción del proyecto.

!!! note "Buenas prácticas"
    Normalmente, `target/` no debe incorporarse al repositorio Git, ya que contiene archivos generados automáticamente.

    Se recomienda incluirlo en `.gitignore`.

### 5. El archivo pom.xml

El archivo **POM (Project Object Model)** es el elemento central de un proyecto Maven.

Es un archivo XML que describe cómo está configurado el proyecto.

Entre otras cosas, permite indicar:

- Identificación del proyecto.
- Versión del proyecto.
- Tipo de empaquetado.
- Versión de Java.
- Dependencias externas.
- Complementos de construcción.

#### Identificación de un proyecto

Maven utiliza principalmente tres elementos para identificar un proyecto:

| Elemento | Significado | Ejemplo |
|---|---|---|
| `groupId` | Identificador del grupo u organización. | `es.iesisidra` |
| `artifactId` | Nombre del artefacto o proyecto. | `gestion-productos` |
| `version` | Versión del proyecto. | `1.0-SNAPSHOT` |

La combinación de estos valores identifica un artefacto Maven.

Por ejemplo:

```xml
<groupId>es.iesisidra</groupId>
<artifactId>gestion-productos</artifactId>
<version>1.0-SNAPSHOT</version>
```

El sufijo `SNAPSHOT` suele indicar una versión en desarrollo.

### 6. Configuración básica de Maven

Vamos a examinar un ejemplo de `pom.xml` para un proyecto Java que utiliza JDK 21.

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="
           http://maven.apache.org/POM/4.0.0
           https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>es.iesisidra</groupId>
    <artifactId>gestion-productos</artifactId>
    <version>1.0-SNAPSHOT</version>

    <packaging>jar</packaging>

    <properties>
        <maven.compiler.release>21</maven.compiler.release>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

</project>
```

#### Explicación de las etiquetas principales

| Etiqueta | Función |
|---|---|
| `<project>` | Elemento raíz del archivo POM. |
| `<modelVersion>` | Versión del modelo POM. |
| `<groupId>` | Identificador de la organización o grupo. |
| `<artifactId>` | Identificador del proyecto. |
| `<version>` | Versión del artefacto. |
| `<packaging>` | Tipo de empaquetado, en este caso JAR. |
| `<properties>` | Propiedades de configuración. |
| `<maven.compiler.release>` | Versión de Java utilizada para compilar. |
| `<project.build.sourceEncoding>` | Codificación de los archivos fuente. |

En nuestro caso, la propiedad:

```xml
<maven.compiler.release>21</maven.compiler.release>
```

indica que el proyecto debe compilarse para **Java 21**, utilizando un JDK compatible.

!!! tip "Importante"
    El archivo `pom.xml` debe situarse en la raíz del proyecto.

    Los comandos Maven se ejecutarán normalmente desde la carpeta que contiene este archivo.

### 7. Gestión de dependencias

Una **dependencia** es una biblioteca externa que nuestro proyecto necesita para funcionar o realizar determinadas tareas.

Por ejemplo:

- MySQL Connector/J permite conectarnos a MySQL mediante JDBC.
- JUnit 5 permite escribir y ejecutar pruebas automatizadas.

Las dependencias se declaran dentro del elemento `<dependencies>` del archivo `pom.xml`.

#### Ejemplo: añadir MySQL Connector/J

```xml
<dependencies>

    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <version>9.2.0</version>
    </dependency>

</dependencies>
```

La versión mostrada es un ejemplo de configuración. En el proyecto de la unidad utilizaremos la versión indicada en el POM proporcionado.

Cuando Maven procesa el proyecto, descarga las bibliotecas necesarias desde los repositorios configurados.

El repositorio público más habitual es **Maven Central**:

https://central.sonatype.com/

#### ¿Dónde guarda Maven las dependencias?

Por defecto, Maven utiliza un repositorio local situado en:

**Windows:**

```text
C:\Users\TU_USUARIO\.m2\repository
```

**Linux:**

```text
~/.m2/repository
```

Cuando una biblioteca ya está descargada, Maven puede reutilizarla en otros proyectos.

#### Dependencias de producción y de pruebas

No todas las bibliotecas se utilizan para lo mismo.

Por ejemplo, JUnit se necesita para ejecutar pruebas, pero normalmente no forma parte de las dependencias de ejecución de la aplicación.

Esto se indica mediante `scope`:

```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.11.4</version>
    <scope>test</scope>
</dependency>
```

En este ejemplo, `test` indica que la dependencia se utiliza para las pruebas.

#### Dependencias transitivas

Una biblioteca puede necesitar otras bibliotecas para funcionar.

Maven puede resolver también esas dependencias indirectas, conocidas como **dependencias transitivas**.

!!! note "Ventaja de Maven"
    No necesitamos descargar manualmente cada archivo JAR ni gestionar todas las dependencias de forma individual.

    Maven permite centralizar esta información en `pom.xml`.

### 8. Ciclo de vida de Maven

Maven organiza la construcción de un proyecto mediante un conjunto de **fases**.

Cada fase tiene una finalidad concreta.

Algunas de las más importantes son:

| Fase | Función |
|---|---|
| `validate` | Comprueba la información básica del proyecto. |
| `compile` | Compila el código de producción. |
| `test` | Ejecuta las pruebas unitarias. |
| `package` | Genera el artefacto distribuible, por ejemplo un JAR. |
| `verify` | Ejecuta comprobaciones adicionales configuradas para verificar el proyecto. |
| `install` | Instala el artefacto en el repositorio Maven local. |
| `deploy` | Publica el artefacto en un repositorio remoto configurado. |

#### ¿Cómo funcionan las fases?

Cuando ejecutamos una fase, Maven realiza también las fases anteriores necesarias dentro del mismo ciclo de vida.

Por ejemplo:

```bash
mvn package
```

No se limita a generar un JAR. Antes ejecuta las fases previas del ciclo de vida predeterminado, incluyendo la compilación y las pruebas.

Esto permite automatizar la construcción de manera ordenada.

!!! warning "No confundir"
    `mvn deploy` publica un artefacto Maven en un repositorio configurado para ello.

    No significa publicar automáticamente una aplicación en un servidor web.

### 9. Comandos esenciales de Maven

Los siguientes comandos se ejecutan desde la carpeta donde se encuentra `pom.xml`.

#### Comprobar la versión de Maven

```bash
mvn -version
```

Muestra la versión de Maven y el entorno Java utilizado.

#### Limpiar los resultados anteriores

```bash
mvn clean
```

Elimina los resultados de construcción anteriores, normalmente el directorio `target/`.

#### Compilar el proyecto

```bash
mvn compile
```

Compila el código Java de producción.

Los archivos `.class` se generan normalmente en:

```text
target/classes/
```

#### Ejecutar las pruebas

```bash
mvn test
```

Compila y ejecuta las pruebas configuradas.

Para ello, utilizaremos JUnit 5 en los proyectos que incluyan pruebas automatizadas.

#### Generar un archivo JAR

```bash
mvn package
```

Construye el artefacto del proyecto.

En un proyecto con empaquetado `jar`, el archivo generado se encontrará normalmente en:

```text
target/gestion-productos-1.0-SNAPSHOT.jar
```

#### Limpiar y construir desde cero

```bash
mvn clean package
```

Este comando combina dos tareas:

1. Elimina los resultados de compilaciones anteriores.
2. Ejecuta el ciclo de construcción hasta la fase `package`.

Es uno de los comandos más utilizados durante el desarrollo.

#### Instalar el artefacto localmente

```bash
mvn install
```

Construye el proyecto e instala su artefacto en el repositorio Maven local.

Esto permite que otros proyectos Maven del mismo ordenador puedan utilizarlo como dependencia.

#### Resumen de comandos

| Comando | Resultado |
|---|---|
| `mvn -version` | Consulta la versión de Maven. |
| `mvn clean` | Elimina resultados de construcción. |
| `mvn compile` | Compila las clases de producción. |
| `mvn test` | Ejecuta las pruebas. |
| `mvn package` | Genera el artefacto. |
| `mvn clean package` | Limpia y construye el proyecto. |
| `mvn install` | Instala el artefacto en el repositorio local. |

### 10. ¿Qué contiene el JAR generado?

Un archivo **JAR (Java Archive)** permite agrupar clases compiladas y recursos Java.

Un JAR estándar de Maven puede contener:

- Archivos `.class` compilados.
- Recursos del proyecto.
- Información de empaquetado.
- Metadatos Maven.

Sin embargo, no suele incluir automáticamente todas las dependencias externas.

!!! warning "El JAR no incluye automáticamente todas las dependencias"
    Si nuestro proyecto utiliza MySQL Connector/J, el controlador debe estar disponible durante la ejecución.

    Para crear un JAR que incorpore dependencias externas es necesario utilizar una configuración específica de empaquetado.

    En esta unidad ejecutaremos normalmente los proyectos desde Maven o desde el IDE.

### 11. Maven y los entornos de desarrollo

Los principales IDE de Java permiten trabajar con proyectos Maven.

En VS Code, Eclipse o IntelliJ IDEA podemos:

- Abrir un proyecto que contiene `pom.xml`.
- Consultar las dependencias.
- Ejecutar comandos Maven.
- Compilar el proyecto.
- Ejecutar pruebas.
- Actualizar la configuración cuando cambia el POM.

!!! tip "Recomendación"
    Aunque el IDE permita realizar estas operaciones mediante botones o menús, es importante conocer los comandos básicos de Maven.

    De esta forma podremos trabajar también desde una terminal y comprender mejor cómo se construye el proyecto.
