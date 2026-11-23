# 4.7. Desarrollo de aplicaciones con ORM

## 1. Del ejemplo aislado a una aplicación mantenible

En la UT3 aprendimos a separar responsabilidades. La UT4 reutiliza esa idea: **el controlador no ejecuta HQL, la vista no abre sesiones y el DAO no lee el teclado**.

| Componente | Responsabilidad |
|---|---|
| `App` | Configurar y conectar componentes |
| `ConsolaVista` | Entrada/salida de consola |
| `ProductoControlador` | Coordinar acciones |
| `ProductoService` | Validar reglas de negocio |
| `ProductoDAO` | Definir operaciones de persistencia |
| `ProductoJpaDAO` | Implementar operaciones mediante Hibernate/JPA |
| `JpaUtil` | Crear y cerrar la fábrica de entidades |
| `ConfiguracionBD` | Leer las propiedades locales |

## 2. Recorrido de una operación

1. El usuario introduce datos en la vista.
2. El controlador solicita la operación al servicio.
3. El servicio comprueba los datos y llama al DAO.
4. El DAO abre un `EntityManager`, inicia una transacción cuando es necesario y trabaja con entidades.
5. El DAO cierra el contexto y devuelve el resultado.
6. El controlador solicita a la vista que muestre el mensaje.

## 3. Configuración externa

El fichero `config/bd.properties` contiene URL, usuario y contraseña. Se lee con `Properties` y `try-with-resources`:

```java
Properties propiedades = new Properties();
try (InputStream entrada = Files.newInputStream(ruta)) {
    propiedades.load(entrada);
}
```

La aplicación debe ejecutarse desde la raíz del proyecto, donde se encuentra `config/`. La plantilla `.example` permite compartir el código sin credenciales.

## 4. Gestión de transacciones

No basta con llamar a `persist()`: debemos decidir cuándo confirmar. Cada alta, modificación o baja se realiza en una transacción; si falla, se revierte.

## 5. Pruebas

Comprobaremos: alta válida, búsqueda existente e inexistente, modificación, baja, consulta filtrada, consulta SQL nativa, errores de configuración y rollback. Una prueba con MySQL requiere una base de datos preparada; no debe confundirse con una prueba unitaria sin dependencias externas.

## 6. RA6.e: componente reutilizable

El componente `ProductoJpaDAO` cumple una interfaz `ProductoDAO`. El servicio depende del contrato, no de la implementación concreta. Esta separación permite sustituir el mecanismo de persistencia sin reescribir la vista.

## 7. Actividad de consolidación

Explica por qué `App` no debería contener sentencias SQL ni métodos para mostrar el menú.

??? success "Orientación"
    Porque son responsabilidades distintas: `App` ensambla; la vista presenta; el controlador coordina; el servicio valida y el DAO accede a datos. Esta organización reduce el acoplamiento y facilita las pruebas.

**Referencia:** carpeta `07-desarrollo-sw-orm` del material del curso anterior y criterios RA3/RA6.e de la programación actual.
