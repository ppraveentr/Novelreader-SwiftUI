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

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.type.stringValue()

        if request.type == .POST {
            if let body = request.requestBody as? Codable,
               let data = request.jsonModelData(body) {
                urlRequest.httpBody = data
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse else {
                    throw NetworkError.badResponse
                }
                guard response.statusCode >= 200 && response.statusCode < 300 else {
                    throw NetworkError.badStatus
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
