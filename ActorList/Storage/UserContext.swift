//
//  UserContext.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 27.06.2022.
//

import Foundation

class UserContext {
    private enum Keys: String {
        case login
        case password
    }

    private lazy var keychainService = KeychainService()
    private lazy var queue = DispatchQueue(label: "KeychainQueue", qos: .userInitiated, attributes: .concurrent)

    var login: String? {
        get {
            return queue.sync {
                return keychainService.login
            }
        }
        set(newLogin) {
            queue.async(flags: .barrier) { [self] in
                self.keychainService.login = newLogin
            }
        }
    }

    var password: String? {
        get {
            return queue.sync {
                return keychainService.password
            }
        }
        set(newPassword) {
            queue.async(flags: .barrier) { [self] in
                self.keychainService.password = newPassword
            }
        }
    }
}
