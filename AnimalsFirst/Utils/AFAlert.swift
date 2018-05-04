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

    static func showCustomAlertView(_ controller: UIViewController, title: String?, message: String?, cancelButtonTitle: String?, completionBlock: AlertDismissCompletionBlock?) {
        AFAlert.showAlertView(controller,
                              title: title,
                              message: message,
                              cancelButtonTitle: cancelButtonTitle,
                              tapBlock: completionBlock)
    }

    static func showEmptyTextFieldsAlert(_ controller: UIViewController, completionBlock: AlertDismissCompletionBlock?) {
        AFAlert.showAlertView(controller,
                              title: "Nu s-a putut crea contul",
                              message: "Toate campurile trebuie completate cu date corecte.",
                              cancelButtonTitle: "OK",
                              tapBlock: completionBlock)
    }

    static func createAccFailAlert(_ controller: UIViewController, completionBlock: AlertDismissCompletionBlock?) {
        AFAlert.showAlertView(controller, title: <#T##String?#>, message: <#T##String?#>, cancelButtonTitle: <#T##String?#>, tapBlock: <#T##AlertDismissCompletionBlock?##AlertDismissCompletionBlock?##(Int) -> Void#>)
        let alert = UIAlertController(title: "Nu s-a putut crea contul", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    static func createAccSuccessAlert(_ controller: UIViewController, completionBlock: AlertDismissCompletionBlock?) {
        let alert = UIAlertController(title: "Cont creat cu success!", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
