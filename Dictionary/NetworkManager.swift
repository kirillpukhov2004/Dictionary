import Foundation

enum NetworkManagerError: Error {
    case unexpectedStatusCode(_ statusCode: Int)
    case dataError
}

final class NetworkManager {
    static let shared: NetworkManager = NetworkManager()

    func load<T: Decodable>(
        request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            let httpResponse = response as! HTTPURLResponse
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkManagerError.unexpectedStatusCode(httpResponse.statusCode)))
                }
                return
            }

            if let data = data {
                do {
                    let output = try JSONDecoder().decode(T.self, from: data)

                    DispatchQueue.main.async {
                        completion(.success(output))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}
