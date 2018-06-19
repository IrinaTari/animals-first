//
//  AppointmentsModel.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 6/13/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import UIKit
import Firebase

class AppointmentsModel: NSObject {
    var day = 0
    var month = 0
    var year = 0
    var client: User!
    var animalType: [(AFConstants.AnimalType, Int)]!
}
