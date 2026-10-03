# JAXB · Jakarta XML Binding

JAXB permite trabajar con XML mediante **objetos Java**, evitando manipular directamente nodos DOM.

## Flujo

```text
XML --unmarshal--> Objetos Java
XML <--marshal---- Objetos Java
```

## JDK 21 y Maven

En JDK modernos JAXB no forma parte del JDK. Utilizaremos **Jakarta XML Binding**.

```xml
<properties>
    <maven.compiler.release>21</maven.compiler.release>
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

## Anotar una clase

```java
@XmlRootElement(name = "alumno")
@XmlAccessorType(XmlAccessType.FIELD)
public class Alumno {

    @XmlAttribute
    private String id;

    @XmlElement
    private String nombre;

    @XmlElement
    private int edad;

    public Alumno() {
    }
}
```

El constructor sin argumentos es importante para JAXB.

## Unmarshalling

```java
JAXBContext context = JAXBContext.newInstance(Alumno.class);
Unmarshaller unmarshaller = context.createUnmarshaller();

Alumno alumno = (Alumno) unmarshaller.unmarshal(
    new File("alumno.xml")
);
```

## Marshalling

```java
Marshaller marshaller = context.createMarshaller();
marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
marshaller.marshal(alumno, new File("alumno.xml"));
```

## Anotaciones habituales

`@XmlRootElement`, `@XmlElement`, `@XmlAttribute`, `@XmlElementWrapper`, `@XmlAccessorType`, `@XmlType` y `@XmlTransient`.

El proyecto descargable incluye ejemplos con **Libro**, **Curso** y **Biblioteca**.
