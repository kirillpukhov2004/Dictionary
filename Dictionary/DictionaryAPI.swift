import Foundation

fileprivate struct Wrapper<T: Decodable>: Decodable {
    let items: [T]
}

final class DictionaryAPI {
    static let shared: DictionaryAPI = DictionaryAPI()

    public func getWords(
        in language: Language,
        completion: @escaping (Result<[Word], Error>) -> Void
    ) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 5000
        components.path = "/words"
        components.queryItems = [
            URLQueryItem(name: "language", value: language.string)
        ]

        guard let url = components.url else {
            fatalError()
        }

        let request = URLRequest(url: url)

        NetworkManager.shared.load(request: request) { (result: Result<Wrapper<Word>, Error>) in
            do {
                let items = try result.get().items
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func getAllLanguages(
        in language: Language? = nil,
        completion: @escaping (Result<[Language], Error>) -> Void
    ) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 5000
        components.path = "/languages"
        components.queryItems = [
            URLQueryItem(name: "language", value: language?.string)
        ]

        guard let url = components.url else {
            fatalError()
        }

        let request = URLRequest(url: url)

        NetworkManager.shared.load(request: request) { (result: Result<Wrapper<Language>, Error>) in
            do {
                let items = try result.get().items
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
