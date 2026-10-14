# 4. Organización estándar de un proyecto Maven

Una ventaja de Maven es que utiliza una **estructura de directorios convencional**.

Esto permite que diferentes desarrolladores puedan reconocer rápidamente dónde se encuentra cada elemento de un proyecto.

Ejemplo:

```text
gestion-productos/
│
├── pom.xml
├── README.md
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── es/
│   │   │       └── iesisidra/
│   │   │           └── productos/
│   │   │               ├── modelo/
│   │   │               │   └── Producto.java
│   │   │               └── dao/
│   │   │                   └── ProductoDAO.java
│   │   │
│   │   └── resources/
│   │
│   └── test/
│       ├── java/
│       │   └── es/
│       │       └── iesisidra/
│       │           └── productos/
│       │
│       └── resources/
│
└── target/
```

#### ¿Qué contiene cada directorio?

| Elemento | Función |
|---|---|
| `pom.xml` | Archivo principal de configuración de Maven. |
| `README.md` | Información general y documentación del proyecto. |
| `src/main/java` | Código fuente Java de la aplicación. |
| `src/main/resources` | Archivos de configuración y otros recursos de producción. |
| `src/test/java` | Código de las pruebas automatizadas. |
| `src/test/resources` | Recursos utilizados por las pruebas. |
| `target/` | Resultados de compilación y empaquetado. |

El directorio `target/` se genera durante la construcción del proyecto.

!!! note "Buenas prácticas"
    Normalmente, `target/` no debe incorporarse al repositorio Git, ya que contiene archivos generados automáticamente.

    Se recomienda incluirlo en `.gitignore`.
