# Comparativa · DOM, SAX y JAXB

| Aspecto | DOM | SAX | JAXB |
|---|---|---|---|
| Representación | Árbol de nodos | Eventos | Objetos Java |
| Carga XML completo | Sí | No | Normalmente sí |
| Consumo de memoria | Mayor | Bajo | Medio |
| Navegación libre | Sí | No | Mediante objetos |
| Modificación | Muy cómoda | No es su objetivo | Cómoda sobre objetos |
| Modelo Java | No necesario | No necesario | Sí |
| Uso típico | CRUD XML | Lectura de XML grandes | Persistencia/intercambio con clases |

## Regla rápida

- Necesito **navegar y modificar el árbol** → DOM.
- Necesito **procesar un XML grande secuencialmente** → SAX.
- Quiero trabajar principalmente con **objetos Java** → JAXB.
