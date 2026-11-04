# 3.3. Arquitectura por capas, interfaces y DAO

!!! info "Proyecto de trabajo"
    Continúa con el [proyecto inicial de Gestión de inventario](../descargas/ut3/Gestion_Inventario_Inicial_Java21_Maven.zip). Añade los archivos y las dependencias de este apartado. La solución completa se facilita al finalizar la UT3.


## Objetivos

- Separar presentación, negocio y persistencia.
- Definir un contrato DAO independiente de la tecnología de almacenamiento.
- Crear el modelo y el servicio de la aplicación.

## 1. Separación de responsabilidades: MVC + servicio + DAO

El **DAO** encapsula el acceso a datos, pero no debe gestionar menús. El **servicio** aplica reglas de negocio, pero no debe leer del teclado. Para separar la interacción con el usuario utilizaremos una **vista** y un **controlador**.

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

### Ejemplo: registrar un producto

1. `ConsolaVista.solicitarProducto()` recoge los datos introducidos.
2. `ProductoControlador.alta()` recibe el producto y llama a `ProductoService.alta(...)`.
3. El servicio comprueba las reglas de negocio y delega en `ProductoDAO.insertar(...)`.
4. El DAO elegido guarda el producto en CSV o MySQL.
5. El controlador pide a la vista que muestre la confirmación.

### ¿Por qué separar también la configuración?

En la solución final `Configuracion` **lee propiedades**, `FabricaDao` **elige el DAO** y `ConexionBD` **abre conexiones JDBC**. `App` se limita a crear y conectar objetos. Así no mezclamos el menú, la lógica de negocio y las credenciales de la base de datos.

## 2. Crear el modelo

Archivo: **`src/main/java/es/iesisidra/inventario/modelo/Producto.java`**.

```java
package es.iesisidra.inventario.modelo;

public record Producto(int id, String nombre, double precio, int stock) { }
```

Utilizamos un `record` de Java 21 para representar datos inmutables. Cuando se modifica un producto se crea un nuevo valor con el mismo `id` y los atributos actualizados.

## 3. Definir el contrato DAO

Archivo: **`src/main/java/es/iesisidra/inventario/dao/ProductoDAO.java`**.

```java
package es.iesisidra.inventario.dao;

import es.iesisidra.inventario.modelo.Producto;
import java.util.List;
import java.util.Optional;

public interface ProductoDAO {
    void insertar(Producto producto);
    Optional<Producto> buscarPorId(int id);
    List<Producto> listar();
    boolean actualizar(Producto producto);
    boolean eliminar(int id);
}
```

La interfaz describe **qué operaciones** puede realizar el componente, no **cómo** las ejecuta.

- `Optional<Producto>` permite representar una búsqueda sin resultado.
- `List<Producto>` devuelve los productos existentes.
- `boolean` indica si se ha modificado o eliminado algún registro.
- `insertar` y los demás métodos pueden lanzar excepciones de ejecución cuando falla la persistencia.

## 4. Implementar las reglas de negocio

Archivo: **`src/main/java/es/iesisidra/inventario/servicio/ProductoService.java`**.

```java
package es.iesisidra.inventario.servicio;

import es.iesisidra.inventario.dao.ProductoDAO;
import es.iesisidra.inventario.modelo.Producto;
import java.util.List;
import java.util.Optional;

public class ProductoService {
    private final ProductoDAO dao;

    public ProductoService(ProductoDAO dao) {
        this.dao = dao;
    }

    public void alta(Producto p) {
        validar(p);
        if (dao.buscarPorId(p.id()).isPresent()) {
            throw new IllegalArgumentException("El ID ya existe");
        }
        dao.insertar(p);
    }

    public Optional<Producto> buscar(int id) {
        return dao.buscarPorId(id);
    }

    public List<Producto> listar() {
        return dao.listar();
    }

    public boolean modificar(Producto p) {
        validar(p);
        return dao.actualizar(p);
    }

    public boolean baja(int id) {
        return dao.eliminar(id);
    }

    private void validar(Producto p) {
        if (p.id() <= 0 || p.nombre() == null || p.nombre().isBlank()
                || !Double.isFinite(p.precio()) || p.precio() < 0 || p.stock() < 0) {
            throw new IllegalArgumentException("Datos de producto no válidos");
        }
    }
}
```

!!! important "Inyección de dependencias"
    El servicio recibe un `ProductoDAO` en el constructor. No crea un DAO concreto con `new ProductoFicheroDAO(...)` ni con `new ProductoJdbcDAO(...)`. Esto permite sustituir la persistencia sin modificar el servicio.

## 5. ¿Dónde están la vista y el controlador?

En este apartado definimos el **contrato de persistencia** y las **reglas de negocio**. En 3.4, al disponer de un DAO CSV funcional, incorporaremos `ConsolaVista` y `ProductoControlador`.

La vista se ocupará de `Scanner`, mensajes y formato de salida. El controlador interpretará las opciones y llamará a los métodos de `ProductoService`. `App` quedará reducida a crear las dependencias y arrancar el controlador.

### Ejemplo: reparto de tareas durante un alta

1. `ConsolaVista.solicitarProducto()` recoge ID, nombre, precio y stock.
2. `ProductoControlador.alta()` recibe el producto y llama a `servicio.alta(producto)`.
3. `ProductoService.alta()` valida y comprueba que no exista el identificador.
4. `ProductoDAO.insertar()` delega el almacenamiento en la implementación seleccionada.
5. El controlador solicita a la vista que muestre «Producto registrado».

**Importante:** la vista no debe llamar directamente al DAO y el DAO no debe imprimir mensajes para el usuario.

## 6. Actividad

1. Añade al modelo un atributo `categoria`. ¿Qué componentes tendrían que adaptarse?
2. Explica por qué `ProductoService` depende de `ProductoDAO` y no de `ProductoFicheroDAO`.
3. Dibuja un diagrama UML de clases con `App`, `ConsolaVista`, `ProductoControlador`, `ProductoService`, `ProductoDAO` y las dos implementaciones.

**Continúa con:** [3.4. Componentes de acceso a ficheros](04-componentes-ficheros.md).
