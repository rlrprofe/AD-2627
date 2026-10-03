# DOM · Lectura y navegación

DOM carga el XML completo en memoria y lo representa como un **árbol de nodos**.

## Flujo de trabajo

```text
XML → DocumentBuilderFactory → DocumentBuilder → Document → nodos
```

## Cargar un documento

```java
DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
DocumentBuilder builder = factory.newDocumentBuilder();
Document doc = builder.parse(new File("resources/alumnos.xml"));
doc.getDocumentElement().normalize();
```

## Acceder a la raíz

```java
Element raiz = doc.getDocumentElement();
System.out.println(raiz.getTagName());
```

## Obtener elementos

```java
NodeList alumnos = doc.getElementsByTagName("alumno");

for (int i = 0; i < alumnos.getLength(); i++) {
    Node nodo = alumnos.item(i);

    if (nodo.getNodeType() == Node.ELEMENT_NODE) {
        Element alumno = (Element) nodo;

        String id = alumno.getAttribute("id");
        String nombre = alumno.getElementsByTagName("nombre")
                              .item(0)
                              .getTextContent();

        System.out.println(id + " - " + nombre);
    }
}
```

## Clases fundamentales

| Clase | Papel |
|---|---|
| `DocumentBuilderFactory` | Crea/configura el constructor del parser |
| `DocumentBuilder` | Parsea el XML |
| `Document` | Representa el documento completo |
| `Node` | Nodo genérico |
| `Element` | Nodo de tipo elemento |
| `NodeList` | Colección de nodos |

En el proyecto descargable, revisa **`LeerXML_DOM.java`** como primer ejemplo.
