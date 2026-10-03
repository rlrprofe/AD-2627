# Serializar varios objetos

Tenemos dos estrategias principales.

## 1. Objetos uno detrás de otro

```java
for (Persona p : personas) {
    oos.writeObject(p);
}
```

Para leer podemos continuar hasta `EOFException`.

```java
try (ObjectInputStream ois =
         new ObjectInputStream(new FileInputStream("personas.dat"))) {

    while (true) {
        Persona p = (Persona) ois.readObject();
        System.out.println(p);
    }

} catch (EOFException e) {
    System.out.println("Fin de fichero");
}
```

## 2. Serializar una colección completa

```java
List<Persona> personas = new ArrayList<>();
// ...

try (ObjectOutputStream oos =
         new ObjectOutputStream(
             new FileOutputStream("personas_lista.dat"))) {

    oos.writeObject(personas);
}
```

Lectura:

```java
List<Persona> personas =
    (List<Persona>) ois.readObject();
```

## 3. Comparativa

| Objetos uno a uno | Colección completa |
|---|---|
| Escritura incremental | Código más sencillo |
| Puede procesarse objeto a objeto | Se recupera la lista completa |
| Lectura hasta EOF | Una sola llamada a `readObject()` |
| Útil para logs/streaming | Útil para persistir conjuntos completos |
| Más complejo | Carga toda la colección en memoria |
