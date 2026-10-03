# Funciones XPath

XPath incorpora funciones para trabajar con texto, números, posiciones y conjuntos de nodos.

| Función | Ejemplo |
|---|---|
| `count()` | `count(//producto)` |
| `last()` | `//producto[last()]` |
| `position()` | `//producto[position() <= 3]` |
| `contains()` | `//producto[contains(nombre,'Java')]` |
| `starts-with()` | `//producto[starts-with(nombre,'J')]` |
| `string()` | `string(//producto[1]/nombre)` |
| `number()` | `number(//producto[1]/precio)` |
| `boolean()` | `boolean(//producto[@id='P01'])` |
| `normalize-space()` | Normaliza espacios |

## Métricas

```xpath
count(//producto)
```

Las funciones permiten que XPath no solo seleccione nodos, sino que también produzca resultados escalares.
