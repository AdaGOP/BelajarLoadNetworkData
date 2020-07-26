//
//  MainViewController.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 05/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import UIKit
import WebKit

extension UIImageView {
    //Additional function to load UIImageView from URL
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class SecondViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var countryTable: UITableView!
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var myWeb: WKWebView!
    
    let countryCellID = "CountryCell"
    
    var countryData: [CountryModel] = []
    
     override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            countryTable.dataSource = self
            countryTable.delegate = self
            
            // 1: Register the TableViewCell
            countryTable.register(UINib(nibName: "SecondCountryTableViewCell", bundle: nil), forCellReuseIdentifier: countryCellID)
            
            // 2: Set the image to scaleAspectFit
            myImage.contentMode = .scaleAspectFit
        
            // 3: Call a function to load image from URL
            let url = URL(string: "https://www.countryflags.io/be/flat/64.png")
            myImage.load(url: url!)
            
            // 5: Parse the JSON data
            if let localData = self.readLocalFile(forName: "Countries") {
                self.parse(jsonData: localData)
            }
            
            // 6: Load SVG URL file
            do {
                let fileURL:URL = URL(string: "https://restcountries.eu/data/ton.svg")!
                let svgString = try? String(contentsOf: fileURL)
                self.myWeb.contentMode = .scaleAspectFit
                self.myWeb.loadHTMLString(svgString!, baseURL: fileURL)
            } catch let error {
                print(error.localizedDescription)
            }
            
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.title = "Sample Countries"
        }
        
        // MARK: - 7: Parse data and reload the data to the table using the data structure we've made
        private func parse(jsonData: Data) {
            do {
                let decodedData = try JSONDecoder().decode([CountryModel].self, from: jsonData)
                
                self.countryData = (decodedData as [CountryModel])
                
                print(self.countryData.count)
                
                DispatchQueue.main.async {
                    self.countryTable.reloadData()
                }
                
                for item in decodedData {
                    print("Name: ", item.name as Any)
                    print("Alpha2Code: ", item.alpha2Code as Any)
                    print("Flag: ", item.flag as Any)
                    print("===================================")
                }
            } catch {
                print("decode error \(error.localizedDescription)")
            }
        }
        
        // 4: Function to read json local file
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

        // Additional : Function to fetch an image from url
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
        
        // Additional : Function to resume the data Task to get the data
        func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
        
        // Additional : Function to download the image from URL
        func downloadImage(from url: URL) {
            print("Download Started")
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { [weak self] in
                    self?.myImage.image = UIImage(data: data)
                }
            }
        }

    }
    // MARK: - Set table view to perform the data
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
                    // 8: Implement the data using CountryModel
                    if let name = countryData[indexPath.row].name, let flagStr = countryData[indexPath.row].flag {
                        //cell.setImageToImageView(imageURLString: flagStr)
                        DispatchQueue.main.async {
                            cell.textLabel?.text = name
                            do{
                                let fileURL:URL = URL(string: flagStr)!
                                //let req = URLRequest(url: fileURL)
                                let svgString = try? String(contentsOf: fileURL)
                                //cell.flagWebView.contentMode = .scaleAspectFit
                                cell.flagWebView.loadHTMLString(svgString!, baseURL: fileURL)
                            } catch let error {
                                print(error.localizedDescription)
                            }
                        }
                        
                    }
                }
                return cell
            }
            return UITableViewCell()
        }
        
        
    }
