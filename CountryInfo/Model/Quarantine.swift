//
//  QuarantineData.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 15/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import Foundation

struct Quarantine: Codable {
    let status: Int
    let type: String
    let quarantineData: QuarantineData
    
    
    enum CodingKeys: String, CodingKey{
        case status = "status"
        case type = "type"
        case quarantineData = "data"
        
    }
}

struct QuarantineData: Codable {
    let summary: Summary
    let change: Summary
    let generatedOn: Int64
    let regions: [String: Region]
    
    enum CodingKeys: String, CodingKey{
        case summary = "summary"
        case change = "change"
        case generatedOn = "generated_on"
        case regions = "regions"
    }
}

//struct listOfObject: Codable{
//    let usa: Region
//    
//    enum CodingKeys: String, CodingKey {
//        case usa = "usa"
//    }
//}

struct Region: Codable {
    let name: String
    let iso3166a2: String
    let iso3166a3: String
    let iso3166numeric: String
    let totalCases: Int
    let activeCases: Int
    let deaths: Int
    let recovered: Int
    let critical: Int
    let tested: Int
    let deathRatio: Double
    let recoveryRatio: Double
    let change: Change
        
    
    enum CodingKeys: String, CodingKey{
      case name = "name"
      case iso3166a2 = "iso3166a2"
      case iso3166a3 = "iso3166a3"
      case iso3166numeric = "iso3166numeric"
      case totalCases = "total_cases"
      case activeCases = "active_cases"
      case deaths = "deaths"
      case recovered = "recovered"
      case critical = "critical"
      case tested = "tested"
      case deathRatio = "death_ratio"
      case recoveryRatio = "recovery_ratio"
      case change = "change"
        
    }
}


struct Change: Codable {
    let totalCases: Int
    let activeCases: Int
    let deaths: Int
    let recovered: Int
    let deathRatio: Double
    let recoveryRatio: Double
    
    enum CodingKeys: String, CodingKey{
        case totalCases = "total_cases"
        case activeCases = "active_cases"
        case deaths = "deaths"
        case recovered = "recovered"
        case deathRatio = "death_ratio"
        case recoveryRatio = "recovery_ratio"
    }
}
