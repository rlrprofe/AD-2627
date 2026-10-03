# Preparación del proyecto

## 1. Soporte nativo para JSON

Python incluye el módulo `json` en su librería estándar.

```python
import json
```

No necesitamos `pip install json`.

!!! warning
    No debemos crear nuestro propio fichero con el nombre `json.py`, porque podría interferir con la importación del módulo estándar.

---

## 2. Estructura recomendada

Para los ejemplos utilizaremos:

```text
python-json-ejemplos/
├── README.md
├── data/
└── src/
```

Los programas estarán en `src/` y los ficheros JSON persistentes en `data/`.

---

## 3. Primer programa

```python
import json

alumno = {
    "nombre": "Ana",
    "edad": 20
}

cadena = json.dumps(alumno)

print(cadena)
```

Salida:

```json
{"nombre": "Ana", "edad": 20}
```

`json.dumps()` no guarda ningún fichero. El resultado es un `str`.

```python
print(type(cadena))
```

Resultado:

```text
<class 'str'>
```

---

## 4. Pretty printing

Para obtener un JSON más legible utilizamos `indent`.

```python
cadena = json.dumps(
    alumno,
    indent=4
)
```

Resultado:

```json
{
    "nombre": "Ana",
    "edad": 20
}
```

---

## 5. Unicode y `ensure_ascii`

Por defecto, `json.dumps()` puede escapar caracteres no ASCII.

Para conservar de forma legible tildes, eñes y otros caracteres Unicode:

```python
cadena = json.dumps(
    alumno,
    indent=4,
    ensure_ascii=False
)
```

Por ejemplo:

```python
alumno = {
    "nombre": "Ángela",
    "ciudad": "Alcalá de Henares"
}
```

---

## 6. Qué tipos podemos convertir

```python
datos = {
    "texto": "Ana",
    "entero": 20,
    "decimal": 8.5,
    "booleano": True,
    "nulo": None,
    "lista": [7, 8, 9]
}
```

Todos ellos tienen una representación JSON natural.

---

## 7. Comprobar el entorno

Crea `src/prueba_json.py`:

```python
import json

datos = {
    "modulo": "Acceso a Datos",
    "curso": "2º DAM",
    "activo": True
}

print(
    json.dumps(
        datos,
        indent=4,
        ensure_ascii=False
    )
)
```

Si se ejecuta correctamente, ya tenemos preparado el entorno.

---

## 8. Lo que no necesitamos

Para este minicurso básico no necesitamos:

- Maven;
- dependencias externas;
- un fichero `requirements.txt`;
- instalar una librería JSON adicional.

El PDF de la unidad menciona otras alternativas (`pydantic`, `orjson`, `ujson`, `ijson`) para necesidades más específicas, pero el núcleo del minicurso se centra en la librería estándar `json`.

---

## 9. Resumen

```text
Python
  │
  ├── librería estándar
  │
  └── json
       │
       ├── dumps()
       ├── loads()
       ├── dump()
       └── load()
```
