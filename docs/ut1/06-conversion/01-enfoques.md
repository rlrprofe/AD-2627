# Enfoques de conversión

Convertir XML y JSON no consiste simplemente en cambiar símbolos. Ambos formatos modelan la información de forma distinta.

## XML

```xml
<cliente id="C01">
    <nombre>Ana</nombre>
</cliente>
```

## JSON

```json
{
  "id": "C01",
  "nombre": "Ana"
}
```

## Decisiones necesarias

- cómo representar atributos XML;
- cómo representar elementos repetidos;
- qué elemento será la raíz;
- cómo tratar texto y subelementos;
- cómo representar `null`, números y booleanos.

## Manual frente a automática

| Manual | Automática |
|---|---|
| Más código | Menos código |
| Control total | Depende del mapeo/librería |
| Buena para comprender la transformación | Buena para modelos estables |
| Permite reglas específicas | Facilita mantenimiento |
