# DOM · Lectura y navegación de XML

## 1. ¿Qué es DOM?

DOM (*Document Object Model*) representa el documento XML completo como un **árbol de nodos en memoria**. La ventaja es que podemos recorrerlo tantas veces como necesitemos, buscar elementos, modificar valores y, si procede, guardar el resultado.

Su principal inconveniente es que **carga el documento entero**: con XML muy grandes, la memoria necesaria puede ser considerable.

## 2. Documento de partida y estructura jerárquica

El proyecto incluye `data/alumnos.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<alumnos>
  <alumno id="A001"><nombre>Ana</nombre><edad>20</edad></alumno>
  <alumno id="A002"><nombre>Luis</nombre><edad>22</edad></alumno>
  <alumno id="A003"><nombre>Marta</nombre><edad>19</edad></alumno>
</alumnos>
```

El documento tiene una raíz `alumnos`; bajo ella hay tres elementos `alumno`. Cada alumno contiene un **atributo** `id`, dos **elementos hijos** (`nombre` y `edad`) y los correspondientes **nodos de texto**.

```text
Document
└── alumnos  (elemento raíz)
    ├── alumno  [atributo id="A001"]
    │   ├── nombre
    │   │   └── "Ana"   (texto)
    │   └── edad
    │       └── "20"    (texto)
    ├── alumno  [atributo id="A002"]
    │   ├── nombre → "Luis"
    │   └── edad   → "22"
    └── alumno  [atributo id="A003"]
        ├── nombre → "Marta"
        └── edad   → "19"
```

!!! note "Elemento, atributo y texto no son lo mismo"
    `alumno` es un elemento; `id="A001"` es un atributo de ese elemento; `Ana` es texto dentro del elemento `nombre`. Aunque en el esquema aparecen juntos, en DOM se manejan mediante tipos y métodos diferentes.

## 3. Fases del análisis DOM

| Fase | Qué hace Java | Clase o método |
|---|---|---|
| 1. Preparación | Configura la fábrica del analizador | `DocumentBuilderFactory` |
| 2. Construcción | Lee el XML y construye el árbol | `DocumentBuilder.parse()` |
| 3. Normalización (opcional) | Fusiona nodos de texto adyacentes en el árbol | `Document.normalize()` / `normalize()` en la raíz |
| 4. Navegación | Localiza elementos y lee atributos o textos | `Document`, `Element`, `NodeList` |
| 5. Escritura (opcional) | Guarda un árbol modificado en un fichero | `Transformer` |

La normalización **no valida** el documento y no elimina de forma general todos los espacios entre etiquetas.

## 4. Cómo lee el XML nuestro proyecto

```text
data/alumnos.xml
   ↓ Files.newInputStream()
DocumentBuilderFactory → DocumentBuilder
   ↓ parse()
Document → NodeList → Element → atributos y texto
```

En el proyecto separamos responsabilidades:

- **`config/XmlConfig.java`** crea una fábrica DOM que rechaza DTD y entidades externas para reducir el riesgo de XXE.
- **`repository/AlumnoXmlRepository.java`** abre el fichero con `Path` y `Files`, analiza el XML y devuelve el `Document`.

Fragmento principal del repositorio:

```java
try (InputStream entrada = Files.newInputStream(ruta)) {
    Document documento = XmlConfig.domFactory()
        .newDocumentBuilder()
        .parse(entrada);
    documento.getDocumentElement().normalize();
    return documento;
}
```

`try-with-resources` cierra el flujo automáticamente. La configuración de seguridad del parser y el cierre de recursos resuelven problemas diferentes.

## 5. Clases y métodos esenciales

| Clase | Método o propiedad | Para qué sirve |
|---|---|---|
| `Document` | `getDocumentElement()` | Obtiene el elemento raíz |
| `Document` / `Element` | `getElementsByTagName("alumno")` | Busca elementos con ese nombre entre sus descendientes |
| `Element` | `getTagName()` | Devuelve el nombre de la etiqueta |
| `Element` | `getAttribute("id")` | Lee el valor de un atributo |
| `Element` | `setAttribute("id", valor)` | Crea o modifica un atributo |
| `Node` | `getNodeName()` | Devuelve el nombre del nodo |
| `Node` | `getNodeType()` | Indica qué tipo de nodo es |
| `Node` | `getParentNode()` | Devuelve su nodo padre |
| `Node` | `getChildNodes()` | Devuelve sus nodos hijos |
| `Node` | `getTextContent()` | Obtiene el contenido textual del nodo y sus descendientes |
| `NodeList` | `getLength()` | Devuelve cuántos nodos contiene |
| `NodeList` | `item(i)` | Obtiene el nodo de la posición `i` (empieza en 0) |

### Tipos de nodos habituales

| Constante | Valor | Ejemplo |
|---|---:|---|
| `Node.ELEMENT_NODE` | 1 | `<alumno>` |
| `Node.ATTRIBUTE_NODE` | 2 | `id="A001"` |
| `Node.TEXT_NODE` | 3 | `Ana` |
| `Node.COMMENT_NODE` | 8 | `<!-- comentario -->` |
| `Node.DOCUMENT_NODE` | 9 | El documento completo |

Los atributos no aparecen normalmente en `getChildNodes()` de un elemento: se consultan con métodos de atributos como `getAttribute()`.

## 6. Ejemplo ejecutable: `LeerXML_DOM.java`

Abre `app/LeerXML_DOM.java`. El programa obtiene todos los elementos `alumno` y recorre la lista con un bucle tradicional:

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

**Lectura paso a paso:**

1. `getElementsByTagName("alumno")` obtiene los nodos que representan alumnos.
2. `item(i)` devuelve un `Node`; lo convertimos a `Element` porque sabemos que corresponde a una etiqueta.
3. `getAttribute("id")` lee el identificador.
4. `getTextContent()` obtiene los textos de `nombre` y `edad`.
5. `Integer.parseInt()` convierte el texto de la edad en un entero Java.

**Salida esperada:**

```text
A001 - Ana - 20
A002 - Luis - 22
A003 - Marta - 19
```

!!! warning "Comprobación de datos"
    El ejemplo supone que cada alumno tiene `nombre` y `edad`, y que la edad es numérica. Si falta un elemento, `.item(0)` puede devolver `null`; si la edad no es numérica, `Integer.parseInt()` puede lanzar una excepción.

## 7. Comprueba que lo entiendes

1. ¿Qué diferencia existe entre `Document`, `Element` y `NodeList`?
2. ¿Por qué necesitamos convertir `Node` a `Element`?
3. ¿Qué devuelve `getAttribute("id")` y qué devuelve `getTextContent()`?
4. Añade un cuarto alumno a `data/alumnos.xml` y ejecuta el programa.

Continúa con **[DOM: modificación y CRUD](02-dom-crud.md)**. Consulta también la [guía del proyecto Maven XML](../03-intercambio/xml/02-proyecto-java.md).
