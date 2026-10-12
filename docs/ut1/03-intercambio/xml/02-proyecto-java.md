# Proyecto de ejemplos XML con Java 21

El proyecto Maven acompaña los apartados de **XML**, **analizadores DOM/SAX/JAXB** y **XPath** de esta unidad.

[**Descargar el proyecto completo XML con Java**](../../../descargas/ut1/java-xml/java-xml-ejemplos.zip)

## Preparación

1. Descarga y descomprime `java-xml-ejemplos.zip`.
2. Abre la carpeta `java-xml-ejemplos` en VS Code.
3. Utiliza **JDK 21**. Maven descarga automáticamente las dependencias JAXB del `pom.xml`.
4. Abre el fichero `data/alumnos.xml` para identificar la raíz, los elementos `alumno` y sus atributos.
5. Ejecuta las clases de `app` desde la raíz del proyecto.

## Estructura de paquetes

```text
src/main/java/com/example/xml/
├── model/
│   └── Alumno.java
├── config/
│   └── XmlConfig.java
├── repository/
│   └── AlumnoXmlRepository.java
└── app/
    ├── LeerXML_DOM.java
    ├── ModificarXML_DOM.java
    ├── ManejadorAlumnos.java
    ├── LeerXML_SAX.java
    ├── ConsultarXPath.java
    └── JaxbEjemplo.java
```

`model` define el objeto que se intercambia con JAXB; `config` crea analizadores DOM y SAX con restricciones de seguridad; `repository` encapsula la lectura y escritura DOM; `app` reúne los programas de demostración. **No es necesario un MVC completo** para estos ejemplos introductorios.

## Orden recomendado

| Orden | Clase o fichero | Objetivo |
| --- | --- | --- |
| 1 | `data/alumnos.xml` | Entender la estructura XML |
| 2 | `config/XmlConfig.java` y `repository/AlumnoXmlRepository.java` | Comprender configuración segura, `Path`, `Files` y `try-with-resources` |
| 3 | `app/LeerXML_DOM.java` | Leer y recorrer el árbol DOM |
| 4 | `app/ModificarXML_DOM.java` | Modificar nodos y guardar `data/alumnos_modificado.xml` |
| 5 | `app/ManejadorAlumnos.java` y `app/LeerXML_SAX.java` | Comprender eventos y leer con SAX |
| 6 | `app/ConsultarXPath.java` | Filtrar alumnos por edad |
| 7 | `model/Alumno.java` y `app/JaxbEjemplo.java` | Convertir entre objetos Java y XML |

El **README.md** del proyecto incluye una guía ampliada y preguntas de autoevaluación.

## Buenas prácticas aplicadas

- **Java 21 y Maven** para gestionar JAXB.
- **Separación de responsabilidades** entre modelo, configuración, persistencia y demostraciones.
- **`try-with-resources`** para cerrar flujos de entrada y salida.
- **UTF-8** para los XML generados.
- **Configuración de seguridad XML** para evitar la lectura de entidades externas y DTD (XXE) en DOM y SAX.
- **Gestión de errores** con mensajes comprensibles.

!!! note "Archivos generados"
    `ModificarXML_DOM` y `JaxbEjemplo` crean nuevos ficheros en `data/`. No modifican el documento de entrada `data/alumnos.xml`.
