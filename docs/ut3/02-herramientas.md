
# 3.2. Herramientas para desarrollar componentes Java

Para desarrollar componentes de acceso a datos utilizaremos diferentes herramientas que nos permitirán **escribir, organizar, compilar, probar, documentar y distribuir** nuestro código Java.

En este apartado conoceremos las herramientas principales y los conceptos básicos de **Apache Maven**. Su explicación detallada está disponible en el **[anexo de Maven](../anexo_maven.md)**.

## 1. Herramientas del entorno de desarrollo

| Herramienta | Función en la UT3 |
|---|---|
| **JDK 21** | Compilar y ejecutar código Java. |
| **VS Code, Eclipse o IntelliJ IDEA** | Editar, ejecutar y depurar programas. |
| **Apache Maven** | Gestionar dependencias, compilar, probar y empaquetar proyectos. |
| **JUnit 5** | Automatizar pruebas unitarias. |
| **MySQL Connector/J** | Permitir el acceso a MySQL mediante JDBC. |
| **Git** | Registrar cambios y facilitar el trabajo colaborativo. |
| **Javadoc** | Generar documentación de las clases e interfaces públicas. |

Estas herramientas cumplen funciones diferentes y pueden utilizarse conjuntamente.

Por ejemplo, podemos escribir una clase Java en VS Code, utilizar Maven para compilar el proyecto, JUnit para ejecutar pruebas y Git para registrar los cambios.

## 2. Maven: conceptos esenciales

**Apache Maven** es una herramienta que organiza y automatiza la construcción de proyectos Java. En la UT3 lo utilizaremos para **gestionar bibliotecas**, **compilar**, **ejecutar pruebas** y **generar un JAR**.

- **`pom.xml`:** archivo XML de la raíz del proyecto que identifica el proyecto, declara dependencias y establece su configuración.
- **Dependencias:** bibliotecas externas que Maven descarga y gestiona, como MySQL Connector/J o JUnit 5.
- **Estructura estándar:** `src/main/java` contiene el código de la aplicación; `src/test/java`, las pruebas; y `target/`, los resultados generados.
- **Ciclo de vida:** Maven organiza la construcción en fases como `compile`, `test` y `package`.

### Comandos que utilizaremos

Desde la carpeta que contiene `pom.xml`:

```bash
mvn -version
mvn clean compile
mvn test
mvn package
```

| Comando | Para qué sirve |
|---|---|
| `mvn -version` | Comprueba la versión de Maven y el Java que utiliza. |
| `mvn clean compile` | Limpia los resultados anteriores y compila el proyecto. |
| `mvn test` | Ejecuta las pruebas configuradas. |
| `mvn package` | Genera el artefacto del proyecto, normalmente un JAR. |

!!! note "Ampliación: anexo de Maven"
    Si necesitas instalar o configurar Maven, comprender el `pom.xml`, consultar el árbol de directorios, gestionar dependencias o conocer otras fases y comandos, revisa el **[Anexo · Apache Maven para proyectos Java](../anexo_maven.md)**.

## 3. Paquetes y modificadores de acceso en Java

Los paquetes permiten organizar las clases e interfaces Java según su responsabilidad.

En la UT3 utilizaremos paquetes diferentes para separar, por ejemplo:

- El modelo de datos.
- Las interfaces de acceso a datos.
- Las implementaciones de persistencia.
- La aplicación que utiliza los componentes.

Ejemplo de declaración de paquete:

```java
package es.iesisidra.productos.dao;

public interface ProductoDAO {
    // Contrato público del componente.
}
```

En este ejemplo:

- `package` indica el paquete al que pertenece la interfaz.
- `public` permite utilizar la interfaz desde otros paquetes.

### 3.1. Modificadores de acceso

Java proporciona diferentes niveles de visibilidad.

| Modificador | Accesibilidad |
|---|---|
| `public` | Desde cualquier clase que pueda acceder al tipo. |
| `protected` | Desde el mismo paquete y desde subclases según las reglas de Java. |
| Sin modificador | Desde clases del mismo paquete. |
| `private` | Dentro de la propia clase. |

En el diseño de componentes es importante **exponer únicamente las operaciones necesarias** y ocultar los detalles internos.

Por ejemplo, una interfaz DAO puede ser pública, mientras que los atributos internos de una implementación suelen declararse privados.

Esto favorece la **encapsulación** y reduce el acoplamiento.

## 4. Herramientas de construcción, pruebas y ejecución

Es importante distinguir las funciones de las herramientas utilizadas durante el desarrollo.

| Herramienta | Función principal |
|---|---|
| **JDK** | Proporciona el compilador y las herramientas de Java. |
| **IDE** | Facilita la escritura, ejecución y depuración del código. |
| **Maven** | Gestiona dependencias y automatiza la construcción. |
| **JUnit 5** | Permite comprobar el comportamiento mediante pruebas. |
| **MySQL Connector/J** | Proporciona el controlador JDBC necesario para acceder a MySQL. |
| **Javadoc** | Genera documentación de la API. |
| **Git** | Controla las versiones del código fuente. |

Por ejemplo, en una aplicación que guarda productos en MySQL:

1. Escribimos el código Java en el IDE.
2. Maven gestiona las dependencias.
3. El JDK compila las clases.
4. JUnit permite ejecutar pruebas.
5. MySQL Connector/J permite establecer la conexión JDBC durante la ejecución.
6. Maven genera el JAR del proyecto.
7. Git registra la evolución del código.

Cada herramienta participa en una parte diferente del proceso.

## 5. Actividad guiada: exploración de un proyecto Maven

En esta actividad conoceremos la organización de un proyecto Maven y ejecutaremos las principales operaciones de construcción.

### Parte A. Exploración del proyecto

1. Descarga el proyecto de la UT3 y ábrelo en tu IDE.
2. Localiza el archivo `pom.xml`.
3. Identifica los directorios `src/main/java` y `src/test/java`.
4. Comprueba qué paquetes Java contiene el proyecto.
5. Localiza las dependencias declaradas en el POM.

### Parte B. Comprobación del entorno

Ejecuta:

```bash
java -version
javac -version
mvn -version
```

Comprueba que el proyecto utiliza JDK 21.

### Parte C. Construcción del proyecto

Ejecuta los siguientes comandos desde la raíz del proyecto:

```bash
mvn clean
mvn compile
mvn test
mvn package
```

Observa los mensajes de la terminal y comprueba qué archivos se generan en `target/`.

### Parte D. Análisis de resultados

Responde a las siguientes cuestiones:

1. ¿Para qué sirve el archivo `pom.xml`?
2. ¿Qué diferencia existe entre `src/main/java` y `src/test/java`?
3. ¿Qué ocurre al ejecutar `mvn clean`?
4. ¿Dónde se almacenan los archivos `.class` compilados?
5. ¿Qué archivo genera `mvn package`?
6. ¿Qué diferencia existe entre una dependencia de producción y una dependencia de pruebas?
7. ¿Por qué Maven facilita el trabajo en proyectos desarrollados por varios programadores?

### Parte E. Identificación de herramientas

Elabora una tabla con las herramientas utilizadas en el proyecto.

Para cada herramienta, indica:

- Nombre.
- Función principal.
- Ejemplo de utilización.

**Evidencia CE b):** identificación de las herramientas de desarrollo de componentes, explicación de su finalidad y utilización básica dentro de un proyecto Java.
