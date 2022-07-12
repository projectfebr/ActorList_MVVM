//
//  UserService.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 28.06.2022.
//

import Foundation

class UserService {
    static let shared = UserService()
    private lazy var userContext = UserContext()
    
    var isAuth: Bool {
        return userContext.password != nil && userContext.login != nil
    }

    func logout() {
        userContext.password = nil
        userContext.login = nil
    }

    func login(login: String, password: String) {
        userContext.login = login
        userContext.password = password
    }

    private init() { }
}
