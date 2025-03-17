//
//  ViewController.swift
//  DriveImageToUIImage
//
//  Created by BJIT on 17/3/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var driveImageToUIImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = URL(string: "https://drive.google.com/uc?export=download&id=1q_CTSe13a_GiPibS_HEXNPphykkgfl-Q") {
                    fetchImage(from: url)
                }
    }
    func fetchImage(from url: URL) {
            // Create URLSession data task to fetch the image
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error loading image: \(String(describing: error))")
                    return
                }

                // Set the imageView's image on the main thread
                DispatchQueue.main.async {
                    self.driveImageToUIImage.image = UIImage(data: data)
                }
            }
            task.resume()
        }


}

