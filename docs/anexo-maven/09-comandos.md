# 9. Comandos esenciales de Maven

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
