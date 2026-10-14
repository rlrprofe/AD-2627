# 10. ¿Qué contiene el JAR generado?

Un archivo **JAR (Java Archive)** permite agrupar clases compiladas y recursos Java.

Un JAR estándar de Maven puede contener:

- Archivos `.class` compilados.
- Recursos del proyecto.
- Información de empaquetado.
- Metadatos Maven.

Sin embargo, no suele incluir automáticamente todas las dependencias externas.

!!! warning "El JAR no incluye automáticamente todas las dependencias"
    Si nuestro proyecto utiliza MySQL Connector/J, el controlador debe estar disponible durante la ejecución.

    Para crear un JAR que incorpore dependencias externas es necesario utilizar una configuración específica de empaquetado.

    En esta unidad ejecutaremos normalmente los proyectos desde Maven o desde el IDE.
