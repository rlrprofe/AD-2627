# Rutas y ficheros con pathlib

## 1. ¿Qué es pathlib?

`pathlib` pertenece a la librería estándar de Python y permite trabajar con rutas de una forma orientada a objetos.

```python
from pathlib import Path
```

En los ejemplos del material se utiliza para construir la ruta del fichero JSON.

---

## 2. Crear una ruta

```python
carpeta = Path("data")
```

Esto representa una ruta; no significa necesariamente que el directorio exista todavía.

---

## 3. El operador `/`

`Path` redefine `/` para unir partes de una ruta:

```python
fichero = carpeta / "alumnos.json"
```

No es una división.

Es equivalente a:

```python
fichero = carpeta.joinpath(
    "alumnos.json"
)
```

---

## 4. Crear directorios

```python
carpeta.mkdir(
    parents=True,
    exist_ok=True
)
```

### `parents=True`

Permite crear también directorios padre que falten.

### `exist_ok=True`

Evita un error si el directorio ya existe.

---

## 5. Comprobar existencia

```python
if fichero.exists():
    print("Existe")
```

---

## 6. Comprobar el tipo

```python
fichero.is_file()
```

```python
carpeta.is_dir()
```

---

## 7. Ruta absoluta

```python
print(fichero.resolve())
```

Es especialmente útil para diagnosticar problemas con rutas relativas.

---

## 8. Abrir desde `Path`

```python
with fichero.open(
    "w",
    encoding="utf-8"
) as f:
    json.dump(datos, f)
```

No necesitamos convertir la ruta en una cadena.

---

## 9. Rutas relativas

Si escribimos:

```python
Path("data/alumnos.json")
```

la ruta se interpreta respecto al **directorio de trabajo actual** desde el que ejecutamos Python.

Por eso, cuando un fichero “no aparece donde esperábamos”, conviene comprobar:

```python
print(Path.cwd())
```

y:

```python
print(fichero.resolve())
```

---

## 10. Ejemplo completo

```python
from pathlib import Path

carpeta = Path("data")

ruta1 = carpeta / "alumnos.json"

ruta2 = carpeta.joinpath(
    "alumnos.json"
)

print(ruta1)
print(ruta2)
print(ruta1.resolve())
```

---

## 11. Aplicación a JSON

```text
Path("data")
     │
     ├── mkdir()
     │
     ▼
data/
     │
     └── / "alumnos.json"
              │
              ▼
       data/alumnos.json
              │
              ▼
         json.dump()
```

---

## 12. Métodos de referencia

| Operación | `pathlib` |
|---|---|
| Crear ruta | `Path(...)` |
| Unir ruta | `/` |
| Alternativa para unir | `joinpath()` |
| ¿Existe? | `exists()` |
| ¿Es fichero? | `is_file()` |
| ¿Es directorio? | `is_dir()` |
| Crear directorio | `mkdir()` |
| Ruta absoluta | `resolve()` |
| Directorio actual | `Path.cwd()` |
| Abrir | `Path.open()` |

!!! tip
    Para los ejemplos del curso utilizaremos `pathlib` en lugar de concatenar manualmente rutas con cadenas.
