# Traductor IA Local con MLX Swift

Ejemplo de implementación de **MLX de Apple** para la inferencia local de Modelos de Lenguaje (LLMs) en dispositivos con Apple Silicon.

![Captura de pantalla de la aplicación TalkefcMLX](ScreenShoot.png)

Este proyecto es una referencia técnica diseñada para desarrolladores interesados en el despliegue de IA generativa de forma nativa. Demuestra cómo integrar modelos locales con una interfaz fluida en SwiftUI y un sistema de síntesis de voz optimizado para evitar bloqueos y warnings de concurrencia.

## Índice

1. [Objetivo](#objetivo)
2. [¿Qué es MLX y ventajas?](#qué-es-mlx-y-ventajas)
3. [Instalación](#instalación)
4. [Plataformas soportadas](#plataformas-soportadas)
5. [Dependencias (Packages)](#dependencias-packages)
6. [Estructura del Código](#estructura-del-código)
    * [Utilities (Audio Manager)](#utilities)
    * [View (SwiftUI)](#view)
    * [Translate (Inferencia de IA)](#translate)
7. [Información adicional](#información-adicional)

## Objetivo

El propósito es proporcionar una base funcional sobre el uso de **MLX Swift**, demostrando la carga de modelos cuantizados (4-bit), la gestión de memoria unificada y un flujo de traducción con salida de voz (TTS) que cumple con los estándares de seguridad de hilos de **Swift 6**.

## ¿Qué es MLX y ventajas?

**MLX** es un framework de arrays diseñado por Apple para la investigación de aprendizaje automático en chips **Apple Silicon**.

* **Privacidad (On-Device):** El procesamiento es local; los datos nunca abandonan el iPhone o Mac.
* **Eficiencia de Memoria:** Acceso directo a la memoria unificada, eliminando copias costosas entre CPU y GPU.
* **Sin Costes de API:** Ejecución gratuita sin suscripciones externas ni pagos por tokens.
* **Latencia:** Inferencia inmediata sin dependencia de conexión a internet.

## Instalación

Sigue estos pasos para configurar el entorno:

1.  **Crea el proyecto:** En Xcode, asegúrate de incluir **Mac** además de **iPhone** en las *Supported Destinations*.
2.  **Añade las dependencias:** Utiliza Swift Package Manager para importar las librerías de MLX (ver sección [Dependencias](#dependencias-packages)).
3.  **Añade las clases del repositorio:** Importa los siguientes archivos a tu proyecto:
    * `ContentView.swift`
    * `TranslaterManager.swift`
    * `SpeechManager.swift`

## Plataformas soportadas

* **iOS / iPhone:** Optimizado para dispositivos con chip A15 Bionic o superior.
* **Mac:** Compatible con cualquier equipo con procesador Apple Silicon (M1, M2, M3).

![Destinos soportados en Xcode](SupportedDestinations.png)

## Dependencias (Packages)

Importar mediante Swift Package Manager (SPM):

![Dependencias de Swift Package Manager en Xcode](PackageDependencies.png)

* **MLX Swift:** El núcleo del framework.  
    `https://github.com/ml-explore/mlx-swift`
* **MLX Swift Chat:** Librería de alto nivel para generación de texto.  
    `https://github.com/ml-explore/mlx-swift-chat`

## Estructura del Código

<a name="utilities"></a>
### Utilities

* **SpeechManager:** Clase final marcada como `@unchecked Sendable` para gestionar `AVSpeechSynthesizer`.
    * Utiliza una **DispatchQueue** serie con `qos: .background` para delegar el procesamiento de audio fuera del hilo principal, eliminando avisos de *Priority Inversion*.
    * El método `toTalk(texto:)` filtra voces británicas mejoradas (`en-GB`) de alta calidad.
    * Gestiona la interrupción inmediata de la voz si se solicita una nueva traducción.

<a name="view"></a>
### View

Interfaz reactiva construida en **SwiftUI**:
* **Input:** `TextEditor` para la captura de texto en español.
* **Gestión de Carga:** Estados diferenciados `isLoading` e `isDownloading` para mostrar el progreso de descarga de pesos del modelo de forma precisa.
* **Scroll Nativo:** Uso de `ScrollView` para evitar el truncado de respuestas largas, permitiendo la lectura completa de traducciones y notas del modelo.

<a name="translate"></a>
### Translate

Lógica principal en la clase **TranslaterManager** (`@Observable` y `@MainActor`):

* **Modelos Disponibles:** Selección dinámica a través del siguiente enumerado:
```swift
enum TypeModelOption: String, CaseIterable {
    case optionA = "mlx-community/Llama-3.2-1B-Instruct-4bit"
    case optionB = "mlx-community/Qwen2.5-1.5B-Instruct-4bit"
    case optionC = "mlx-community/Mistral-7B-Instruct-v0.3-4bit"
}
