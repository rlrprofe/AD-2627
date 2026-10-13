# Conversión mediante objetos Java (semiautomática)

El segundo proyecto, `conversion-automatica`, utiliza **JAXB y Gson**. La idea es que un objeto Java represente los mismos datos en ambos formatos.

## Paso 1. Estudiar los modelos

Abre las clases `Cliente.java` y `Clientes.java` de los paquetes `xmltojson/modelo` y `jsontoxml/modelo`.

- `Cliente` representa un elemento XML `<cliente>` con atributo `id` y elementos `nombre` y `edad`.
- `Clientes` representa la raíz `<clientes>` y agrupa una lista de objetos `Cliente`.
- `@XmlRootElement` identifica el elemento raíz.
- `@XmlAttribute` y `@XmlElement` indican cómo representar los campos en XML.
- JAXB necesita un constructor sin argumentos para reconstruir los objetos.

Los dos sentidos de conversión tienen modelos en paquetes diferentes; no debes mezclar sus importaciones.

## Paso 2. XML → JSON: `XmlToJsonAutomatica1.java`

```text
resources/clientes.xml
    ↓ JAXB (Unmarshaller)
Objetos Clientes / Cliente
    ↓ Gson (toJson)
salida/clientes_jaxb.json
```

JAXB interpreta las anotaciones y crea los objetos Java. Después Gson convierte esos objetos en JSON. A diferencia de la conversión manual, no es necesario recorrer cada nodo DOM en el programa principal.

## Paso 3. JSON → XML: `JsonToXmlAutomatico1.java`

```text
resources/clientes.json
    ↓ Gson (fromJson)
Objetos Clientes / Cliente
    ↓ JAXB (Marshaller)
XML en la carpeta salida/
```

En este sentido, Gson reconstruye los objetos a partir del JSON y JAXB genera los elementos y atributos XML. El programa admite las estructuras de entrada previstas por su código: revisa el tratamiento de una lista JSON y de un objeto con propiedad `clientes`.

## ¿Por qué no es una conversión completamente automática?

Porque debemos decidir qué clases usar, cómo representar atributos y elementos, y qué forma JSON aceptamos. Además, algunos detalles XML, como comentarios, espacios o contenido mixto, no se conservan necesariamente.

## Java 21 y seguridad

El proyecto revisado utiliza Java 21 y dependencias Maven para Gson y JAXB. **JAXB no forma parte del JDK 21**. Para leer XML de procedencia externa es necesario proporcionar a JAXB un analizador configurado contra DTD y entidades externas; el ejemplo es didáctico y trabaja con ficheros locales de confianza.

**Actividad:** cambia el nombre de un cliente en el fichero de entrada y comprueba ambos sentidos de conversión.

[Proyecto y orden de ejecución](index.md).

---

## Las dos operaciones fundamentales de JAXB

| Operación | Nombre habitual | Sentido |
|---|---|---|
| *Unmarshalling* | Deserialización XML | XML → objetos Java |
| *Marshalling* | Serialización XML | Objetos Java → XML |

**Gson** realiza un trabajo distinto: convierte entre JSON y objetos Java. La combinación de ambas bibliotecas permite utilizar los objetos como representación intermedia.

### Las anotaciones del modelo

Una anotación es información que se escribe junto a una clase, atributo o método Java para que una herramienta o biblioteca pueda interpretarla. En JAXB son especialmente útiles:

| Anotación | Función |
|---|---|
| `@XmlRootElement` | Indica qué clase puede representar un elemento raíz XML |
| `@XmlElement` | Relaciona una propiedad con un elemento XML |
| `@XmlAttribute` | Relaciona una propiedad con un atributo XML |
| `@XmlElementWrapper` | Puede definir un elemento contenedor para una colección |
| `@XmlAccessorType` | Determina si JAXB accede a campos o propiedades |

Las anotaciones concretas que se utilizan en los proyectos deben comprobarse en las clases `Cliente` y `Clientes` descargables. **No todas las anotaciones de la tabla son necesarias en estos ejemplos.**

### Ejemplo conceptual de correspondencia

```java
@XmlRootElement(name = "cliente")
@XmlAccessorType(XmlAccessType.FIELD)
public class Cliente {
    @XmlAttribute
    private String id;

    @XmlElement
    private String nombre;

    @XmlElement
    private int edad;

    public Cliente() {
        // Constructor requerido para reconstruir el objeto con JAXB.
    }
}
```

Este fragmento **ilustra** el mecanismo; para ejecutar los programas utiliza las clases completas del proyecto, que incluyen el modelo y las dependencias necesarias. No contiene expresiones lambda.

## ¿Por qué se necesitan dos clases?

`Cliente` describe un registro individual; `Clientes` describe la agrupación y permite representar el elemento raíz que contiene una lista. Separar ambas responsabilidades facilita el trabajo con colecciones y evita intentar representar varios elementos raíz en un mismo documento XML.

### Limitaciones y seguridad

- JAXB y Gson son **dependencias externas** en Java 21; no forman parte de la API básica del JDK.
- El mapeo de propiedades y los nombres XML deben estar definidos en las clases.
- Los documentos XML de fuentes no confiables deben analizarse con una configuración que impida DTD y entidades externas (XXE).
- Los comentarios XML, el formato original y el contenido mixto no se conservan necesariamente en el modelo.

**Actividad:** identifica qué clase representa el elemento raíz y qué anotación convierte `id` en atributo. Explica qué biblioteca interviene primero en cada sentido de conversión.
