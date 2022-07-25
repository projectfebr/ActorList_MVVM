//
//  AuthViewModel.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 12.07.2022.
//

import Foundation

class AuthViewModel {
    private var model = AuthModel(email: "", password: "", terms: false)

    var credentialsInputErrorMessage: Observable<String> = Observable("")
    var isUsernameTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPasswordTextFieldHighLighted: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    var canPressEnterButton: Observable<Bool> = Observable(false)

    func updateCredentials(username: String? = nil, password: String? = nil, terms: Bool? = nil) {
        model = model.copyWith(email: username, password: password, terms: terms)
        checkEnterButton()
    }

    func auth() -> Bool {
        UserService.shared.auth(email: model.email, password: model.password)
// MARK: раскомментировать для тестирования ошибки авторизации
//        errorMessage.value = "Ошибка авторизации"
//        return false
        return true

    }

    func credentialsInput() -> CredentialsInputStatus {
        if model.email.isEmpty && model.password.isEmpty {
            credentialsInputErrorMessage.value = "Please provide email and password."
            return .incorrect
        }
        if model.email.isEmpty {
            credentialsInputErrorMessage.value = "Email field is empty."
            isUsernameTextFieldHighLighted.value = true
            return .incorrect
        }
        if isNotValidEmail(model.email) {
            credentialsInputErrorMessage.value = "Email is not valid."
            isUsernameTextFieldHighLighted.value = true
            return .incorrect
        }
        if model.password.isEmpty {
            credentialsInputErrorMessage.value = "Password field is empty."
            isPasswordTextFieldHighLighted.value = true
            return .incorrect
        }
        return .correct
    }

    private func isNotValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,62}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return !emailPred.evaluate(with: email)
    }
    
    private func checkEnterButton() {
        canPressEnterButton.value = !model.email.isEmpty && !model.password.isEmpty && model.terms
    }
}

extension AuthViewModel {
    enum CredentialsInputStatus {
        case correct
        case incorrect
    }
}
