# UT2 · Conexión a bases de datos relacionales (JDBC)

En esta unidad aprenderás a conectar Java con MySQL, ejecutar sentencias SQL, recuperar resultados y realizar operaciones seguras sobre bases de datos relacionales. Los contenidos parten de los apuntes y proyectos del módulo, ampliados con ejemplos Java 21.

## Contenidos


| Bloque | Qué aprenderás | Práctica |
|---|---|---|
| [2.1 Fundamentos](01-fundamentos.md) | API, drivers, URL y conexión | Conectar con MySQL |
| [2.2 Sentencias](02-sentencias.md) | DDL, DML, `Statement`, `PreparedStatement`, `CallableStatement` | CRUD de productos |
| [2.3 Resultados](03-resultados.md) | Cursores, `ResultSet`, metadatos | Consultas de empleados |
| [2.4 Transacciones](04-transacciones.md) | ACID, `commit`, `rollback`, `Savepoint` | Transferencia bancaria |
| [2.5 Buenas prácticas](05-buenas-practicas.md) | Seguridad, excepciones, arquitectura | Revisión de código |
| [2.6 Actividades](06-actividades.md) | Prácticas y consolidación | Miniaplicación |

## Resultado de aprendizaje

**RA2.** Desarrolla aplicaciones que gestionan información almacenada en bases de datos relacionales identificando y utilizando mecanismos de conexión.

## Criterios de evaluación

| CE | Descripción |
|---|---|
| a | Se han valorado las ventajas e inconvenientes de utilizar conectores. |
| b | Se han utilizado gestores de bases de datos embebidos e independientes. |
| c | Se ha utilizado el conector idóneo en la aplicación. |
| d | Se ha establecido la conexión. |
| e | Se ha definido la estructura de la base de datos. |
| f | Se han desarrollado aplicaciones que modifican el contenido de la base de datos. |
| g | Se han definido los objetos destinados a almacenar el resultado de las consultas. |
| h | Se han desarrollado aplicaciones que efectúan consultas. |
| i | Se han eliminado los objetos una vez finalizada su función. |
| j | Se han gestionado las transacciones. |
| k | Se han ejecutado procedimientos almacenados en la base de datos. |

## Evaluación y calificación de la UT2

La unidad trabaja el **RA2**, que tiene una ponderación del **20 % en la calificación final del módulo**. Para evaluar sus criterios de evaluación (CE) se emplean **dos instrumentos**, con el siguiente reparto:

| Instrumento | Peso en la evaluación del RA2 | ¿En qué consiste? |
|---|---:|---|
| **PEC: prácticas y ejercicios** | **60 %** | Realización individual de actividades prácticas de programación con JDBC y bases de datos relacionales. Se comprobará tanto el funcionamiento como la comprensión de lo realizado. |
| **Prueba objetiva** | **40 %** | Prueba de contenidos teórico-prácticos que podrá combinar preguntas tipo test, preguntas cortas o largas, abiertas o cerradas y ejercicios prácticos de programación. |
| **Total** | **100 %** | Se evalúan los criterios a)–k) del RA2. |

!!! info "Cómo se calcula la calificación"
    **Nota del RA2 = 0,60 × nota de la PEC + 0,40 × nota de la prueba objetiva.**

    Por ejemplo, con un 8 en la PEC y un 6 en la prueba objetiva: `0,60 × 8 + 0,40 × 6 = 7,2`.

### 1. PEC: prácticas y ejercicios (60 %)

La parte práctica consiste en desarrollar y comprobar programas que accedan a bases de datos relacionales mediante JDBC. A lo largo de la unidad se trabajarán actividades relacionadas con los siguientes contenidos:

