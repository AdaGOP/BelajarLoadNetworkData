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
            
            // 1: Register the cell
            countryTable.register(UINib(nibName: "CountryTableViewCell", bundle: nil), forCellReuseIdentifier: countryCellID)
            
            // 4: Implement URL Session using data model of Country Model
            loadTableFromJson()
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.title = "Countries"
        }
        
        // MARK: - 2: Parse data and reload the data to the table using the data structure we've made

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
        
        
        // MARK: - 3: Set the URLSession using data model
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
        
    }

    // MARK: - Set table view to perform the data
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
                     // 5: Implement the data using CountryModel
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


