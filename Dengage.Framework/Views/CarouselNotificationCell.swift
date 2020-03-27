//
//  CarouselNotificationCell.swift
//  carouselViewController
//
//  Created by Ekin Bulut on 10.03.2020.
//  Copyright © 2020 Ekin. All rights reserved.
//

import UIKit

open class CarouselNotificationCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var desc : UILabel!
    
    func configure(imagePath : String) {
        self.setImage(imagePath: imagePath)
    }
    
    func configure(imagePath : String, title: String, desc: String) {
        self.setImage(imagePath: imagePath)
        self.title.text = title
        self.desc.text = desc
        
    }
    
    private func setImage(imagePath: String){
        guard let url = URL(string: imagePath) else {
            print("Failed to present attachment due to an invalid url: %@", imagePath)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                guard let unwrappedData = data, let image = UIImage(data: unwrappedData) else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        })
        task.resume()
    }

    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
