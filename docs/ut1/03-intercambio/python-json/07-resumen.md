# Resumen de JSON con Python

## 1. Mapa general

```text
                         módulo json
                             │
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
       memoria            ficheros          personalizar
          │                  │                  │
     dumps / loads       dump / load       default
                                              │
                                          object_hook
```

---

## 2. Las cuatro funciones esenciales

| Función | Entrada | Salida |
|---|---|---|
| `json.dumps(obj)` | objeto Python | `str` JSON |
| `json.loads(str)` | `str` JSON | objeto Python |
| `json.dump(obj, f)` | objeto Python | escribe JSON en fichero |
| `json.load(f)` | fichero JSON | objeto Python |

---

## 3. Regla para recordarlas

```text
dumps / loads
      │
      └── string

dump / load
      │
      └── fichero
```

---

## 4. Pretty printing

```python
json.dumps(
    datos,
    indent=4
)
```

o:

```python
json.dump(
    datos,
    fichero,
    indent=4
)
```

---

## 5. Unicode

```python
ensure_ascii=False
```

junto con:

```python
encoding="utf-8"
```

nos permite conservar de forma legible caracteres como tildes y eñes.

---

## 6. Correspondencia de tipos

| Python | JSON |
|---|---|
| `dict` | object |
| `list`, `tuple` | array |
| `str` | string |
| `int`, `float` | number |
| `True` | true |
| `False` | false |
| `None` | null |

---

## 7. Diccionario

```python
alumno = {
    "nombre": "Ana",
    "edad": 20
}
```

Acceso:

```python
alumno["nombre"]
```

Alternativa segura:

```python
alumno.get(
    "nombre",
    "(sin nombre)"
)
```

---

## 8. Lista de objetos

```python
alumnos = [
    {"nombre": "Ana"},
    {"nombre": "Luis"}
]
```

Recorrido:

```python
for alumno in alumnos:
    print(alumno["nombre"])
```

---

## 9. Guardar fichero

```python
with fichero.open(
    "w",
    encoding="utf-8"
) as f:
    json.dump(
        alumnos,
        f,
        indent=4,
        ensure_ascii=False
    )
```

---

## 10. Leer fichero

```python
with fichero.open(
    "r",
    encoding="utf-8"
) as f:
    alumnos = json.load(f)
```

---

## 11. pathlib

```python
from pathlib import Path
```

Ruta:

```python
data_dir = Path("data")
fichero = data_dir / "alumnos.json"
```

Crear directorio:

```python
data_dir.mkdir(
    parents=True,
    exist_ok=True
)
```

Comprobar:

```python
fichero.exists()
```

Ruta absoluta:

```python
fichero.resolve()
```

---

## 12. Errores frecuentes

### JSON incorrecto

```python
json.JSONDecodeError
```

### Fichero inexistente

```python
FileNotFoundError
```

### Tipo no serializable

```python
TypeError
```

---

## 13. Tipos personalizados

Para escritura:

```python
json.dumps(
    datos,
    default=convertir
)
```

Para lectura:

```python
json.loads(
    cadena,
    object_hook=convertir
)
```

---

## 14. dataclasses

```python
@dataclass
class Alumno:
    nombre: str
    edad: int
```

A diccionario:

```python
asdict(alumno)
```

De diccionario a objeto:

```python
Alumno(**datos)
```

---

## 15. Comparación rápida con Java

| Concepto | Gson | Jackson | Python |
|---|---|---|---|
| Clase/módulo principal | `Gson` | `ObjectMapper` | `json` |
| A JSON | `toJson()` | `writeValueAsString()` | `dumps()` |
| Desde JSON | `fromJson()` | `readValue()` | `loads()` |
| Escribir fichero | writer | `writeValue()` | `dump()` |
| Leer fichero | reader | `readValue()` | `load()` |
| Colecciones genéricas | `TypeToken` | `TypeReference` | `list` / `dict` |
| Formato legible | `GsonBuilder` | pretty printer | `indent=4` |
| Personalización | `TypeAdapter` | serializers/anotaciones | `default`, `object_hook` |

---

## 16. Ejemplos del proyecto

| Fichero | Objetivo |
|---|---|
| `01_basico_en_memoria.py` | `dumps()` y `loads()` |
| `02_estructuras_json.py` | diccionarios, listas y anidación |
| `03_guardar_alumnos.py` | `dump()` y escritura |
| `04_leer_alumnos.py` | `load()` y lectura |
| `05_pathlib.py` | rutas con `Path` |
| `06_errores_json.py` | tratamiento de errores |
| `07_tipos_personalizados.py` | `date`, `default` y `object_hook` |
| `08_dataclass_json.py` | modelos con `@dataclass` |

---

## 17. Flujo completo

```text
datos Python
     │
     ├──── dumps() ────► cadena JSON
     │                      │
     │                    loads()
     │                      │
     ◄──────────────────────┘
     │
     ├──── dump() ─────► fichero JSON
     │                      │
     │                     load()
     │                      │
     ◄──────────────────────┘
```

---

## 18. Preguntas de repaso

1. ¿Qué diferencia existe entre `dump()` y `dumps()`?
2. ¿Qué diferencia existe entre `load()` y `loads()`?
3. ¿Qué tipo Python corresponde a un objeto JSON?
4. ¿Qué tipo Python corresponde a un array JSON?
5. ¿Para qué sirve `indent=4`?
6. ¿Por qué utilizamos `ensure_ascii=False`?
7. ¿Qué ventaja aporta `with` al abrir un fichero?
8. ¿Para qué utilizamos `Path`?
9. ¿Qué excepción puede producir un JSON mal formado?
10. ¿Para qué sirve `default=`?
11. ¿Qué permite hacer `object_hook`?
12. ¿Qué ventaja puede aportar una `dataclass`?

---

!!! success "Idea final"
    En Python, JSON se integra de forma natural con las estructuras básicas del lenguaje:

    ```text
    dict + list
        ⇅
       JSON
        ⇅
     ficheros
    ```

    Por eso el módulo estándar `json` permite resolver la mayoría de los casos habituales con una API pequeña y directa.
