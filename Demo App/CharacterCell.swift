//
//  CharacterCell.swift
//  Simpsons Viewer
//
//  Created by Joshua Cleetus on 4/30/23.
//

import UIKit
import SwiftUI

class CharacterCell: UITableViewCell {
    
    let characterImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureImageView()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.clipsToBounds = true
        characterImageView.layer.cornerRadius = 5
        characterImageView.layer.borderWidth = 1
        characterImageView.layer.borderColor = UIColor.gray.cgColor
        
        contentView.addSubview(characterImageView)
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            characterImageView.widthAnchor.constraint(equalToConstant: 80),
            characterImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [characterImageView, titleLabel, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with viewModel: CharacterCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
        if let imageUrl = viewModel.imageURLString {
            // Use Kingfisher library or any other image caching library of your choice to download and cache images
            characterImageView.downloadImage(from: imageUrl) { [weak self] response in
                if response.image != nil {
                    DispatchQueue.main.async {
                        self?.characterImageView.image = response.image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.characterImageView.image = UIImage(named: "placeholder_image")
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.characterImageView.image = UIImage(named: "placeholder_image")
            }
        }
    }
}

extension UIImageView {
func downloadImage(from URLString: String, with completion: @escaping (_ response: (status: Bool, image: UIImage? ) ) -> Void) {
    guard let url = URL(string: URLString) else {
        completion((status: false, image: nil))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard error == nil else {
            completion((status: false, image: nil))
            return
        }
        
        guard let httpURLResponse = response as? HTTPURLResponse,
              httpURLResponse.statusCode == 200,
              let data = data else {
            completion((status: false, image: nil))
            return
        }
        
        let image = UIImage(data: data)
        completion((status: true, image: image))
    }.resume()
}
}
