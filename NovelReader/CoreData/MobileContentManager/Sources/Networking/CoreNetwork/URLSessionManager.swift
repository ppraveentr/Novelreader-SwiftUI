//
//  URLSessionManager.swift
//  MobileCore-NetworkLayer
//
//  Created by Praveen Prabhakar on 11/04/18.
//  Copyright © 2018 Praveen Prabhakar. All rights reserved.
//

import Foundation
import Combine

public typealias URLSessionCompletionBlock = (Data?, URLResponse?, Error?) -> Swift.Void

open class URLSessionManager: NSObject {
    public static let sharedInstance = URLSessionManager()
    public static var sessionConfiguration: URLSessionConfiguration = .default
    public static var sessionDelegate: URLSessionDelegate? = URLSessionManager.sharedInstance
    public static var sessionQueue = OperationQueue()
    public static var urlSession: URLSession = URLSessionManager.createURLSession()

    /// Returns a Combine publisher for the provided URLRequest
    public class func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return urlSession.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .map { ($0.data, $0.response) }
            .eraseToAnyPublisher()
    }

    @available(*, deprecated, message: "Use Combine's dataTaskPublisher(for:) instead")
    @discardableResult open class
    func startDataTask(with request: URLRequest, completionHandler: URLSessionCompletionBlock? = nil) -> URLSessionDataTask {
        let task: URLSessionDataTask
        if let completionHandler = completionHandler {
            task = Self.urlSession.dataTask(with: request, completionHandler: completionHandler)
        } else {
            task = Self.urlSession.dataTask(with: request)
        }
        // start task
        task.resume()
        return task
    }
}

extension URLSessionManager: URLSessionDelegate {
    public static func createURLSession() -> URLSession {
        // default values
        let config = URLSessionManager.sessionConfiguration
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        return URLSession(
            configuration: URLSessionManager.sessionConfiguration,
            delegate: URLSessionManager.sessionDelegate,
            delegateQueue: nil
        )
    }
}
