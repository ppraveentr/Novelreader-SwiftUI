//
//  WebService.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import Foundation
import Networking

public class WebService {
    func downloadData<T: Codable>(_ request: any RequestObject) async throws -> T {
        guard var url = URL(string: request.baseURL) else { throw NetworkError.badUrl }
        url = url.appending(path: request.path)

        // Append query parameters if any
        if let queryItems = request.requestQuery {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            if let componentsURL = components?.url {
                url = componentsURL
            }
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.type.stringValue()

        // For POST, encode body if available
        if request.type == .POST {
            if let body = request.requestBody as? Codable,
               let data = request.jsonModelData(body) {
                urlRequest.httpBody = data
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            #if DEBUG
                print("Failed to decode response: \(error.localizedDescription)")
            #endif
        }
        throw NetworkError.failedToDecodeResponse
    }
}
