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

---

## Antes de abrir los programas: cómo se transforma un cliente

El objetivo de los tres ejemplos es el mismo: extraer la información del XML y crear datos Java que Gson pueda serializar. Lo que cambia es **la forma de leer el XML**.

| Dato XML | Operación conceptual | Dato JSON |
|---|---|---|
| `<cliente id="C01">` | Leer el atributo `id` | `"id": "C01"` |
| `<nombre>Laura</nombre>` | Obtener el texto de `nombre` | `"nombre": "Laura"` |
| `<edad>30</edad>` | Leer texto y convertirlo a número | `"edad": 30` |
| Dos elementos `<cliente>` | Añadir dos objetos a una lista | Array con dos objetos |

### DOM: pasos de lectura

1. `DocumentBuilderFactory` prepara el analizador y sus opciones de seguridad.
2. `DocumentBuilder` analiza el XML y obtiene un `Document`.
3. `getElementsByTagName("cliente")` permite obtener los elementos de interés.
4. Para cada `Element`, `getAttribute("id")` recupera el identificador y `getTextContent()` permite obtener el texto de los hijos seleccionados.
5. Se construye una lista de datos Java y Gson genera el JSON.

No confundas **analizar XML** con **generar JSON**: son dos operaciones independientes.

### XPath: seleccionar en lugar de recorrer manualmente

Una expresión como `//cliente` selecciona los elementos cliente. Desde cada uno se pueden obtener el atributo `@id` y los elementos hijos `nombre` y `edad`. La expresión XPath **no convierte** por sí sola a JSON: devuelve nodos o valores que el programa utiliza para construir la salida.

### SAX: reconstruir datos a partir de eventos

Durante la lectura de un cliente, SAX comunica la apertura de `cliente`, la aparición de `nombre` y `edad`, sus fragmentos de texto y los cierres correspondientes. El manejador debe conservar temporalmente el cliente en construcción.

!!! important "Un detalle fundamental de SAX"
    `characters()` puede ejecutarse varias veces para el contenido de un mismo elemento. No debe suponerse que entrega todo el texto en una sola llamada. Es habitual acumular los fragmentos y procesarlos al cerrar el elemento.

## Resultado esperado y comprobación

Tras ejecutar cada clase, abre el fichero generado en `salida/` y verifica que aparecen los dos clientes y que la edad se representa como número. **El formato de sangrado puede variar sin que cambien los datos.**

### Actividad guiada

1. Añade `<cliente id="C03"><nombre>Inés</nombre><edad>21</edad></cliente>` dentro de `<clientes>`.
2. Ejecuta los tres programas y comprueba si generan tres objetos JSON.
3. Localiza en cada clase el punto exacto donde se obtiene el identificador.
4. Explica por qué SAX necesita un manejador y DOM no.
