//
//  APIInputBase.swift
//  RxSwiftDemo
//
//  Created by nguyen.tam.thi on 5/4/18.
//  Copyright © 2018 nguyen.tam.thi. All rights reserved.
//

import UIKit
import Alamofire

class APIUploadFile {
    let data:Data?
    let key:String?
    let fileName:String?
    let mimeType:String?
    init(key:String, data:Data, fileName:String, mimeType:String) {
        self.key = key
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

class APIInputBase {
    var headers = [
        "Content-Type":"application/json; charset=utf-8",
        "Accept":"application/json"
    ]
    let host:String
    let path:String?
    var urlString: String {
        get {
            if let path = self.path {
                return self.host + path
            }
            return self.host
        }
    }
    let requestType: HTTPMethod
    var encoding: ParameterEncoding
    let parameters: [String: Any]?
    let requireAccessToken: Bool
    let uploadFiles:[APIUploadFile]?
    var isCache = false
    var timeout = 35.0
    
    init(host: String, path:String, parameters: [String: Any]?, requestType: HTTPMethod, requireAccessToken: Bool = true, uploadFiles:[APIUploadFile]? = nil, isCache: Bool = false) {
        self.host = host
        self.path = path
        self.parameters = parameters
        self.requestType = requestType
        self.encoding = requestType == .get ? URLEncoding.default : JSONEncoding.default
        self.requireAccessToken = requireAccessToken
        self.uploadFiles = uploadFiles
    }
}
