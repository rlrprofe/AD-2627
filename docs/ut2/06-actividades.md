# 2.6 · Actividades y proyecto de consolidación

## Actividades de introducción

1. Dibuja el flujo Aplicación Java → API JDBC → Driver → MySQL.
2. Compara un SGBD embebido y otro independiente.
3. Localiza en un proyecto Maven la dependencia del driver.
4. Interpreta una URL JDBC e identifica host, puerto y base de datos.

## Actividades de desarrollo

1. Ejecuta el ejemplo de `Statement` y explica qué hace cada instrucción.
2. Inserta, consulta, modifica y elimina un producto con `PreparedStatement`.
3. Ejecuta procedimientos con parámetros `OUT` e `INOUT`.
4. Recorre un `ResultSet` y muestra sus metadatos.

## Actividades procedimentales

1. Provoca una violación de clave primaria y registra el `SQLState`.
2. Ejecuta una actualización que no encuentre filas y comprueba el resultado.
3. Simula un fallo en una transferencia y verifica el `rollback()`.
4. Implementa una consulta por intervalo de precios usando dos parámetros `?`.

## Proyecto de consolidación: gestor de productos

**Objetivo:** aplicación de consola con MySQL que permita listar, buscar, insertar, modificar stock y eliminar productos.

### Requisitos funcionales

- Menú que se repite hasta seleccionar «Salir».
- Validación de identificadores, precios y existencias.
- Consultas parametrizadas con `PreparedStatement`.
- Mensajes distintos para operación correcta y registro inexistente.
- Comprobación de filas afectadas.
- Cierre automático de los recursos JDBC.
- Registro de errores sin exponer credenciales.

### Diseño propuesto

```text
app/MenuProductos.java
modelo/Producto.java
servicio/ProductoService.java
dao/ProductoDAO.java
config/ConexionBD.java
sql/01-curso-original.sql
```

### Entregables

1. Proyecto Maven que compile con Java 21.
2. Script SQL y README de ejecución.
3. Capturas o evidencias de al menos cuatro operaciones correctas.
4. Dos pruebas de error justificadas.
5. Explicación individual del flujo menú → servicio → DAO → MySQL.

### Lista de comprobación

- [ ] La conexión funciona sin contraseña en el código.
- [ ] Los parámetros de entrada se validan.
- [ ] No se concatenan datos de usuario en SQL.
- [ ] El programa maneja registros inexistentes.
- [ ] Todos los recursos se cierran.
- [ ] El README permite reproducir la práctica.
- [ ] Puedo explicar cada clase y justificar su responsabilidad.

!!! info "Evaluación"
    La valoración concreta de las prácticas seguirá los criterios y porcentajes indicados en la [guía de la UT2](index.md) y las instrucciones de entrega del aula virtual.
