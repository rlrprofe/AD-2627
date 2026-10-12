# XPath desde Java

XPath permite seleccionar nodos o valores dentro de un documento XML mediante **expresiones de consulta**. En el proyecto Maven utilizamos DOM para cargar el XML y XPath para localizar los alumnos que cumplen una condición.

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

## Buenas prácticas

- Mantén la apertura del XML en el repositorio y las consultas en la aplicación.
- Usa `XPathConstants` cuando necesites un tipo de resultado concreto.
- Comprueba si una consulta puede devolver cero resultados.
- No confundas una **expresión XPath** con una ruta de fichero del sistema.

**Actividad:** cambia la expresión para seleccionar alumnos de 20 años o más. ¿Qué nombres aparecen? Prueba también `count(//alumno)`.

[Guía y descarga del proyecto XML](../03-intercambio/xml/02-proyecto-java.md).
