# Ejercicios, práctica integradora y descargas de la UT3

## 1. Ejercicios por apartados

| Actividad | Enunciado resumido | CE |
|---|---|---|
| A1. Diagnóstico | Detecta responsabilidades mezcladas en una aplicación y propone una división por capas. | a) |
| A2. Herramientas | Explica la función de Maven, JDK, IDE, JUnit y el driver JDBC. | b) |
| A3. Repaso de interfaces | Implementa dos tipos de `Notificador` y demuestra el polimorfismo. | a), i) (preparatorio) |
| A4. DAO CSV | Implementa `guardar`, `buscarPorId` y `listar` sobre CSV. | c) |
| A5. DAO JDBC | Implementa las mismas operaciones sobre MySQL. | d) |
| A6. Pruebas | Diseña casos normales, límite y de error; automatiza los del CSV. | h) |
| A7. Integración | Ejecuta una aplicación con ambos DAO sin modificar su lógica de negocio. | i) |

## 2. Práctica integradora: gestión de productos

### Enunciado

Desarrolla una aplicación Java 21 con Maven que permita registrar, buscar y listar productos. La aplicación utilizará una interfaz `ProductoDAO` con **dos implementaciones**: almacenamiento en fichero CSV y almacenamiento en MySQL mediante JDBC.

### Requisitos mínimos

1. Definir un modelo `Producto` con ID, nombre y precio.
2. Crear una interfaz `ProductoDAO` con `guardar`, `buscarPorId` y `listar`.
3. Implementar `ProductoFicheroDAO` con manejo de errores.
4. Implementar `ProductoJdbcDAO` usando `PreparedStatement` y `try-with-resources`.
5. Crear una clase `ProductoService` con las validaciones de negocio.
6. Crear un menú de consola que permita utilizar cualquiera de las dos implementaciones.
7. Diseñar y ejecutar pruebas, al menos para el componente CSV.
8. Documentar la API pública con Javadoc y preparar un README de uso.
9. No incluir contraseñas ni datos personales en el repositorio.

### Entregables

- Proyecto Maven completo, con código fuente y `pom.xml`.
- Script SQL para crear la tabla MySQL.
- README de instalación, ejecución y limitaciones.
- Tabla de casos de prueba y evidencias de ejecución.
- Breve explicación de la arquitectura y diagrama de clases.

### Comprobación individual

Durante la revisión deberás poder ejecutar la aplicación, explicar cómo se selecciona el DAO, localizar dónde se realiza cada operación y justificar cómo has separado las responsabilidades.

## 3. Evaluación

La programación didáctica establece **práctica(s) 60 %** y **prueba objetiva 40 %**. Para los CE prácticos se valoran la ejecución correcta (hasta 6 puntos) y la comprensión individual (hasta 4 puntos).

!!! note "Sobre la ponderación"
    Esta página describe las evidencias propuestas para la UT3. No sustituye los criterios de calificación oficiales de la programación ni establece porcentajes adicionales entre actividades.

## 4. Descargas

- [Proyecto completo Maven: gestión de productos](../descargas/ut3/gestion-productos-ut3.zip)
- [Script SQL: base de datos de productos](../descargas/ut3/01-productos.sql)
- [Plantilla de casos de prueba (CSV)](../descargas/ut3/plantilla-pruebas.csv)

## 5. Preguntas de repaso para la prueba objetiva

1. Define componente software y explica dos ventajas y dos inconvenientes.
2. Diferencia clase, interfaz y biblioteca JAR.
3. Explica qué significa alta cohesión y bajo acoplamiento.
4. ¿Qué responsabilidad corresponde a cada capa de la aplicación?
5. ¿Qué hacen `interface`, `implements` y `@Override`?
6. Explica el polimorfismo con dos implementaciones de `ProductoDAO`.
7. ¿Qué problema resuelve el patrón DAO?
8. ¿Qué ventajas aporta `PreparedStatement` frente a construir SQL concatenando datos?
9. ¿Por qué es útil probar un componente sin ejecutar el menú?
10. ¿Cómo puedes cambiar de CSV a MySQL sin modificar `ProductoService`?
