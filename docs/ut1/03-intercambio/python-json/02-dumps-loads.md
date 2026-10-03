# JSON en memoria: dumps() y loads()

## 1. Trabajar sin ficheros

Antes de guardar datos en disco conviene comprender el proceso en memoria.

```text
dict/list
   │
   │ json.dumps()
   ▼
str con JSON
   │
   │ json.loads()
   ▼
dict/list
```

### Mapa visual: operaciones JSON en Python

El siguiente esquema resume las cuatro operaciones principales del módulo `json` y permite distinguir entre el trabajo con cadenas en memoria y el trabajo con ficheros:

![Operaciones JSON en Python: dumps, loads, dump y load](../../../images/ut1/python-json/python-json-operaciones.png)

---

## 2. `json.dumps()`

Partimos de:

```python
alumno = {
    "nombre": "Ana",
    "edad": 20
}
```

Serializamos:

```python
json_str = json.dumps(
    alumno,
    indent=4,
    ensure_ascii=False
)
```

`json_str` es una cadena.

---

## 3. `json.loads()`

Podemos recuperar una estructura Python:

```python
alumno2 = json.loads(json_str)
```

Ahora:

```python
print(type(alumno2))
```

produce:

```text
<class 'dict'>
```

---

## 4. Acceso a los datos recuperados

```python
print(alumno2["nombre"])
print(alumno2["edad"])
```

También podemos utilizar:

```python
nombre = alumno2.get("nombre")
```

`get()` resulta especialmente útil cuando una clave puede no existir.

---

## 5. Acceso directo frente a `get()`

```python
alumno["nombre"]
```

Si la clave no existe, se produce `KeyError`.

En cambio:

```python
alumno.get("telefono")
```

devuelve `None`.

También podemos indicar un valor por defecto:

```python
telefono = alumno.get(
    "telefono",
    "(sin teléfono)"
)
```

---

## 6. Ejemplo completo

```python
import json

def main():
    alumno = {
        "nombre": "Ana",
        "edad": 20
    }

    json_str = json.dumps(
        alumno,
        indent=4,
        ensure_ascii=False
    )

    print("Python → JSON")
    print(json_str)

    alumno2 = json.loads(json_str)

    print("\nJSON → Python")
    print(alumno2)
    print(
        f"Nombre: {alumno2['nombre']} - "
        f"Edad: {alumno2['edad']}"
    )

if __name__ == "__main__":
    main()
```

Este ejemplo amplía el `01_basico_en_memoria.py` indicado en el material de la unidad.

---

## 7. ¿Qué significa serializar?

En este contexto:

```text
objeto/estructura Python → representación JSON
```

Con `dumps()` obtenemos esa representación como texto.

---

## 8. ¿Qué significa deserializar?

Es el proceso inverso:

```text
texto JSON → estructura Python
```

Con `loads()` recuperamos normalmente diccionarios y listas.

---

## 9. Errores de sintaxis JSON

Este texto no es JSON válido:

```python
cadena = "{'nombre': 'Ana'}"
```

JSON exige comillas dobles en nombres de propiedades y cadenas:

```python
cadena = '{"nombre": "Ana"}'
```

Si el texto no es válido, `json.loads()` puede lanzar:

```python
json.JSONDecodeError
```

---

## 10. Tratamiento básico del error

```python
import json

try:
    datos = json.loads(cadena)
except json.JSONDecodeError as e:
    print("JSON incorrecto")
    print(e)
```

---

## 11. `dumps` frente a `dump`

```text
dumps()
   └── devuelve str

dump()
   └── escribe en fichero
```

## 12. `loads` frente a `load`

```text
loads()
   └── recibe str

load()
   └── lee desde fichero
```

!!! tip "Regla rápida"
    La `s` identifica las operaciones con una cadena en memoria:

    ```text
    dumps → JSON string
    loads → JSON string
    ```
