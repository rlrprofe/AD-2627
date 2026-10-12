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
