
# UT1 · Ficheros y formatos de intercambio de datos

Esta unidad desarrolla el trabajo con información persistente en ficheros y con formatos de intercambio de datos. Partiremos de las clases de entrada/salida de Java y avanzaremos hasta JSON, XML, analizadores sintácticos, XPath y conversión entre formatos.

## Contenidos

1. **Repaso de ficheros secuenciales y aleatorios, directorios, flujos de bytes y caracteres y manejo de excepciones.**
2. **Serialización y deserialización de objetos.**
3. **Ficheros de intercambio de datos: JSON y XML.**
4. **Analizadores sintácticos: DOM, SAX y binding/JAXB.**
5. **Consultas sobre XML con XPath.**
6. **Conversión entre formatos JSON ↔ XML.**

## Resultado de aprendizaje

**RA1.** Desarrolla aplicaciones que gestionan información almacenada en ficheros identificando el campo de aplicación de los mismos y utilizando clases específicas.

## Criterios de evaluación

| CE | Criterio de evaluación |
|---|---|
| **a)** | Se han utilizado clases para la gestión de ficheros y directorios. |
| **b)** | Se han valorado las ventajas y los inconvenientes de las distintas formas de acceso. |
| **c)** | Se han utilizado clases para recuperar información almacenada en ficheros. |
| **d)** | Se han utilizado clases para almacenar información en ficheros. |
| **e)** | Se han utilizado clases para realizar conversiones entre diferentes formatos de ficheros. |
| **f)** | Se han previsto y gestionado las excepciones. |
| **g)** | Se han probado y documentado las aplicaciones desarrolladas. |

## Evaluación

El **RA1 tiene una ponderación del 20 % en la calificación final del módulo** de Acceso a Datos.

### Instrumentos de evaluación y calificación

Para evaluar los criterios de evaluación del RA1 se utilizarán los siguientes instrumentos:

| Instrumento | Peso |
|---|---:|
| **PEC (prácticas evaluables)** | **60 %** |
| **Prueba objetiva** | **40 %** |

Ambos instrumentos permitirán recoger evidencias de los criterios de evaluación asociados a esta unidad.

### Prueba objetiva

La prueba objetiva incluirá contenidos teórico-prácticos de la unidad y podrá combinar diferentes tipos de preguntas y ejercicios:

- Preguntas de tipo test.
- Preguntas cortas o de desarrollo.
- Cuestiones abiertas o cerradas.
- Ejercicios prácticos de programación.
- Análisis, interpretación o corrección de fragmentos de código.

### Prácticas evaluables (PEC)

Las prácticas podrán calificarse mediante observación directa registrada en una ficha de seguimiento y/o mediante rúbrica, según las características de las actividades.

**Las prácticas deberán ser realizadas por el propio alumno o alumna.**

Durante la revisión, la profesora podrá solicitar que el estudiante:

- Explique las operaciones y procedimientos realizados.
- Justifique las decisiones adoptadas.
- Interprete el funcionamiento de su código.
- Reproduzca alguno de los procedimientos utilizados.

Estas comprobaciones permitirán verificar tanto la **autoría del trabajo** como la **comprensión de los contenidos**.

**Importante:** la correcta entrega o ejecución de una práctica no garantiza la puntuación máxima. También será necesario demostrar que se comprenden los procedimientos realizados.

### Criterios de calificación de las prácticas

La calificación de cada criterio de evaluación práctico se distribuirá de la siguiente manera:

| Evidencia | Qué se valora | Puntuación máxima |
|---|---|---:|
| **Ejecución correcta de los procedimientos solicitados** | Realiza y demuestra las operaciones solicitadas. | **6 puntos** |
| **Comprensión y explicación de los procedimientos realizados** | Responde a preguntas sobre lo realizado y explica su finalidad. | **4 puntos** |
| **Total por CE** | | **10 puntos** |

## Mapa de la unidad

```text
Ficheros y directorios
        │
        ├── Acceso secuencial / aleatorio
        ├── Flujos de bytes / caracteres
        └── Excepciones
                │
                ▼
       Serialización de objetos
                │
                ▼
        Formatos de intercambio
          ├── JSON
          └── XML
                │
                ▼
         Analizadores XML
         DOM · SAX · JAXB
                │
                ▼
              XPath
                │
                ▼
        Conversión XML ↔ JSON
```

## Materiales didácticos

Los apuntes, ejemplos y recursos necesarios para esta unidad se encuentran disponibles en:

- **Aula virtual del módulo de Acceso a Datos.**
- **[Sitio web de Acceso a Datos – UT1](https://rlrprofe.github.io/AD-2627/ut1/).**

Se propone una batería amplia de ejercicios para practicar los contenidos de la unidad.

**Es imprescindible que el alumnado realice los ejercicios propuestos y plantee sus dudas durante las clases.**

## Cómo utilizar estos materiales

Cada bloque contiene explicaciones, ejemplos progresivos, tablas de consulta y proyectos descargables. Los ejemplos Java están planteados para **JDK 21**.

Se recomienda estudiar primero los conceptos de cada apartado, ejecutar los ejemplos proporcionados y realizar posteriormente los ejercicios de forma autónoma.
