# JAXB · Conversión entre objetos Java y XML

## 1. ¿Qué significa *data binding*?

**Jakarta XML Binding (JAXB)** permite relacionar la estructura de un XML con un conjunto de **clases Java**. En vez de recorrer manualmente los nodos DOM o reaccionar a eventos SAX, trabajamos con objetos como `Alumno`.

Hay dos operaciones fundamentales:

| Operación | Sentido | Ejemplo |
|---|---|---|
| **Marshalling** | Objeto Java → XML | Guardar un `Alumno` en `alumno_jaxb.xml` |
| **Unmarshalling** | XML → objeto Java | Recuperar un `Alumno` desde un fichero XML |

```text
  Alumno (objeto Java) ── marshal() ──► alumno_jaxb.xml
  Alumno (objeto Java) ◄─ unmarshal() ─ alumno_jaxb.xml
```

JAXB es especialmente útil cuando la estructura XML es **estable** y existe un modelo de clases que la representa.

## 2. Antes de empezar: ¿qué es una anotación Java?

Una **anotación** añade información a una clase, campo o método. Se escribe con `@` y permite que herramientas o bibliotecas interpreten cómo deben tratar ese elemento.

```java
@XmlRootElement(name = "alumno")
public class Alumno {
    // ...
}
```

La anotación no convierte el objeto por sí sola: JAXB la interpreta cuando ejecutamos `marshal()` o `unmarshal()`.

## 3. Preparación con Java 21 y Maven

En Java 21 JAXB **no viene incluido en el JDK**. El proyecto necesita la API y una implementación:

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

La API define las clases y contratos; el *runtime* ejecuta la conversión.

## 4. Paso 1. Estudiar `model/Alumno.java`

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

### Anotaciones utilizadas y otras habituales

| Anotación | Función |
|---|---|
| `@XmlRootElement(name = "alumno")` | Establece la etiqueta raíz |
| `@XmlAccessorType(XmlAccessType.FIELD)` | Indica que JAXB utiliza los campos directamente |
| `@XmlAttribute` | Representa un campo como atributo XML |
| `@XmlElement` | Representa un campo como elemento hijo |
| `@XmlTransient` | Excluye un campo o propiedad de la conversión |
| `@XmlElementWrapper` | Introduce un elemento contenedor para una colección |
| `@XmlType(propOrder = {...})` | Permite indicar el orden de los elementos mapeados |

El **constructor sin argumentos** permite que JAXB instancie la clase al recuperar datos. Para un modelo más complejo también debemos decidir cómo representar listas y relaciones entre objetos.

## 5. Paso 2. Ejecutar `app/JaxbEjemplo.java`

```java
Alumno original = new Alumno("A010", "Lucía", 21);
JAXBContext contexto = JAXBContext.newInstance(Alumno.class);
```

`JAXBContext` conoce las clases que JAXB debe convertir.

### Marshalling: guardar el objeto como XML

```java
Marshaller escritor = contexto.createMarshaller();
escritor.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
escritor.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");

try (var salida = Files.newOutputStream(
        Path.of("data/alumno_jaxb.xml"))) {
    escritor.marshal(original, salida);
}
```

El fichero resultante tendrá un contenido equivalente a:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<alumno id="A010">
    <nombre>Lucía</nombre>
    <edad>21</edad>
</alumno>
```

La presentación exacta puede variar según la implementación.

### Unmarshalling: recuperar un objeto desde XML

```java
Unmarshaller lector = contexto.createUnmarshaller();

try (var entrada = Files.newInputStream(
        Path.of("data/alumno_jaxb.xml"))) {
    Alumno recuperado = (Alumno) lector.unmarshal(entrada);
    System.out.println(recuperado);
}
```

**Salida esperada:** `A010 - Lucía - 21`.

## 6. ¿Qué sucede en cada paso?

1. Creamos un objeto Java con valores.
2. `JAXBContext` prepara el mapeo a partir de las anotaciones.
3. `Marshaller` transforma sus campos en atributos y elementos XML.
4. `Unmarshaller` interpreta el XML y crea un nuevo objeto Java.
5. El programa puede utilizar los datos recuperados como cualquier otro objeto.

## 7. Ventajas y limitaciones

| Ventajas | Limitaciones |
|---|---|
| Código de acceso a datos más expresivo | Requiere definir clases y mapeos |
| Evita recorrer nodos manualmente | Menos cómodo con XML muy irregular o contenido mixto |
| Adecuado para modelos de dominio estables | La lectura de XML externo exige configurar seguridad |

!!! warning "XML de origen no confiable"
    El ejemplo lee un fichero generado por el propio programa. Si se recibe XML externo, conviene proporcionar a JAXB un analizador seguro (por ejemplo, StAX con DTD y entidades externas desactivadas). Cerrar el flujo no evita por sí solo problemas XXE.

## 8. Relación con JSON y actividades

| JSON con Gson/Jackson | XML con JAXB |
|---|---|
| `toJson()` / `writeValueAsString()` | `marshal()` |
| `fromJson()` / `readValue()` | `unmarshal()` |
| Objeto Java ↔ JSON | Objeto Java ↔ XML |

1. Cambia los datos de `original` y comprueba el XML generado.
2. Explica por qué `id` aparece como atributo y `nombre` como elemento.
3. ¿Qué ocurre conceptualmente si quitamos el constructor sin argumentos?
4. Investiga qué anotación utilizarías para excluir un campo de la conversión.

[Proyecto Maven XML y orden didáctico](../03-intercambio/xml/02-proyecto-java.md).
