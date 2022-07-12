//
//  LoginViewModel.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 31.05.2022.
//

import Foundation

class AuthModel {
    var isOnEnterButton = false

    var login = "" {
        didSet {
            isOnEnterButton = canPressEnterButton()
        }
    }

    var password = "" {
        didSet {
            isOnEnterButton = canPressEnterButton()
        }
    }

    var terms = false {
        didSet {
            isOnEnterButton = canPressEnterButton()
        }
    }

    func auth() -> Bool {
        UserService.shared.login(login: login, password: password)
        return true
    }

    private func canPressEnterButton() -> Bool {
        return !login.isEmpty && !password.isEmpty && terms
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,62}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: login)
    }
}
