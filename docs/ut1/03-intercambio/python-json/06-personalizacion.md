# Tipos personalizados y modelos de datos

## 1. El límite de la conversión automática

El módulo `json` conoce los tipos JSON básicos, pero no sabe convertir automáticamente cualquier objeto Python.

Por ejemplo:

```python
from datetime import date

datos = {
    "nombre": "Ana",
    "fecha_nacimiento": date(
        2005,
        3,
        15
    )
}
```

Si intentamos:

```python
json.dumps(datos)
```

obtendremos un `TypeError` porque `date` no es directamente serializable a JSON.

---

## 2. `default=`

`json.dumps()` y `json.dump()` permiten indicar una función que se utilizará cuando aparezca un tipo no soportado.

```python
from datetime import date
import json

def convertir(obj):
    if isinstance(obj, date):
        return obj.isoformat()

    raise TypeError(
        f"Tipo no serializable: "
        f"{type(obj).__name__}"
    )
```

Utilizamos:

```python
cadena = json.dumps(
    datos,
    default=convertir,
    indent=4,
    ensure_ascii=False
)
```

Resultado:

```json
{
  "nombre": "Ana",
  "fecha_nacimiento": "2005-03-15"
}
```

---

## 3. ¿Qué hace `default`?

```text
objeto Python
     │
     ▼
json.dumps()
     │
     ├── tipo conocido ──► JSON
     │
     └── tipo desconocido
              │
              ▼
          default=
              │
              ▼
       valor serializable
```

---

## 4. `object_hook`

En la lectura podemos proporcionar una función con:

```python
object_hook=
```

La función recibe cada diccionario decodificado y puede transformarlo.

Ejemplo didáctico:

```python
from datetime import date

def convertir_fechas(diccionario):
    valor = diccionario.get(
        "fecha_nacimiento"
    )

    if valor is not None:
        diccionario[
            "fecha_nacimiento"
        ] = date.fromisoformat(valor)

    return diccionario
```

Uso:

```python
datos = json.loads(
    cadena,
    object_hook=convertir_fechas
)
```

---

## 5. `default` y `object_hook`

Podemos relacionarlos conceptualmente con los mecanismos personalizados estudiados en Java:

```text
ESCRITURA
Python personalizado
       │
       ▼
    default=
       │
       ▼
      JSON


LECTURA
      JSON
       │
       ▼
 object_hook=
       │
       ▼
Python personalizado
```

No son exactamente la misma API que un `TypeAdapter` de Gson o un serializer/deserializer de Jackson, pero resuelven un problema conceptual parecido: definir cómo traducir datos que requieren reglas propias.

---

## 6. Clases Python

Si tenemos:

```python
class Alumno:
    def __init__(
        self,
        nombre,
        edad
    ):
        self.nombre = nombre
        self.edad = edad
```

un objeto `Alumno` no se convierte automáticamente como un `dict`.

Una posibilidad sencilla:

```python
alumno = Alumno(
    "Ana",
    20
)

cadena = json.dumps(
    alumno.__dict__,
    indent=4,
    ensure_ascii=False
)
```

---

## 7. `dataclass`

Python permite definir modelos de datos de forma compacta:

```python
from dataclasses import dataclass

@dataclass
class Alumno:
    nombre: str
    edad: int
```

Creamos:

```python
alumno = Alumno(
    "Ana",
    20
)
```

---

## 8. `asdict()`

Para convertir una `dataclass` a diccionario:

```python
from dataclasses import asdict

datos = asdict(alumno)
```

y después:

```python
cadena = json.dumps(
    datos,
    indent=4,
    ensure_ascii=False
)
```

---

## 9. Recuperar una dataclass

Primero recuperamos un diccionario:

```python
datos = json.loads(cadena)
```

Después podemos construir el objeto:

```python
alumno = Alumno(**datos)
```

---

## 10. ¿Cuándo usar diccionarios y cuándo modelos?

### Diccionarios

Adecuados para:

- scripts sencillos;
- estructuras dinámicas;
- ejemplos introductorios;
- datos cuya forma puede variar.

### `dataclass`

Puede resultar útil cuando:

- queremos expresar claramente un modelo;
- conocemos los campos;
- queremos anotaciones de tipo;
- trabajamos con objetos del dominio de la aplicación.

---

## 11. Validación

El módulo `json` convierte formatos, pero no es un sistema completo de validación de modelos.

El material de la unidad menciona **Pydantic** como alternativa cuando necesitamos validación estructurada de datos. Ese uso queda fuera del núcleo del módulo estándar `json`, pero es importante distinguir:

```text
json
 └── codificar / decodificar JSON

validación
 └── reglas adicionales de la aplicación
```

---

## 12. Resumen

```text
Tipos JSON nativos
      │
      └── conversión automática

Tipos especiales
      │
      ├── default=
      └── object_hook

Modelos Python
      │
      ├── class
      └── @dataclass
            │
            └── asdict()
```
