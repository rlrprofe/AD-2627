# 7. Gestión de dependencias

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
