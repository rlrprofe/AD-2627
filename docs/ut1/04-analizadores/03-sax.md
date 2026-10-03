# SAX · Lectura mediante eventos

SAX no construye un árbol completo. El parser recorre el documento y genera **eventos**.

## Flujo

```text
XML
 │
 ▼
SAXParser
 │
 ├── startDocument()
 ├── startElement()
 ├── characters()
 ├── endElement()
 └── endDocument()
```

## Crear el parser

```java
SAXParserFactory factory = SAXParserFactory.newInstance();
SAXParser parser = factory.newSAXParser();

parser.parse(new File("resources/alumnos.xml"),
             new ManejadorAlumnos());
```

## Handler

```java
public class ManejadorAlumnos extends DefaultHandler {

    @Override
    public void startElement(
            String uri, String localName,
            String qName, Attributes attributes) {

        if (qName.equals("alumno")) {
            System.out.println("ID: " + attributes.getValue("id"));
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {
        String texto = new String(ch, start, length).trim();

        if (!texto.isEmpty()) {
            System.out.println(texto);
        }
    }
}
```

!!! warning
    `characters()` puede ejecutarse varias veces para un mismo contenido. No debemos asumir que recibiremos todo el texto en una única llamada.

## DOM frente a SAX

SAX consume poca memoria y es adecuado para documentos grandes, pero no ofrece un árbol que podamos recorrer hacia atrás o modificar cómodamente.
