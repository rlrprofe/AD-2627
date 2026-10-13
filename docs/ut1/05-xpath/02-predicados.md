# 5.3. Predicados y filtros XPath

Un **predicado** es una condición entre corchetes `[...]` que restringe los nodos seleccionados por un paso de la ruta. Podemos filtrar por **posición**, **atributos**, **valores de elementos** y **condiciones combinadas**.

Usamos el [catálogo de tres productos](index.md).

## 1. Filtrar por posición

```xpath
/catalogo/producto[1]
```

Selecciona el primer `<producto>` hijo de `<catalogo>`: **P01**. Las posiciones XPath comienzan en **1**, no en 0.

| Expresión | Resultado |
|---|---|
| `/catalogo/producto[2]` | P02 |
| `/catalogo/producto[last()]` | P03 |
| `/catalogo/producto[position() <= 2]` | P01 y P02 |
| `/catalogo/producto[position() != last()]` | P01 y P02 |

!!! warning "`//producto[1]` no siempre equivale a `(//producto)[1]`"
    `//producto[1]` selecciona los elementos `producto` que ocupan la primera posición **entre los hijos `producto` de cada padre**. `(//producto)[1]` selecciona el **primer `producto` del conjunto global**. Con nuestro catálogo sencillo coinciden, pero en un XML con productos agrupados bajo varios padres pueden dar resultados diferentes.

## 2. Filtrar por atributos

```xpath
//producto[@id='P02']
```

Selecciona el producto **P02**.

```xpath
//producto[@categoria='periféricos']
```

Selecciona **P01 y P02**. También podemos comprobar la mera existencia de un atributo:

```xpath
//producto[@categoria]
```

## 3. Filtrar por valores de elementos

```xpath
//producto[precio > 50]
```

Selecciona **P03**, porque su precio es 179.00. XPath 1.0 convierte el texto del elemento a número al efectuar esta comparación numérica.

```xpath
//producto[nombre='Teclado mecánico']
```

Selecciona **P01**.

## 4. Combinar condiciones

| Expresión | Resultado |
|---|---|
| `//producto[precio > 20 and precio < 100]` | P01 y P02 |
| `//producto[@categoria='pantallas' or precio < 30]` | P02 y P03 |
| `//producto[not(@categoria='pantallas')]` | P01 y P02 |
| `//producto[@categoria='periféricos'][precio > 40]` | P01 |

Los predicados encadenados se aplican sucesivamente: primero se filtra por categoría y después por precio.

## 5. Combinar filtros con funciones

```xpath
//producto[contains(nombre,'Monitor')]
```

Resultado: **P03**.

```xpath
//producto[starts-with(@id,'P0')]
```

Resultado: **P01, P02 y P03**.

```xpath
//producto[string-length(nombre) > 16]
```

Resultado: **P03** (`Monitor 24 pulgadas`).

## 6. Seleccionar solo el dato que necesitamos

Esta expresión **primero filtra productos** y **después selecciona el texto de sus nombres**:

```xpath
//producto[precio > 50]/nombre/text()
```

Resultado: `Monitor 24 pulgadas`.

## Buenas prácticas

- Coloca el predicado sobre el elemento que quieres filtrar: `producto[precio > 50]`.
- Distingue seleccionar un **elemento** de seleccionar su **texto**.
- Usa comillas en comparaciones con cadenas: `[@id='P01']`.
- Comprueba si el filtro puede devolver **cero nodos**.
- Cuando la posición sea importante, especifica bien el conjunto al que se aplica.

## Actividad

Construye una consulta que obtenga los nombres de los productos de categoría `periféricos` cuyo precio sea superior a 40.

**Solución:** `//producto[@categoria='periféricos' and precio > 40]/nombre/text()` → `Teclado mecánico`.
