# 6. Conversión XML ↔ JSON

En este bloque utilizaremos **dos proyectos Maven con Java 21**. Ambos convierten información de clientes entre XML y JSON, pero emplean estrategias distintas.

[**Descargar los dos proyectos de conversión**](../../descargas/ut1/conversion/code_Example_1-6.zip)


## Mapa conceptual: enfoques de conversión XML y JSON

![Mapa conceptual: enfoques de conversión XML y JSON](../../images/ut1/mapas/conversion-xml-json-enfoques.svg)


## Qué contiene la descarga

```text
conversion-manual/
  pom.xml
  resources/clientes.xml
  resources/clientes.json
  src/main/java/com/example/
    xmltojson/XmlToJsonManual1.java
    xmltojson/XmlToJsonManual2.java
    xmltojson/XmlToJsonManual3.java
    xmltojson/handlers/ClienteHandler.java
    jsontoxml/JsonToXmlManual1.java
    jsontoxml/JsonToXmlManual2_Recursivo.java

conversion-automatica/
  pom.xml
  resources/clientes.xml
  resources/clientes.json
  src/main/java/com/example/
    xmltojson/XmlToJsonAutomatica1.java
    xmltojson/modelo/Cliente.java, Clientes.java
    jsontoxml/JsonToXmlAutomatico1.java
    jsontoxml/modelo/Cliente.java, Clientes.java
```

## Orden didáctico

| Orden | Programa | Qué aprenderás |
|---|---|---|
| 1 | `XmlToJsonManual1` | DOM y creación de JSON |
| 2 | `XmlToJsonManual2` | Consultas XPath y JSON |
| 3 | `ClienteHandler` + `XmlToJsonManual3` | SAX y eventos |
| 4 | `JsonToXmlManual1` | Gson y construcción DOM |
| 5 | `JsonToXmlManual2_Recursivo` | Objetos y arrays anidados |
| 6 | Modelos `Cliente` / `Clientes` | Correspondencia entre objetos Java y XML |
| 7 | `XmlToJsonAutomatica1` | JAXB → objetos → Gson |
| 8 | `JsonToXmlAutomatico1` | Gson → objetos → JAXB |

Abre **cada proyecto por separado** en VS Code, desde la carpeta que contiene su `pom.xml`. Ejecuta las clases con la carpeta del proyecto como directorio de trabajo, ya que utilizan rutas relativas `resources/` y escriben los resultados en `salida/`.

!!! note "Alcance"
    Los ejemplos se centran en clientes con `id`, `nombre` y `edad`. No constituyen una herramienta genérica capaz de conservar todos los detalles de cualquier XML o JSON.

---

## ¿Qué aprenderás en este apartado?

Al terminar deberías poder **explicar** las diferencias entre XML y JSON, **elegir** un procedimiento de conversión y **seguir** la transformación de datos en los proyectos Java. No se trata únicamente de ejecutar programas: hay que identificar qué información se mantiene y qué decisiones toma el programador.

### XML y JSON: dos formas de representar información

| Característica | XML | JSON |
|---|---|---|
| Organización | Elementos anidados y atributos | Objetos, propiedades y arrays |
| Tipos de datos | El contenido de elementos y atributos es texto; el esquema puede definir tipos | Cadenas, números, booleanos, `null`, objetos y arrays |
| Colecciones | Repetición de elementos | Arrays explícitos |
| Metadatos | Atributos y espacios de nombres | No existe una construcción equivalente directa |
| Comentarios | Permite comentarios XML | JSON estándar no admite comentarios |
| Uso frecuente | Documentos, configuraciones e intercambio estructurado | APIs REST e intercambio de datos |

**Ejemplo:** `<edad>30</edad>` y `"edad": 30` parecen equivalentes, pero el primero contiene texto y el segundo un número JSON. La conversión debe decidir si transforma el tipo.

### Flujo general

```text
XML --(DOM / SAX / XPath / JAXB)--> estructuras u objetos Java
                                           |
                                           v
                                      Gson / JSON
                                           |
                                           v
                                          JSON

JSON --(Gson)--> estructuras u objetos Java --(DOM / JAXB)--> XML
```

En las páginas siguientes verás **qué ocurre en cada flecha**, con los nombres de las clases que ya están en los proyectos descargables.
