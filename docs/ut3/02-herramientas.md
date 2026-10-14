# 3.2. Herramientas para desarrollar componentes Java

**Duración orientativa:** 2 horas · **CE b)**

## 1. Herramientas del entorno

| Herramienta | Función en la UT3 |
|---|---|
| JDK 21 | Compilar y ejecutar código Java. |
| VS Code, Eclipse o IntelliJ IDEA | Editar, ejecutar y depurar. |
| Maven | Gestionar dependencias, compilar, probar y empaquetar. |
| JUnit 5 | Automatizar pruebas unitarias. |
| MySQL Connector/J | Permitir el acceso JDBC a MySQL. |
| Git | Registrar cambios y colaborar. |
| Javadoc | Generar documentación de la API pública. |

## 2. Organización estándar de Maven

```text
mi-componente/
├── pom.xml
├── README.md
└── src/
    ├── main/
    │   └── java/
    │       └── es/iesisidra/productos/...
    └── test/
        └── java/
            └── es/iesisidra/productos/...
```

En `src/main/java` escribimos el código de producción; en `src/test/java`, las pruebas automatizadas.

## 3. Configuración básica

```xml
<properties>
    <maven.compiler.release>21</maven.compiler.release>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>
```

El proyecto descargable incluye un `pom.xml` completo, con dependencias para MySQL Connector/J y JUnit 5, además de los complementos necesarios para ejecutar pruebas y generar el JAR.

## 4. Comandos esenciales

Desde la carpeta que contiene `pom.xml`:

```powershell
mvn clean compile
mvn test
mvn package
```

- `compile`: compila las clases de producción.
- `test`: ejecuta las pruebas configuradas.
- `package`: construye el artefacto JAR, después de las fases anteriores.

!!! warning "El JAR no incluye automáticamente todas las dependencias"
    El JAR estándar de Maven contiene las clases y recursos del proyecto, pero no suele incorporar dentro el controlador MySQL. Para ejecutar una aplicación que lo necesite, las dependencias deben estar disponibles en el classpath o utilizarse un empaquetado específico. En esta unidad ejecutaremos el proyecto desde Maven o el IDE.

## 5. Paquetes y visibilidad

En Java organizamos las clases mediante `package`. Por ejemplo:

```java
package es.iesisidra.productos.dao;

public interface ProductoDAO {
    // Contrato público del componente.
}
```

`public` permite que otras partes del programa accedan a la interfaz. Los atributos de las implementaciones serán normalmente `private` para proteger sus detalles internos.

## 6. Herramientas de construcción frente a herramientas de ejecución

Maven ayuda a **construir** y gestionar el proyecto. El driver JDBC participa en su **ejecución** cuando se conecta a MySQL. JUnit se utiliza para **verificar** el comportamiento. No debemos confundir estas funciones.

## Actividad guiada

1. Descarga el proyecto de la UT3 y ábrelo en tu IDE.
2. Localiza `pom.xml`, `src/main/java` y `src/test/java`.
3. Comprueba la versión del JDK con `java -version` y la de Maven con `mvn -version`.
4. Ejecuta `mvn clean test` y explica las fases que aparecen.
5. Ejecuta `mvn package`, localiza el JAR en `target/` y explica qué contiene.
6. Identifica las dependencias que se utilizan para JDBC y para las pruebas.

**Evidencia CE b):** tabla breve con herramienta, función y ejemplo de utilización en el proyecto.
