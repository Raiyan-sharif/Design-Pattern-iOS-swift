import UIKit
import FirebaseDatabase
import Foundation
import ImageIO


struct Tag {
    let id: Int
    let name: String
    var isSelected: Bool
}

// Define the Item model
struct Item {
    let id: Int
    let name: String
    let tags: [Tag] // Tags associated with the item
}


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var imageViewTest: UIImageView!
    // Dummy data
    var tags: [Tag] = [
    ]
    
    var allItems: [Item] = [
       
    ]
    
    var filteredItems: [Item] = [] // Items filtered by selected tags
    
    // Collection Views
    var tagCollectionView: UICollectionView!
    var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        var ref: DatabaseReference!

        ref = Database.database().reference()
//        print(ref)
        
        ref.child("Template").observeSingleEvent(of: .value, with: { snapshot in
            // Convert snapshot data into a [String: Any] dictionary
            guard let templateData = snapshot.value as? [String: Any] else {
                print("Failed to cast snapshot to dictionary")
                return
            }

            // Parse the data into [String: [[String: String]]] for the new format
            var parsedTemplate: [String: [[String: String]]] = [:]
            var countKey: Int = 0
            for (key, value) in templateData {
                // Ensure each value is an array of dictionaries with "thumbnail" and "original" keys
                self.tags.append(Tag(id: countKey, name: key, isSelected: false))
                countKey += 1
                print(key)
                if let urlArray = value as? [[String: String]] {
                
                    parsedTemplate[key] = urlArray
                } else {
                    print("Unexpected data format for key: \(key)")
                }
            }
            
            DispatchQueue.main.async {[weak self] in
                self?.tagCollectionView.reloadData()
            }
            
            // Print the parsed data for debugging
//            print("Parsed Template Data: \(parsedTemplate["Hot"])")

            // Example: Access individual categories
            
            for t in self.tags {
                print(t)
                var count = 0
                if let data = parsedTemplate["\(t.name)"] {
                    print("\(t.name) Data: \(data)")
                    for item in data {
                        if let thumbnail = item["thumbnail"], let original = item["original"] {
                            self.allItems.append(Item(id: count, name: "\(t.name)", tags: [t]))
                            print("Thumbnail URL: \(thumbnail), Original URL: \(original)")
//                            guard let cgImageSource = CGImageSourceCreateWithURL(URL(fileURLWithPath: thumbnail) as CFURL, nil) else {
//                                print("Failed to create CGImageSource")
//                                return
//                            }
                        }
                    }
                }
            }
            //https://drive.google.com/uc?export=download&id=1q_CTSe13a_GiPibS_HEXNPphykkgfl-Q
            //https://drive.google.com/file/d/1q_CTSe13a_GiPibS_HEXNPphykkgfl-Q/view?usp=drive_link

//            let imageFileURL = URL(fileURLWithPath: "https://drive.google.com/uc?export=download&id=1wXGfrzjXrgji6Q7qURYod4wdkHAMFzm0")
//            if let imageSource = CGImageSourceCreateWithURL(imageFileURL as CFURL, nil),
//               let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) {
//                print("Image properties: \(properties)")
//            } else {
//                print("Failed to read the image properties.")
//            }
            
            // Example usage
            let remoteURL = URL(string: "https://drive.google.com/uc?export=download&id=1wXGfrzjXrgji6Q7qURYod4wdkHAMFzm0")!
            let localURL = FileManager.default.temporaryDirectory.appendingPathComponent("downloaded_image.png")

            self.downloadFile(from: remoteURL, to: localURL) { result in
                switch result {
                case .success(let fileURL):
                    print("File downloaded to: \(fileURL.path)")
                    // Now process the file using CGImageSource
                    if let imageSource = CGImageSourceCreateWithURL(fileURL as CFURL, nil) {
                        DispatchQueue.main.async {
                            self.imageViewTest.image = self.createUIImage(from: imageSource)
                        }
                        
                        print("Successfully created image source.")
                    } else {
                        print("Failed to create image source.")
                    }
                case .failure(let error):
                    print("Error downloading file: \(error)")
                }
            }
            
            self.itemCollectionView.reloadData()
                

        }) { error in
            print("Error fetching data: \(error.localizedDescription)")
        }

