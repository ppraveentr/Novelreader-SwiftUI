//
//  WebServiceModel.swift
//  MobileContentManager
//
//  Created by Praveen Prabhakar on 2/21/25.
//

import Foundation

/**
 The standard HTTP Verbs
 */
public enum ReqeustType: String, Codable {
    case GET, POST
    /*
    case PUT, FORM, HEAD, DELETE, PATCH, OPTIONS, TRACE, CONNECT
     */

    func stringValue() -> String {
//        if self == .FORM {
//            return ReqeustType.POST.rawValue
//        }
        return self.rawValue
    }
}

public enum NetworkError: Error {
    case badUrl, badResponse, badStatus
    case invalidRequest, failedToDecodeResponse
}

public protocol ServiceModel: Codable {}

public protocol RequestObject {
    associatedtype ResponseType

    var type: ReqeustType { get }
    var baseURL: String { get }
    var path: String { get }

    var requestQuery: JSON? { get set }
    var requestBody: JSON? { get set }
    var responseBody: JSON? { get }

    // JSON
    func jsonModel(_ data: Codable) throws -> JSON?
    func jsonModelData(_ data: Codable) -> Data?
    func jsonString(_ data: JSON) -> String?
    // URL
    func queryItems() -> [URLQueryItem]
}

extension RequestObject {
    public func jsonModelData(_ data: Codable) -> Data? {
        try? JSONEncoder().encode(data)
    }

    public func jsonModel(_ data: Codable) throws -> JSON? {
        let data: Data = try JSONEncoder().encode(data)
        return try? data.jsonContent() as? JSON
    }

    public func jsonString(_ data: JSON) -> String? {
        if let data = data as? Codable, var jsn = try? self.jsonModel(data) {
            jsn.stripNilElements()
            if JSONSerialization.isValidJSONObject(jsn),
               let data = try? JSONSerialization.data(withJSONObject: jsn, options: .prettyPrinted) {
                return data.decodeToString()
            }
        }
        return nil
    }

    // Encode complex key/value objects in NSRULQueryItem pairs
    private func queryItems(_ key: String, _ value: Any?) -> [URLQueryItem] {
        var result = [] as [URLQueryItem]

        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                result += queryItems("\(key).\(nestedKey)", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                result += queryItems(key, value)
            }
        } else if (value as? NSNull) != nil {
            result.append(URLQueryItem(name: key, value: nil))
        } else if let v = value {
            result.append(URLQueryItem(name: key, value: "\(v)"))
        } else {
            result.append(URLQueryItem(name: key, value: nil))
        }
        return result
    }

    // URL
    public func queryItems() -> [URLQueryItem] {
        guard let obj = self.requestQuery as? Codable, let json = try? jsonModel(obj) else { return [] }
        var query: [URLQueryItem] = []
        json.forEach { arg in
            let val = queryItems(arg.key, arg.value)
            query.append(contentsOf: val)
        }
        return query
    }

    // FORM
    public func formData() -> Data? {
        guard let obj = self.requestBody as? Codable,
              let json = try? jsonModel(obj) else { return nil }
        var postData: Data?
        json.forEach { arg in
            let key = arg.key
            if let value = arg.value as? String {
                let data = Data("\(key)=\(value)".utf8)
                if postData == nil {
                    postData = data
                } else {
                    postData?.append(data)
                }
            }
        }
        return postData
    }
}
