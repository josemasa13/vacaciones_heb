//
//  Utility.swift
//  vacaciones_HEB
//
//  Created by Ricardo Ramirez on 23/05/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import Foundation
import UIKit

class Utility: NSObject {
    static func backToPreviousScreen(_ view: UIViewController){
        if view.navigationController != nil{
            view.navigationController?.popViewController(animated: true)
        }else{
            view.dismiss(animated: true, completion: nil)
        }
    }
    static func backToLogin(_ view: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "login")
        view.present(vc, animated: false)
    }
}
