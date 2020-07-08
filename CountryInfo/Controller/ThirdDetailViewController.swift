//
//  ThirdDetailViewController.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 08/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import UIKit

class ThirdDetailViewController: UIViewController {

    @IBOutlet weak var provinceTable: UITableView!
    @IBOutlet weak var isoLabel: UILabel!
    var iso = ""
    var provinceData:[[String: AnyObject]] = []
    let cellID = "ProvinceCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        provinceTable.dataSource = self
        provinceTable.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isoLabel.text = iso
        
        getProvinceData(byRegionIso: iso)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getProvinceData(byRegionIso: String){
        let service = APIService()
                service.getAvailableProvinces(iso: byRegionIso) { (result) in
                    switch result {
                    case .Success(let data):
                        self.provinceData = data
                        self.provinceTable.reloadData()
                    case .Error(let message):
                        print(message)
                    }
                    
                }
    }

}


extension ThirdDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        provinceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = provinceTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = provinceData[indexPath.row]["province"] as? String
        
        let lat = provinceData[indexPath.row]["lat"] as? String ?? "empty lat"
        let longi = provinceData[indexPath.row]["long"] as? String ?? "empty long"
        cell.detailTextLabel?.text =  "\(lat), \(longi)"
        
        return cell
    }
    
    
}
