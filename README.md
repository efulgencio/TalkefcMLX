# Traductor IA Local con MLX Swift

Ejemplo de implementación de **MLX de Apple** para la inferencia local de Modelos de Lenguaje (LLMs) en dispositivos con Apple Silicon.

![Captura de pantalla de la aplicación TalkefcMLX](ScreenShoot.png)

Este proyecto es una referencia técnica diseñada para desarrolladores interesados en el despliegue de IA generativa de forma nativa. Demuestra cómo integrar modelos locales con una interfaz fluida en SwiftUI y un sistema de síntesis de voz optimizado para evitar bloqueos y warnings de concurrencia.

---

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

---

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

1.  **Crea el proyecto:** En Xcode, añade **Mac** además de **iPhone** en las *Supported Destinations*.
2.  **Añade las dependencias:** Utiliza Swift Package Manager para importar las librerías de MLX.
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

* **MLX Swift:** `https://github.com/ml-explore/mlx-swift`
* **MLX Swift Chat:** `https://github.com/ml-explore/mlx-swift-chat`

---

## Estructura del Código

<a name="utilities"></a>
### Utilities
* **SpeechManager:** Gestiona `AVSpeechSynthesizer` en una `DispatchQueue` serie de fondo para evitar bloqueos en el hilo principal. Utiliza voces de alta calidad `en-GB`.

<a name="view"></a>
### View
* **SwiftUI:** Interfaz reactiva con estados `isLoading` e `isDownloading` para gestionar el feedback visual durante la carga de pesos y la generación de texto.

<a name="translate"></a>
### Translate
* **TranslaterManager:** Lógica de inferencia con **Prompt Engineering** (System Prompts y Few-Shot) y configuración determinista (`temperature: 0.0`) para asegurar traducciones precisas.

---

### Información adicional

Para la gestión de modelos, el proyecto utiliza un enumerado que apunta a repositorios específicos de la comunidad MLX en Hugging Face. Esto permite alternar fácilmente entre diferentes arquitecturas de LLM:


<pre><code>
enum TypeModelOption: String, CaseIterable {
    case optionA = "mlx-community/Llama-3.2-1B-Instruct-4bit"
    case optionB = "mlx-community/Qwen2.5-1.5B-Instruct-4bit"
    case optionC = "mlx-community/Mistral-7B-Instruct-v0.3-4bit"
}
</code></pre>

### Detalles de los Modelos Soportados

* **Llama 3.2 1B (Meta):** Es el modelo más ligero y veloz. Gracias a su tamaño reducido, genera tokens de forma casi instantánea y consume muy poca batería, siendo la opción ideal para iPhones con hardware base.
* **Qwen 2.5 1.5B (Alibaba):** Ofrece un equilibrio excepcional entre ligereza y precisión. Demuestra una capacidad de comprensión gramatical superior a modelos de 1B, siendo la opción recomendada para un uso general en movilidad.
* **Mistral 7B v0.3 (Mistral AI):** Es el modelo más potente incluido. Ofrece traducciones mucho más naturales y ricas en contexto, aunque se recomienda su uso principalmente en Mac o dispositivos con amplia memoria RAM debido a su mayor exigencia técnica.

> [!IMPORTANT]
> Todos los modelos están cuantizados a **4 bits**, lo que permite reducir el uso de memoria RAM en más de un 70% sin sacrificar la calidad necesaria para tareas de traducción profesional.

---

*Este proyecto es un ejemplo educativo. Se recomienda el uso de modelos de 1B o 1.5B para dispositivos iOS con limitaciones de RAM.*
