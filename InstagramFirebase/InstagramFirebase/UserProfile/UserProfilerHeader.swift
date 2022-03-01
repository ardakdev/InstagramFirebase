//
//  UserProfilerHeader.swift
//  InstagramFirebase
//
//  Created by Ardak on 17.02.2022.
//

import Firebase
import SnapKit
import UIKit

final class UserProfilerHeader: UICollectionViewCell {

    var user: User? {
        didSet {
            setupProfileImage()
            usernameLabel.text = user?.user ?? ""
        }
    }

    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        return image
    }()

    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        return button
    }()

    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let postLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()

    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(safeAreaLayoutGuide).offset(12)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        setupBottomToolbar()
        setupUsernameLabel()
        setupUserStratsViews()

        addSubview(editProfileButton)
        editProfileButton.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.top.equalTo(postLabel.snp.bottom).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-12)
            make.height.equalTo(34)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUserStratsViews() {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(50)
        }
    }

    private func setupUsernameLabel() {
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(12)
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.bottom.equalTo(gridButton.snp.top).offset(-12)
        }
    }
    
    private func setupBottomToolbar() {
        stackView.addArrangedSubview(gridButton)
        stackView.addArrangedSubview(listButton)
        stackView.addArrangedSubview(bookmarkButton)
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-5)
            make.height.equalTo(50)
        }
        bottomToolbarDividers()
    }

    private func bottomToolbarDividers() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = .lightGray
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topDividerView)

        topDividerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(stackView.snp.top)
            make.height.equalTo(0.5)
        }

        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = .lightGray
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomDividerView)

        bottomDividerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(stackView.snp.bottom)
            make.height.equalTo(0.5)
        }
    }

    private func setupProfileImage() {
        guard let url = URL(string: user?.profileUserUrl ?? "") else { return }
        URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.profileImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
