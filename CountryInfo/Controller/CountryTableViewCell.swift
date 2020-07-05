//
//  CountryTableCellTableViewCell.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 05/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        nameLabel.textColor = .red
//        nameLabel.backgroundColor = .yellow
        flagImageView.contentMode = .center
        flagImageView.backgroundColor = .yellow
        setImage(from: "https://image.blockbusterbd.net/00416_main_image_04072019225805.png")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
        let url = URL(string: urlString)

        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }

        dataTask.resume()
    }
    
    func setImageToImageView(imageURLString: String) {
        fetchImage(from: imageURLString) { (imageData) in
            if let data = imageData {
                // referenced imageView from main thread
                // as iOS SDK warns not to use images from
                // a background thread
                DispatchQueue.main.async {
                    self.flagImageView.image = UIImage(data: data)
                }
            } else {
                    // show as an alert if you want to
                print("Error loading image");
            }
        }
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)

            DispatchQueue.main.async {
               self.flagImageView.image = image
            }
        }
    }
    
}
