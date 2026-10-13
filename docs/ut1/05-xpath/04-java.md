# XPath desde Java

XPath permite seleccionar nodos o valores dentro de un documento XML mediante **expresiones de consulta**. En el proyecto Maven utilizamos DOM para cargar el XML y XPath para localizar los alumnos que cumplen una condición.

## Clases principales

| Clase o interfaz | Función |
|---|---|
| `Document` | Representa el documento XML cargado en memoria con DOM. |
| `XPathFactory` | Crea el evaluador XPath. |
| `XPath` | Evalúa expresiones sobre un documento o nodo. |
| `XPathExpression` | Representa una expresión previamente compilada. |
| `XPathConstants` | Define el tipo de resultado esperado. |
| `Node`, `NodeList` | Representan uno o varios nodos devueltos. |

### Flujo general

1. Abrir y analizar el XML mediante DOM.
2. Crear un objeto `XPath`.
3. Escribir o compilar la expresión XPath.
4. Evaluarla indicando el tipo de resultado.
5. Comprobar y procesar el resultado.

El XML debe abrirse con una configuración segura que impida el acceso no autorizado a entidades y recursos externos. El proyecto existente encapsula esta responsabilidad en `XmlConfig`.

## Documento y ejemplo

El fichero `data/alumnos.xml` contiene tres alumnos: Ana (20), Luis (22) y Marta (19).

La expresión:

```xpath
//alumno[edad > 20]
```

selecciona los elementos `alumno` cuyo elemento hijo `edad` tiene un valor numérico superior a 20. En nuestros datos solo coincide **Luis**.

## Paso 1. Cargar el XML

Abre `app/ConsultarXPath.java`:

```java
Document documento = new AlumnoXmlRepository()
    .leer(Path.of("data/alumnos.xml"));
```

El repositorio utiliza la configuración DOM segura de `XmlConfig`, de modo que el programa de consultas no necesita repetir la apertura y el análisis del fichero.

## Paso 2. Crear un evaluador XPath

```java
XPath xpath = XPathFactory.newInstance().newXPath();
```

## Paso 3. Ejecutar una consulta que devuelve nodos

```java
NodeList mayores = (NodeList) xpath.evaluate(
    "//alumno[edad > 20]",
    documento,
    XPathConstants.NODESET
);
```

`XPathConstants.NODESET` indica que esperamos una colección de nodos. Después se recorren los resultados:

```java
for (int i = 0; i < mayores.getLength(); i++) {
    Element alumno = (Element) mayores.item(i);
    System.out.println(
        alumno.getElementsByTagName("nombre")
              .item(0).getTextContent()
    );
}
```

### Resultado esperado

```text
Luis
```

## Otros tipos de resultado

| Constante | Tipo Java |
|---|---|
| `XPathConstants.STRING` | `String` |
| `XPathConstants.NUMBER` | `Double` |
| `XPathConstants.BOOLEAN` | `Boolean` |
| `XPathConstants.NODE` | `Node` |
| `XPathConstants.NODESET` | `NodeList` |

Por ejemplo, para contar alumnos:

```java
Double total = (Double) xpath.evaluate(
    "count(//alumno)", documento, XPathConstants.NUMBER
);
System.out.println(total); // 3.0
```

Para reutilizar una consulta:

```java
XPathExpression consulta = xpath.compile("//alumno[edad > 20]");
NodeList lista = (NodeList) consulta.evaluate(
    documento, XPathConstants.NODESET
);
```

## Ejemplos equivalentes sobre el catálogo de productos

En las páginas anteriores hemos utilizado `catalogo.xml` para estudiar las expresiones. Si se carga ese documento en una variable `Document catalogo`, las mismas consultas pueden ejecutarse desde Java:

```java
XPath xpathCatalogo = XPathFactory.newInstance().newXPath();

// Consultar el nombre del producto P02 como texto.
String nombre = (String) xpathCatalogo.evaluate(
    "string(//producto[@id='P02']/nombre)",
    catalogo,
    XPathConstants.STRING
);
System.out.println(nombre); // Ratón inalámbrico

// Contar productos con precio superior a 40.
Double cantidad = (Double) xpathCatalogo.evaluate(
    "count(//producto[precio > 40])",
    catalogo,
    XPathConstants.NUMBER
);
System.out.println(cantidad.intValue()); // 2
```

Este fragmento es **ilustrativo**: `catalogo` debe contener previamente el XML cargado mediante DOM. El proyecto descargable del sitio trabaja con `alumnos.xml`, por lo que no se han cambiado sus ficheros ni sus nombres.

## Errores y excepciones habituales

- `XPathExpressionException`: expresión mal formada o función no compatible con XPath 1.0.
- `ClassCastException`: el resultado no se ha convertido al tipo Java adecuado.
- `NullPointerException`: se intenta utilizar un nodo que no existe; comprueba los resultados antes de acceder a ellos.
- Consulta vacía: revisa el contexto, la ruta, los atributos y los espacios de nombres del XML.

## Buenas prácticas

- Mantén la apertura del XML en el repositorio y las consultas en la aplicación.
- Usa `XPathConstants` cuando necesites un tipo de resultado concreto.
- Comprueba si una consulta puede devolver cero resultados.
- No confundas una **expresión XPath** con una ruta de fichero del sistema.

**Actividad:** cambia la expresión para seleccionar alumnos de 20 años o más. ¿Qué nombres aparecen? Prueba también `count(//alumno)`.

[Guía y descarga del proyecto XML](../03-intercambio/xml/02-proyecto-java.md).
