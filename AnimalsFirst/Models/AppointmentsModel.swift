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
    var day = AFDayModel(index: 0, month: 0, year: 0)
    var client: User!
    var animalType: [(AFConstants.AnimalType, Int)]!
}
