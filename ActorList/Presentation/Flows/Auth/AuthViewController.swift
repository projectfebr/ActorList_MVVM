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
        static let error = "Ошибка"
    }

    private let viewModel = AuthViewModel()

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
    @IBOutlet weak var loginErrorDescriptionLabel: UILabel! {
        didSet {
            loginErrorDescriptionLabel.isHidden = true
            loginErrorDescriptionLabel.textColor = .red
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.placeholder = Constants.loginPlacegolder
            emailTextField.textContentType = .emailAddress
            emailTextField.keyboardType = .emailAddress
            emailTextField.returnKeyType = .next
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
        emailTextField.text = "myapp@swift.com"
        passwordTextField.text = "password12345"
        acceptTermsSwitch.isOn = true
        enterButton.isEnabled = true
        viewModel.updateCredentials(username: "myapp@swift.com", password: "password12345", terms: true)
#endif
        bindData()
    }

    deinit {
        removeKeyboardNotifications()
    }

    @IBAction func pressEnterButton(_ sender: CustomButton) {
        onPressEnterButton()
    }
    @IBAction func togleSwitch(_ sender: UISwitch) {
        viewModel.updateCredentials(terms: sender.isOn)
    }

    private func bindData() {
        viewModel.canPressEnterButton.bind { [weak self] isEnabled in
            self?.enterButton.isEnabled = isEnabled
        }
        viewModel.credentialsInputErrorMessage.bind { [weak self] in
            guard let vc = self else { return }
            vc.loginErrorDescriptionLabel.isHidden = false
            vc.loginErrorDescriptionLabel.text = $0
        }
        viewModel.isUsernameTextFieldHighLighted.bind { [weak self] in
            guard let vc = self else { return }
            if $0 { vc.highlightTextField(vc.emailTextField) }
        }
        viewModel.isPasswordTextFieldHighLighted.bind { [weak self] in
            guard let vc = self else { return }
            if $0 { vc.highlightTextField(vc.passwordTextField) }
        }
        viewModel.errorMessage.bind { [weak self] in
            guard let errorMessage = $0, let vc = self else { return }
            vc.showAlert(title: Constants.error, message: errorMessage)
        }
    }

    private func onPressEnterButton() {
        viewModel.updateCredentials(username: emailTextField.text, password: passwordTextField.text, terms: acceptTermsSwitch.isOn)
        switch viewModel.credentialsInput() {
        case .correct:
            auth()
        case .incorrect:
            return
        }
    }

    private func auth(){
        if viewModel.auth() {
            showActorList()
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
    
    private func highlightTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 3
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
        loginErrorDescriptionLabel.isHidden = true
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
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
            viewModel.updateCredentials(username: textField.text)
        } else if textField.restorationIdentifier == TextFields.passwordTextFieldIdentifier {
            viewModel.updateCredentials(password: textField.text)
        }
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
