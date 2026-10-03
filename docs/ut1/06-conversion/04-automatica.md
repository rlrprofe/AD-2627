# Conversión automática

Cuando existe un modelo de datos estable podemos apoyarnos en objetos Java y librerías de binding/serialización.

## XML → JSON

```text
XML → JAXB → Objetos Java → Gson/Jackson → JSON
```

## JSON → XML

```text
JSON → Gson/Jackson → Objetos Java → JAXB → XML
```

Los objetos Java actúan como **modelo intermedio**.

## Ventajas

- menos código de recorrido manual;
- modelo reutilizable;
- transformación más legible;
- separación entre formato y lógica de negocio.

## Inconvenientes

- requiere definir correctamente el modelo;
- XML y JSON no siempre tienen una correspondencia perfecta;
- puede ser necesario personalizar el mapeo.

El proyecto de conversión automática contiene ejemplos en ambos sentidos y modelos `Cliente` / `Clientes`.
