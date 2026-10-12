# JAXB · Conversión entre objetos Java y XML

**Jakarta XML Binding (JAXB)** permite transformar objetos Java en documentos XML y recuperar objetos a partir de XML. Es el equivalente conceptual de serializar y deserializar objetos con las librerías JSON que hemos estudiado.

```text
Objeto Java -- marshal() --> XML
Objeto Java <-- unmarshal() -- XML
```

## Preparación con Java 21 y Maven

JAXB ya no está incluido en el JDK moderno, así que el `pom.xml` del proyecto añade las dependencias:

```xml
<properties>
    <maven.compiler.release>21</maven.compiler.release>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
</properties>
<dependencies>
    <dependency>
        <groupId>jakarta.xml.bind</groupId>
        <artifactId>jakarta.xml.bind-api</artifactId>
        <version>4.0.2</version>
    </dependency>
    <dependency>
        <groupId>org.glassfish.jaxb</groupId>
        <artifactId>jaxb-runtime</artifactId>
        <version>4.0.5</version>
    </dependency>
</dependencies>
```

La primera dependencia proporciona la API; la segunda aporta una implementación para ejecutar las conversiones.

## Paso 1. Estudiar `model/Alumno.java`

La clase representa un alumno con `id`, `nombre` y `edad`:

```java
@XmlRootElement(name = "alumno")
@XmlAccessorType(XmlAccessType.FIELD)
public class Alumno {
    @XmlAttribute private String id;
    @XmlElement private String nombre;
    @XmlElement private int edad;

    public Alumno() { }

    public Alumno(String id, String nombre, int edad) {
        this.id = id;
        this.nombre = nombre;
        this.edad = edad;
    }
}
```

- **`@XmlRootElement`** define la etiqueta raíz del XML generado.
- **`@XmlAccessorType(XmlAccessType.FIELD)`** indica que JAXB accede directamente a los campos.
- **`@XmlAttribute`** representa `id` como atributo.
- **`@XmlElement`** representa `nombre` y `edad` como elementos hijos.
- El **constructor sin argumentos** permite que JAXB reconstruya el objeto.

## Paso 2. Ejecutar `app/JaxbEjemplo.java`

El ejemplo crea un objeto:

```java
Alumno original = new Alumno("A010", "Lucía", 21);
JAXBContext contexto = JAXBContext.newInstance(Alumno.class);
```

### Serializar: `Marshaller`

```java
Marshaller escritor = contexto.createMarshaller();
escritor.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
escritor.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");

try (var salida = Files.newOutputStream(
        Path.of("data/alumno_jaxb.xml"))) {
    escritor.marshal(original, salida);
}
```

El resultado es un documento equivalente a:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<alumno id="A010">
    <nombre>Lucía</nombre>
    <edad>21</edad>
</alumno>
```

La disposición exacta de los elementos y espacios puede variar según la implementación.

### Deserializar: `Unmarshaller`

```java
Unmarshaller lector = contexto.createUnmarshaller();

try (var entrada = Files.newInputStream(
        Path.of("data/alumno_jaxb.xml"))) {
    Alumno recuperado = (Alumno) lector.unmarshal(entrada);
    System.out.println(recuperado);
}
```

**Resultado esperado en consola:** `A010 - Lucía - 21`.

!!! warning "Seguridad al leer XML"
    El ejemplo utiliza la API directa de JAXB con un fichero generado por el propio programa. Para procesar XML de origen externo o no confiable, es preferible configurar un analizador seguro (por ejemplo, StAX con DTD y entidades externas desactivadas) y pasarlo a JAXB. El `try-with-resources` cierra los flujos, pero no sustituye esa protección.

## Comparación con Jackson y Gson

| JSON con Java | XML con JAXB |
|---|---|
| `writeValueAsString()` / `toJson()` | `marshal()` |
| `readValue()` / `fromJson()` | `unmarshal()` |
| Configuración de propiedades/anotaciones | Anotaciones `@Xml...` |
| Objeto Java ↔ JSON | Objeto Java ↔ XML |

**Actividad:** cambia el nombre y la edad del objeto `original`, ejecuta el programa y comprueba el XML generado.

[Proyecto Maven XML y orden didáctico](../03-intercambio/xml/02-proyecto-java.md).
