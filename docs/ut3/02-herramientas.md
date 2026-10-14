# 3.2. Herramientas para desarrollar componentes

## Objetivos

- Preparar JDK 21, un IDE y Maven.
- Crear un proyecto Java Maven con una estructura reproducible.
- Interpretar el archivo `pom.xml` y ejecutar las primeras fases de construcción.

## 1. Herramientas del proyecto

Utilizaremos **JDK 21**, **Maven**, **VS Code con Extension Pack for Java** (o IntelliJ IDEA), **Git** y, a partir del apartado 3.5, **MySQL**.

| Herramienta | Función |
|---|---|
| JDK 21 | Compilar y ejecutar código Java. |
| Maven | Gestionar dependencias, pruebas y empaquetado. |
| IDE | Editar, ejecutar y depurar el código. |
| Git | Registrar los avances del proyecto. |
| MySQL | Almacenar los productos en la segunda implementación. |

!!! info "Anexo de consulta"
    Si necesitas repasar la instalación, la estructura de carpetas, el `pom.xml` o los comandos de Maven, consulta el [Anexo · Apache Maven](../anexo-maven/index.md).

## 2. Verificar las instalaciones

Desde una terminal:

```bash
java -version
javac -version
mvn -version
```

Comprueba que `java` y `javac` utilizan JDK 21. `mvn -version` también muestra la versión de Java que utiliza Maven.

## 3. Crear el proyecto

Nombre: `gestion-inventario`. Coordenadas Maven:

- `groupId`: `es.iesisidra`
- `artifactId`: `gestion-inventario`
- `version`: `1.0-SNAPSHOT`

Estructura inicial:

```text
gestion-inventario/
├── pom.xml
├── datos/
├── sql/
└── src/
    ├── main/java/es/iesisidra/inventario/
    └── test/java/es/iesisidra/inventario/
```

Descarga el **proyecto inicial** para comenzar con la misma estructura que utilizaremos en toda la unidad. Tendrás que ir incorporando las clases y configuraciones siguiendo los apartados siguientes.

[**Descargar proyecto inicial de Gestión de inventario (ZIP)**](../descargas/ut3/Gestion_Inventario_Inicial_Java21_Maven.zip)

## 4. Configurar `pom.xml`

Archivo: **`gestion-inventario/pom.xml`**.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>es.iesisidra</groupId>
    <artifactId>gestion-inventario</artifactId>
    <version>1.0-SNAPSHOT</version>
    <properties>
        <maven.compiler.release>21</maven.compiler.release>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
</project>
```

Este es el **punto de partida mínimo**. En 3.5 incorporaremos el driver MySQL; en 3.6, JUnit; y en 3.7, el plugin para generar un JAR ejecutable. El `pom.xml` del **proyecto inicial** contiene únicamente la configuración mínima: las dependencias y los plugins se añadirán durante la unidad.

## 5. Primera construcción

Desde la carpeta que contiene `pom.xml`:

```bash
mvn validate
mvn compile
```

En la primera ejecución Maven puede necesitar conexión a Internet para descargar plugins.

## 6. Control de versiones

```bash
git init
git add .
git commit -m "Crear estructura inicial del proyecto Maven"
```

Crea un `.gitignore` para excluir `target/`, los archivos propios del IDE y los secretos locales. No subas contraseñas de MySQL al repositorio.

## 7. Comprobación

- [ ] El IDE reconoce el JDK 21.
- [ ] Maven funciona desde la terminal.
- [ ] Existe `pom.xml` en la raíz.
- [ ] `mvn compile` finaliza correctamente.
- [ ] El proyecto está bajo control de versiones.

**Continúa con:** [3.3. Arquitectura por capas, interfaces y DAO](03-arquitectura-dao.md).
