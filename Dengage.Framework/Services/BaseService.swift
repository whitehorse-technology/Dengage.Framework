//
//  BaseService.swift
//  dengage.ios.sdk
//
//  Created by Developer on 27.11.2019.
//  Copyright © 2019 Dengage. All rights reserved.
//

import Foundation

internal class BaseService {
    let logger: SDKLogger
    let session: URLSession
    let settings: Settings

    init(logger: SDKLogger = .shared,
         session: URLSession = .shared,
         settings: Settings = .shared) {
        
        self.logger  = logger
        self.session = session
        self.settings = settings
    }

    func send<T: APIRequest>(request: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        let decoder = JSONDecoder()
        var request = request.asURLRequest()
        let userAgent = settings.getUserAgent()
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        logger.Log(message: "URL is %s", logtype: .debug, argument: request.url?.absoluteString ?? "")
        logger.Log(message: "USER_AGENT is %s", logtype: .debug, argument: userAgent)
        let dataTask = session.dataTask(with: request) { [weak self] data, response, _ in
            guard let self = self else { return }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ServiceError.noHttpResponse))
                return
            }
            if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
                self.logger.Log(message: "HTTP REQUEST BODY: %s",
                                logtype: .debug,
                                argument: bodyString)
            }

            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                self.logger.Log(message: "API_RESPONSE: %s",
                                logtype: .debug,
                                argument: dataString)
            }

            switch httpResponse.statusCode {
            case 200..<300:
                guard let data = data else {
                    completion(.failure(ServiceError.noData))
                    return
                }
                print(String(data: data, encoding: .utf8))
                guard let responseObject = try? decoder.decode(T.Response.self, from: data) else {
                    completion(.failure(ServiceError.decoding))
                    return
                }
                completion(.success(responseObject))
            default:
                self.logger.Log(message: "RESPONSE_STATUS %s", logtype: .debug, argument: "\(httpResponse.statusCode)")
                completion(.failure(ServiceError.fail(httpResponse.statusCode)))
            }
        }
        dataTask.resume()
    }
}

// MARK: - Event Collection
extension BaseService {

    func eventCall(with parameters: [String: Any], for urlAddress: String) {
        let queue = DispatchQueue(label: DEVICE_EVENT_QUEUE, qos: .utility)
        queue.async {
            self.apiCall(data: parameters, urlAddress: urlAddress)
        }
    }

    private func apiCall(data: Any, urlAddress: String?) {

        guard let urlStr = urlAddress, let url = URL(string: urlStr) else { return }
//        let url = URL(string: urlAddress)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)

            logger.Log(message: "HTTP REQUEST BODY: %s",
                       logtype: .debug,
                       argument: String(data: request.httpBody!,
                                        encoding: String.Encoding.utf8)!)
        } catch let error {
            self.logger.Log(message: "%s", logtype: .error, argument: error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let userAgent = settings.getUserAgent()
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        logger.Log(message: "USER_AGENT is %s", logtype: .debug, argument: userAgent)
        let task = session.dataTask(with: request, completionHandler: handler(data:urlResponse:error:))
        task.resume()
    }

    private func handler(data: Data?, urlResponse: URLResponse?, error: Error?) {

        if error != nil {
            self.logger.Log(message: "API_CALL_ERROR %s", logtype: .error, argument: error!.localizedDescription)
        }

        if let response = urlResponse as? HTTPURLResponse {
            self.logger.Log(message: "RESPONSE_STATUS %s", logtype: .debug, argument: "\(response.statusCode)")
        }

        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            self.logger.Log(message: "API_RESPONSE %s", logtype: .debug, argument: dataString)
        }
    }
}

internal enum ServiceError: Error {
    case invalidRefreshToken
    case noHttpResponse
    case noData
    case socialMediaReauth
    case fail(Int)
    case decoding
}
