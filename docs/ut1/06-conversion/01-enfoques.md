# Enfoques de conversión

XML y JSON pueden representar los mismos datos, pero **no tienen una equivalencia automática y única**.

## Ejemplo de partida

```xml
<cliente id="C01">
    <nombre>Laura</nombre>
    <edad>30</edad>
</cliente>
```

Una representación JSON posible es:

```json
{"id": "C01", "nombre": "Laura", "edad": 30}
```

En XML, `id` es un **atributo**, `nombre` y `edad` son **elementos**, y el texto `30` se interpreta inicialmente como texto. En JSON, hemos elegido convertir `id` en una propiedad y `edad` en un número.

## Decisiones que debe tomar el programador

| Aspecto | Decisión posible | Riesgo |
|---|---|---|
| Atributos XML | Convertirlos en propiedades JSON | Se pierde la distinción entre atributo y elemento |
| Elementos repetidos | Convertirlos en un array | Un único elemento podría representarse como objeto o array |
| Raíz XML | Mantener o eliminar el nombre de la raíz | No hay una raíz nombrada equivalente en JSON |
| Números y booleanos | Convertir cadenas a tipos JSON | Una conversión incorrecta puede alterar datos |
| `null` y elementos vacíos | Elegir una representación explícita | No significan necesariamente lo mismo |
| Orden y contenido mixto | Definir reglas especiales | Puede perderse información |

## Conversión manual y mediante modelo

| Manual | Mediante modelo Java |
|---|---|
| DOM, XPath o SAX para leer XML | JAXB para convertir XML a objetos |
| Construcción explícita de JSON o XML | Gson para convertir objetos a JSON |
| Control sobre cada campo | Menos código para estructuras estables |
| Mayor flexibilidad, más código | Requiere modelos y anotaciones correctos |

El segundo enfoque es **semiautomático**, porque debemos definir las clases `Cliente` y `Clientes` y decidir el mapeo. En los proyectos descargables se mantienen ambas estrategias para poder compararlas.

[Guía de los proyectos y orden de ejecución](index.md).
