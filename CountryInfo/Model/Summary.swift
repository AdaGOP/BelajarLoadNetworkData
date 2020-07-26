//
//  Summary.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 15/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import Foundation
// MARK: - This is how to analyze the data from API
// copy-paste the sample of the data we get, create the variables based on those sample
// if u don' wanna do this, you can use https://app.quicktype.io

//{
//  "total_cases": 13617360,
//  "active_cases": 4997374,
//  "deaths": 583710,
//  "recovered": 8036276,
//  "critical": 59350,
//  "tested": 262099908,
//  "death_ratio": 0.04286513685472074,
//  "recovery_ratio": 0.5901493387851977
//}

struct Summary: Codable {
    let totalCases: Int
    let activeCases: Int
    let deaths: Int
    let recovered: Int
    let critical: Int
    let tested: Int
    let deathRatio: Double
    let recoveryRatio: Double
    
    enum CodingKeys: String, CodingKey {
        case totalCases = "total_cases"
        case activeCases = "active_cases"
        case deaths = "deaths"
        case recovered = "recovered"
        case critical = "critical"
        case tested = "tested"
        case deathRatio = "death_ratio"
        case recoveryRatio = "recovery_ratio"
    }
}
