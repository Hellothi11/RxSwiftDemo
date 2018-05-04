//
//  APIError.swift
//  RxSwiftDemo
//
//  Created by nguyen.tam.thi on 5/4/18.
//  Copyright © 2018 nguyen.tam.thi. All rights reserved.
//

import UIKit

enum APIError: Error {
    case invalidURL(url: String)
    case invalidResponseData(data: Any)
    case error(responseCode: Int, data: Any)
}

enum ResponseError: Error {
    case noStatusCode
    case invalidData(data: Any?)
    case unknown(statusCode: Int)
    case notModified // 304
    case invalidRequest // 400
    case unauthorized // 401
    case accessDenied // 403
    case notFound  // 404
    case methodNotAllowed  // 405
    case validate   // 422
    case serverError // 500
    case badGateway // 502
    case serviceUnavailable // 503
    case gatewayTimeout // 504
}
