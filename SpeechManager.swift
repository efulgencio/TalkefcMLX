final class SpeechManager: @unchecked Sendable {
    private let synthesizer = AVSpeechSynthesizer()
    private let queue = DispatchQueue(label: "com.talkefc.audio", qos: .background)

    func toTalk(texto: String) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            if self.synthesizer.isSpeaking {
                self.synthesizer.stopSpeaking(at: .immediate)
            }
            
            let utterance = AVSpeechUtterance(string: texto)
            let vocesUK = AVSpeechSynthesisVoice.speechVoices().filter { $0.language == "en-GB" }
            
            if let betterPronuntation = vocesUK.first(where: { $0.quality == .enhanced }) {
                utterance.voice = betterPronuntation
            } else {
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            }
            
            utterance.rate = 0.48
            utterance.pitchMultiplier = 1.05
            
            self.synthesizer.speak(utterance)
        }
    }
}
