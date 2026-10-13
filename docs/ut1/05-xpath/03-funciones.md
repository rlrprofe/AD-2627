# 5.4. Funciones XPath más utilizadas

XPath incorpora funciones para **contar**, **sumar**, **comparar**, **trabajar con cadenas** y **consultar posiciones**. Las expresiones de esta página utilizan el [catálogo de productos](index.md).

!!! info "Versión utilizada en Java 21"
    La implementación estándar de `javax.xml.xpath` de Java admite **XPath 1.0**. Por eso trabajaremos con funciones compatibles con esa versión. Por ejemplo, `ends-with()` pertenece a XPath 2.0 y **no debe utilizarse** con el evaluador estándar de Java.

## Funciones numéricas

| Función | Expresión | Resultado |
|---|---|---|
| `count()` | `count(//producto)` | `3` |
| `sum()` | `sum(//producto/precio)` | `258.49` |
| `number()` | `number(//producto[@id='P01']/precio)` | `49.99` |
| `round()` | `round(//producto[@id='P01']/precio)` | `50` |
| `floor()` | `floor(//producto[@id='P01']/precio)` | `49` |
| `ceiling()` | `ceiling(//producto[@id='P02']/precio)` | `30` |

**Importante:** `sum()` requiere que los nodos seleccionados contengan valores convertibles a números. En este XML, los precios usan punto decimal.

## Funciones de texto

| Función | Ejemplo | Resultado o utilidad |
|---|---|---|
| `contains()` | `//producto[contains(nombre,'Monitor')]` | Selecciona P03. |
| `starts-with()` | `//producto[starts-with(@id,'P0')]` | Selecciona P01, P02 y P03. |
| `string()` | `string(//producto[@id='P01']/nombre)` | `Teclado mecánico` |
| `string-length()` | `string-length('Java')` | `4` |
| `normalize-space()` | `normalize-space('  Hola   XML  ')` | `Hola XML` |
| `concat()` | `concat('Producto ', 'P01')` | `Producto P01` |
| `substring()` | `substring('XPath', 1, 3)` | `XPa` |
| `translate()` | `translate('ABC', 'ABC', 'abc')` | `abc` |

En XPath 1.0, `substring()` utiliza posiciones que comienzan en **1**.

## Posición y contexto

| Función | Ejemplo | Explicación |
|---|---|---|
| `position()` | `/catalogo/producto[position() = 2]` | Selecciona P02. |
| `last()` | `/catalogo/producto[last()]` | Selecciona P03. |
| `name()` | `name(/catalogo/producto[1])` | Devuelve `producto`. |
| `local-name()` | `local-name(/catalogo/producto[1])` | Nombre local del elemento. |

## Funciones booleanas

| Expresión | Resultado |
|---|---|
| `boolean(//producto[@id='P03'])` | `true` |
| `boolean(//producto[@id='P99'])` | `false` |
| `not(//producto[@categoria='pantallas'])` | `false` |
| `//producto[not(@categoria='pantallas')]` | P01 y P02 |

Observa que `not()` puede utilizarse como **resultado booleano** o dentro de un **predicado**.

## Combinación de funciones

```xpath
count(//producto[precio > 40])
```

Resultado: `2` (P01 y P03).

```xpath
sum(//producto[@categoria='periféricos']/precio)
```

Resultado: `79.49`.

```xpath
//producto[contains(nombre,'Ratón')]/@id
```

Resultado: atributo `id` con valor `P02`.

## ¿Cuándo conviene utilizar cada función?

- **`count()`**: número de coincidencias, sin recorrer una lista en Java.
- **`sum()`**: total de valores numéricos.
- **`contains()` y `starts-with()`**: búsqueda parcial de texto.
- **`position()` y `last()`**: seleccionar elementos según su posición.
- **`normalize-space()`**: comparar texto cuando puede contener espacios adicionales.

**Actividad:** calcula el número de productos con precio inferior a 50. **Solución:** `count(//producto[precio < 50])` → `2`.
