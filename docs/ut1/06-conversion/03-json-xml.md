# Conversión JSON → XML

En la dirección inversa partimos de objetos/arrays JSON y construimos una jerarquía XML.

```text
JSON → parser JSON → objetos/arrays → elementos/atributos XML → XML
```

Una estrategia consiste en crear un `Document` DOM:

```java
Document doc = builder.newDocument();

Element raiz = doc.createElement("clientes");
doc.appendChild(raiz);

Element cliente = doc.createElement("cliente");
cliente.setAttribute("id", "C01");
raiz.appendChild(cliente);
```

## Conversión recursiva

Cuando el JSON contiene objetos y arrays anidados, una solución general puede recorrer recursivamente cada valor.

El proyecto incluye:

- `JsonToXmlManual1`
- `JsonToXmlManual2_Recursivo`
