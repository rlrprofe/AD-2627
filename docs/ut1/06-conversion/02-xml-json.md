# Conversión XML → JSON

Partimos de `resources/clientes.xml`, que contiene **Laura (30)** y **Pedro (25)**. El objetivo es obtener una lista JSON de clientes.

```text
XML → analizador XML → datos Java → Gson → fichero JSON
```

## Ejemplo 1: DOM — `XmlToJsonManual1.java`

1. Abre `conversion-manual` en VS Code.
2. Localiza `src/main/java/com/example/xmltojson/XmlToJsonManual1.java`.
3. Identifica dónde se crea `DocumentBuilderFactory` y se analiza el fichero XML.
4. Observa cómo se recorren los elementos `cliente` y se crean mapas `Map<String, Object>`.
5. Localiza `GsonBuilder` y `toJson()`, que producen el texto JSON.

DOM construye un árbol en memoria. Es apropiado cuando queremos acceder a elementos y atributos en cualquier orden.

## Ejemplo 2: XPath — `XmlToJsonManual2.java`

Este programa también utiliza DOM para cargar el documento, pero selecciona los datos con **expresiones XPath**. Compara su código con el anterior: la conversión final a JSON es similar; cambia la forma de localizar los nodos.

## Ejemplo 3: SAX — `ClienteHandler.java` y `XmlToJsonManual3.java`

Lee **primero el manejador** `xmltojson/handlers/ClienteHandler.java`. Sus métodos reciben eventos del analizador:

- `startElement()` detecta la apertura de una etiqueta y sus atributos.
- `characters()` recibe fragmentos de texto; pueden llegar en varias llamadas.
- `endElement()` permite completar los valores de cada cliente.

Después ejecuta `XmlToJsonManual3.java`, que conecta el analizador SAX con el manejador y utiliza Gson para generar JSON. SAX no construye el árbol completo, aunque el programa sí acumula la lista de clientes que desea convertir.

## Comparación

| Ejemplo | Lectura de XML | Uso principal |
|---|---|---|
| `XmlToJsonManual1` | DOM | Recorrido del árbol |
| `XmlToJsonManual2` | DOM + XPath | Selección de nodos |
| `XmlToJsonManual3` | SAX | Lectura secuencial por eventos |

### Buenas prácticas

Los analizadores DOM y SAX deben impedir la carga de DTD y entidades externas (protección XXE). La salida JSON debe usar UTF-8, y los errores de lectura o sintaxis deben tratarse explícitamente. En el proyecto revisado se han reforzado las opciones de seguridad de los analizadores existentes.

**Actividad:** añade un tercer cliente al XML y comprueba que aparece en los tres resultados.

[Descargar proyectos y consultar el orden didáctico](index.md).
