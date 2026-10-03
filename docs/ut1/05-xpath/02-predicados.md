# Predicados y filtros XPath

Los predicados se escriben entre corchetes `[]` y permiten filtrar nodos.

## 1. Por posición

```xpath
//producto[1]
```

```xpath
//producto[last()]
```

## 2. Por valor de un hijo

```xpath
//producto[precio > 50]
```

## 3. Por atributo

```xpath
//producto[@id="P01"]
```

## 4. Condiciones combinadas

```xpath
//producto[precio > 20 and precio < 100]
```

## 5. Seleccionar el dato final

```xpath
//producto[precio > 50]/nombre/text()
```

Primero filtramos los productos y después obtenemos únicamente el texto de `nombre`.
