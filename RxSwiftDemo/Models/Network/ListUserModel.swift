//
//  ListUserModel.swift
//  RxSwiftDemo
//
//  Created by nguyen.tam.thi on 5/4/18.
//  Copyright © 2018 nguyen.tam.thi. All rights reserved.
//

import UIKit
import Himotoki

struct UserModel: Himotoki.Decodable {
    var name:String?
    var role:String?
    
    // MARK: Himotoki.Decodable
    static func decode(_ e: Extractor) throws -> UserModel {
        return try UserModel(
            name: e <|? KeyPath("name"),
            role: e <|? KeyPath("role")
        )
    }
}

struct ListUserModel: Himotoki.Decodable {
    let users: [UserModel]?
    
    // MARK: Himotoki.Decodable
    static func decode(_ e: Extractor) throws -> ListUserModel {
        return try ListUserModel(
            users: e <||? ["response", "list"]
        )
    }
}
