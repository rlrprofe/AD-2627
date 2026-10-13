# DOM · Modificación y operaciones CRUD

## 1. Modificar un árbol no significa modificar el fichero

DOM trabaja con un **árbol en memoria**. Cuando cambiamos un elemento, el objeto `Document` queda modificado, pero el XML original del disco **no cambia hasta que lo escribimos** mediante un `Transformer`.

Por eso distinguimos dos operaciones: **modificar el árbol** y **guardar el resultado**.

## 2. Las operaciones CRUD

CRUD significa *Create, Read, Update, Delete* (crear, leer, actualizar y eliminar).

| Operación | Qué hacemos | Métodos DOM |
|---|---|---|
| Crear | Incorporar un alumno | `createElement()`, `appendChild()` |
| Leer | Consultar alumnos | `getElementsByTagName()`, `getAttribute()`, `getTextContent()` |
| Actualizar | Cambiar edad o atributo | `setTextContent()`, `setAttribute()` |
| Eliminar | Quitar un alumno | `removeChild()` |

!!! info "Qué incluye el proyecto descargable"
    El proyecto actual implementa **lectura** (`LeerXML_DOM.java`) y **actualización** (`ModificarXML_DOM.java`). Las operaciones de **creación y eliminación** de esta página son fragmentos didácticos de ampliación; no corresponden a clases CRUD adicionales en el ZIP.

## 3. Actualizar: `ModificarXML_DOM.java`

El ejemplo modifica la edad del primer alumno y añade un atributo `revisado`:

```java
AlumnoXmlRepository repositorio = new AlumnoXmlRepository();
Document documento = repositorio.leer(Path.of("data/alumnos.xml"));

Element alumno = (Element)
    documento.getElementsByTagName("alumno").item(0);

if (alumno == null) {
    System.err.println("El documento no contiene alumnos.");
    return;
}

alumno.getElementsByTagName("edad")
      .item(0).setTextContent("21");
alumno.setAttribute("revisado", "true");

repositorio.guardar(
    documento, Path.of("data/alumnos_modificado.xml")
);
```

**Qué cambia:** `setTextContent("21")` modifica el texto de `edad`; `setAttribute()` crea o actualiza un atributo. Se genera `alumnos_modificado.xml` y se mantiene intacto `alumnos.xml`.

## 4. Crear un elemento (ampliación)

Para crear un alumno primero construimos sus nodos y después lo incorporamos al árbol:

```java
Element nuevo = documento.createElement("alumno");
nuevo.setAttribute("id", "A004");

Element nombre = documento.createElement("nombre");
nombre.setTextContent("Elena");
nuevo.appendChild(nombre);

Element edad = documento.createElement("edad");
edad.setTextContent("23");
nuevo.appendChild(edad);

documento.getDocumentElement().appendChild(nuevo);
```

`createElement()` crea un nodo **desconectado**; `appendChild()` lo incorpora como hijo de otro nodo. Hasta que no añadimos `nuevo` a la raíz, no forma parte del árbol del documento.

## 5. Eliminar un elemento (ampliación)

Para eliminar un alumno necesitamos localizarlo y pedirle a su **padre** que lo quite:

```java
NodeList alumnos = documento.getElementsByTagName("alumno");
Element alumno = null;

for (int i = 0; i < alumnos.getLength(); i++) {
    Element actual = (Element) alumnos.item(i);
    if ("A002".equals(actual.getAttribute("id"))) {
        alumno = actual;
        break;
    }
}

if (alumno != null) {
    Node padre = alumno.getParentNode();
    padre.removeChild(alumno);
}
```

El bucle evita eliminar accidentalmente un alumno distinto: buscamos el identificador `A002` y solo eliminamos si existe.

## 6. Guardar los cambios: `Transformer`

En `repository/AlumnoXmlRepository.java`, el método `guardar()` prepara un `Transformer`, configura la salida UTF-8, abre un `OutputStream` y transforma el árbol DOM en texto XML.

```java
transformador.transform(
    new DOMSource(documento),
    new StreamResult(salida)
);
```

- `DOMSource` es el árbol que queremos guardar.
- `StreamResult` representa el destino de escritura.
- `transform()` realiza la serialización XML.

El repositorio usa `try-with-resources` y restringe el acceso externo de la fábrica de transformación.

!!! tip "Práctica segura"
    Mientras se aprende, guarda siempre en un fichero diferente para poder comparar el XML original con el modificado.

## 7. Actividades

1. Ejecuta `ModificarXML_DOM.java` y compara los dos ficheros.
2. Añade el alumno `A004` utilizando el fragmento de creación y guarda un nuevo XML.
3. Elimina el alumno `A002` y comprueba que ya no aparece en el resultado.
4. Explica por qué `removeChild()` se invoca sobre el padre y no sobre el propio alumno.

[Proyecto Maven XML y orden de ejecución](../03-intercambio/xml/02-proyecto-java.md).
