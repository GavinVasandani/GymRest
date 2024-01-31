//
//  SearchResponse.swift
//  ICHackMenstraulGym
//
//  Created by Gavin Vasandani on 04/02/2023.
//

import Foundation

struct SearchResponse: Codable { //allows JSON gotten back from API call to be mapped to object as long as keys match and value match, so JSON outputs a specific struct/set of values per query and that's assigned to the struct as long as keys of the struct and keys of the JSON object match
    let count: Int //so count constant which is of type int
    let result: [SearchResult]
    //Struct is dictionary not constants
    //let SearchDict: [String: String]// = [
    }

struct SearchResult : Codable { //SearchResult is object from JSON file
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
