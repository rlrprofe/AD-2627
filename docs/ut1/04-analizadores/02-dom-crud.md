# DOM · Modificación y operaciones CRUD

Una vez cargado un XML con DOM, podemos modificar el árbol en memoria. **Los cambios no se guardan en disco automáticamente**: es necesario transformar el `Document` y escribirlo.

## Las cuatro operaciones CRUD

| Operación | Métodos DOM | Ejemplo |
|---|---|---|
| Crear | `createElement()`, `appendChild()` | Añadir un alumno |
| Leer | `getElementsByTagName()`, `getAttribute()` | Consultar un alumno |
| Actualizar | `setTextContent()`, `setAttribute()` | Cambiar edad o atributo |
| Eliminar | `removeChild()` | Quitar un alumno |

El proyecto descargable demuestra de forma ejecutable **lectura y actualización**; las operaciones de creación y eliminación se presentan aquí como ampliación. No se incluyen clases llamadas `GestionBiblioteca_DOM` o `GestionBibliotecaCRUD_DOM` en el ZIP actual.

## Actualizar un alumno: `ModificarXML_DOM.java`

El programa abre `data/alumnos.xml` con `AlumnoXmlRepository`, obtiene el primer elemento `alumno` y modifica su edad:

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

**Observa:** `setTextContent("21")` cambia el contenido de la etiqueta `edad`, mientras que `setAttribute("revisado", "true")` crea o actualiza un atributo del elemento `alumno`.

### Resultado esperado

Se crea `data/alumnos_modificado.xml`. El primer alumno queda con edad `21` y atributo `revisado="true"`. **El fichero de entrada permanece sin cambios.**

## ¿Cómo se escribe el XML?

En `repository/AlumnoXmlRepository.java`, el método `guardar()`:

1. Crea el directorio de destino si es necesario.
2. Configura un `Transformer` con salida indentada y codificación UTF-8.
3. Abre un `OutputStream` con `Files.newOutputStream()`.
4. Convierte el árbol DOM en XML mediante `transform(new DOMSource(documento), new StreamResult(salida))`.
5. Cierra el flujo automáticamente con `try-with-resources`.

El repositorio también restringe el acceso externo de la fábrica de transformadores.

## Crear y eliminar: ampliación

Para **crear** un elemento, utilizamos el mismo `Document`:

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

Para **eliminar** un nodo:

```java
Node padre = alumno.getParentNode();
padre.removeChild(alumno);
```

En ambos casos debemos llamar después a `repositorio.guardar(...)` para persistir los cambios.

!!! tip "Buena práctica"
    Es preferible guardar el resultado en otro fichero mientras se aprende, para evitar sobrescribir accidentalmente los datos originales.

**Actividad:** modifica `ModificarXML_DOM.java` para añadir un alumno y guardar el resultado en un tercer fichero.

[Proyecto Maven XML y orden de los ejemplos](../03-intercambio/xml/02-proyecto-java.md).
