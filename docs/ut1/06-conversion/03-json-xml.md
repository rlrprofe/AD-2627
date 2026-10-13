# Conversión JSON → XML

Ahora partimos de `resources/clientes.json`, que contiene una lista de objetos con `id`, `nombre` y `edad`.

```text
JSON → Gson → estructuras Java → árbol DOM → fichero XML
```

## Ejemplo 1: `JsonToXmlManual1.java`

Abre `conversion-manual/src/main/java/com/example/jsontoxml/JsonToXmlManual1.java`.

1. Gson lee el JSON y lo transforma en una lista de mapas.
2. `DocumentBuilder` crea un documento DOM nuevo.
3. `createElement()` crea las etiquetas `clientes`, `cliente`, `nombre` y `edad`.
4. `setAttribute()` coloca el identificador en el atributo `id`.
5. `appendChild()` construye las relaciones entre nodos.
6. Un `Transformer` escribe el documento XML en la carpeta `salida/`.

Por ejemplo, un objeto JSON:

```json
{"id": "C01", "nombre": "Laura", "edad": 30}
```

puede convertirse en:

```xml
<cliente id="C01">
  <nombre>Laura</nombre>
  <edad>30</edad>
</cliente>
```

## Ejemplo 2: `JsonToXmlManual2_Recursivo.java`

Este programa amplía el anterior para recorrer **objetos y arrays anidados**. La recursividad permite aplicar la misma lógica a distintos niveles de profundidad, pero exige reglas para nombrar las etiquetas de los elementos de una lista.

**Importante:** no existe una traducción universal de arrays JSON a etiquetas XML. Revisa qué convención adopta el ejemplo y comprueba si la transformación inversa recuperaría exactamente la estructura original.

## Buenas prácticas

- Utiliza UTF-8 en la lectura y escritura de ficheros.
- Cierra los flujos con `try-with-resources` cuando se abran explícitamente.
- Evita sobrescribir los ficheros de entrada: guarda resultados en `salida/`.
- Valida si el JSON recibido es una lista o un objeto con la estructura esperada.
- Configura de forma segura los analizadores XML si el programa también lee XML.

**Actividad:** añade un cliente al JSON y comprueba el XML generado. Después prueba una estructura anidada con el ejemplo recursivo.

[Descargar proyectos](index.md).

---

## Antes de programar: definir la estructura XML de salida

Partimos de un array JSON con clientes. Nuestro objetivo no es copiar literalmente las llaves y corchetes, sino **construir un documento XML válido** con un único elemento raíz `<clientes>`.

| Estructura JSON | Representación XML elegida |
|---|---|
| Array de clientes | Elemento raíz `<clientes>` con varios `<cliente>` |
| Objeto cliente | Elemento `<cliente>` |
| Propiedad `id` | Atributo `id` |
| Propiedad `nombre` | Elemento hijo `<nombre>` |
| Propiedad `edad` | Elemento hijo `<edad>` |

### Cómo se construye el árbol DOM

```text
Document
└── clientes
    ├── cliente (id="C01")
    │   ├── nombre → Laura
    │   └── edad → 30
    └── cliente (id="C02")
        ├── nombre → Pedro
        └── edad → 25
```

En Java, `createElement()` **crea** un elemento, pero este no forma parte del documento hasta que se incorpora con `appendChild()`. Para establecer texto se puede crear un nodo de texto o utilizar `setTextContent()`. Para escribir el documento se emplea un `Transformer`.

### ¿Por qué utilizar recursividad en el segundo ejemplo?

El primer programa conoce de antemano los campos `id`, `nombre` y `edad`. El segundo aborda estructuras con objetos dentro de objetos y listas dentro de objetos. Un método recursivo puede examinar cada valor:

1. Si es un **objeto**, crear un elemento y procesar sus propiedades.
2. Si es un **array**, recorrer sus elementos y aplicar de nuevo el mismo procedimiento.
3. Si es un **valor simple**, escribirlo como texto.
4. Si es `null`, aplicar la convención decidida para ese caso.

No todas las estructuras JSON son válidas como nombres de etiquetas XML; tampoco todos los arrays tienen una traducción única. Por eso hay que documentar las convenciones de cada conversor.

### Errores que debes detectar

- Crear varios elementos raíz, lo que produciría un XML no bien formado.
- Confundir `setAttribute()` con `createElement()`.
- Perder los caracteres especiales `&`, `<` y `>` al escribir XML manualmente. Un `Transformer` sobre DOM se ocupa del escape correspondiente.
- Suponer que cualquier JSON contiene siempre los campos esperados.

**Pregunta de comprensión:** ¿por qué `"edad": 30` termina como texto dentro de `<edad>30</edad>` aunque en JSON fuese un número?
