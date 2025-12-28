import SwiftUI

struct ContentView: View {
    @State private var manager = TranslaterManager()
    @State private var userText: String = ""
    @State private var modelSelected: TypeModelOption = .optionA
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                VStack(alignment: .leading) {
                    Text("Español")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextEditor(text: $userText)
                        .frame(height: 100)
                        .padding(8)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }

                if manager.isDownloading {
                    VStack {
                        ProgressView(value: Double(manager.progress), total: 100)
                            .tint(.blue)
                        Text("Cargando modelo: \(manager.progress)%")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .transition(.opacity)
                } else if manager.isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .padding(.vertical, 5)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                            Text("Inglés (Traducción)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if !manager.englishText.isEmpty {
                                Button(action: {
                                    manager.translateText(texto: manager.englishText)
                                }) {
                                    Image(systemName: "speaker.wave.2.circle.fill")
                                        .font(.title2)
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(.blue)
                                }
                                .transition(.scale.combined(with: .opacity)) // Animación suave al aparecer
                            }
                        }
                    
                    ScrollView {
                        Text(manager.englishText.isEmpty ? "La traducción aparecerá aquí..." : manager.englishText)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(height: 150)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Spacer()
                
                Button(action: {
                    Task { await manager.translateAndTalk(originalText: userText, typeModelOption: modelSelected) }
                }) {
                    HStack {
                        Image(systemName: manager.isLoading ? "brain.head.profile" : "translate")
                        Text(manager.isLoading ? "Traduciendo..." : "Traducir y Hablar")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(userText.isEmpty || manager.isLoading ? Color.gray : Color.blue)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .disabled(userText.isEmpty || manager.isLoading)
            }
            .padding()
            .navigationTitle("Traductor IA Local")
        }
    }
}

#Preview {
    ContentView()
}
