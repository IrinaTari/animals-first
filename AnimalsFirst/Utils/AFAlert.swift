//
//  AFAlert.swift
//  AnimalsFirst
//
//  Created by Irina Țari on 5/4/18.
//  Copyright © 2018 Irina Tari. All rights reserved.
//

import Foundation
import UIKit

typealias AlertDismissCompletionBlock = ((Int) -> Void)

@objcMembers class AFAlert: NSObject {
    static var currentAlertController: UIAlertController?

    @discardableResult static func showAlertView(_ controller: UIViewController,
                                                 title: String?,
                                                 message: String?,
                                                 cancelButtonTitle: String?,
                                                 destructiveButtonTitle: String? = nil,
                                                 otherButtonsTitle: [String?]? = nil,
                                                 tapBlock: AlertDismissCompletionBlock?) -> UIAlertController {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if cancelButtonTitle != nil {
            alertController.addAction(UIAlertAction.init(title: cancelButtonTitle, style: .cancel, handler: { _ in
                if tapBlock != nil {
                    tapBlock!(0)
                }
            }))
        }
        if destructiveButtonTitle != nil {
            alertController.addAction(UIAlertAction.init(title: destructiveButtonTitle, style: .destructive, handler: { _ in
                if tapBlock != nil {
                    tapBlock!(-1)
                }
            }))
        }
        if otherButtonsTitle != nil {
            for otherTitle in otherButtonsTitle! where otherTitle != nil {
                alertController.addAction(UIAlertAction.init(title: otherTitle, style: .default, handler: { _ in
                    var buttonIndex: Int = 0
                    var index = 1
                    for title in otherButtonsTitle! {
                        if title == otherTitle {
                            buttonIndex = index
                        }
                        index += 1
                    }
                    if tapBlock != nil {
                        tapBlock!(buttonIndex)
                    }
                }))
            }
        }
        currentAlertController = alertController
        controller.present(alertController, animated: true, completion: nil)
        return alertController
    }

    @discardableResult static func showBasicAlertView(_ controller: UIViewController,
                                                 title: String?,
                                                 message: String?,
                                                 cancelButtonTitle: String?,
                                                 tapBlock: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if cancelButtonTitle != nil {
            alertController.addAction(UIAlertAction.init(title: cancelButtonTitle, style: .cancel, handler: tapBlock))
        }
        currentAlertController = alertController
        controller.present(alertController, animated: true, completion: nil)
        return alertController
    }


    static func showCustomAlertView(_ controller: UIViewController, title: String?, message: String?, cancelButtonTitle: String?, completionBlock: AlertDismissCompletionBlock?) {
        AFAlert.showAlertView(controller,
                              title: title,
                              message: message,
                              cancelButtonTitle: cancelButtonTitle,
                              tapBlock: completionBlock)
    }

    static func showEmptyTextFieldsAlert(_ controller: UIViewController, completionBlock: (@escaping (UIAlertAction) -> Void)) {
        AFAlert.showBasicAlertView(controller,
                              title: "Nu s-a putut crea contul",
                              message: "Toate campurile trebuie completate cu date corecte.",
                              cancelButtonTitle: "OK",
                              tapBlock: completionBlock)
    }

    static func showAccFailAlert(_ controller: UIViewController, error: Error, completionBlock: @escaping (UIAlertAction) -> Void) {
        AFAlert.showBasicAlertView(controller, title: "Nu s-a putut crea contul", message: error.localizedDescription, cancelButtonTitle: "OK", tapBlock: completionBlock)
    }

    static func showAccSuccessAlert(_ controller: UIViewController, completionBlock: @escaping (UIAlertAction) -> Void) {
        AFAlert.showBasicAlertView(controller, title: "Cont creat cu success!", message: nil, cancelButtonTitle: "OK", tapBlock: completionBlock)
    }

    static func showInequalPasswordAlert(_ controller: UIViewController, completionBlock: @escaping (UIAlertAction) -> Void) {
        AFAlert.showBasicAlertView(controller, title: "Nu s-a putut crea contul", message: "Parolele nu coincid.", cancelButtonTitle: "OK", tapBlock: completionBlock)
    }
}
