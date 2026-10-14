# 8. Ciclo de vida de Maven

Maven organiza la construcción de un proyecto mediante un conjunto de **fases**.

Cada fase tiene una finalidad concreta.

Algunas de las más importantes son:

| Fase | Función |
|---|---|
| `validate` | Comprueba la información básica del proyecto. |
| `compile` | Compila el código de producción. |
| `test` | Ejecuta las pruebas unitarias. |
| `package` | Genera el artefacto distribuible, por ejemplo un JAR. |
| `verify` | Ejecuta comprobaciones adicionales configuradas para verificar el proyecto. |
| `install` | Instala el artefacto en el repositorio Maven local. |
| `deploy` | Publica el artefacto en un repositorio remoto configurado. |

#### ¿Cómo funcionan las fases?

Cuando ejecutamos una fase, Maven realiza también las fases anteriores necesarias dentro del mismo ciclo de vida.

Por ejemplo:

```bash
mvn package
```

No se limita a generar un JAR. Antes ejecuta las fases previas del ciclo de vida predeterminado, incluyendo la compilación y las pruebas.

Esto permite automatizar la construcción de manera ordenada.

!!! warning "No confundir"
    `mvn deploy` publica un artefacto Maven en un repositorio configurado para ello.

    No significa publicar automáticamente una aplicación en un servidor web.
