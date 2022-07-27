//
//  LoginViewModel.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 31.05.2022.
//

import Foundation

struct AuthModel {
    let email: String
    let password: String
    let terms: Bool
}

extension AuthModel {
    func copyWith(email: String? = nil, password: String? = nil, terms: Bool? = nil) -> AuthModel {
        return AuthModel(email: email ?? self.email,
                         password: password ?? self.password,
                         terms: terms ?? self.terms)
    }
}
