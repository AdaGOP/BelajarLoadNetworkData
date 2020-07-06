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
        
//        countryTable.prefetchDataSource = self
        countryTable.dataSource = self
        countryTable.delegate = self
        
        countryTable.register(UINib(nibName: "SecondCountryTableViewCell", bundle: nil), forCellReuseIdentifier: countryCellID)
        
        myImage.contentMode = .scaleAspectFit
        
//        setImage(from: "https://image.blockbusterbd.net/00416_main_image_04072019225805.png")
    
        let url = URL(string: "https://www.countryflags.io/be/flat/64.png")
        myImage.load(url: url!)
        
        if let localData = self.readLocalFile(forName: "Countries") {

            self.parse(jsonData: localData)
            
//            fetchImage(from: "https://restcountries.eu/data/ton.svg") { (data) in
//                DispatchQueue.main.async {
//                    self.myImage.image = UIImage(data: data!)
//                }
//                
//            }
        }
        
        do{
            //        let path = Bundle.main.path(forResource: "svgNameFileHere", ofType: "svg")!
            //        if path != "" {
            let fileURL:URL = URL(string: "https://restcountries.eu/data/ton.svg")!
            let req = URLRequest(url: fileURL)
            //            self.myWeb.scalesPageToFit = false
            //            self.myWeb.loadRequest(req)
            //            if let request = URLRequest(url: fileURL), let svgString = try? String(contentsOf: request) {
            //                self.myWeb.loadHTMLString(svgString, baseURL: request)
            //            }
            let svgString = try? String(contentsOf: fileURL)
            self.myWeb.contentMode = .scaleAspectFit
            //            self.myWeb.load(req)
            self.myWeb.loadHTMLString(svgString!, baseURL: fileURL)
        } catch {
            
        }
        //        }
        //        else {
        //           //handle here if path not found
        //        }
        
        
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
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)

            DispatchQueue.main.async {
                self.myImage.image = image
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
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
                        } catch {
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
