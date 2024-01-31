//
//  PeristenceManager.swift
//  ICHackMenstraulGym
//
//  Created by Gavin Vasandani on 04/02/2023.
//
//Memorizes previously stored info on app
import Foundation

final class PersistenceManager {
    //class member variable which gives class instance property is singleton (only 1 property):
    static let shared = PersistenceManager() //create instance of PersistenceManager() type
    
    //We store this information in:
    private let userDefaults: UserDefaults = .standard //userDefaults variable is object of UserDefaults class and is assigned standard, Apps store these preferences by assigning values to a set of parameters in a user’s defaults database
    
    private struct Constants {
        
    }
    
    private init () {}
    
    //Public func
    public var watchList: [String] { //func with array of String output, array with each element being company watched (string type)
        return []
    }
    
    public func addToWatchlist () {
        //member func to add company to watch list
    }
    
    public func removeFromtWatchlist () {
        //member func to remove company to watch list
    }
    
    //Private funcs:
    private var hasOnboarded: Bool {
        return false
    }
    
    
    
}
