//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Ardak on 01.03.2022.
//
import Firebase
import SnapKit
import UIKit

class LoginController: UIViewController {
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",
                                                        attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up",
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                               NSAttributedString.Key.foregroundColor: UIColor(named: "buttonColorActive") ?? .systemBlue]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()

    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 200, height: 50))
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        view.backgroundColor = UIColor(named: "logoBackgroundColor")
        return view
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "buttonColor")
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()


    @objc
    private func handleShowSignUp() {
        navigationController?.pushViewController(SignUpController(), animated: true)
    }

    @objc
    private func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        loginButton.isEnabled = isFormValid
        loginButton.backgroundColor = isFormValid ? UIColor(named: "buttonColorActive") :UIColor(named: "buttonColor")
    }

    @objc
    private func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let err = error {
                print("Filed to sign in with email: ", err)
                return
            }
            print("Successfully logged back in with user: ", user?.user.uid ?? "")
            guard let mainTabBarController = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController
            else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white

        view.addSubview(logoContainerView)
        logoContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(150)
        }

        setupInputFields()

        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }

    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.top.equalTo(logoContainerView.snp.bottom).offset(40)
            make.height.equalTo(140)
        }
    }

}
