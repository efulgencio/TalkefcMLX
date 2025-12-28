import Foundation
@preconcurrency import AVFoundation
import SwiftUI
import MLX
import MLXLLM
import MLXLMCommon

enum TypeModelOption: String, CaseIterable {
    case optionA = "mlx-community/Llama-3.2-1B-Instruct-4bit"
    case optionB = "mlx-community/Qwen2.5-1.5B-Instruct-4bit"
    case optionC = "mlx-community/Mistral-7B-Instruct-v0.3-4bit"
}

@Observable
@MainActor
class TranslaterManager {
    var englishText: String = ""
    var isLoading: Bool = false
    var isDownloading: Bool = false
    var progress: Int = 0
    
    private let speechManager = SpeechManager()
    
    func translateAndTalk(originalText: String, typeModelOption: TypeModelOption = .optionA) async {
        guard !originalText.isEmpty else { return }
        
        self.isLoading = true
        self.englishText = ""
        self.progress = 0
        
        let systemInstruction: String
        switch typeModelOption {
        case .optionA:
            systemInstruction = """
            You are a professional Spanish-to-English translator. 
            Task: Translate the user text to English.
            Rule: Respond ONLY with the English translation. Do not explain. Do not chat.
            
            Example:
            User: Hola, ¿cómo estás?
            Assistant: Hello, how are you?
            """
        case .optionB:
            systemInstruction = "You are a professional translator. Translate the text to natural, conversational English."
        case .optionC:
            systemInstruction = "Translate the text to English and list 3 key vocabulary words used."
        }
        
        do {
            let config = ModelConfiguration(id: typeModelOption.rawValue)
            self.isDownloading = true
            
            let container = try await LLMModelFactory.shared.loadContainer(configuration: config) { progress in
                let p = Int(progress.fractionCompleted * 100)
                Task { @MainActor in self.progress = p }
            }
            
            self.isDownloading = false
            
            let prompt = """
            <|begin_of_text|><|start_header_id|>system<|end_header_id|>
            \(systemInstruction)<|eot_id|>
            <|start_header_id|>user<|end_header_id|>
            Translate this: "\(originalText)"<|eot_id|>
            <|start_header_id|>assistant<|end_header_id|>
            
            """
        
            try await container.perform { context in
                let input = try await context.processor.prepare(input: .init(prompt: prompt))
                
                _ = try MLXLMCommon.generate(
                    input: input,
                    parameters: GenerateParameters(temperature: 0.0, repetitionPenalty: 1.1),
                    context: context
                ) { tokens in
                    if let lastToken = tokens.last {
                        let text = context.tokenizer.decode(tokens: [lastToken])
                        Task { @MainActor in
                            self.englishText += text
                        }
                    }
                    return .more
                }
            }
            
            self.translateText(texto: self.englishText)
            
        } catch {
            print("❌ Error: \(error)")
            self.isDownloading = false
        }
        
        self.isLoading = false
    }
    
    func translateText(texto: String) {
        speechManager.toTalk(texto: texto)
    }
}