//        ref.child("Template").observeSingleEvent(of: .value, with: { snapshot in
//                   // Convert snapshot data into a [String: Any] dictionary
//                   guard let templateData = snapshot.value as? [String: Any] else {
//                       print("Failed to cast snapshot to dictionary")
//                       return
//                   }
//
//                   // Parse the data into [String: [String]]
//                   var parsedTemplate: [String: [String]] = [:]
//            var countKey: Int = 0
//                   for (key, value) in templateData {
//                       // Ensure each value is an array of URLs (as Strings)
//                       self.tags.append(Tag(id: countKey, name: key, isSelected: false))
//                       countKey += 1
//                       print(key)
//                       if let urlArray = value as? [String] {
//                           parsedTemplate[key] = urlArray
//                       } else {
//                           print("Unexpected data format for key: \(key)")
//                       }
//                   }
//            DispatchQueue.main.async {[weak self] in
//                self?.tagCollectionView.reloadData()
//            }
//                   // Print the parsed data
////                   print("Parsed Template Data: \(parsedTemplate)")
//                   
//
//                   // Example: Access individual categories
//                   if let businessURLs = parsedTemplate["Business"] {
//                       print("Business URLs: \(businessURLs)")
//                   }
//
//               }) { error in
//                   print("Error fetching data: \(error.localizedDescription)")
//               }
        setupCollectionViews()
        filterItems() // Initialize with unfiltered data
    }
    
    func createUIImage(from imageSource: CGImageSource?) -> UIImage? {
        // Check if the image source is valid
        guard let imageSource = imageSource else {
            print("Invalid CGImageSource")
            return nil
        }

        // Create a CGImage from the image source (first image/index 0)
        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            print("Failed to create CGImage from CGImageSource")
            return nil
        }

        // Convert the CGImage into a UIImage and return
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage
    }
    
    func downloadFile(from remoteURL: URL, to localURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let task = URLSession.shared.downloadTask(with: remoteURL) { tempURL, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let tempURL = tempURL else {
                let error = NSError(domain: "FileDownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get temporary file URL."])
                completion(.failure(error))
                return
            }

            do {
                // Save the downloaded file to the specified location.
                try FileManager.default.moveItem(at: tempURL, to: localURL)
                completion(.success(localURL))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

   
    
    func setupCollectionViews() {
        // Collection View Layouts
        let tagLayout = UICollectionViewFlowLayout()
        tagLayout.scrollDirection = .horizontal
        
        let itemLayout = UICollectionViewFlowLayout()
        
        // Create UICollectionView for Tags
        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tagLayout)
        tagCollectionView.backgroundColor = .white
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        
        // Create UICollectionView for Items
        itemCollectionView = UICollectionView(frame: .zero, collectionViewLayout: itemLayout)
        itemCollectionView.backgroundColor = .white
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ItemCell")
        
        // Add Collection Views to the View
        view.addSubview(tagCollectionView)
        view.addSubview(itemCollectionView)
        
        // Layout using Auto Layout
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        itemCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Tag Collection View at the top
            tagCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            // Item Collection View below
            itemCollectionView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor),
            itemCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return tags.count
        } else {
            return filteredItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            // Tag Collection Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath)
            cell.backgroundColor = tags[indexPath.item].isSelected ? .blue : .lightGray
            let label = UILabel(frame: cell.contentView.bounds)
            label.text = tags[indexPath.item].name
            label.textAlignment = .center
            cell.contentView.addSubview(label)
            return cell
        } else {
            // Item Collection Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath)
            cell.backgroundColor = .systemGreen
            let label = UILabel(frame: cell.contentView.bounds)
            label.text = filteredItems[indexPath.item].name
            label.textAlignment = .center
            cell.contentView.addSubview(label)
            return cell
        }
    }
    
    // Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            // Toggle Tag Selection
            tags[indexPath.item].isSelected.toggle()
            collectionView.reloadData() // Refresh the tag appearance
            
            // Update filter
            filterItems()
        }
    }
    
    // Flow Layout for Sizing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            return CGSize(width: 100, height: 40)
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
    
    // Filter Items Based on Selected Tags
    func filterItems() {
        let selectedTags = tags.filter { $0.isSelected }
        if selectedTags.isEmpty {
            filteredItems = allItems // No tag selected, show all items
        } else {
            filteredItems = allItems.filter { item in
                for tag in selectedTags {
                    if item.tags.contains(where: { $0.id == tag.id }) {
                        return true
                    }
                }
                return false
            }
        }
        itemCollectionView.reloadData()
    }
}
