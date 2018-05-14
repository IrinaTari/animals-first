//
//  UILabel+UITextFieldExtensions.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/14/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func adjustTextUsingDynamicType() {
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.adjustsFontForContentSizeCategory = true
        self.adjustsFontSizeToFitWidth = true
    }
}

extension UITextField {
    func adjustTextUsingDynamicType() {
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.adjustsFontForContentSizeCategory = true
        self.adjustsFontSizeToFitWidth = true
    }
}
