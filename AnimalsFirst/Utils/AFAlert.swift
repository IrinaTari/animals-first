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

    static func showLoginFailure(_ controller: UIViewController, error: Error, completionBlock: @escaping (UIAlertAction) -> Void) {
        AFAlert.showBasicAlertView(controller, title: "Emailul si parola sunt gresite", message: error.localizedDescription, cancelButtonTitle: "OK", tapBlock: completionBlock)
    }
    
    static func showAppointmentDayAlert(_ controller: UIViewController, day: AFDayModel, completionBlock: @escaping AlertDismissCompletionBlock) {
        AFAlert.showAlertView(controller, title: "Sunteti sigur(a) ca doriti sa va programati pentru ziua de \(day.index!)/\(day.month!)/\(day.year!)?", message: nil, cancelButtonTitle: "DA", destructiveButtonTitle: nil, otherButtonsTitle: ["NU"], tapBlock: completionBlock)
    }
    
    static func showInvalidDayAlert(_ controller: UIViewController) {
        AFAlert.showAlertView(controller, title: "Nu se poate face programare", message: "Va rugam alegeti una dintre zilele disponibile (marcate cu verde).", cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonsTitle: nil, tapBlock: nil)
    }
    
    static func showSterilizationInfoAlert(_ controller: UIViewController, completionBlock: @escaping AlertDismissCompletionBlock) {
        AFAlert.showAlertView(controller, title: "Inainte sa va programam:", message: " - animalul trebuie transportat intr-o cutie speciala pentru a evita evenimente nedorite \n - se poate sa ramana si o noapte post-operator, dar nu vineri \n - intre 8 si 9 preluam animalele si intre 16 si 17 le dam inapoi \n - aveti optiunea sa aduca cu o zi inainte intre 16 si 17 (in conditia in care programarea nu este luni) \n - la final, fiecare animal este predat stpanului impreuna cu adeverinta de sterilizare si recomandarile post-operatorii care sunt si explicate pe larg verbal", cancelButtonTitle: "Accept", destructiveButtonTitle: nil, otherButtonsTitle: ["Nu accept"], tapBlock: completionBlock)
    }
    
    static func showZeroAnimalsSelectedAlert(_ controller: UIViewController) {
        AFAlert.showAlertView(controller, title: "Nu se poate face programare", message: "Introduceti numarul de caini/pisici/ motani.", cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonsTitle: nil, tapBlock: nil)
    }

    static func showNoDateSelectionAlert(_ controller: UIViewController) {
        AFAlert.showAlertView(controller, title: "Nu se poate face programare", message: "Va rugam, selectati o date de predare si una de recuperare.", cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonsTitle: nil, tapBlock: nil)
    }
}
