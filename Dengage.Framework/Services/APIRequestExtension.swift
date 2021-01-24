//
//  APIRequestExtension.swift
//  Dengage.Framework
//
//  Created by Nahit Rustu Heper on 10.01.2021.
//

import Foundation

let defaultHeaders: [String: String] = [
    "Content-Type": "application/json",
    "Accept": "application/json",
]

typealias APIResponse = Decodable

struct EmptyResponse: Decodable { }

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

protocol APIRequest {
    var baseURL: String{ get }
    var path: String { get }
    var httpBody: Data? { get }
    var queryParameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }

    associatedtype Response: APIResponse
}

extension APIRequest {
    func asURLRequest() -> URLRequest {
        var urlComps = URLComponents(string: baseURL + path)!
        urlComps.queryItems = queryParameters.filter { $0.value != nil }
        var urlRequest = URLRequest(url: urlComps.url!)
        defaultHeaders.forEach{ header in
            urlRequest.setValue(header.value,forHTTPHeaderField: header.key)
        }
        if let httpBody = httpBody {
            urlRequest.httpBody = httpBody
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
