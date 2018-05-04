//
//  UserAPIService.swift
//  RxSwiftDemo
//
//  Created by nguyen.tam.thi on 5/4/18.
//  Copyright © 2018 nguyen.tam.thi. All rights reserved.
//

import UIKit
import RxSwift

protocol UserAPIServiceProtocol {
    func userList() -> Observable<UserModel>
}

class UserAPIService: APIService, UserAPIServiceProtocol {
    static let shareInstance:UserAPIServiceProtocol = UserAPIService()
    
    func userList() -> Observable<UserModel> {
        let input = APIInputBase(host: URLs.Host,
                                 path: URLs.GetUsers,
                                 parameters: nil,
                                 requestType: .get,
                                 isCache: true)
        return self.request(input)
            .observeOn(MainScheduler.instance)
            .share(replay: 1)
    }

}
