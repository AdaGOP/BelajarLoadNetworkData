//
//  CountryModel.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 03/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on July 3, 2020

import Foundation
import CoreLocation

// MARK: - Prepare the enum of Decodable to read data of a given type

enum QuantumValue: Decodable {
    
    case string(String), double(Double)
    
    init(from decoder: Decoder) throws {
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }
        
        throw QuantumError.missingValue
    }
    
    enum QuantumError:Error {
        case missingValue
    }
}

extension QuantumValue {
    
    var intValue: Int? {
        switch self {
        case .string(let value): return Int(value)
        case .double(let value): return Int(value)
        }
    }
    var doubleValue: Double? {
        switch self {
        case .double(let value): return value
        case .string(let value): return Double(value)
        }
    }
}

// MARK: - Analyze and prepare the data structure of CountryModel from the API as a Codable struct
// which combines the Encodable and Decodable protocols,
// it will enable to encode or decode the data. This step is analogue for the others struct below
// To access each of data, we need to declare our key by create the data structure for each

struct CountryModel : Codable {
    
    
    // 1 : Prepare the variables provided by API
    let alpha2Code : String?
    let alpha3Code : String?
    let altSpellings : [String]?
    let area : Double?
    let borders : [String]?
    let callingCodes : [String]?
    let capital : String?
    let cioc : String?
    let currencies : [Currency]?
    let demonym : String?
    let flag : String?
    let gini : Double?
    let languages : [Language]?
    let latlng : [Double]?
    let name : String?
    let nativeName : String?
    let numericCode : String?
    let population : Double?
    let region : String?
    let regionalBlocs : [RegionalBloc]?
    let subregion : String?
    let timezones : [String]?
    let topLevelDomain : [String]?
    let translations : Translation?
    
    // 2 : Create enum CodingKeys, alternative keys by specifying String as the raw-value type for the CodingKeys enumeration which is the key name used during encoding and decoding. It lets you name your data structures according to the Swift API Design Guidelines rather than having to match the names, punctuation, and capitalization of the serialization format you're modeling.
    enum CodingKeys: String, CodingKey {
        case alpha2Code = "alpha2Code"
        case alpha3Code = "alpha3Code"
        case altSpellings = "altSpellings"
        case area = "area"
        case borders = "borders"
        case callingCodes = "callingCodes"
        case capital = "capital"
        case cioc = "cioc"
        case currencies = "currencies"
        case demonym = "demonym"
        case flag = "flag"
        case gini = "gini"
        case languages = "languages"
        case latlng = "latlng"
        case name = "name"
        case nativeName = "nativeName"
        case numericCode = "numericCode"
        case population = "population"
        case region = "region"
        case regionalBlocs = "regionalBlocs"
        case subregion = "subregion"
        case timezones = "timezones"
        case topLevelDomain = "topLevelDomain"
        case translations = "translations"
    }
    
    // 3 : By implementing the enum above, we can use a KeyedDecodingContainer Container (by calling the Decoder’s method container<Key>(keyedBy: Key.Type)) to extract the data by converting it into something that we can use in our app:
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self) // defining our (keyed) container
        // Extracting each data
        alpha2Code = try values.decodeIfPresent(String.self, forKey: .alpha2Code)
        alpha3Code = try values.decodeIfPresent(String.self, forKey: .alpha3Code)
        altSpellings = try values.decodeIfPresent([String].self, forKey: .altSpellings)
        area = try values.decodeIfPresent(Double.self, forKey: .area)
        borders = try values.decodeIfPresent([String].self, forKey: .borders)
        callingCodes = try values.decodeIfPresent([String].self, forKey: .callingCodes)
        capital = try values.decodeIfPresent(String.self, forKey: .capital)
        cioc = try values.decodeIfPresent(String.self, forKey: .cioc)
        currencies = try values.decodeIfPresent([Currency].self, forKey: .currencies)
        demonym = try values.decodeIfPresent(String.self, forKey: .demonym)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
        
        do {
            gini = try values.decodeIfPresent(Double.self, forKey: .gini)
            
        } catch {
            // The check for a String and then cast it, this will throw if decoding fails
            if let typeValue = Double(try values.decode(String.self, forKey: .gini)) {
                gini = typeValue
            } else {
                // You may want to throw here if you don't want to default the value(in the case that it you can't have an optional).
                gini = nil
            }
        }
        languages = try values.decodeIfPresent([Language].self, forKey: .languages)
        latlng = try values.decodeIfPresent([Double].self, forKey: .latlng)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nativeName = try values.decodeIfPresent(String.self, forKey: .nativeName)
        numericCode = try values.decodeIfPresent(String.self, forKey: .numericCode)
        population = try values.decodeIfPresent(Double.self, forKey: .population)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        regionalBlocs = try values.decodeIfPresent([RegionalBloc].self, forKey: .regionalBlocs)
        subregion = try values.decodeIfPresent(String.self, forKey: .subregion)
        timezones = try values.decodeIfPresent([String].self, forKey: .timezones)
        topLevelDomain = try values.decodeIfPresent([String].self, forKey: .topLevelDomain)
        translations = try Translation(from: decoder)
    }
    
}

