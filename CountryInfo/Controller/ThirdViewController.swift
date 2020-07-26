//
//  ThirdViewController.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 08/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var regionsTable: UITableView!
    
    var regionData:[[String: AnyObject]] = []
    
    let cellID = "RegionCell"
    
   override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            regionsTable.dataSource = self
            regionsTable.delegate = self
            title = "Regions"
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            getRegionData()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            // 1: Make the navigation bar's title with red text.
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemRed
            appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText] // With a red background, make the title more readable.
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance // For iPhone small navigation bar in landscape.

            // 2: Make all buttons with green text.
            let buttonAppearance = UIBarButtonItemAppearance()
            buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
            navigationItem.standardAppearance?.buttonAppearance = buttonAppearance
            navigationItem.compactAppearance?.buttonAppearance = buttonAppearance // For iPhone small navigation bar in landscape.

            // 3: Make the done style button with yellow text.
            let doneButtonAppearance = UIBarButtonItemAppearance()
            doneButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemYellow]
            navigationItem.standardAppearance?.doneButtonAppearance = doneButtonAppearance
            navigationItem.compactAppearance?.doneButtonAppearance = doneButtonAppearance // For iPhone small navigation bar in landscape.
            navigationController?.navigationBar.prefersLargeTitles = true
        }

    // MARK: - Implement APIService
        func getRegionData(){
            let service = APIService()
            service.getAvailableRegions { (result) in
                switch result {
                case .Success(let data):
    //                for itemData in data {
    //                    print(itemData["name"] as? String ?? "Empty")
    //                    print(itemData["iso"] as? String ?? "Empty")
    //                }
                    self.regionData = data
                    self.regionsTable.reloadData()
                case .Error(let message):
                    print(message)
                }
                
            }
        }
    }

    // MARK : - Set table view to perform the data
    extension ThirdViewController: UITableViewDataSource, UITableViewDelegate{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            regionData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = regionsTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            
            cell.detailTextLabel?.text = regionData[indexPath.row]["iso"] as? String
            cell.textLabel?.text = regionData[indexPath.row]["name"] as? String

            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedRegion = regionData[indexPath.row]
            
            if let viewController = storyboard?.instantiateViewController(identifier: "ThirdDetail") as? ThirdDetailViewController {
                viewController.title = selectedRegion["name"] as? String
                viewController.iso = (selectedRegion["iso"] as? String)!
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
