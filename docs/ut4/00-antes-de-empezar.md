# Antes de empezar la unidad

Antes de comenzar a trabajar con persistencia en Java, es importante aclarar algo que genera mucha confusión en vídeos, tutoriales y ejemplos de Internet.

Hibernate se ha usado de muchas formas diferentes a lo largo de más de 20 años, y por eso hoy existen varias API, varios tipos de configuración y muchos tutoriales mezclados.

## 1. Hibernate nació primero (años 2001–2006)

En sus inicios, Hibernate funcionaba solo con su propia API, usando:

- `SessionFactory`
- `Session`
- `Transaction`
- `hibernate.cfg.xml`

Esto se llama **Hibernate nativo**. Muchos tutoriales antiguos están escritos así.

## 2. Más tarde apareció JPA (Java Persistence API)

!!! info "Nota de terminología: JPA vs Jakarta Persistence"
    En muchos materiales antiguos verás «JPA (Java Persistence API)» y paquetes `javax.persistence.*`. Actualmente, el estándar se llama **Jakarta Persistence** y los paquetes han pasado a `jakarta.persistence.*`. En esta unidad, cuando digamos «JPA» nos referiremos a Jakarta Persistence, y por eso en el código usaremos `jakarta.persistence`.

JPA es una especificación estándar de persistencia en Java que define cómo deben trabajar las implementaciones ORM que se ajustan a ella. Pero:

- JPA no es un framework.
- JPA no funciona sola.
- JPA necesita una implementación.

Una de las implementaciones más utilizadas es precisamente **Hibernate**.

A partir de ese momento:

- Se introduce `EntityManager`.
- Se usa `persistence.xml`.
- Aparecen las anotaciones estándar (`@Entity`, `@Id`, `@Column`, etc.).

Y Hibernate decide soportar esta nueva API también.

## 3. Entonces… ¿qué pasó? Se mezclaron las API

Durante años se podían usar:

- La API original de Hibernate (`Session`).
- La API estándar JPA (`EntityManager`).
- Y las dos juntas, según el proyecto.

Con el tiempo, los tutoriales mezclaron:

- `Session` + anotaciones JPA.
- `EntityManager` + `hibernate.cfg.xml`.
- `.get()`, método marcado como obsoleto en Hibernate 7.
- Configuraciones antiguas y modernas.
- Versiones de Hibernate 3, 4, 5, 6 y 7.
- XML antiguo con DTD ya obsoletas.

Resultado: mucha confusión si no conoces la historia. Por eso en Internet ves código muy distinto según el año del tutorial.

!!! note "Importante al consultar ejemplos"
    Utilizar `Session` con anotaciones JPA no es necesariamente incorrecto. Hibernate admite estas anotaciones también con su API nativa. La compatibilidad de cada configuración y método depende de la versión utilizada.

## 4. ¿Qué se usa profesionalmente hoy?

Un enfoque muy habitual en el desarrollo profesional es:

**JPA estándar (`EntityManager`) + Hibernate como implementación.**

Es decir, Hibernate se usa «debajo», pero el programador trabaja con la API estándar JPA.

Este enfoque se utiliza, entre otros, en proyectos de:

- Spring Boot.
- Microservicios Java.
- API REST.
- Sistemas empresariales.

Es una forma moderna de trabajar que favorece la portabilidad y la mantenibilidad del código de persistencia.

## 5. ¿Cómo enfocaremos este tema en el módulo?

Para no liarte y para que entiendas todo bien, veremos los dos modos por separado, sin mezclarlos:

### Parte 1: Hibernate nativo (Session API)

Comenzaremos por esta forma de trabajar para aprender cómo funciona un ORM. Vas a ver:

- Qué es una `Session`.
- Cómo se hace un CRUD básico.
- Cómo se mapea una clase Java a una tabla.
- Cómo se genera SQL automáticamente.

### Parte 2: JPA estándar (EntityManager)

Es una forma de trabajo ampliamente utilizada en empresas. Vas a aprender:

- Qué es `EntityManager`.
- Qué es `persistence.xml`.
- Cómo se hacen consultas JPQL.
- Cómo se trabajan relaciones 1-N y N-1.

!!! warning "IMPORTANTE: NO mezclaremos Session y EntityManager"
    Cada parte se explica y se practica separadamente para evitar confusiones.

## Resumen para que no te confundas

- **Hibernate nativo** → API propia de Hibernate (`Session`).
- **JPA estándar** → API estándar de persistencia (`EntityManager`).
- **Hibernate puede trabajar de ambas formas** → por eso hay tantos tutoriales mezclados.
- **Un enfoque profesional habitual** → JPA + Hibernate (`EntityManager`).
- Cuando entiendes esta diferencia, **TODO lo demás encaja**.

---

## Documentación teórica original de referencia

- [Consultar PDF: 1.0 Antes de empezar](../descargas/ut4/teoria/1.0%20Antes%20de%20empezar.pdf)
