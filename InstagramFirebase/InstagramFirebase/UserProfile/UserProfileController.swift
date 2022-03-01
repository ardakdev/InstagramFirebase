//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Ardak on 17.02.2022.
//

import UIKit
import Firebase

final class UserProfileController: UICollectionViewController {
    private var user: User?
    private let cellId = "cellId"
    override func loadView() {
        super.loadView()
        fetchUsers()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(UserProfilerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)

        setupLogOutButton()
    }

    private func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain
                                                            , target: self, action: #selector(handleLogOut))
    }

    @objc
    private func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self?.present(navController, animated: true)
            } catch let singOutError {
                print(singOutError)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .purple
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    private func fetchUsers() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observe(.value) {[weak self] snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return}
            self?.user = User(dictionary)
            self?.title = self?.user?.user
            self?.collectionView.reloadData()
        } withCancel: { error in
            print(error.localizedDescription)
        }
    }
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                 withReuseIdentifier: "headerId",
                                                 for: indexPath) as? UserProfilerHeader
        else { return UICollectionReusableView() }
        headerView.user = user
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
