# 5.2. Rutas y selectores XPath

Las expresiones XPath recorren el **árbol de nodos** de un XML. Para entenderlas conviene distinguir el **nodo de contexto** (desde dónde empezamos), la **ruta** (por dónde navegamos) y el **nodo seleccionado** (qué obtenemos).

En los ejemplos utilizaremos el [`catalogo.xml` de la introducción](index.md).

## Rutas absolutas, relativas y descendentes

| Tipo | Expresión | Qué selecciona |
|---|---|---|
| Absoluta | `/catalogo/producto/nombre` | Los tres elementos `<nombre>` que cuelgan directamente de `producto`. |
| Relativa | `producto/nombre` | Los `<nombre>` a partir del nodo de contexto; funciona, por ejemplo, si el contexto es `<catalogo>`. |
| Descendente | `//nombre` | Todos los elementos `<nombre>` del documento, a cualquier profundidad. |
| Mixta | `/catalogo//precio` | Los elementos `<precio>` descendientes de `<catalogo>`. |

**Atención:** una ruta que comienza por `/` parte de la **raíz del árbol del documento**, no del directorio donde está guardado el fichero XML. `//` permite localizar descendientes, no significa simplemente «dos niveles».

```xpath
/catalogo/producto/nombre
```

Resultado: **Teclado mecánico**, **Ratón inalámbrico** y **Monitor 24 pulgadas** (se seleccionan los elementos que contienen esos textos).

## Selectores y operadores

| Símbolo | Función | Ejemplo |
|---|---|---|
| `/` | Paso a un hijo directo | `/catalogo/producto` |
| `//` | Búsqueda de descendientes | `//precio` |
| `.` | Nodo actual | `./nombre` desde un `<producto>` |
| `..` | Nodo padre | `../@id` desde `<nombre>` |
| `@` | Atributo | `//producto/@id` |
| `*` | Cualquier elemento en ese paso | `//producto/*` |
| `@*` | Cualquier atributo | `//producto/@*` |
| `text()` | Nodos de texto | `//producto/nombre/text()` |
| `|` | Unión de selecciones | `//nombre | //precio` |

### Diferencia entre elementos, atributos y textos

```xpath
//producto[@id='P01']/nombre
```

Selecciona el **elemento** `<nombre>` del producto P01.

```xpath
//producto[@id='P01']/nombre/text()
```

Selecciona su **nodo de texto**: `Teclado mecánico`.

```xpath
//producto[@id='P01']/@categoria
```

Selecciona el **atributo** `categoria`, cuyo valor es `periféricos`.

## Navegación avanzada: ejes XPath

Un eje indica la relación entre el nodo de contexto y los nodos que queremos seleccionar. Se escribe `eje::nombre`.

| Eje | Significado | Ejemplo |
|---|---|---|
| `child::` | Hijos directos | `/catalogo/child::producto` |
| `parent::` | Padre | `//nombre/parent::producto` |
| `ancestor::` | Antepasados | `//precio/ancestor::catalogo` |
| `descendant::` | Descendientes | `/catalogo/descendant::nombre` |
| `following-sibling::` | Hermanos posteriores | `//producto[@id='P01']/following-sibling::producto` |
| `preceding-sibling::` | Hermanos anteriores | `//producto[@id='P03']/preceding-sibling::producto` |
| `attribute::` | Atributos | `//producto/attribute::id` |

La abreviatura `@id` equivale a `attribute::id`; `..` equivale a `parent::node()`.

## Expresiones comentadas

| Consulta | Resultado en nuestro catálogo |
|---|---|
| `/catalogo/producto[1]/nombre` | Teclado mecánico |
| `/catalogo/producto[last()]/nombre` | Monitor 24 pulgadas |
| `//producto/@id` | P01, P02 y P03 |
| `//producto[@id='P02']/precio/@moneda` | EUR |
| `//producto[@id='P01']/following-sibling::producto[1]/nombre` | Ratón inalámbrico |

!!! tip "No confundas el resultado con su representación"
    XPath suele **seleccionar nodos**. Cuando una tabla muestra «Teclado mecánico», está mostrando el contenido legible del nodo seleccionado. Desde Java podemos pedir el nodo (`NODE`), la colección (`NODESET`) o su valor textual (`STRING`).

## Actividad de comprobación

Escribe una expresión para: (a) obtener todos los identificadores; (b) seleccionar las descripciones; (c) obtener el nombre del producto P03; (d) localizar el producto inmediatamente posterior al P01.

**Soluciones:** `//producto/@id`; `//descripcion`; `//producto[@id='P03']/nombre/text()`; `//producto[@id='P01']/following-sibling::producto[1]`.
