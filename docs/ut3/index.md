
# UT3 · Diseño y desarrollo de componentes de acceso a datos

En la UT1 aprendimos a gestionar información almacenada en **ficheros** y en la UT2 a acceder a **bases de datos relacionales mediante JDBC**. En esta unidad aprenderás a diseñar y desarrollar **componentes de acceso a datos reutilizables**, separando las responsabilidades de una aplicación para facilitar su mantenimiento, las pruebas y la integración. La solución de referencia aplica **MVC + capa de servicio + patrón DAO**, con configuración mediante fichero `.properties` y cierre seguro de recursos con `try-with-resources`: el menú se sitúa en la vista, la coordinación en el controlador y el acceso a datos en componentes intercambiables.

Como proyecto conductor utilizaremos una aplicación de **gestión de productos** que podrá almacenar información en un fichero CSV o en una base de datos MySQL mediante distintas implementaciones de una misma interfaz.

## Contenidos

1. **[Programación orientada a componentes](01-componentes.md).** Concepto de componente, características, ventajas e inconvenientes.
2. **[Herramientas de desarrollo](02-herramientas.md).** IDE, JDK 21, conceptos esenciales de Maven, paquetes y visibilidad.
3. **[Arquitectura por capas, interfaces y DAO](03-arquitectura-dao.md).** Separación de responsabilidades, cohesión, acoplamiento, interfaces, polimorfismo y patrón DAO.
4. **[Componentes de acceso a ficheros](04-componentes-ficheros.md).** Encapsulación de operaciones de lectura y escritura en ficheros CSV.
5. **[Componentes de acceso mediante JDBC](05-componentes-jdbc.md).** Desarrollo de componentes que gestionan información almacenada en bases de datos MySQL mediante conectores.
6. **[Pruebas y documentación](06-pruebas-documentacion.md).** Pruebas de componentes, JUnit 5, Javadoc y documentación de uso.
7. **[Integración de componentes](07-integracion.md).** Composición de la aplicación MVC, selección de persistencia y empaquetado.
8. **[Actividades, proyecto y descargas](08-actividades-descargas.md).** Prácticas de consolidación y solución de referencia.

Para ampliar la configuración y el uso de Maven, consulta el **[Anexo · Apache Maven para proyectos Java](../anexo-maven/index.md)**.


## Arquitectura de la aplicación

En una operación normal, el usuario interactúa con la **vista**, el **controlador** coordina la acción, el **servicio** valida los datos y el **DAO** realiza el acceso al almacenamiento. El siguiente esquema representa el **flujo de una operación**, no el orden en el que se crean los objetos:

```mermaid
flowchart TB
    vista["ConsolaVista: interacción con el usuario"]
    controlador["ProductoControlador: coordina"]
    servicio["ProductoService: reglas de negocio"]
    dao["ProductoDAO: contrato de persistencia"]
    vista <--> controlador
    controlador --> servicio
    servicio --> dao
```

La interfaz `ProductoDAO` tiene dos implementaciones alternativas:

| Implementación | Almacenamiento | Se utiliza cuando... |
|---|---|---|
| `ProductoFicheroDAO` | Fichero `datos/productos.csv` | `almacenamiento.tipo=csv` |
| `ProductoJdbcDAO` | Base de datos MySQL | `almacenamiento.tipo=mysql` |

**¿Dónde quedan `App` y la configuración?** `App` es el punto de entrada. Al arrancar, `Configuracion` lee el fichero `.properties`; `FabricaDao` crea el DAO elegido y `App` construye el servicio, la vista y el controlador. `ConexionBD` proporciona conexiones JDBC al DAO MySQL. Estas tareas de **inicialización** no forman parte del flujo de cada operación.

### Responsabilidades de las clases

| Clase | Responsabilidad principal |
|---|---|
| `Producto` | Representar un producto mediante un `record`. |
| `ConsolaVista` | Mostrar el menú, leer datos y presentar resultados. |
| `ProductoControlador` | Coordinar los casos de uso: alta, búsqueda, listado, modificación y baja. |
| `ProductoService` | Validar y aplicar reglas de negocio. |
| `ProductoDAO` | Definir las operaciones CRUD sin imponer CSV ni MySQL. |
| `ProductoFicheroDAO` y `ProductoJdbcDAO` | Implementar el contrato en CSV y MySQL. |
| `Configuracion` | Leer el fichero `config/configuracion.properties`. |
| `FabricaDao` | Crear la implementación de `ProductoDAO` seleccionada. |
| `ConexionBD` | Abrir conexiones a MySQL. |
| `App` | Ensamblar las dependencias y arrancar el controlador. |

!!! info "MVC en consola"
    No hace falta una interfaz gráfica para separar vista, controlador y modelo. El objetivo principal de esta UT3 sigue siendo **desarrollar componentes de acceso a datos**; MVC organiza la aplicación que los utiliza.

## Resultado de aprendizaje

**RA6.** Programa componentes de acceso a datos identificando las características que debe poseer un componente y utilizando herramientas de desarrollo.

En esta unidad se trabajan los criterios **a), b), c), d), h) e i)** del RA6. Los restantes criterios se desarrollarán en otras unidades del módulo.

## Criterios de evaluación

| CE | Criterio de evaluación |
|---|---|
| **a)** | Se han valorado las ventajas e inconvenientes de utilizar programación orientada a componentes. |
| **b)** | Se han identificado herramientas de desarrollo de componentes. |
| **c)** | Se han programado componentes que gestionan información almacenada en ficheros. |
| **d)** | Se han programado componentes que gestionan mediante conectores información almacenada en bases de datos. |
| **h)** | Se han probado y documentado los componentes desarrollados. |
| **i)** | Se han integrado los componentes desarrollados en aplicaciones. |

