//
//  ViewController.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 03/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var countryTable: UITableView!

    var countryData: [CountryModel] = []
    
    let countryCellID = "CountryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        countryTable.delegate = self
        countryTable.dataSource = self
        
        
        countryTable.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: countryCellID)
        
        loadTableFromJson()
        
//        if let localData = self.readLocalFile(forName: "Countries") {
//            self.parse(jsonData: localData)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Countries"
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode([CountryModel].self, from: jsonData)
            for item in decodedData {
            print("Name: ", item.name as Any)
            print("Alpha2Code: ", item.alpha2Code as Any)
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
    
//    private func loadJson(fromURLString urlString: String,
//                          completion: @escaping (Result<Data, Error>) -> Void) {
//        if let url = URL(string: urlString) {
//            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    completion(.failure(error))
//                }
//
//                if let data = data {
//                    completion(.success(data))
//                }
//            }
//
//            urlSession.resume()
//        }
//    }
    
    
    
    func loadTableFromJson(){
        let session = URLSession.shared
        let url = URL(string: "https://restcountries.eu/rest/v2/all")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            // Check the response
            //print(data)
            
            // Check if an error occured
            if error != nil {
                // HERE you can manage the error
                print("error: \(error.debugDescription)")
                return
            }
            
            // Serialize the data into an object
            do {
                let json = try JSONDecoder().decode([CountryModel].self, from: data!)
                    //try JSONSerialization.jsonObject(with: data!, options: [])
                //print(json)
                self.countryData = (json as [CountryModel])
                
                print(self.countryData.count)
                
                DispatchQueue.main.async {
                    self.countryTable.reloadData()
                }
                
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
            
        })
        task.resume()
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
    
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = countryTable.dequeueReusableCell(withIdentifier: countryCellID, for: indexPath) as? CountryTableViewCell {
            if countryData.count > 0 {
                if let name = countryData[indexPath.row].name {
                    //cell.textLabel?.text = name
                    cell.nameLabel.text = name
                    //cell.setImageToImageView(imageURLString: flagStr)
                 }
                }
            return cell
            }
            return UITableViewCell()
        }
    
}


