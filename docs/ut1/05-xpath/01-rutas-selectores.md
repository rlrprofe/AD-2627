# Rutas y selectores XPath

## Expresiones básicas

| XPath | Significado |
|---|---|
| `/catalogo/producto` | `producto` hijos directos de `catalogo` |
| `//producto` | Todos los `producto` del documento |
| `//producto/nombre` | Elementos `nombre` |
| `//producto/@id` | Atributos `id` |
| `//producto/nombre/text()` | Texto de `nombre` |
| `.` | Nodo actual |
| `..` | Nodo padre |
| `*` | Cualquier elemento |

## Ruta absoluta

```xpath
/catalogo/producto/nombre
```

Parte desde la raíz.

## Búsqueda descendente

```xpath
//nombre
```

Busca coincidencias en cualquier nivel.

## Atributos

```xpath
//producto/@id
```

El símbolo `@` identifica atributos.