## Evaluación y calificación de la UT3

La unidad desarrolla una parte del **RA6**, que tiene una ponderación del **15 % en la calificación final del módulo**.

Para evaluar los criterios de evaluación asociados a esta unidad se utilizarán los siguientes instrumentos:

| Instrumento | Peso |
|---|---:|
| **PEC (prácticas evaluables)** | **60 %** |
| **Prueba objetiva** | **40 %** |

### 1. PEC: prácticas evaluables (60 %)

Las actividades prácticas permitirán trabajar el diseño de componentes, el acceso a ficheros y bases de datos, la realización de pruebas y la integración en una aplicación.

Los enunciados concretos, las condiciones de entrega y los plazos se comunicarán a través del **aula virtual**. Esta guía no establece un número cerrado de entregas ni una ponderación independiente para cada ejercicio.

Las prácticas deberán ser **originales y realizadas por el propio alumno o alumna**.

Podrán calificarse mediante observación directa registrada en una ficha de seguimiento y/o mediante rúbrica, según las características de la actividad.

#### ¿Cómo se califica cada criterio de evaluación práctico?

| Evidencia | Qué se comprobará | Puntuación máxima |
|---|---|---:|
| **Ejecución correcta** | Desarrolla y demuestra los componentes y procedimientos solicitados. | **6 puntos** |
| **Comprensión y explicación** | Explica el funcionamiento del código, las decisiones de diseño y la integración de los componentes. | **4 puntos** |
| **Total por CE práctico** | | **10 puntos** |

Durante la revisión, la profesora podrá solicitar que el estudiante:

- Ejecute el proyecto y demuestre su funcionamiento.
- Explique las clases, interfaces y métodos desarrollados.
- Justifique las decisiones de diseño adoptadas.
- Interprete el funcionamiento de su código.
- Reproduzca o modifique alguno de los procedimientos realizados.

Estas comprobaciones permitirán verificar tanto la **autoría del trabajo** como la **comprensión de los contenidos**.

**Importante:** la correcta entrega o ejecución de una práctica no garantiza la puntuación máxima. También será necesario demostrar que se comprenden los procedimientos realizados.

!!! warning "Autoría de las prácticas"
    Las prácticas deben ser **originales y de elaboración propia**. Si se acredita copia, presentación como propio de un trabajo no realizado o utilización de medios no autorizados, **la práctica se calificará con 0**, conforme a la guía didáctica.

### 2. Prueba objetiva (40 %)

La prueba objetiva incluirá contenidos teórico-prácticos de la unidad y podrá combinar diferentes tipos de preguntas y ejercicios:

- Preguntas de tipo test.
- Preguntas cortas o de desarrollo.
- Cuestiones abiertas o cerradas.
- Ejercicios prácticos de programación.
- Análisis, interpretación o corrección de fragmentos de código Java.

Estos son formatos posibles y no implican una distribución fija de preguntas ni de puntuaciones dentro del examen.

## Mapa de la unidad

El recorrido está organizado en ocho apartados. Primero identificamos qué es un componente; después construimos progresivamente una aplicación que utiliza **dos componentes de persistencia intercambiables**.

| Paso | Apartado | Qué aprenderemos | Resultado en el proyecto |
|---|---|---|---|
| 1 | [3.1. Componentes](01-componentes.md) | Cohesión, acoplamiento y reutilización | Entender el problema y el diseño propuesto |
| 2 | [3.2. Herramientas](02-herramientas.md) | JDK 21, Maven y estructura del proyecto | Proyecto inicial compilable |
| 3 | [3.3. Arquitectura y DAO](03-arquitectura-dao.md) | Interfaces, modelo, servicio y MVC | Contrato `ProductoDAO` y reglas de negocio |
| 4 | [3.4. Ficheros](04-componentes-ficheros.md) | CRUD en CSV y vista de consola | Primera aplicación funcional |
| 5 | [3.5. JDBC](05-componentes-jdbc.md) | CRUD en MySQL y conexiones | Segunda implementación del DAO |
| 6 | [3.6. Pruebas](06-pruebas-documentacion.md) | JUnit, pruebas aisladas y Javadoc | Comprobación de componentes |
| 7 | [3.7. Integración](07-integracion.md) | `.properties`, fábrica DAO y JAR | Aplicación final configurable |
| 8 | [3.8. Actividades](08-actividades-descargas.md) | Consolidación y entrega | Solución de referencia |

## Materiales didácticos

Los apuntes, ejemplos y recursos necesarios para esta unidad se encuentran disponibles en:

- **Aula virtual del módulo de Acceso a Datos.**
- **[Sitio web de Acceso a Datos – UT3](https://rlrprofe.github.io/AD-2627/ut3/).**
- **[Ejercicios, proyecto y descargas](08-actividades-descargas.md).**

Para realizar las prácticas se utilizarán **JDK 21**, **Maven**, un entorno de desarrollo Java, **MySQL** y, cuando corresponda, **JUnit 5**.

Se propone una batería de ejercicios para practicar los contenidos de la unidad.

**Es imprescindible que el alumnado realice los ejercicios propuestos y plantee sus dudas durante las clases.**

## Cómo utilizar estos materiales

Cada bloque contiene explicaciones, ejemplos progresivos y actividades prácticas. Los ejemplos Java están planteados para **JDK 21**.

Se recomienda estudiar primero los conceptos de cada apartado, ejecutar los ejemplos proporcionados y realizar posteriormente los ejercicios de forma autónoma.

El repaso de **interfaces y polimorfismo** del apartado 3.3 es especialmente importante para comprender el patrón DAO y la sustitución de componentes.
