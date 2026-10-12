# SAX · Lectura de XML mediante eventos

SAX (*Simple API for XML*) analiza el documento secuencialmente y comunica los eventos a un **manejador** (*handler*). A diferencia de DOM, no necesita construir un árbol completo en memoria.

## Cómo funciona

```text
data/alumnos.xml
       ↓
     SAXParser
       ↓
  ManejadorAlumnos
       ├── startElement()  → se abre una etiqueta
       ├── characters()    → llega contenido de texto
       └── endElement()    → se cierra una etiqueta
```

Es útil para lectura secuencial de documentos grandes, pero no facilita modificar nodos o navegar libremente por el documento.

## Paso 1. Leer `ManejadorAlumnos.java`

Abre `app/ManejadorAlumnos.java`. Esta clase extiende `DefaultHandler` y sobrescribe tres métodos:

```java
@Override
public void startElement(String uri, String localName,
                         String qName, Attributes attributes) {
    texto.setLength(0);
    if ("alumno".equals(qName)) {
        System.out.println("Alumno " + attributes.getValue("id"));
    }
}

@Override
public void characters(char[] ch, int start, int length) {
    texto.append(ch, start, length);
}

@Override
public void endElement(String uri, String localName, String qName) {
    if ("nombre".equals(qName) || "edad".equals(qName)) {
        System.out.println("  " + qName + ": " + texto.toString().trim());
    }
    texto.setLength(0);
}
```

El `StringBuilder texto` acumula fragmentos. **`characters()` puede invocarse varias veces para una misma etiqueta**; por eso no debemos dar por hecho que una llamada contiene todo el texto.

El manejador del proyecto está diseñado para la estructura sencilla de `alumnos.xml` (elementos `nombre` y `edad` sin etiquetas anidadas). Para XML con contenido mixto o anidamiento complejo habría que llevar un estado o una pila de elementos.

## Paso 2. Ejecutar `LeerXML_SAX.java`

El programa configura el analizador a través de `XmlConfig` y abre el fichero con cierre automático:

```java
try (var entrada = Files.newInputStream(Path.of("data/alumnos.xml"))) {
    var analizador = XmlConfig.saxFactory().newSAXParser();
    analizador.parse(entrada, new ManejadorAlumnos());
}
```

`XmlConfig.saxFactory()` desactiva DTD y entidades externas, reduciendo el riesgo de ataques XXE.

### Resultado esperado

```text
Alumno A001
  nombre: Ana
  edad: 20
Alumno A002
  nombre: Luis
  edad: 22
Alumno A003
  nombre: Marta
  edad: 19
```

## DOM frente a SAX

| Característica | DOM | SAX |
|---|---|---|
| Modelo | Árbol de nodos | Eventos secuenciales |
| Memoria | Mayor para documentos grandes | Menor |
| Navegación | Flexible | Secuencial |
| Modificación | Sí | No directamente |
| Proyecto | `LeerXML_DOM` | `LeerXML_SAX` |

**Actividad:** añade un alumno al XML y comprueba cómo se muestran los eventos. Después explica por qué `ManejadorAlumnos` no tiene método `main`.

[Descarga y guía del proyecto XML](../03-intercambio/xml/02-proyecto-java.md).
