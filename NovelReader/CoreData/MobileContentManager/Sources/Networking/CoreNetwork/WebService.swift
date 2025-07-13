//
//  WebService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import Foundation
import Combine

public enum NetworkError: Error {
    case badUrl, badResponse, badStatus
    case invalidRequest, failedToDecodeResponse
    case networkUnreachable(underlying: Error)

    public var stringValue: String {
        switch self {
        case .badUrl:
            return "Bad URL"
        case .badResponse:
            return "Bad Response"
        case .badStatus:
            return "Bad Status"
        case .invalidRequest:
            return "Invalid Request"
        case .failedToDecodeResponse:
            return "Failed to decode response"
        case .networkUnreachable(underlying: let underlying):
            return "Network Unreachable"
        }
    }
}

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
    public static func downloadDataPublisher<T: Codable>(_ request: any RequestObject) -> AnyPublisher<T, Error> {
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
                try validateResponse(output)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                mapNetworkError(error)
            }
            .eraseToAnyPublisher()
    }
}

private extension WebService {
     static func cachedPublisher<T: Codable>(for cacheKey: String) -> AnyPublisher<T, Error>? {
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

    static func prepareHttpBody(for request: any RequestObject) -> Data? {
        guard let body = request.requestBody as? Codable else { return nil }
        return request.jsonModelData(body)
    }

    static func validateResponse(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkError.badResponse
        }
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badStatus
        }
        return output.data
    }

    static func mapNetworkError(_ error: Error) -> Error {
        if let urlError = error as? URLError, urlError.code == .cannotConnectToHost {
            return NetworkError.networkUnreachable(underlying: urlError)
        }
        return error
    }
}
