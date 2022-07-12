//
//  ViewController.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 26.05.2022.
//

import UIKit

class AuthViewController: UIViewController {
    enum Constants {
        static let mainTitle = "Мое приложение"
        static let termsTitle = "Согласен с условиями"
        static let loginPlacegolder = "Введите логин"
        static let passwordPlaceholder = "Введите пароль"
        static let enterTitle = "Войти"
        static let alertTitle = "Уведомление"
        static let alertMessageEmailNotValid = "Не валидный email"
    }
    
    private let viewModel = AuthModel()
    private var isEnabledEnterButton = false {
        didSet {
            if oldValue != isEnabledEnterButton {
                enterButton.isEnabled = isEnabledEnterButton
            }
        }
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delaysContentTouches = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.isScrollEnabled = false
        }
    }

    @IBOutlet weak var switchTerms: UISwitch! {
        didSet {
            switchTerms.isOn = false
            switchTerms.backgroundColor = .white
            switchTerms.layer.cornerRadius = 16.0
        }
    }

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.image = UIImage(named: "background_image")
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Constants.mainTitle
            titleLabel.textAlignment = .center
        }
    }

    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.delegate = self
            loginTextField.placeholder = Constants.loginPlacegolder
            loginTextField.textContentType = .emailAddress
            loginTextField.keyboardType = .emailAddress
            loginTextField.returnKeyType = .next
        }
    }

    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
            passwordTextField.placeholder = Constants.passwordPlaceholder
            passwordTextField.textContentType = .password
            passwordTextField.keyboardType = .default
            passwordTextField.isSecureTextEntry = true
            passwordTextField.returnKeyType = .done
        }
    }

    @IBOutlet weak var enterButton: CustomButton! {
        didSet {
            enterButton.setTitleColor(.black, for: .normal)
            enterButton.setTitle(Constants.enterTitle, for: .normal)
            enterButton.isEnabled = false
        }
    }

    @IBOutlet weak var acceptTermsSwitch: UISwitch!

    @IBOutlet weak var termsLabel: UILabel! {
        didSet {
            termsLabel.text = Constants.termsTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
#if DEBUG
        loginTextField.text = "myapp@swift.com"
        passwordTextField.text = "password12345"
        acceptTermsSwitch.isOn = true
        enterButton.isEnabled = true
        viewModel.login = "myapp@swift.com"
        viewModel.password = "password12345"
#endif
    }

    deinit {
        removeKeyboardNotifications()
    }
    
    @IBAction func pressEnterButton(_ sender: CustomButton) {
        onPressEnterButton()
    }
    
    @IBAction func togleSwitch(_ sender: UISwitch) {
        viewModel.terms = sender.isOn
        isEnabledEnterButton = viewModel.isOnEnterButton
    }

    private func onPressEnterButton() {
        if !viewModel.isValidEmail() {
            passwordTextField.resignFirstResponder()
            loginTextField.resignFirstResponder()
            loginTextField.textColor = .red
            viewModel.isOnEnterButton = false
            showAlert(title: Constants.alertTitle,message: Constants.alertMessageEmailNotValid)
        } else {
            if viewModel.auth() {
                showActorList()
            }
        }
    }
    
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    private func showActorList() {
        let storyboard = UIStoryboard(name: "ActorList", bundle: nil)
        guard let actorListViewController = storyboard.instantiateViewController(withIdentifier: "ActorListViewController") as? ActorTableViewController else { return  }
        show(actorListViewController, sender: nil)
    }
}

//MARK: Implements UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {

    enum TextFields {
        static let passwordTextFieldIdentifier = "passwordTextField"
        static let loginTextFieldIdentifier = "loginTextField"
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.restorationIdentifier == TextFields.loginTextFieldIdentifier {
            passwordTextField.becomeFirstResponder()
        } else if textField.restorationIdentifier == TextFields.passwordTextFieldIdentifier {
            passwordTextField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.restorationIdentifier == TextFields.loginTextFieldIdentifier {
            viewModel.login = textField.text ?? ""
        } else if textField.restorationIdentifier == TextFields.passwordTextFieldIdentifier {
            viewModel.password = textField.text ?? ""
        }
        isEnabledEnterButton = viewModel.isOnEnterButton
    }
}

//MARK: Extension for keyboard notifications
extension AuthViewController {
    private func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(AuthViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AuthViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let bottomOfPasswordTextField = passwordTextField.convert(passwordTextField.bounds, to: view).maxY
        let visibleRange = self.view.frame.height - keyboardSize.height
        let offset = visibleRange - bottomOfPasswordTextField - 20
        if scrollView.contentOffset.y == 0 {
            scrollView.setContentOffset(CGPoint(x: 0,y: -offset), animated: true)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
}
