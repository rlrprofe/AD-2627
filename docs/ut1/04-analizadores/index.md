# 4. Analizadores XML con Java

## ¿Por qué necesitamos un analizador XML?

Un fichero XML es texto, pero **su contenido representa datos estructurados**. Leerlo como líneas de texto no permite distinguir con fiabilidad qué datos pertenecen a cada elemento, qué valores son atributos o cómo se relacionan los elementos anidados.

Un **analizador sintáctico** (*parser*) interpreta la sintaxis del XML, comprueba que está **bien formado** y permite que nuestro programa acceda a su estructura. Un XML bien formado tiene una única raíz, etiquetas correctamente anidadas, atributos entre comillas y caracteres especiales escapados cuando corresponda.

!!! info "Bien formado no significa válido"
    Que el XML esté bien formado no implica que respete las reglas de negocio o un esquema XSD. La **validación** es una comprobación adicional, distinta del análisis sintáctico básico.

## Tres maneras de trabajar con XML

| Tecnología | Idea fundamental | ¿Qué obtiene el programa? | Uso habitual |
|---|---|---|---|
| **DOM** (*Document Object Model*) | Construye el documento completo como árbol | Objetos `Document`, `Element`, `Node` | Consultar y modificar documentos pequeños o medianos |
| **SAX** (*Simple API for XML*) | Lee el XML y notifica eventos | Llamadas a un manejador (*handler*) | Procesar muchos registros sin conservar todo el documento |
| **JAXB / Jakarta XML Binding** | Relaciona etiquetas y atributos con clases Java | Objetos de nuestro modelo, como `Alumno` | Importar/exportar datos con una estructura estable |

```text
                    DOCUMENTO XML
                          |
              +-----------+-----------+
              |           |           |
             DOM         SAX         JAXB
              |           |           |
         Árbol de      Eventos     Objetos Java
           nodos       de lectura   (binding)
              |           |           |
        Navegar y     Procesar      marshal /
        modificar     secuencia     unmarshal
```

**Ejemplo común:** trabajaremos con un documento `alumnos.xml` en el que cada `alumno` tiene un atributo `id` y los elementos `nombre` y `edad`. DOM permite recorrer el árbol; SAX informa de las etiquetas conforme se leen; JAXB convierte un alumno en un objeto Java.

## Itinerario de estudio

1. **[DOM: lectura y navegación](01-dom.md)**: cómo se construye el árbol y cómo se consultan sus nodos.
2. **[DOM: operaciones CRUD](02-dom-crud.md)**: cómo crear, consultar, actualizar y eliminar elementos.
3. **[SAX](03-sax.md)**: cómo se procesan eventos de lectura.
4. **[JAXB](04-jaxb.md)**: cómo convertir entre XML y objetos Java.
5. **[Comparativa](05-comparativa.md)**: cómo elegir el enfoque adecuado.

## Proyecto de ejemplos

[📦 **Descargar proyectos DOM, SAX y JAXB**](../../descargas/ut1/analizadores/code_Examples_1-4.zip)

La documentación distingue los ejemplos **implementados en el ZIP** de las **ampliaciones propuestas**. Se utilizan Java 21 y código imperativo tradicional, sin expresiones lambda.
