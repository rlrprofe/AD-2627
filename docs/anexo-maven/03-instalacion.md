# 3. Instalación y comprobación de Maven

Para trabajar con Maven necesitamos disponer de un JDK instalado y de Maven accesible desde el sistema, o utilizar el Maven integrado en el entorno de desarrollo.

En esta unidad utilizaremos **JDK 21**.

Abre una terminal y comprueba la versión de Java:

```bash
java -version
```

Comprueba también el compilador:

```bash
javac -version
```

Y finalmente Maven:

```bash
mvn -version
```

La salida de Maven debe indicar su versión y el entorno Java que está utilizando.

!!! warning "Posibles problemas"
    Si aparece un mensaje indicando que `mvn` no se reconoce como comando, Maven no está instalado o no está correctamente configurado en el `PATH`.

    Si Maven utiliza una versión de Java diferente de JDK 21, habrá que revisar la configuración del entorno, especialmente `JAVA_HOME`.
