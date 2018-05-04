//
//  APIService.swift
//  RxSwiftDemo
//
//  Created by nguyen.tam.thi on 5/4/18.
//  Copyright © 2018 nguyen.tam.thi. All rights reserved.
//

import UIKit
import Alamofire
import RxAlamofire
import RxSwift
import Himotoki

class APIService: NSObject {
    private func _request(_ input: APIInputBase) -> Observable<Any> {
        let manager = Alamofire.SessionManager.default
        var urlRequest: URLRequest
        var data: Data?
        
        guard var url = URL(string: input.urlString) else {
            return Observable.error(APIError.invalidURL(url: input.urlString))
        }
        if let parameters = input.parameters {
            if input.requestType != .get {
                do {
                    data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                if let urlValue = createURLWithComponents(urlString: input.urlString, params: parameters) {
                    url = urlValue
                }
            }
        }
        if input.isCache {
            urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: input.timeout)
        } else {
            urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: input.timeout)
        }
        
        urlRequest.httpMethod = input.requestType.rawValue
        urlRequest.allHTTPHeaderFields = input.headers
        if let data = data {
            urlRequest.httpBody = data
        }
        return manager
            .rx
            .request(urlRequest: urlRequest)
            .flatMap { dataRequest -> Observable<DataResponse<Any>> in
                dataRequest.rx.responseJSON()
            }
            .map { dataResponse -> Any in
                return try self.process(dataResponse)
        }
    }
    
    func createURLWithComponents(urlString: String, params: [String: Any]) -> URL? {
        var urlComponents = URLComponents(string: urlString)
        // add params
        urlComponents?.queryItems = []
        for param in params {
            let query = URLQueryItem(name: param.key, value: param.key)
            urlComponents?.queryItems?.append(query)
        }
        return urlComponents?.url
    }
    
    private func process(_ response: DataResponse<Any>) throws -> Any {
        let error: Error
        switch response.result {
        case .success(let value):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200:
                    return value
                case 304:
                    error = ResponseError.notModified
                case 400:
                    error = ResponseError.invalidRequest
                case 401:
                    error = ResponseError.unauthorized
                case 403:
                    error = ResponseError.accessDenied
                case 404:
                    error = ResponseError.notFound
                case 405:
                    error = ResponseError.methodNotAllowed
                case 422:
                    error = ResponseError.validate
                case 500:
                    error = ResponseError.serverError
                case 502:
                    error = ResponseError.badGateway
                case 503:
                    error = ResponseError.serviceUnavailable
                case 504:
                    error = ResponseError.gatewayTimeout
                default:
                    error = ResponseError.unknown(statusCode: statusCode)
                }
            } else {
                error = ResponseError.noStatusCode
            }
            print(value)
        case .failure(let e):
            error = e
        }
        throw error
    }
    
    public func request<T: Himotoki.Decodable>(_ input: APIInputBase) -> Observable<T> {
        return _request(input)
            .map { data -> T in
                if let _ = data as? [String:Any], let object = try? T.decodeValue(data) {
                    return object
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
        }
    }
    
    public func requestArray<T: Himotoki.Decodable>(_ input: APIInputBase) -> Observable<[T]> {
        return _request(input)
            .map { data -> [T] in
                if let _ = data as? [[String:Any]], let object = try? [T].decode(data) {
                    return object
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
        }
    }
}

