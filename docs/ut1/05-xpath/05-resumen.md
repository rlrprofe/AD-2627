# Resumen · XPath

```text
XML
 │
 ▼
Document (DOM)
 │
 ▼
XPathFactory
 │
 ▼
XPath
 │
 ▼
evaluate()
 │
 ├── String
 ├── Number
 ├── Boolean
 ├── Node
 └── NodeList
```

## Errores frecuentes

| Error | Posible causa |
|---|---|
| `XPathExpressionException` | Expresión XPath incorrecta |
| `ClassCastException` | Tipo de resultado equivocado |
| `NullPointerException` | Documento o nodo no inicializado |

XPath permite expresar **qué información queremos**, evitando muchos recorridos manuales del árbol DOM.
