# TalkefcMLX: Traductor IA Local con MLX Swift

Ejemplo uso de MLX de Apple

Este proyecto es una implementación de referencia técnica diseñada para desarrolladores interesados en el despliegue de modelos de lenguaje (LLMs) de forma nativa en el ecosistema Apple utilizando el framework **MLX**. Sirve como ejemplo práctico de cómo integrar IA generativa local con una interfaz fluida en SwiftUI.

## Índice
1. [Objetivo](#objetivo)
2. [¿Qué es MLX y ventajas?](#qué-es-mlx-y-ventajas)
3. [Plataformas soportadas](#plataformas-soportadas)
4. [Dependencias (Packages)](#dependencias-packages)
5. [Estructura del Código](#estructura-del-código)
    * [Utilidades](#utilidades)
    * [View (Interfaz)](#view-interfaz)
    * [Translate (Lógica de IA)](#translate-lógica-de-ia)

---

## Objetivo
El objetivo principal de este proyecto es proporcionar un ejemplo base y funcional para la comunidad de desarrolladores de iOS/macOS sobre el uso de **MLX Swift**. Se centra en demostrar la carga de modelos cuantizados (4-bit), la gestión de memoria unificada y la implementación de un flujo de traducción de texto a voz (TTS) cumpliendo con los estándares de concurrencia de Swift 6.

## ¿Qué es MLX y ventajas?
**MLX** es un framework de arrays diseñado específicamente para la investigación de aprendizaje automático en **Apple Silicon**. 

**Ventajas clave frente a soluciones en la nube:**
* **Privacidad (On-Device):** El procesamiento de los datos es estrictamente local; ideal para aplicaciones que manejan información sensible.
* **Eficiencia de Memoria:** Utiliza la arquitectura de memoria unificada de Apple para mover datos entre CPU y GPU sin copias innecesarias.
* **Sin Costes de API:** Elimina la dependencia de servicios de terceros (OpenAI, Anthropic) y sus costes por token.
* **Latencia Reducida:** No depende de la conexión a internet para realizar la inferencia.

## Plataformas soportadas
* **iOS / iPhone:** Optimizado para dispositivos con chip A15 Bionic o superior.
* **Mac:** Compatible con cualquier equipo con procesador M1, M2 o M3.

## Dependencias (Packages)
Para este proyecto es necesario importar los siguientes paquetes oficiales mediante Swift Package Manager (SPM):

* **MLX Swift:** El núcleo del framework.
  `https://github.com/ml-explore/mlx-swift`
* **MLX Swift Chat:** Librería de alto nivel para la carga y generación con LLMs.
  `https://github.com/ml-explore/mlx-swift-chat`

## Estructura del Código

### Utilidades
* **SpeechActor:** Un `actor` de Swift diseñado para encapsular `AVSpeechSynthesizer`. Soluciona problemas de *Priority Inversion* y cumple con la seguridad de hilos de Swift 6. Implementa voces británicas de alta calidad (`en-GB`) con parámetros de tono y velocidad ajustados para una calidez humana.

### View
La interfaz está construida íntegramente en **SwiftUI** siguiendo un patrón reactivo:
* **Entrada de Usuario:** Utiliza un `TextEditor` para la captura de texto en español.
* **Gestión de Carga:** Implementa un `ProgressView` condicional que solo se muestra durante la descarga inicial de los pesos del modelo, optimizando el feedback visual.
* **Contenedor de Salida:** El resultado de la traducción se presenta dentro de un `ScrollView` con altura dinámica para asegurar que las respuestas largas o explicaciones del modelo sean totalmente legibles.
* **Controles:** Incluye un `Picker` segmentado para alternar entre modelos y un botón de repetición de audio que solo se habilita cuando existe una traducción disponible.

### Translate
La lógica de negocio reside en el **TraductorManager**:
* **Carga de Modelos:** Capacidad para alternar entre tres configuraciones (Llama 3.2 1B, Qwen 1.5B y Mistral 7B) mediante parámetros dinámicos.
* **Ingeniería de Prompts:** Implementa un sistema de roles (*System Prompts*) que instruye al modelo para actuar como un traductor estricto, eliminando respuestas conversacionales innecesarias.
* **Inferencia:** Realiza la generación de texto de forma asíncrona, actualizando la interfaz mediante streaming de tokens para una respuesta instantánea.
* Optimización de Inferencia: Para modelos de baja escala (1B-2B), se implementa una técnica de Few-Shot Prompting y se ajusta la temperature a 0.1 para evitar alucinaciones y asegurar que el modelo se mantenga en la tarea de traducción sin derivar en completado de texto conversacional.

---
*Este proyecto es un ejemplo educativo. Pendiente de completar información sobre optimización de pesos específicos.*
