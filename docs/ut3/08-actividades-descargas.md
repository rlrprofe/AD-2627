# 3.8. Actividades, proyecto y descargas

## 1. Proyecto transversal: Gestión de inventario

A lo largo de la UT3 hemos desarrollado una misma aplicación Java 21 con Maven, separando el modelo, el servicio y el acceso a datos mediante una interfaz DAO. Hemos implementado dos mecanismos de persistencia: CSV y MySQL con JDBC.

### Material de partida

[**Descargar proyecto inicial (ZIP)**](../descargas/ut3/Gestion_Inventario_Inicial_Java21_Maven.zip)

Este proyecto contiene la estructura Maven, `pom.xml` mínimo, el modelo `Producto` y la interfaz `ProductoDAO`. No incluye las implementaciones DAO ni la aplicación terminada. Completa el desarrollo siguiendo los apartados 3.2 a 3.7.

## 2. Actividades de consolidación

1. **Arquitectura:** explica la función de `Producto`, `ProductoDAO`, `ProductoService` y `App`.
2. **CSV:** implementa y comprueba las cinco operaciones CRUD con `ProductoFicheroDAO`.
3. **JDBC:** crea la tabla MySQL e implementa las mismas operaciones en `ProductoJdbcDAO` con `PreparedStatement`.
4. **Pruebas:** añade pruebas JUnit para las reglas de negocio y documenta la interfaz DAO.
5. **Integración:** ejecuta la misma aplicación con ambas persistencias sin modificar la capa de servicio.
6. **Empaquetado:** construye y prueba el JAR ejecutable mediante Maven.

## 3. Entrega del alumno

Entrega el proyecto Maven con el código fuente, el `pom.xml`, el script SQL, las pruebas y un README que explique cómo ejecutarlo. Adjunta también el enlace al repositorio Git con historial de cambios.

## 4. Solución de referencia (al finalizar la unidad)

!!! warning "Consultar después de completar las actividades"
    El siguiente ZIP contiene **la aplicación resuelta**. Se facilita para contrastar el trabajo una vez terminados los apartados 3.1 a 3.7 y las actividades de consolidación.

[**Descargar proyecto completo / solución de referencia (ZIP)**](../descargas/ut3/Gestion_Inventario_Completo_Java21_Maven.zip)

Incluye la aplicación de consola, los DAO CSV y JDBC, la capa de servicio, pruebas JUnit, el script MySQL y el `pom.xml` final.

!!! note "Requisitos"
    Se necesita JDK 21 y Maven. Para probar la versión JDBC se necesita además MySQL y configurar la conexión. No publiques contraseñas en el repositorio.
