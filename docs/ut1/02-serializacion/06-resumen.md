# Resumen · Serialización

## Conceptos esenciales

| Concepto | Significado |
|---|---|
| Serializar | Objeto → bytes |
| Deserializar | Bytes → objeto |
| `Serializable` | Marca una clase como serializable |
| `transient` | Excluye un atributo de la serialización |
| `writeObject()` | Escribe un objeto |
| `readObject()` | Recupera un objeto |
| `serialVersionUID` | Control de versión de la clase |

## Buenas prácticas

- Usar `try-with-resources`.
- Preferir una colección completa cuando los objetos se gestionan en bloque.
- Usar objetos consecutivos cuando realmente se necesite escritura incremental.
- Declarar `serialVersionUID`.
- Para interoperabilidad con otros lenguajes o sistemas, utilizar formatos como JSON o XML.

## Preguntas de repaso

1. ¿Qué requisito debe cumplir una clase para serializarse?
2. ¿Qué efecto tiene `transient`?
3. ¿Por qué `readObject()` necesita normalmente un cast?
4. ¿Qué problema aparece al hacer append con varios `ObjectOutputStream`?
5. ¿Para qué sirve `serialVersionUID`?
