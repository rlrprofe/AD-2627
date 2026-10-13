# Comparativa · DOM, SAX y JAXB

## 1. ¿Qué tienen en común?

Los tres enfoques permiten trabajar con información XML desde Java, pero **no ofrecen el mismo nivel de abstracción**: DOM proporciona nodos, SAX comunica eventos y JAXB construye objetos de nuestras clases.

## 2. Comparativa completa

| Aspecto | DOM | SAX | JAXB |
|---|---|---|---|
| Modelo | Árbol en memoria | Eventos secuenciales | Objetos Java |
| Resultado principal | `Document`, `Element`, `NodeList` | Métodos del *handler* | Instancias de clases del modelo |
| ¿Conserva todo el XML en un árbol DOM? | Sí | No | No necesariamente; depende de la implementación y del uso |
| Memoria | Mayor en XML grandes | Habitualmente reducida | Depende de cuántos objetos se recuperen |
| Navegación libre | Sí | No | Sí, sobre los objetos ya creados |
| Modificación de estructura | Directa sobre el árbol | No es su objetivo | Se modifican objetos y se vuelve a generar XML |
| ¿Exige clases de modelo propias? | No | No | Habitualmente sí |
| Complejidad inicial | Media | Media-alta si hay estado | Configuración inicial de anotaciones |
| Uso habitual | Consultar y editar XML | Importar XML grandes | Intercambiar XML con modelos estables |

!!! note "Una precisión sobre JAXB"
    JAXB no es un tercer tipo de parser al mismo nivel interno que DOM o SAX: es una **capa de enlace entre XML y objetos** que utiliza mecanismos de análisis XML por debajo.

## 3. Elegir la tecnología según el problema

| Situación | Elección razonable | Motivo |
|---|---|---|
| Cambiar el año de un libro en un XML y guardarlo | **DOM** | Permite localizar y modificar nodos |
| Leer cientos de miles de registros y contabilizarlos | **SAX** | Evita mantener todo el árbol en memoria |
| Guardar una instancia de `Alumno` como XML | **JAXB** | Convierte el objeto mediante anotaciones |
| Buscar elementos con expresiones XPath | **DOM + XPath** | XPath puede evaluar rutas sobre un documento DOM |
| Leer XML y generar un informe sin modificarlo | **SAX** o **DOM** | Depende del tamaño y de la complejidad de las consultas |

## 4. Preguntas de autoevaluación

1. ¿Por qué DOM consume más memoria que SAX en documentos grandes?
2. ¿Puede SAX modificar directamente un nodo de un árbol que no construye?
3. ¿Qué diferencia hay entre un `Element` de DOM y un `Alumno` recuperado con JAXB?
4. Si solo necesitas contar alumnos en un XML enorme, ¿qué tecnología elegirías y por qué?
5. Si necesitas cambiar varios elementos y guardar el XML, ¿cuál elegirías?

## 5. Relación con los siguientes apartados

- **[XPath](../05-xpath/index.md)** complementa DOM para localizar nodos mediante rutas y filtros.
- **[Conversión XML ↔ JSON](../06-conversion/index.md)** aprovecha DOM, SAX, XPath y JAXB para transformar datos entre formatos.

[Volver a la introducción de Analizadores](index.md).
