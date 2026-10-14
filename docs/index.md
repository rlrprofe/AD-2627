
# Acceso a Datos – 2.º DAM

Bienvenidos al espacio de materiales didácticos del módulo profesional **Acceso a Datos**, correspondiente al segundo curso del ciclo formativo de grado superior de **Desarrollo de Aplicaciones Multiplataforma (DAM)**.

En este sitio encontrarás contenidos teóricos, ejemplos de código, actividades prácticas y proyectos para trabajar durante el curso 2026-2027.

El objetivo del módulo es aprender a desarrollar aplicaciones que permitan **almacenar, consultar, modificar y recuperar información**, utilizando diferentes mecanismos de persistencia.

---

## Unidades de trabajo

### UT1 · Ficheros y formatos de intercambio de datos

En esta unidad estudiaremos el acceso a ficheros y el tratamiento de diferentes formatos de intercambio de información.

**Contenidos:**

- Ficheros, directorios y flujos de entrada y salida.
- Gestión de excepciones.
- Serialización de objetos Java.
- Tratamiento de JSON con Java y Python.
- Documentos XML y analizadores DOM, SAX y JAXB.
- Consultas XPath.
- Conversión entre XML y JSON.

[:material-arrow-right-circle: Acceder a la UT1](ut1/index.md){ .md-button }

---

### UT2 · Conexión a bases de datos relacionales (JDBC)

Aprenderemos a desarrollar aplicaciones Java que accedan a bases de datos relacionales mediante **JDBC (Java Database Connectivity)**.

Trabajaremos principalmente con Java y MySQL.

**Contenidos:**

- Conceptos y fundamentos de JDBC.
- Configuración de conexiones a MySQL.
- Ejecución de sentencias SQL DDL y DML.
- Consultas y procesamiento de resultados con `ResultSet`.
- Uso de `PreparedStatement`.
- Gestión de transacciones.
- Control de excepciones y liberación de recursos.
- Buenas prácticas de acceso a datos.
- Ejercicios y aplicaciones prácticas.

[:material-arrow-right-circle: Acceder a la UT2](ut2/index.md){ .md-button }

---

### UT3 · Diseño y desarrollo de componentes de acceso a datos

En esta unidad aprenderemos a diseñar y construir **componentes Java reutilizables**, separando el acceso a los datos del resto de la aplicación.

Utilizaremos como hilo conductor una aplicación de **Gestión de inventario**, que desarrollaremos progresivamente con dos mecanismos de persistencia: ficheros CSV y bases de datos MySQL.

**Contenidos:**

- Introducción a la programación orientada a componentes.
- Herramientas de desarrollo: JDK 21, IDE y Apache Maven.
- Organización de proyectos Java.
- Arquitectura por capas.
- Interfaces y patrón DAO (*Data Access Object*).
- Componentes de acceso a ficheros.
- Componentes de acceso a bases de datos mediante JDBC.
- Pruebas unitarias con JUnit.
- Documentación de componentes.
- Integración, reutilización y empaquetado JAR.

#### Proyecto práctico: Gestión de inventario

A lo largo de la unidad construiremos una aplicación Java que permita registrar, consultar, modificar y eliminar productos.

El proyecto se desarrollará por etapas:

1. Preparación del proyecto Maven.
2. Diseño del modelo y de la interfaz DAO.
3. Implementación del acceso a ficheros CSV.
4. Implementación del acceso a MySQL mediante JDBC.
5. Pruebas, documentación e integración.
6. Generación del componente distribuible.

El alumnado dispondrá de un proyecto inicial descargable para realizar el desarrollo guiado.

[:material-arrow-right-circle: Acceder a la UT3](ut3/index.md){ .md-button }

---

## Anexos y recursos complementarios

### Anexo · Apache Maven

Apache Maven es una herramienta de automatización utilizada en proyectos Java para gestionar dependencias, compilar código, ejecutar pruebas y generar artefactos distribuibles.

**Contenidos del anexo:**

- Introducción a Maven.
- Recursos de aprendizaje.
- Instalación y configuración.
- Estructura de proyectos Maven.
- El archivo `pom.xml`.
- Configuración básica de proyectos Java 21.
- Gestión de dependencias.
- Ciclo de vida de Maven.
- Comandos esenciales.
- Generación de archivos JAR.
- Integración con entornos de desarrollo.

[:material-arrow-right-circle: Acceder al Anexo de Apache Maven](anexo-maven/index.md){ .md-button }

---

## Metodología de trabajo

El aprendizaje combinará explicaciones teóricas, ejemplos de código y actividades prácticas.

Utilizaremos principalmente las siguientes herramientas:

| Herramienta | Utilización |
|---|---|
| **Java 21** | Desarrollo de aplicaciones y componentes. |
| **Visual Studio Code** | Edición, compilación y depuración de código. |
| **Apache Maven** | Gestión de proyectos, dependencias y construcción de artefactos. |
| **MySQL** | Gestión de bases de datos relacionales. |
| **Git y GitHub** | Control de versiones y gestión de proyectos. |
| **JUnit** | Pruebas unitarias automatizadas. |

En las distintas unidades encontrarás proyectos descargables, ejemplos resueltos y ejercicios para consolidar los conocimientos adquiridos.

---

**Acceso a Datos – 2.º DAM**

IES Isidra de Guzmán · Alcalá de Henares

Curso 2026-2027
