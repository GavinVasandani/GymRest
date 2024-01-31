//
//  HapticsManager.swift
//  ICHackMenstraulGym
//
//  Created by Gavin Vasandani on 04/02/2023.
//

import Foundation
import UIKit

//final keyword means no other class in the project can be subclass of hapticsManager class, so no inhereting?
final class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    //Public func:
    public func vibrateforSelection() {
        //Vibrate lightly for selection tap interaction - so vibrate for when rest timer ends?
    }
}
