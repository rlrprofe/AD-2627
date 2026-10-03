# XML: estructura y conceptos básicos

## 1. ¿Qué es XML?

XML es un lenguaje de marcado jerárquico. Los datos se representan mediante elementos, atributos y texto.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<alumnos>
    <alumno id="A001">
        <nombre>Ana</nombre>
        <edad>20</edad>
    </alumno>
</alumnos>
```

## 2. Elemento raíz

Un documento XML debe tener un único elemento raíz:

```xml
<alumnos>
    ...
</alumnos>
```

Todos los demás elementos están contenidos dentro de él.

## 3. Elementos

```xml
<nombre>Ana</nombre>
```

`nombre` es el elemento y `Ana` es su contenido de texto.

## 4. Atributos

```xml
<alumno id="A001">
```

`id` es un atributo del elemento `alumno`.

Los atributos se escriben dentro de la etiqueta de apertura y sus valores deben ir entre comillas.

## 5. Estructura jerárquica

XML forma un árbol:

```text
alumnos
└── alumno
    ├── atributo id="A001"
    ├── nombre
    │   └── "Ana"
    └── edad
        └── "20"
```

Esta idea es fundamental para comprender DOM.

## 6. XML bien formado

Un XML está **bien formado** cuando cumple las reglas sintácticas de XML.

Entre otras:

- existe una única raíz;
- las etiquetas se cierran correctamente;
- los elementos están correctamente anidados;
- los valores de atributos aparecen entre comillas.

Este XML no está bien formado:

```xml
<alumno>
    <nombre>Ana
</alumno>
```

## 7. XML válido

Un documento **válido** es, además de bien formado, conforme a un contrato como DTD o XSD.

```text
bien formado
    +
cumple DTD/XSD
    =
válido
```

DTD permite definir elementos, orden, repeticiones y atributos. XSD añade un sistema de tipos más rico, restricciones y soporte avanzado para espacios de nombres.

## 8. Ejemplo de DTD

```dtd
<!ELEMENT alumnos (alumno+)>
<!ELEMENT alumno (nombre, edad)>
<!ATTLIST alumno id CDATA #REQUIRED>
<!ELEMENT nombre (#PCDATA)>
<!ELEMENT edad (#PCDATA)>
```

Este contrato exige que cada `alumno` tenga `nombre` y `edad`, en ese orden, y un atributo `id`.

## 9. Namespaces

XML puede utilizar espacios de nombres para evitar colisiones entre vocabularios:

```xml
<alumnos xmlns="http://ejemplo.org/alumnos">
```

El namespace forma parte de la identidad de los elementos y debe tenerse en cuenta cuando se procesan documentos que lo utilizan.

## 10. XML frente a JSON

| XML | JSON |
|---|---|
| Etiquetas y atributos | Pares clave-valor |
| Muy jerárquico | Objetos y arrays |
| DTD/XSD | Validación mediante herramientas externas/esquemas |
| Namespaces | No tiene equivalente directo |
| Más verboso | Más compacto |
| Muy presente en sistemas empresariales y configuración | Muy habitual en APIs REST |

## 11. Idea clave

Antes de programar un parser, identifica siempre:

```text
raíz
├── elementos repetidos
├── atributos
├── subelementos
└── texto
```

Esa estructura determinará cómo recorreremos el documento desde Java.
