# Conversión XML → JSON

## Proceso general

```text
XML → lectura/parser → estructura intermedia → objeto JSON → JSON
```

En una conversión manual podemos leer el XML mediante DOM, SAX o XPath y construir después el JSON.

```java
JsonObject clienteJson = new JsonObject();

clienteJson.addProperty("id", id);
clienteJson.addProperty("nombre", nombre);
clienteJson.addProperty("edad", edad);
```

El punto importante es decidir cómo traducimos la estructura XML a propiedades y arrays JSON.

## Ejemplos del proyecto

- `XmlToJsonManual1`
- `XmlToJsonManual2`
- `XmlToJsonManual3`
