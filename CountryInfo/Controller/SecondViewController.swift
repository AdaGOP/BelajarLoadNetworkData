//
//  MainViewController.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 05/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var countryTable: UITableView!
    
    let countryCellID = "CountryCell"
    
    var countryData: [CountryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        countryTable.prefetchDataSource = self
        countryTable.dataSource = self
        countryTable.delegate = self
        
        countryTable.register(UINib(nibName: "SecondCountryTableViewCell", bundle: nil), forCellReuseIdentifier: countryCellID)
        
        if let localData = self.readLocalFile(forName: "Countries") {

            self.parse(jsonData: localData)
            
            
        }
        
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode([CountryModel].self, from: jsonData)
            
            self.countryData = (decodedData as? [CountryModel])!
            
            print(self.countryData.count)
            
            DispatchQueue.main.async {
                self.countryTable.reloadData()
            }
            
            for item in decodedData {
                print("Name: ", item.name)
                print("Alpha2Code: ", item.alpha2Code)
                print("Flag: ", item.flag)
                print("===================================")
            }
        } catch {
            print("decode error \(error.localizedDescription)")
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension SecondViewController: UITableViewDataSourcePrefetching, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//
//    }
//
//
//}


extension SecondViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = countryTable.dequeueReusableCell(withIdentifier: countryCellID, for: indexPath) as? SecondCountryTableViewCell {
            if countryData.count > 0 {
                if let flagStr = countryData[indexPath.row].flag {
                    //cell.setImageToImageView(imageURLString: flagStr)
                    fetchImage(from: flagStr) { (imageData) in
                        if let img = imageData {
                            // referenced imageView from main thread
                            // as iOS SDK warns not to use images from
                            // a background thread
                            DispatchQueue.main.async {
                                cell.flagImage.image = UIImage(data: img)
                            }
                        } else {
                                // show as an alert if you want to
                            print("Error loading image");
                        }
                    }
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
}
