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

---

## Tabla de decisión: ¿qué técnica elegir?

| Situación | Enfoque recomendado | Justificación |
|---|---|---|
| XML pequeño y recorrido completo | DOM + Gson | Permite explorar y modificar el árbol |
| XML con nodos concretos que seleccionar | DOM + XPath + Gson | Las expresiones facilitan localizar los datos |
| XML grande y lectura secuencial | SAX + Gson | Evita construir el árbol XML completo |
| JSON conocido que debe generar XML | Gson + DOM | Permite controlar elementos y atributos |
| JSON con estructuras anidadas | Gson + DOM recursivo | Reutiliza el mismo procedimiento en varios niveles |
| Modelo de datos estable | JAXB + Gson | Reduce el código manual de transformación |

## Ejercicio de análisis: detectar pérdidas de información

Estudia este XML:

```xml
<producto codigo="007">
    <!-- Oferta de otoño -->
    <nombre>Teclado</nombre>
    <precio moneda="EUR">29.50</precio>
    <etiqueta>informática</etiqueta>
    <etiqueta>periféricos</etiqueta>
</producto>
```

Imagina que el programa produce este JSON:

```json
{
  "codigo": 7,
  "nombre": "Teclado",
  "precio": 29.5,
  "etiqueta": "periféricos"
}
```

**Cuestiones:**

1. ¿Qué ha sucedido con el cero inicial de `codigo`?
2. ¿Se ha conservado el atributo `moneda`?
3. ¿Dónde está el comentario XML?
4. ¿Se han conservado las dos etiquetas?
5. ¿Podría reconstruirse exactamente el XML original con ese JSON?

??? success "Solución razonada"
    1. Al convertir `"007"` en número se pierde la representación original.
    2. No: `moneda="EUR"` no aparece en el JSON.
    3. El comentario se ha descartado.
    4. No: solo aparece la última etiqueta; para mantener ambas convendría un array.
    5. No: faltan datos y decisiones de formato, por lo que la conversión no es reversible.

## Lista de comprobación para las prácticas

- [ ] Identifico el fichero de entrada y el de salida.
- [ ] Sé qué biblioteca lee el formato de origen.
- [ ] Localizo dónde se transforman los datos.
- [ ] Distingo atributos XML, elementos y propiedades JSON.
- [ ] Compruebo listas, valores numéricos y caracteres acentuados.
- [ ] Puedo explicar qué información se pierde y por qué.