// MARK: - Analyze and prepare the data structure of Translation from the API as a Codable struct

struct Translation : Codable {
    
    let br : String?
    let de : String?
    let es : String?
    let fa : String?
    let fr : String?
    let hr : String?
    let it : String?
    let ja : String?
    let nl : String?
    let pt : String?
    
    enum CodingKeys: String, CodingKey {
        case br = "br"
        case de = "de"
        case es = "es"
        case fa = "fa"
        case fr = "fr"
        case hr = "hr"
        case it = "it"
        case ja = "ja"
        case nl = "nl"
        case pt = "pt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        br = try values.decodeIfPresent(String.self, forKey: .br)
        de = try values.decodeIfPresent(String.self, forKey: .de)
        es = try values.decodeIfPresent(String.self, forKey: .es)
        fa = try values.decodeIfPresent(String.self, forKey: .fa)
        fr = try values.decodeIfPresent(String.self, forKey: .fr)
        hr = try values.decodeIfPresent(String.self, forKey: .hr)
        it = try values.decodeIfPresent(String.self, forKey: .it)
        ja = try values.decodeIfPresent(String.self, forKey: .ja)
        nl = try values.decodeIfPresent(String.self, forKey: .nl)
        pt = try values.decodeIfPresent(String.self, forKey: .pt)
    }
    
}

// MARK: - Analyze and prepare the data structure of RegionalBloc from the API as a Codable struct

struct RegionalBloc : Codable {
    
    let acronym : String?
    let name : String?
    let otherAcronyms : [String]?
    let otherNames : [String]?
    
    enum CodingKeys: String, CodingKey {
        case acronym = "acronym"
        case name = "name"
        case otherAcronyms = "otherAcronyms"
        case otherNames = "otherNames"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        acronym = try values.decodeIfPresent(String.self, forKey: .acronym)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        //otherAcronyms = try values.decodeIfPresent([AnyObject].self, forKey: .otherAcronyms)
        do {
            otherAcronyms = try values.decodeIfPresent([String].self, forKey: .otherAcronyms)
        } catch {
            // You may want to throw here if you don't want to default the value(in the case that it you can't have an optional).
            otherAcronyms = nil
        }
        otherNames = try values.decodeIfPresent([String].self, forKey: .otherNames)
    }
    
}

// MARK: - Analyze and prepare the data structure of Language from the API as a Codable struct

struct Language : Codable {
    
    let iso6391 : String?
    let iso6392 : String?
    let name : String?
    let nativeName : String?
    
    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso639_1"
        case iso6392 = "iso639_2"
        case name = "name"
        case nativeName = "nativeName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iso6391 = try values.decodeIfPresent(String.self, forKey: .iso6391)
        iso6392 = try values.decodeIfPresent(String.self, forKey: .iso6392)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nativeName = try values.decodeIfPresent(String.self, forKey: .nativeName)
    }
    
}

// MARK: - Analyze and prepare the data structure of Currency from the API as a Codable struct

struct Currency : Codable {
    
    let code : String?
    let name : Double?
    let symbol : Double?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case name = "name"
        case symbol = "symbol"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        do {
            name = try values.decodeIfPresent(Double.self, forKey: .name)
            
        } catch {
            // The check for a String and then cast it, this will throw if decoding fails
            if let typeValue = Double(try values.decode(String.self, forKey: .name)) {
                name = typeValue
            } else {
                // You may want to throw here if you don't want to default the value(in the case that it you can't have an optional).
                name = nil
            }
        }
        
        do {
            symbol = try values.decodeIfPresent(Double.self, forKey: .symbol)
            
        } catch {
            // The check for a String and then cast it, this will throw if decoding fails
            if let typeValue = Double(try values.decode(String.self, forKey: .symbol)) {
                symbol = typeValue
            } else {
                // You may want to throw here if you don't want to default the value(in the case that it you can't have an optional).
                symbol = nil
            }
        }
    }
    
}
