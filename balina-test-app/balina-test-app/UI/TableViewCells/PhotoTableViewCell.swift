//
//  PhotoTableViewCell.swift
//  balina-test-app
//
//  Created by Bahdan Piatrouski on 30.06.23.
//

import UIKit
import SDWebImage

class PhotoTableViewCell: UITableViewCell {

    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private var photo: PhotoTypeResponseModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        guard let photo else { return }
        
        set(photo: photo)
    }
    
    func set(photo: PhotoTypeResponseModel) {
        self.photo = photo
        photoImageView.image = UIImage(systemName: "photo")
        if let photoLink = photo.image {
            if let image = SDImageCache.shared.imageFromCache(forKey: photoLink) {
                photoImageView.image = image
            } else {
                photoImageView.sd_setImage(with: URL(string: photoLink))
            }
        }
        
        nameLabel.text = photo.name
        setupInterface()
    }
    
    private func setupInterface() {
        setupLayout()
        setupConstraints()
    }

    private func setupLayout() {
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.width.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(photoImageView.snp.trailing).offset(10)
            make.centerY.equalTo(photoImageView)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
