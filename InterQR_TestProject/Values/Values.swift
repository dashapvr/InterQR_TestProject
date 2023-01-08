//
//  Values.swift
//  InterQR_TestProject
//
//  Created by Дарья Пивовар on 08.01.2023.
//

import Foundation

struct Values {
    
    struct DoorStatus {
        static let locked = "Locked"
        static let unlocking = "Unlocking..."
        static let unlocked = "Unlocked"
    }
    
    struct StatusImagesNames {
        static let shieldLocked = "shieldLocked"
        static let shieldUnlocking = "shieldUnlocking"
        static let shieldUnlocked = "shieldUnlocked"
        static let doorLocked = "doorLocked"
        static let doorUnlocking = "doorUnlocking"
        static let doorUnlocked = "doorUnlocked"
    }
    
    struct Cells {
        static let doorCell = "doorCell"
        static let loadingCell = "loadingCell"
    }
    
    struct Elements {
        static let interQR = "InterQR"
        static let settings = "Settings"
        static let welcome = "Welcome"
        static let home = "Home"
        static let myDoors = "My doors"
    }
}
