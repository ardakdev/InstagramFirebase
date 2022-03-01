//
//  SignUpController.swift
//  InstagramFirebase
//
//  Created by Ardak on 16.02.2022.
//

import Firebase
import FirebaseStorage
import SnapKit
import UIKit

final class SignUpController: UIViewController {

    let plusButtonPhoto: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal) , for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
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

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
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

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "buttonColor")
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()

    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ",
                                                        attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In",
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                                                               NSAttributedString.Key.foregroundColor: UIColor(named: "buttonColorActive") ?? .systemBlue]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()

    @objc
    private func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }
    @objc
    func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)

    }

    @objc
    func handleSignUp() {
        guard let email = emailTextField.text,
              let username = usernameTextField.text,
              let password = passwordTextField.text
        else { return }

        //Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] user, error in
            if let error = error {
                print("Filed to create user: ", error.localizedDescription)
            }
            print("Successfully created user: ", user?.user.uid ?? "")

            //Firebase Storage
            let storageRef = Storage.storage().reference().child("profile_image.jpg")
            guard let image = self?.plusButtonPhoto.imageView?.image?.jpegData(compressionQuality: 0.3) else { return }
            storageRef.putData(image, metadata: nil) { metadata, error in
                if let error = error {
                    print("Filed to upload profile image:", error.localizedDescription)
                    return
                }
                print("Successfully saved profile image")

                //Firebase Realtime Database
                storageRef.downloadURL { url, error in
                    if error == nil {
                        let ref = Database.database().reference().child("users")
                        guard let uid = user?.user.uid else { return }
                        guard let url = url?.absoluteString else { return }
                        let value = [uid: ["username": username, "profileURL": url]]

                        ref.updateChildValues(value) { err, ref in
                            if let err = err {
                                print("Failed save user info to db:" , err.localizedDescription)
                                return
                            }
                            print("Successfully saved user info to db.")

                            guard let mainTabBarController = UIApplication.shared.connectedScenes
                                    .filter({$0.activationState == .foregroundActive})
                                    .map({$0 as? UIWindowScene})
                                    .compactMap({$0})
                                    .first?.windows
                                    .filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController
                            else { return }
                            mainTabBarController.setupViewControllers()
                            self?.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }

    @objc
    func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
        usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        signUpButton.isEnabled = isFormValid
        signUpButton.backgroundColor = isFormValid ? UIColor(named: "buttonColorActive"): UIColor(named: "buttonColor")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(plusButtonPhoto)
        view.addSubview(emailTextField)

        NSLayoutConstraint.activate([
            plusButtonPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            plusButtonPhoto.heightAnchor.constraint(equalToConstant: 140),
            plusButtonPhoto.widthAnchor.constraint(equalToConstant: 140),
            plusButtonPhoto.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])

        setupInputFields()

        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }

    }

    private func setupInputFields() {
        let safeArea = view.safeAreaLayoutGuide

        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: plusButtonPhoto.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let imageEdited = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        plusButtonPhoto.setImage(imageEdited?.withRenderingMode(.alwaysOriginal) ??
                                 imageOriginal?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusButtonPhoto.layer.cornerRadius = plusButtonPhoto.frame.width / 2
        plusButtonPhoto.layer.borderColor = UIColor.black.cgColor
        plusButtonPhoto.layer.borderWidth = 3
        dismiss(animated: true)
    }
}