- **Conectores y conexión:** elección del conector adecuado, configuración de JDBC y establecimiento de conexiones con el gestor de bases de datos.
- **Estructura y modificación de datos:** definición de estructuras y ejecución de operaciones de inserción, actualización y eliminación.
- **Consultas y resultados:** ejecución de consultas, recuperación de información y utilización de objetos para almacenar o procesar resultados.
- **Gestión de recursos:** cierre correcto de conexiones, sentencias y resultados al finalizar su uso.
- **Transacciones:** agrupación de operaciones, confirmación de cambios y recuperación ante errores.
- **Procedimientos almacenados:** ejecución desde Java de procedimientos definidos en la base de datos.

Estas líneas de trabajo describen los contenidos de las prácticas de la unidad; **la guía didáctica no establece un número cerrado de entregas ni una ponderación individual para cada ejercicio**. Los enunciados concretos y las instrucciones de entrega se comunicarán en el aula virtual.

Las prácticas deberán ser **realizadas por cada alumno o alumna**. Si se desarrollan en clase, podrán calificarse mediante observación directa registrada en la ficha de seguimiento y/o mediante rúbrica, según corresponda.

#### ¿Cómo se califica cada criterio de evaluación práctico?

| Evidencia | Qué se comprobará | Puntuación máxima |
|---|---|---:|
| **Ejecución correcta** | Realiza y demuestra las operaciones solicitadas. | **6 puntos** |
| **Comprensión y explicación** | Responde a preguntas sobre su trabajo y explica qué ha hecho y con qué finalidad. | **4 puntos** |
| **Total por CE práctico** | | **10 puntos** |

Durante la revisión, la profesora podrá pedir al alumno que **explique el código, justifique sus decisiones o reproduzca un procedimiento** para comprobar la autoría y el aprendizaje. Por tanto, **entregar un programa que funciona no garantiza obtener los 10 puntos**: también es necesario demostrar que se comprende.

Si durante la comprobación individual no se demuestra una comprensión suficiente, no se obtendrá toda la puntuación del apartado de explicación, aunque el código sea técnicamente correcto.

!!! warning "Autoría de las prácticas"
    Las prácticas deben ser **originales y de elaboración propia**. Si se acredita copia, presentación como propio de un trabajo no realizado o utilización de medios no autorizados, **la práctica se calificará con 0**, conforme a la guía didáctica.

### 2. Prueba objetiva (40 %)

Se realizará una **prueba de carácter teórico-práctico** sobre los contenidos de la unidad y los criterios de evaluación del RA2.

La prueba **podrá incluir**, entre otros formatos:

- **Preguntas tipo test** sobre conceptos, clases e interfaces de JDBC.
- **Preguntas cortas o de desarrollo** para explicar conexiones, consultas, resultados, transacciones y gestión de errores.
- **Lectura, interpretación o análisis de código Java y SQL** para identificar su funcionamiento y posibles problemas.
- **Ejercicios prácticos de programación** en los que haya que escribir o completar instrucciones relacionadas con JDBC.

Estos son **formatos posibles**, no bloques con puntuaciones fijadas de antemano. La guía didáctica no determina cuántas preguntas habrá de cada tipo ni su peso específico dentro del examen.

### 3. Criterios de evaluación incluidos

Los **11 criterios (a–k)** indicados en la tabla anterior se evaluarán mediante la **PEC (60 %) y la prueba objetiva (40 %)**, de acuerdo con la guía didáctica. La distribución de 6 puntos por ejecución y 4 por explicación se aplica a la **valoración de los criterios prácticos**, no a la división entre PEC y examen.

## Requisitos y materiales

- Java **21**, Maven, VS Code o un IDE equivalente.
- MySQL 8 y un usuario de prácticas con permisos adecuados.
- [Proyectos Maven descargables](07-descargas.md), con README detallado y scripts SQL.
- Aula virtual del módulo para actividades, plazos y entregas.

!!! warning "Scripts de prácticas"
    El script original de la base de datos `curso` incluye una instrucción que elimina la base existente. **No lo ejecutes sobre una base de datos con información que necesites conservar.**
