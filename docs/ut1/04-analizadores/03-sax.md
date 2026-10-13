# SAX · Lectura de XML mediante eventos

## 1. ¿Qué es SAX?

SAX (*Simple API for XML*) es un analizador **secuencial y basado en eventos**. A diferencia de DOM, no construye un árbol completo: mientras procesa el documento, **avisa a nuestro programa** de que ha comenzado una etiqueta, ha encontrado texto o ha terminado un elemento.

No debemos decir que SAX lee necesariamente «línea a línea»: el parser analiza el flujo XML y puede notificar eventos independientemente de los saltos de línea.

## 2. ¿Qué ocurre al leer un alumno?

Para este fragmento:

```xml
<alumno id="A001"><nombre>Ana</nombre><edad>20</edad></alumno>
```

El parser puede comunicar esta secuencia (simplificada):

| Orden | Evento | Información recibida |
|---:|---|---|
| 1 | `startElement()` | Apertura de `alumno`, atributo `id="A001"` |
| 2 | `startElement()` | Apertura de `nombre` |
| 3 | `characters()` | Texto `Ana` |
| 4 | `endElement()` | Cierre de `nombre` |
| 5 | `startElement()` | Apertura de `edad` |
| 6 | `characters()` | Texto `20` |
| 7 | `endElement()` | Cierre de `edad` |
| 8 | `endElement()` | Cierre de `alumno` |

Además, existen los eventos `startDocument()` y `endDocument()` para el documento completo. La tabla simplifica la lectura: **el evento `characters()` puede producirse más de una vez** para un mismo texto, y también pueden aparecer eventos para espacios de formato.

```text
XML → SAXParser → ManejadorAlumnos (DefaultHandler)
                     ├── startElement()
                     ├── characters()
                     └── endElement()
```

## 3. Clases principales

| Clase o interfaz | Responsabilidad |
|---|---|
| `SAXParserFactory` | Configura y crea analizadores SAX |
| `SAXParser` | Analiza el documento y produce eventos |
| `DefaultHandler` | Clase base que podemos extender para reaccionar a eventos |
| `Attributes` | Permite consultar atributos de una etiqueta |

El manejador **no necesita `main`**: lo llama el analizador SAX cuando se producen eventos.

## 4. Paso 1. Estudiar `ManejadorAlumnos.java`

Abre `app/ManejadorAlumnos.java`:

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

- `startElement()` reconoce la etiqueta y permite consultar los atributos.
- `characters()` acumula fragmentos en `StringBuilder texto`.
- `endElement()` muestra el valor cuando termina la etiqueta.

!!! warning "Limitación del manejador de ejemplo"
    El código está pensado para `alumnos.xml`, con campos simples `nombre` y `edad`. Para contenido mixto o etiquetas anidadas dentro de esos campos sería necesario gestionar mejor el estado y la acumulación de texto, por ejemplo con una pila.

## 5. Paso 2. Ejecutar `LeerXML_SAX.java`

El programa crea el parser configurado y le entrega el manejador:

```java
try (var entrada = Files.newInputStream(Path.of("data/alumnos.xml"))) {
    var analizador = XmlConfig.saxFactory().newSAXParser();
    analizador.parse(entrada, new ManejadorAlumnos());
}
```

`XmlConfig.saxFactory()` rechaza DTD y entidades externas, reduciendo el riesgo XXE. `try-with-resources` cierra el flujo al terminar.

**Resultado esperado:**

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

## 6. Ventajas, limitaciones y usos

| Ventajas | Limitaciones |
|---|---|
| No almacena todo el árbol XML | No permite retroceder libremente |
| Adecuado para ficheros grandes y flujos | Hay que mantener estado para relacionar datos |
| Permite procesar registros conforme llegan | No modifica el XML de entrada directamente |

**Cuándo elegirlo:** importación de registros, análisis de ficheros grandes y procesamiento secuencial sin necesidad de modificar la estructura XML.

## 7. Actividades

1. Añade un alumno y comprueba que el programa lo muestra.
2. Identifica qué método se ejecuta al encontrar el atributo `id`.
3. Explica por qué `characters()` usa `append()` en lugar de sustituir el texto anterior.
4. Razona por qué SAX no ofrece un equivalente directo a `getElementsByTagName()`.

Continúa con **[JAXB](04-jaxb.md)** o consulta la [guía del proyecto XML](../03-intercambio/xml/02-proyecto-java.md).
