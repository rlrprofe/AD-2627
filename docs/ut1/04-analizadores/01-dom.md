# DOM · Lectura y navegación de XML

DOM (*Document Object Model*) representa un documento XML como un **árbol de nodos en memoria**. Permite consultar elementos, atributos y contenido, y resulta adecuado para documentos pequeños o medianos que necesitemos recorrer o modificar.

## Documento de partida

El proyecto incluye `data/alumnos.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<alumnos>
  <alumno id="A001"><nombre>Ana</nombre><edad>20</edad></alumno>
  <alumno id="A002"><nombre>Luis</nombre><edad>22</edad></alumno>
  <alumno id="A003"><nombre>Marta</nombre><edad>19</edad></alumno>
</alumnos>
```

La raíz es `alumnos`; cada elemento `alumno` tiene un atributo `id` y dos elementos hijos: `nombre` y `edad`.

## Flujo de lectura

```text
data/alumnos.xml
   ↓ Files.newInputStream()
DocumentBuilderFactory → DocumentBuilder
   ↓ parse()
Document → NodeList → Element → atributos y texto
```

En el proyecto separamos dos responsabilidades:

- **`config/XmlConfig.java`** crea una fábrica DOM configurada para rechazar DTD y entidades externas, evitando problemas de seguridad XXE.
- **`repository/AlumnoXmlRepository.java`** abre el fichero con `Path` y `Files`, usa `try-with-resources` y devuelve un `Document`.

Este es el fragmento principal del repositorio:

```java
try (InputStream entrada = Files.newInputStream(ruta)) {
    Document documento = XmlConfig.domFactory()
        .newDocumentBuilder()
        .parse(entrada);
    documento.getDocumentElement().normalize();
    return documento;
}
```

El flujo se cierra automáticamente incluso si el análisis del XML produce un error. `normalize()` normaliza los nodos de texto del árbol; **no valida** el documento.

## Recorrer los alumnos: `LeerXML_DOM.java`

Abre `app/LeerXML_DOM.java`. El programa recupera todos los elementos llamados `alumno` y los recorre:

```java
Document documento = new AlumnoXmlRepository()
    .leer(Path.of("data/alumnos.xml"));

NodeList lista = documento.getElementsByTagName("alumno");
for (int i = 0; i < lista.getLength(); i++) {
    Element alumno = (Element) lista.item(i);
    String id = alumno.getAttribute("id");
    String nombre = alumno.getElementsByTagName("nombre")
                          .item(0).getTextContent();
    int edad = Integer.parseInt(
        alumno.getElementsByTagName("edad").item(0).getTextContent()
    );
    System.out.printf("%s - %s - %d%n", id, nombre, edad);
}
```

`NodeList` no es una lista de objetos `Alumno`: contiene nodos DOM. `getAttribute()` obtiene un atributo, mientras que `getTextContent()` obtiene el texto de un elemento. La conversión con `Integer.parseInt()` es necesaria porque el XML contiene texto.

### Resultado esperado

```text
A001 - Ana - 20
A002 - Luis - 22
A003 - Marta - 19
```

## Clases principales

| Clase | Función |
|---|---|
| `DocumentBuilderFactory` | Configura la creación del analizador |
| `DocumentBuilder` | Analiza el flujo XML |
| `Document` | Árbol completo del documento |
| `Node` | Nodo genérico del árbol |
| `Element` | Nodo que representa una etiqueta |
| `NodeList` | Colección de nodos |

!!! warning "Comprobación de datos"
    El ejemplo presupone que cada alumno contiene `nombre` y `edad`, y que la edad es numérica. En aplicaciones reales debemos validar estos datos antes de acceder a `.item(0)` o convertirlos.

**Actividad:** añade un cuarto alumno a `data/alumnos.xml` y ejecuta de nuevo `LeerXML_DOM`.

Consulta también la [guía y descarga del proyecto Maven](../03-intercambio/xml/02-proyecto-java.md).
