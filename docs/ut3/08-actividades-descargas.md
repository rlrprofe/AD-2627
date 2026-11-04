# 3.8. Actividades, proyecto y descargas

## 1. Proyecto transversal: Gestión de inventario

A lo largo de la UT3 hemos desarrollado una misma aplicación Java 21 con Maven, separando **modelo, vista, controlador, servicio y acceso a datos**. El patrón MVC organiza la interacción con el usuario y el patrón DAO permite cambiar de almacenamiento sin modificar la lógica de negocio. Hemos implementado dos mecanismos de persistencia: CSV y MySQL con JDBC.

### Material de partida

[**Descargar proyecto inicial (ZIP)**](../descargas/ut3/Gestion_Inventario_Inicial_Java21_Maven.zip)

Este proyecto contiene la estructura Maven, `pom.xml` mínimo, el modelo `Producto` y la interfaz `ProductoDAO`. No incluye las implementaciones DAO ni la aplicación terminada. Completa el desarrollo siguiendo los apartados 3.2 a 3.7.

## 2. Actividades de consolidación

1. **Arquitectura:** explica la función de `Producto`, `ConsolaVista`, `ProductoControlador`, `ProductoDAO`, `ProductoService`, `Configuracion` y `App`.
2. **CSV:** implementa y comprueba las cinco operaciones CRUD con `ProductoFicheroDAO`.
3. **JDBC:** crea la tabla MySQL e implementa las mismas operaciones en `ProductoJdbcDAO` con `PreparedStatement`.
4. **Pruebas:** añade pruebas JUnit para las reglas de negocio y documenta la interfaz DAO.
5. **Integración:** ejecuta la misma aplicación con ambas persistencias sin modificar la vista, el controlador ni el servicio.
6. **Empaquetado:** construye y prueba el JAR ejecutable mediante Maven.

## 3. Entrega del alumno

Entrega el proyecto Maven con el código fuente, el `pom.xml`, el script SQL, las pruebas y un README que explique cómo ejecutarlo. Adjunta también el enlace al repositorio Git con historial de cambios.

### Comprobación de la modularización

Antes de consultar la solución, comprueba que:

- [ ] `App` no contiene el menú ni operaciones CRUD.
- [ ] `ConsolaVista` es la única clase que lee del teclado y muestra mensajes.
- [ ] `ProductoControlador` tiene métodos diferenciados para alta, búsqueda, listado, modificación y baja.
- [ ] `ProductoService` valida los datos sin conocer el almacenamiento.
- [ ] El servicio depende de `ProductoDAO`, no de una implementación concreta.
- [ ] Cambiar de CSV a MySQL no obliga a modificar la vista ni el controlador.
- [ ] Las pruebas pueden ejecutarse sin una conexión MySQL real cuando verifican reglas de negocio.

### Configuración que debes poder explicar en la defensa

1. ¿Por qué `App` no debería contener SQL ni el menú?
2. ¿Qué diferencia existe entre `Configuracion`, `FabricaDao` y `ConexionBD`?
3. ¿Cómo cambias entre CSV y MySQL sin tocar el código Java?
4. ¿Qué recursos se cierran mediante `try-with-resources`?
5. ¿Por qué no debes subir `config/configuracion.properties` con contraseñas?

??? success "Orientaciones para la solución"
    - `App` es el punto de composición; la vista muestra el menú y el DAO ejecuta la persistencia.
    - `Configuracion` lee las propiedades, `FabricaDao` elige el DAO y `ConexionBD` abre conexiones.
    - Se modifica `almacenamiento.tipo` en `config/configuracion.properties`.
    - Se cierran flujos de lectura/escritura, `Scanner` y recursos JDBC.
    - El archivo real puede contener credenciales; se comparte solo la plantilla `.example`.

## 4. Solución de referencia (al finalizar la unidad)

!!! warning "Consultar después de completar las actividades"
    El siguiente ZIP contiene **la aplicación resuelta**. Se facilita para contrastar el trabajo una vez terminados los apartados 3.1 a 3.7 y las actividades de consolidación.

[**Descargar proyecto completo / solución de referencia (ZIP)**](../descargas/ut3/Gestion_Inventario_Completo_Java21_Maven.zip)

Incluye la aplicación de consola **modularizada con MVC**, los DAO CSV y JDBC, la capa de servicio, pruebas JUnit, el script MySQL, el `pom.xml` final y `config/configuracion.properties.example`. Cada estudiante crea localmente su fichero de configuración; no debe publicarse con contraseñas. `App` solo conecta los componentes; `ConsolaVista` gestiona la interacción y `ProductoControlador` coordina las operaciones.

!!! note "Requisitos"
    Se necesita JDK 21 y Maven. Para probar la versión JDBC se necesita además MySQL y configurar la conexión. No publiques contraseñas en el repositorio.
