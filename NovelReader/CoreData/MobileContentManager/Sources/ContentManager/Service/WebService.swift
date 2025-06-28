//
//  WebService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import Foundation
import Combine
import Networking

private extension URL {
    mutating func appending(queryItems: [URLQueryItem]?) -> URL {
        // Append query parameters if any
        guard let queryItems else { return self }
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        return components?.url ?? self
    }
}

public class WebService {
    public func downloadDataPublisher<T: Codable>(_ request: any RequestObject) -> AnyPublisher<T, Error> {
        guard var url = URL(string: request.baseURL) else {
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher()
        }
        url = url.appending(path: request.path)
        url = url.appending(queryItems: request.requestQuery)

        let cacheKey = "\(url.absoluteString)_\(request.type.stringValue())"
        if let cached: AnyPublisher<T, Error> = cachedPublisher(for: cacheKey) {
            return cached
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.type.stringValue()

        if request.type == .POST {
            urlRequest.httpBody = prepareHttpBody(for: request)
            if urlRequest.httpBody != nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return URLSessionManager.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse
                }
                guard response.statusCode >= 200 && response.statusCode < 300 else {
                    throw NetworkError.badStatus
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func cachedPublisher<T: Codable>(for cacheKey: String) -> AnyPublisher<T, Error>? {
        if let cachedData = UserCacheManager.getCachedObject(key: cacheKey, cacheType: .application) as? Data {
            do {
                let decoded = try JSONDecoder().decode(T.self, from: cachedData)
                return Just(decoded)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        return nil
    }

    private func prepareHttpBody(for request: any RequestObject) -> Data? {
        guard let body = request.requestBody as? Codable else { return nil }
        return request.jsonModelData(body)
    }
}
