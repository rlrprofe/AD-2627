# XPath desde Java

## 1. Cargar el XML con DOM

```java
DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
DocumentBuilder builder = factory.newDocumentBuilder();
Document doc = builder.parse(new File("resources/catalogo.xml"));
```

## 2. Crear el evaluador

```java
XPathFactory xpathFactory = XPathFactory.newInstance();
XPath xpath = xpathFactory.newXPath();
```

## 3. Obtener un texto

```java
String nombre = xpath.evaluate(
    "//producto[1]/nombre/text()",
    doc
);
```

## 4. Obtener varios nodos

```java
NodeList lista = (NodeList) xpath.evaluate(
    "//producto[precio > 50]",
    doc,
    XPathConstants.NODESET
);
```

## 5. Tipos de resultado

| Constante | Resultado |
|---|---|
| `XPathConstants.STRING` | `String` |
| `XPathConstants.NUMBER` | `Double` |
| `XPathConstants.BOOLEAN` | `Boolean` |
| `XPathConstants.NODE` | `Node` |
| `XPathConstants.NODESET` | `NodeList` |

## 6. Compilar y reutilizar

```java
XPathExpression expr =
    xpath.compile("//producto[precio > 50]/nombre/text()");

NodeList lista = (NodeList)
    expr.evaluate(doc, XPathConstants.NODESET);
```

## Ejemplos del proyecto

1. `Example01Catalogo`
2. `Example02TiposResultado`
3. `Example03Contexto`
4. `Example04Metricas`
5. `Example05TextoYLimpieza`
