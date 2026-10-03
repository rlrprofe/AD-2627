# 2. Serialización y deserialización de objetos

Serializar consiste en convertir un objeto en una secuencia de bytes para almacenarlo o transmitirlo. Deserializar realiza el proceso inverso.

## Clases fundamentales

- `Serializable`
- `ObjectOutputStream`
- `ObjectInputStream`
- `FileOutputStream`
- `FileInputStream`

## Flujo básico

```text
Objeto Java
   │
   │ writeObject()
   ▼
ObjectOutputStream
   │
   ▼
Fichero binario
   │
   │ readObject()
   ▼
ObjectInputStream
   │
   ▼
Objeto Java
```

## Proyecto de ejemplos

[📦 **Descargar ejemplos de serialización**](../../descargas/ut1/serializacion/code_examples_1-2.zip)
