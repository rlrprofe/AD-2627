# 5.6. Resumen y autoevaluación de XPath

## Esquema de trabajo

```text
Documento XML
     │
     ▼
Árbol DOM (Document)
     │
     ▼
XPathFactory → XPath → expresión
     │
     ▼
evaluate(..., XPathConstants.TIPO)
     │
     ├── NODESET → NodeList
     ├── NODE    → Node
     ├── STRING  → String
     ├── NUMBER  → Double
     └── BOOLEAN → Boolean
```

## Tabla de consulta rápida

| Necesito… | Expresión de ejemplo |
|---|---|
| Todos los productos | `//producto` |
| Sus identificadores | `//producto/@id` |
| El producto P02 | `//producto[@id='P02']` |
| Productos de precio superior a 50 | `//producto[precio > 50]` |
| El último producto del catálogo | `/catalogo/producto[last()]` |
| Contar los productos | `count(//producto)` |
| Sumar precios | `sum(//producto/precio)` |
| Obtener los textos de los nombres | `//producto/nombre/text()` |

## Errores frecuentes

| Situación | Qué revisar |
|---|---|
| No devuelve resultados | Ruta, nombre de etiqueta, mayúsculas, nodo de contexto o espacios de nombres. |
| `XPathExpressionException` | Sintaxis XPath incorrecta o función no admitida por XPath 1.0. |
| `ClassCastException` | Tipo de resultado solicitado y conversión Java incompatibles. |
| `NullPointerException` | Nodo inexistente o uso de `.item(0)` sin comprobar la lista. |
| El resultado no es el esperado | Diferencia entre `/`, `//`, `[1]` y `(//...)[1]`. |

## Comprueba lo aprendido

Sobre el [`catalogo.xml`](index.md), intenta resolver estas preguntas antes de ver las soluciones.

1. ¿Qué expresión selecciona el nombre del producto P03?
2. ¿Cuántos productos son de la categoría `periféricos`?
3. ¿Qué expresión obtiene los precios superiores a 40?
4. ¿Cómo seleccionarías el segundo producto del catálogo?
5. ¿Cómo comprobarías si existe un producto P99?

??? success "Ver soluciones"
    1. `//producto[@id='P03']/nombre/text()` → Monitor 24 pulgadas.
    2. `count(//producto[@categoria='periféricos'])` → 2.
    3. `//producto[precio > 40]/precio` → 49.99 y 179.00.
    4. `/catalogo/producto[2]` → P02.
    5. `boolean(//producto[@id='P99'])` → false.

## Relación con Java

XPath **no reemplaza al parser XML**: primero cargamos el documento (por ejemplo, con DOM) y después evaluamos las consultas. En el [apartado Java](04-java.md) se muestra el flujo completo con `XPathFactory`, `XPath`, `evaluate()` y `XPathConstants`.

[📦 Descargar proyecto Java XPath](../../descargas/ut1/xpath/xpath-example.zip)
