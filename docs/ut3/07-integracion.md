# 3.7. Integración de componentes en aplicaciones

!!! info "Proyecto de trabajo"
    Continúa con el [proyecto inicial de Gestión de inventario](../descargas/ut3/Gestion_Inventario_Inicial_Java21_Maven.zip). Añade los archivos y las dependencias de este apartado. La solución completa se facilita al finalizar la UT3.


## Objetivos

- Integrar las implementaciones CSV y JDBC en una sola aplicación.
- Elegir el mecanismo de persistencia sin modificar las reglas de negocio.
- Construir un JAR ejecutable con Maven y documentar su puesta en marcha.

## 1. Punto de integración

La clase `App` utiliza un único servicio:

```java
ProductoDAO dao = crearDao();
ProductoService servicio = new ProductoService(dao);
```

El método `crearDao()` selecciona la implementación:

```java
private static ProductoDAO crearDao() {
    String modo = System.getenv().getOrDefault("INVENTARIO_STORAGE", "csv");
    return switch (modo.toLowerCase()) {
        case "csv" -> new ProductoFicheroDAO(Path.of("datos", "productos.csv"));
        case "mysql" -> new ProductoJdbcDAO();
        default -> throw new IllegalArgumentException("Persistencia desconocida: " + modo);
    };
}
```

!!! important "Concepto clave"
    `ProductoService` desconoce si el almacenamiento es un fichero o una base de datos. La selección se realiza al arrancar la aplicación.

## 2. Preparar el JAR ejecutable

En el `pom.xml` incorporamos `maven-jar-plugin` para indicar la clase principal:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <version>3.4.2</version>
            <configuration>
                <archive>
                    <manifest>
                        <mainClass>es.iesisidra.inventario.App</mainClass>
                    </manifest>
                </archive>
            </configuration>
        </plugin>
    </plugins>
</build>
```

!!! warning "Dependencias externas"
    El JAR básico no incluye las dependencias externas dentro del mismo archivo. Para generar un JAR autónomo con el driver JDBC incluido, incorpora también `maven-shade-plugin`. El proyecto completo, disponible al terminar la unidad, contiene esa configuración.

## 3. Construcción final

```bash
mvn clean package
```

Resultado esperado:

```text
target/gestion-inventario-1.0-SNAPSHOT.jar
```

Este resultado requiere completar la configuración de empaquetado con `maven-shade-plugin`, además de los cambios indicados en esta sección.

## 4. Ejecutar con CSV

Por defecto:

```bash
java -jar target/gestion-inventario-1.0-SNAPSHOT.jar
```

El fichero se guarda en `datos/productos.csv`, relativo al directorio desde el que ejecutamos el programa.

## 5. Ejecutar con MySQL

Primero ejecuta `sql/inventario.sql` en MySQL y configura las variables de entorno.

**PowerShell:**

```powershell
$env:INVENTARIO_STORAGE = "mysql"
$env:INVENTARIO_DB_URL = "jdbc:mysql://localhost:3306/inventario"
$env:INVENTARIO_DB_USER = "inventario_app"
$env:INVENTARIO_DB_PASSWORD = "TU_CLAVE_LOCAL"
java -jar target/gestion-inventario-1.0-SNAPSHOT.jar
```

**Linux (bash):**

```bash
export INVENTARIO_STORAGE=mysql
export INVENTARIO_DB_URL=jdbc:mysql://localhost:3306/inventario
export INVENTARIO_DB_USER=inventario_app
export INVENTARIO_DB_PASSWORD='TU_CLAVE_LOCAL'
java -jar target/gestion-inventario-1.0-SNAPSHOT.jar
```

No compartas las contraseñas ni las guardes en el repositorio.

## 6. Comprobar la integración

Realiza estas operaciones en **ambos modos**:

1. Listar productos.
2. Insertar un producto nuevo.
3. Buscar el producto por su identificador.
4. Modificar el precio y el stock.
5. Eliminarlo.

Anota si el menú cambia y qué componente es responsable de la persistencia.

## 7. Propuesta de ampliación

Añade una tercera implementación `ProductoMemoriaDAO` y comprueba que no necesitas modificar ni la interfaz de usuario ni `ProductoService`.

Como reto adicional, puedes sustituir el CSV simplificado por una biblioteca que gestione correctamente campos entrecomillados y separadores.

## 8. Entrega del proyecto

Entrega:

- Repositorio Git con historial de desarrollo.
- Proyecto Maven completo y compilable con Java 21.
- Implementaciones CSV y JDBC de `ProductoDAO`.
- Script SQL y datos de ejemplo.
- Pruebas unitarias ejecutables mediante `mvn test`.
- Breve README con instrucciones para ejecutar ambas versiones.

**Continúa con:** [Ejercicios, proyecto y descargas](08-actividades-descargas.md).
