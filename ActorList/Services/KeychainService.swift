//
//  KeychainService.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 01.07.2022.
//

import Foundation
#warning ("TODO: найучить брать пароль из связки ключей при авторизации")
class KeychainService {
    private enum Keys: String {
        case login
        case password
        case keychainService = "mynovoros.co.ActorList"
    }

    private lazy var currentKeychain = Keychain(service: Keys.keychainService.rawValue)

    var login: String? {
        get { return  currentKeychain[Keys.login.rawValue] }
        set(newLogin) { currentKeychain[Keys.login.rawValue] = newLogin }
    }

    var password: String? {
        get { return  currentKeychain[Keys.password.rawValue] }
        set(newPassword) { currentKeychain[Keys.password.rawValue] = newPassword }
    }
}
