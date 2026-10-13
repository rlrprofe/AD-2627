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

---

## Ejemplo completo: una lista de clientes

Considera este XML:

```xml
<clientes>
    <cliente id="C01">
        <nombre>Laura</nombre>
        <edad>30</edad>
    </cliente>
    <cliente id="C02">
        <nombre>Pedro</nombre>
        <edad>25</edad>
    </cliente>
</clientes>
```

Una representación JSON elegida para nuestros ejercicios es:

```json
[
  {"id": "C01", "nombre": "Laura", "edad": 30},
  {"id": "C02", "nombre": "Pedro", "edad": 25}
]
```

Observa las reglas aplicadas: la raíz `<clientes>` se representa mediante una lista; cada `<cliente>` es un objeto; el atributo `id` pasa a ser una propiedad; los elementos `nombre` y `edad` pasan a propiedades; y `edad` se convierte de texto a número. **Estas reglas son una elección del programa**, no una obligación de los formatos.

## ¿Qué significa conversión manual?

La aplicación lee el formato de origen y construye explícitamente la estructura de destino. Por ejemplo, para XML → JSON:

1. Abrir y analizar el fichero XML.
2. Localizar cada elemento `cliente`.
3. Extraer `id`, `nombre` y `edad`.
4. Guardar esos valores en una estructura Java.
5. Convertir la estructura a JSON con Gson.
6. Escribir el resultado en un fichero.

**DOM** permite recorrer el árbol; **XPath** permite seleccionar nodos mediante expresiones; **SAX** informa de los elementos conforme se leen. Las tres alternativas pueden terminar produciendo el mismo JSON.

## ¿Qué significa conversión mediante objetos?

Con **JAXB**, las anotaciones de una clase Java indican cómo se corresponde un objeto con un documento XML. **Gson** transforma esos objetos a JSON o los reconstruye desde JSON. Se reduce el código de recorrido, pero el programador sigue diseñando el modelo y eligiendo las reglas de correspondencia.

!!! warning "Conversión de ida y vuelta"
    Convertir XML → JSON → XML **no garantiza recuperar exactamente el documento original**. Se pueden perder comentarios, espacios de nombres, orden, atributos o diferencias entre elementos vacíos y ausentes. Para evaluar una conversión, comprueba los datos y las reglas acordadas, no solo que el fichero resultante se pueda abrir.

### Comprueba que lo entiendes

1. ¿Por qué el `id` aparece como atributo en XML y como propiedad en JSON?
2. ¿Qué sucedería si hubiera un solo elemento `<cliente>`? ¿Debería seguir generándose un array?
3. ¿Qué problema puede surgir al convertir un código postal `"02801"` en número?
