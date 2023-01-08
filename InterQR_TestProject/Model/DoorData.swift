//
//  DoorData.swift
//  InterQR_TestProject
//
//  Created by Дарья Пивовар on 08.01.2023.
//

import Foundation

class DoorData {
    static let instance = DoorData()
    
    var doors = [
        Door(title: "Front door", position: "Home", status: Values.DoorStatus.locked),
        Door(title: "Front door", position: "Office", status: Values.DoorStatus.unlocked),
        Door(title: "Front door", position: "Home", status: Values.DoorStatus.unlocking)
    ]
    
    func getDoors() -> [Door] {
        return doors
    }
}
