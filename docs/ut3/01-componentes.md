# 3.1. Programación orientada a componentes

**Duración orientativa:** 2 horas · **CE a)**

## 1. ¿Qué es un componente software?

Un **componente software** es una unidad de funcionalidad que ofrece servicios a través de una interfaz o contrato conocido, y que puede utilizarse desde otras partes de una aplicación. En este curso construiremos componentes Java encargados de **guardar y recuperar productos**.

No todos estos conceptos son equivalentes:

| Concepto | Qué representa | Ejemplo |
|---|---|---|
| Clase | Plantilla para crear objetos o agrupar comportamiento. | `Producto`. |
| Objeto | Instancia de una clase. | `new Producto(1, "Ratón", 15.5)`. |
| Interfaz | Contrato de operaciones disponibles. | `ProductoDAO`. |
| Componente | Unidad reutilizable con una responsabilidad y un contrato de uso. | Implementación de acceso a productos. |
| Biblioteca | Conjunto de clases y recursos reutilizables. | Un archivo JAR. |
| Módulo/proyecto | Unidad de organización, compilación o despliegue. | Proyecto Maven `gestion-productos`. |

!!! note "Importante"
    Un componente puede estar formado por varias clases. **Un JAR no garantiza por sí solo un buen diseño**: el componente debe tener una responsabilidad clara y una interfaz de uso coherente.

## 2. De una aplicación monolítica a componentes

Considera una aplicación donde `Main` lee opciones, valida precios, abre conexiones, ejecuta SQL y muestra mensajes. Funciona, pero cada modificación puede afectar a tareas no relacionadas.

```java
// Ejemplo esquemático: responsabilidades mezcladas.
public class Main {
    public static void main(String[] args) {
        // 1. Leer la opción del menú.
        // 2. Comprobar que el precio sea válido.
        // 3. Abrir una conexión a MySQL.
        // 4. Ejecutar un INSERT.
        // 5. Mostrar el resultado al usuario.
    }
}
```

En un diseño por componentes separamos **presentación**, **reglas de negocio** y **persistencia**. Cada parte se puede comprender y probar de manera más independiente.

## 3. Características deseables

- **Responsabilidad definida:** un componente hace bien una tarea concreta.
- **Encapsulación:** oculta los detalles internos de implementación.
- **Contrato estable:** ofrece operaciones claras y documentadas.
- **Reutilización:** puede emplearse en varias aplicaciones.
- **Bajo acoplamiento:** exige conocer pocos detalles de otros componentes.
- **Alta cohesión:** sus métodos colaboran en una misma finalidad.
- **Sustituibilidad:** es posible cambiar una implementación por otra compatible.
- **Pruebas y documentación:** se puede verificar y utilizar sin estudiar todo su código.

## 4. Ventajas e inconvenientes

| Ventajas | Inconvenientes o costes |
|---|---|
| Reutilización de código. | Mayor diseño inicial. |
| Mantenimiento localizado. | Más clases y contratos que comprender. |
| Facilita pruebas independientes. | Gestión de versiones y dependencias. |
| Permite sustituir implementaciones. | Una abstracción innecesaria puede complicar proyectos pequeños. |
| Favorece el trabajo en equipo. | Una interfaz mal diseñada puede afectar a muchos consumidores. |

La programación orientada a componentes **no significa crear una interfaz para cada clase**. Las abstracciones deben resolver un problema real.

## 5. Caso práctico: catálogo de productos

La aplicación necesita tres operaciones: **guardar**, **buscar por identificador** y **listar**. Primero las implementaremos sobre CSV y después sobre MySQL. Las pantallas o menús no deberían necesitar saber dónde se guardan los datos.

## Actividades

1. Explica dos problemas de una clase que contiene menús, validaciones y SQL.
2. Identifica dos ventajas y dos costes de extraer el acceso a datos a un componente.
3. Decide si `Producto`, `ProductoDAO` y `ProductoJdbcDAO` son clases, interfaces o componentes; justifica tu respuesta.
4. ¿Crear un JAR convierte automáticamente un conjunto de clases en un componente bien diseñado? Razona.

!!! tip "Autoevaluación"
    Debes poder explicar la diferencia entre **reutilizar una clase** y **ofrecer un componente con un contrato de uso estable**.
