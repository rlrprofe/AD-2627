# Resumen · Conversión XML ↔ JSON

## Qué debes saber hacer

| Objetivo | Clase del proyecto | Tecnología |
|---|---|---|
| Convertir XML a JSON con DOM | `XmlToJsonManual1` | DOM + Gson |
| Convertir XML a JSON con XPath | `XmlToJsonManual2` | DOM + XPath + Gson |
| Convertir XML a JSON con SAX | `XmlToJsonManual3` | SAX + Gson |
| Convertir JSON a XML con DOM | `JsonToXmlManual1` | Gson + DOM |
| Convertir JSON a XML anidado | `JsonToXmlManual2_Recursivo` | Gson + DOM + recursividad |
| Convertir XML a JSON mediante modelos | `XmlToJsonAutomatica1` | JAXB + Gson |
| Convertir JSON a XML mediante modelos | `JsonToXmlAutomatico1` | Gson + JAXB |

## Conceptos clave

- **Conversión manual:** el programa decide explícitamente cómo se traducen nodos, atributos y arrays.
- **Conversión mediante modelos:** las clases Java representan los datos y las librerías realizan gran parte del trabajo.
- **No hay equivalencia perfecta:** un atributo XML, un elemento repetido, un valor vacío o el orden de los nodos pueden requerir reglas propias.
- **Buenas prácticas:** Java 21, UTF-8, control de errores, cierre de recursos y parsers XML protegidos frente a XXE.

## Preguntas de autoevaluación

1. ¿Por qué un atributo XML no se convierte siempre de la misma manera a JSON?
2. ¿En qué se diferencian DOM, XPath y SAX en los tres ejemplos XML → JSON?
3. ¿Por qué el ejemplo recursivo necesita reglas para los arrays?
4. ¿Qué funciones desempeñan Gson y JAXB en cada sentido?
5. ¿Por qué se necesitan clases `Cliente` y `Clientes` en el enfoque mediante modelos?
6. ¿Qué información podría perderse en una conversión XML → JSON → XML?

**Práctica de consolidación:** añade un cliente con un nombre que contenga una tilde, realiza una conversión en cada sentido y compara el resultado con los datos originales.

[Descargar ambos proyectos Maven](index.md).
