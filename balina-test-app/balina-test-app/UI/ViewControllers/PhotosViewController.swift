//
//  PhotosViewController.swift
//  balina-test-app
//
//  Created by Bahdan Piatrouski on 30.06.23.
//

import UIKit
import SnapKit
import SPAlert

class PhotosViewController: UIViewController {

    lazy var photosTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(PhotoTableViewCell.self)
        tableView.delegate = self
        return tableView
    }()
    
    private var photos = [PhotoTypeResponseModel]()
    private var currentPage = 0
    private var totalPage = 0
    private var isPhotosLoading = false
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alert = SPAlertView.loadingAlert
        alert.present()
        Provider.standard.getPhotos { photos in
            alert.dismiss()
            guard let photosArray = photos.photos else {
                let alert = SPAlertView(title: "Error", message: "Response doesn't contain any photos", preset: .error)
                alert.present(haptic: .error)
                return
            }
            
            self.photos = photosArray
            self.photosTableView.reloadData()
            self.totalPage = photos.totalPage
        } failure: {
            alert.dismiss()
            let alert = SPAlertView(title: "Error", preset: .error)
            alert.present(haptic: .error)
        }
        
        setupInterface()
    }
    
    private func setupInterface() {
        self.view.backgroundColor = UIColor.systemBackground
        setupLayout()
        setupConstraints()
    }
    
    private func setupLayout() {
        self.view.addSubview(photosTableView)
    }
    
    private func setupConstraints() {
        photosTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension PhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.id, for: indexPath)
        guard let photoCell = cell as? PhotoTableViewCell else { return cell }
        
        photoCell.set(photo: photos[indexPath.row])
        return photoCell
    }
}

extension PhotosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .camera
        imagePickerVC.delegate = self
        self.present(imagePickerVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height, !isPhotosLoading, !photos.isEmpty, totalPage - 1 >= currentPage {
            currentPage += 1
            isPhotosLoading = true
            let alert = SPAlertView.loadingAlert
            alert.present()
            Provider.standard.getPhotos(page: currentPage) { photos in
                alert.dismiss()
                guard let photos = photos.photos else { return }
                
                self.isPhotosLoading = false
                self.photos += photos
                self.photosTableView.reloadData()
            } failure: {
                self.isPhotosLoading = false
                alert.dismiss()
            }
        }
    }
}

extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let alert = SPAlertView.loadingAlert
        alert.present()
        Provider.standard.uploadPhoto(id: photos[selectedIndex].id, photo: image) {
            alert.dismiss()
            let alert = SPAlertView(title: "Success", preset: .done)
            alert.present(haptic: .success)
        } failure: {
            alert.dismiss()
            let alert = SPAlertView(title: "Error", preset: .error)
            alert.present(haptic: .error)
        }

    }
}
