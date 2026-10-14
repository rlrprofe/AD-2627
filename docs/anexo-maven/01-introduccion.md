# 1. ¿Qué es Maven?

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
