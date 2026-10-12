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
