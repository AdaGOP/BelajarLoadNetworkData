//
//  ForthViewController.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 15/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import UIKit

class ForthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //read it from the
        readFromApi()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func readFromLocal(){
        //read the local file as if it is a data from the API
        do{
            if let path = Bundle.main.path(forResource: "Quarantine", ofType: "json"),
                let jsonData = try String(contentsOfFile: path).data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                
                print(json)
                
                let quarantine = try JSONDecoder().decode(Quarantine.self, from: jsonData)
                
                //                print(quarantine)
                for regions in quarantine.quarantineData.regions{
                    print(regions.key)
                }
                
            }
        } catch let error {
            print("Error reading local file:" + error.localizedDescription)
        }
    }
    
    func readFromApi(){
        let session = URLSession.shared
        let url = URL(string: "https://api.quarantine.country/api/v1/summary/latest")
        let task = session.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("fail request data: " + error.localizedDescription)
            }
            
            if let data = data {
                do{
                    let quarantine = try JSONDecoder().decode(Quarantine.self, from: data) as Quarantine
                    
                    for region in quarantine.quarantineData.regions{
                        print(region.key)
                    }
                } catch let error {
                    print("fail to parse data:" + error.localizedDescription)
                }
                
            }
            
        }
        task.resume()
    }

}
