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
        let urlString = request.baseURL + request.path
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.failedToDecodeResponse
        }
        return decodedResponse
        /*
         catch NetworkError.badUrl {
         print("There was an error creating the URL")
         } catch NetworkError.badResponse {
         print("Did not get a valid response")
         } catch NetworkError.badStatus {
         print("Did not get a 2xx status code from the response")
         } catch NetworkError.failedToDecodeResponse {
         print("Failed to decode response into the given type")
         } catch {
         print("An error occured downloading the data")
         }
         */
    }
}
