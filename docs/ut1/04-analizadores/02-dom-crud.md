# DOM · Modificación y CRUD

Una ventaja de DOM es que el árbol permanece en memoria y podemos modificarlo antes de volver a guardarlo.

## Modificar contenido y atributos

```java
elemento.setTextContent("Nuevo valor");
elemento.setAttribute("estado", "revisado");
```

## Crear nodos

```java
Element libro = doc.createElement("libro");
Element titulo = doc.createElement("titulo");

titulo.setTextContent("Acceso a Datos");
libro.appendChild(titulo);
doc.getDocumentElement().appendChild(libro);
```

## Eliminar nodos

```java
Node padre = nodo.getParentNode();
padre.removeChild(nodo);
```

## Guardar el documento

```java
TransformerFactory tf = TransformerFactory.newInstance();
Transformer transformer = tf.newTransformer();

transformer.setOutputProperty(OutputKeys.INDENT, "yes");

transformer.transform(
    new DOMSource(doc),
    new StreamResult(new File("salida.xml"))
);
```

## CRUD con DOM

| Operación | Métodos |
|---|---|
| Create | `createElement()`, `appendChild()` |
| Read | `getElementsByTagName()` |
| Update | `setTextContent()`, `setAttribute()` |
| Delete | `removeChild()` |

En el proyecto se incluyen **`GestionBiblioteca_DOM.java`** y **`GestionBibliotecaCRUD_DOM.java`**.
