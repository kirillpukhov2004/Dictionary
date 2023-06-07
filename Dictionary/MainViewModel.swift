import Combine

class MainViewModel {
    @Published var words: [Word]
    @Published var languages: [Language]

    init() {
        self.words = []
        self.languages = []

        fetchAllLanguages() { [self] in
            if !languages.isEmpty {
                fetchAllWords(in: languages.first!)
            }
        }
    }

    private func fetchAllLanguages(completion: (() -> Void)? = nil) {
        DictionaryAPI.shared.getAllLanguages { [weak self] result in
            do {
                let languages = try result.get()
                self?.languages = languages
                completion?()
            } catch {
                self?.languages = []
                completion?()
            }
        }
    }

    private func fetchAllWords(in language: Language) {
        DictionaryAPI.shared.getWords(in: language) { [weak self] result in
            do {
                let words = try result.get()
                self?.words = words
            } catch {
                self?.words = []
            }
        }
    }
}
